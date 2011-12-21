package uk.co.itrainconsulting.contentbuilder.model {
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.setTimeout;

    import flashx.textLayout.events.ModelChange;

    import mx.core.FlexGlobals;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    import mx.managers.DragManager;
    import mx.utils.ObjectUtil;
    import mx.utils.UIDUtil;

    import uk.co.itrainconsulting.common.model.Slide;
    import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
    import uk.co.itrainconsulting.contentbuilder.control.events.EditorEvent;

    public class UndoRedoBean {
        private static const MAX_CACHE_SIZE:int=100;
        private static const PROPERTY_CHANGE_DELAY:int=700;

        private var _actions:Vector.<ModelChangeItem>=new Vector.<ModelChangeItem>();
        private var _currentIndex:int=0;

        private var _uniqueIdItemMap:Dictionary=new Dictionary(); //getObjectPropertyId -> ModelChangeItem
        private var _uniqueIdTimerMap:Dictionary=new Dictionary(); //getObjectPropertyId -> Timer
        private var _timerUniqueIdMap:Dictionary=new Dictionary(); //Timer->getObjectPropertyId

        private var _lastEvent:Event;
        private var _slideReplaceMCI:ModelChangeItem;
        private var _propertyChangeTrackingEnabled:Boolean=true;
        private var _lastSaveIndex:int=-2;

        [Bindable]
        public var redoEnabled:Boolean=false;
        [Bindable]
        public var undoEnabled:Boolean=false;
        [Bindable]
        public var saveRequired:Boolean=false;

        [Dispatcher]
        public var dispatcher:IEventDispatcher;

        public function UndoRedoBean() {
        }

        [PostConstruct]
        public function onPostConstruct():void {
            ChangeAwareModel.changeHandler=onChange;
        }

        [Mediate(event="EditorEvent.DISABLE_PROPERTY_CHANGE_TRACKING")]
        public function onSlideListManipulationStart(e:EditorEvent):void {
            _propertyChangeTrackingEnabled=false;
        }

        [Mediate(event="EditorEvent.ENABLE_PROPERTY_CHANGE_TRACKING")]
        public function onSlideListManipulationEnd(e:EditorEvent):void {
            _propertyChangeTrackingEnabled=true;
        }

        [Mediate(event="EditorEvent.UNDO")]
        public function undoAction():void {
            if (undoEnabled) {
                var mci:ModelChangeItem=_actions[_currentIndex++];
                if (mci.type == ModelChangeItem.ITEM_ADDED) { //slide object actions
                    _lastEvent=new EditorEvent(EditorEvent.DELETE_MEDIA, true);
                    (_lastEvent as EditorEvent).media=mci.reference as MediaObject;
                    (_lastEvent as EditorEvent).slide=mci.parent as Slide;
                    dispatcher.dispatchEvent(_lastEvent);
                } else if (mci.type == ModelChangeItem.ITEM_REMOVED) {
                    _lastEvent=new EditorEvent(EditorEvent.ADD_MEDIA, true);
                    (_lastEvent as EditorEvent).media=mci.reference as MediaObject;
                    (_lastEvent as EditorEvent).slide=mci.parent as Slide;
                    dispatcher.dispatchEvent(_lastEvent);
                } else if (mci.type == ModelChangeItem.ITEM_REORDERED) {
                    var ee:EditorEvent=new EditorEvent(EditorEvent.REORDER_MEDIA, true);
                    ee.media=mci.reference as MediaObject;
                    ee.slide=mci.parent as Slide;
                    ee.additionalData=mci.oldValue;
                    dispatcher.dispatchEvent(ee);
                } else if (mci.type == ModelChangeItem.PROPERTY_CHANGE || mci.type == ModelChangeItem.POSITION_CHANGE || mci.type == ModelChangeItem.DIMENSION_CHANGE) {
                    restoreValue(mci, "oldValue");
                } else { // slides actions
                    var e:Event;
                    if (mci.type == ModelChangeItem.SLIDE_SELECTION_CHANGE) {
                        //_lastEvent=e=buildSeletionChangeEvent(mci.oldValue as int);
                    } else {
                        var ee:EditorEvent;
                        if (mci.type == ModelChangeItem.SLIDE_REORDERED) {
                            ee=new EditorEvent(EditorEvent.REORDER_SLIDE_SILENTLY, true);
                            ee.slide=mci.reference as Slide;
                            ee.additionalData=mci.oldValue;
                        } else if (mci.type == ModelChangeItem.SLIDES_ADDED) { // selection crashes
                            ee=new EditorEvent(EditorEvent.REMOVE_SLIDES_SILENTLY, true)
                            ee.additionalData=mci.reference; // array of slideindex
                            _updateSelectionAfterSilent=true;
                        } else if (mci.type == ModelChangeItem.SLIDES_REMOVED) {
                            ee=new EditorEvent(EditorEvent.ADD_SLIDES_SILENTLY, true);
                            ee.additionalData=mci.reference;
                        }
                        e=ee;
                    }
                    dispatcher.dispatchEvent(e);
                }
                updateUndoRedoAvailability();
                updateSaveRequired();
            }
        }

        private var _updateSelectionAfterSilent:Boolean=false;

        [Mediate(event="EditorEvent.SLIDES_ADDED_SILENTLY")]
        [Mediate(event="EditorEvent.SLIDES_REMOVED_SILENTLY")]
        public function onSilentEventDone():void {
            if (_updateSelectionAfterSilent) {
                _updateSelectionAfterSilent=false;
                sendSelectSlideAfter();
            }
        }

        private function sendSelectSlideAfter():void {
            var e:Event;
            for (var i:int=_currentIndex; i < _actions.length; i++) {
                if (_actions[i].type == ModelChangeItem.SLIDE_SELECTION_CHANGE) {
                    e=buildSeletionChangeEvent(_actions[i].newValue as int);
                    break;
                }
            }
            if (!e)
                e=buildSeletionChangeEvent(0);
            _lastEvent=e;
            dispatcher.dispatchEvent(e);
        }

        private function buildSeletionChangeEvent(slideIndex:int):EditorEvent {
            var me:EditorEvent=new EditorEvent(EditorEvent.CHANGE_SLIDE_SELECTION, true);
            me.additionalData=slideIndex;
            return me;
        }

        [Mediate(event="EditorEvent.REDO")]
        public function redoAction():void {
            if (redoEnabled) {
                var mci:ModelChangeItem=_actions[--_currentIndex];
                if (mci.type == ModelChangeItem.ITEM_ADDED) {
                    _lastEvent=new EditorEvent(EditorEvent.ADD_MEDIA, true);
                    (_lastEvent as EditorEvent).media=mci.reference as MediaObject;
                    (_lastEvent as EditorEvent).slide=mci.parent as Slide;
                    dispatcher.dispatchEvent(_lastEvent);
                } else if (mci.type == ModelChangeItem.ITEM_REMOVED) {
                    _lastEvent=new EditorEvent(EditorEvent.DELETE_MEDIA, true);
                    (_lastEvent as EditorEvent).media=mci.reference as MediaObject;
                    (_lastEvent as EditorEvent).slide=mci.parent as Slide;
                    dispatcher.dispatchEvent(_lastEvent);
                } else if (mci.type == ModelChangeItem.ITEM_REORDERED) {
                    var ee:EditorEvent=new EditorEvent(EditorEvent.REORDER_MEDIA, true);
                    ee.media=mci.reference as MediaObject;
                    ee.slide=mci.parent as Slide;
                    ee.additionalData=mci.newValue;
                    dispatcher.dispatchEvent(ee);
                } else if (mci.type == ModelChangeItem.PROPERTY_CHANGE || mci.type == ModelChangeItem.POSITION_CHANGE || mci.type == ModelChangeItem.DIMENSION_CHANGE) {
                    restoreValue(mci, "newValue");
                } else { // slides actions
                    var e:Event;
                    if (mci.type == ModelChangeItem.SLIDE_SELECTION_CHANGE) {
                        //_lastEvent=e=buildSeletionChangeEvent(mci.newValue as int);
                    } else {
                        var ee:EditorEvent;
                        if (mci.type == ModelChangeItem.SLIDE_REORDERED) {
                            ee=new EditorEvent(EditorEvent.REORDER_SLIDE_SILENTLY, true);
                            ee.slide=mci.reference as Slide;
                            ee.additionalData=mci.newValue;
                        } else if (mci.type == ModelChangeItem.SLIDES_ADDED) {
                            ee=new EditorEvent(EditorEvent.ADD_SLIDES_SILENTLY, true)
                            ee.additionalData=mci.reference; // array of slideindex		

                            _updateSelectionAfterSilent=true;
                        } else if (mci.type == ModelChangeItem.SLIDES_REMOVED) {
                            ee=new EditorEvent(EditorEvent.REMOVE_SLIDES_SILENTLY, true);
                            ee.additionalData=mci.reference;
                        }
                        e=ee;
                    }
                    dispatcher.dispatchEvent(e);
                }
                updateUndoRedoAvailability();
                updateSaveRequired();
            }
        }

        [Mediate(event="EditorEvent.MEDIA_REORDERED")]
        public function onMediaReordered(e:EditorEvent):void {
            if (!e.silent) {
                var mci:ModelChangeItem=new ModelChangeItem();
                mci.type=ModelChangeItem.ITEM_REORDERED;
                mci.reference=e.media;
                mci.parent=e.slide;
                mci.oldValue=e.additionalData;
                mci.newValue=e.slide.getStageObjectIndex(e.media);

                addToActions(mci);

                trace("Reordered: " + mci.reference);
            }
        }

        [Mediate(event="EditorEvent.MEDIA_ADDED")]
        public function onAddObject(e:EditorEvent):void {
            if (!_lastEvent || !(e.media == (_lastEvent as EditorEvent).media || e.silent)) {

                var mci:ModelChangeItem=new ModelChangeItem();
                mci.type=ModelChangeItem.ITEM_ADDED;
                mci.reference=e.media;
                mci.parent=e.slide;
                mci.oldValue=e.additionalData
                mci.newValue=e.slide.getStageObjectIndex(e.media);
                addToActions(mci);

                trace("Added: " + mci.reference);

            } else {
                _lastEvent=null;
            }
        }

        [Mediate(event="EditorEvent.MEDIA_DELETED")]
        public function onRemoveObject(e:EditorEvent):void {
            if (!_lastEvent || !(e.media == (_lastEvent as EditorEvent).media || e.silent)) {

                var mci:ModelChangeItem=new ModelChangeItem();
                mci.type=ModelChangeItem.ITEM_REMOVED;
                mci.reference=e.media;
                mci.parent=e.slide;

                addToActions(mci);
                trace("Removed: " + mci.reference);


            } else {
                _lastEvent=null;
            }
        }

        private function addToActions(mci:ModelChangeItem):void {
            resetCurrentIndex();
            _actions.unshift(mci);
            updateCache();
            updateSaveRequired(mci);
        }

        private function restoreValue(mci:ModelChangeItem, propetyName:String):void {
            mci.reference.unlistenForChange();
            var sovo:MediaObject;
            if (mci.type == ModelChangeItem.POSITION_CHANGE) {
                var position:Position=mci[propetyName] as Position;
                sovo=mci.reference as MediaObject;
                sovo.x=position.x;
                sovo.y=position.y;
                sovo.rotation=position.rotation;
            } else if (mci.type == ModelChangeItem.DIMENSION_CHANGE) {
                var dimension:Dimension=mci[propetyName] as Dimension;
                sovo=mci.reference as MediaObject;
                sovo.width=dimension.width;
                sovo.height=dimension.height;
            } else if (mci.type == ModelChangeItem.PROPERTY_CHANGE) {
                mci.reference[mci.propertyName]=mci[propetyName];
            }
            mci.reference.listenForChange();
        }

        private function onChange(e:Event):void {
            if (e is CollectionEvent)
                onSlideCollectionChange(e as CollectionEvent);
            else if (_propertyChangeTrackingEnabled)
                onSlideObjectPropertyChange(e as PropertyChangeEvent);
        }

        private function onSlideCollectionChange(e:CollectionEvent):void {
            //trace("Collection changes:" + e.kind + " " + DragManager.isDragging);
            var type:String=getChangeType(e);
            var mci:ModelChangeItem;
            if (type == ModelChangeItem.SLIDE_REORDERED) {
                if (_slideReplaceMCI) {
                    _slideReplaceMCI.newValue=e.location;
                    if (_slideReplaceMCI.oldValue != _slideReplaceMCI.newValue) {
                        var replaceTimer:Timer=new Timer(PROPERTY_CHANGE_DELAY, 1);
                        _uniqueIdTimerMap[ModelChangeItem.SLIDE_REORDERED]=replaceTimer;
                        var replaceMCI:ModelChangeItem=_slideReplaceMCI;
                        var onReplaceTimerComplete:Function=function(e:TimerEvent):void {
                            _uniqueIdTimerMap[ModelChangeItem.SLIDE_REORDERED]=null;
                            addToActions(replaceMCI);
                            trace("Slide reordered: " + replaceMCI.oldValue + " " + replaceMCI.newValue);
                        }
                        replaceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onReplaceTimerComplete);
                        replaceTimer.start();
                    }

                    _slideReplaceMCI=null;
                } else {
                    _slideReplaceMCI=new ModelChangeItem();
                    _slideReplaceMCI.type=type;
                    _slideReplaceMCI.oldValue=e.location;
                    _slideReplaceMCI.reference=e.items.shift();
                }
            } else if (type == ModelChangeItem.SLIDES_ADDED || type == ModelChangeItem.SLIDES_REMOVED) {
                mci=_uniqueIdItemMap[type];
                if (!mci) {
                    mci=new ModelChangeItem();
                    mci.type=type;
                    mci.reference=[];
                    mci.newValue=e.location;
                    _uniqueIdItemMap[type]=mci;
                }
                var timer:Timer=_uniqueIdTimerMap[type];
                if (!timer) {
                    _uniqueIdTimerMap[type]=timer=new Timer(PROPERTY_CHANGE_DELAY, 1);
                    var onTimerSlideCollectionChangeComplete:Function=function(te:TimerEvent):void {
                        var mciCompleted:ModelChangeItem=_uniqueIdItemMap[type];
                        addToActions(mciCompleted);
                        trace("Slide collection change: " + type + " " + mci.newValue);
                        _uniqueIdItemMap[type]=_timerUniqueIdMap[te.target]=_uniqueIdTimerMap[type]=null;
                    }
                    timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerSlideCollectionChangeComplete);
                    _timerUniqueIdMap[timer]=type;
                }
                timer.reset();
                timer.start();
                addSlideIndecies(mci.reference as Array, e.items, e.location);
            }
        }

        private function addSlideIndecies(targetArray:Array, sourceArray:Array, index:int=0):void {
            for (var i:int=0; i < sourceArray.length; i++) {
                targetArray.push(new SlideIndex(index + i, sourceArray[i] as Slide));
            }
        }

        private function onSlideObjectPropertyChange(e:PropertyChangeEvent):void {
            var uid:String=getObjectPropertyId(e);
            var mci:ModelChangeItem=_uniqueIdItemMap[uid];
            var timer:Timer;
            if (!mci) {
                mci=new ModelChangeItem();
                mci.reference=e.target as ChangeAwareModel;
                mci.type=getChangeType(e);
                setMCIOldValue(mci, e);
                _uniqueIdItemMap[uid]=mci;
            }
            timer=_uniqueIdTimerMap[uid];
            if (!timer) {
                _uniqueIdTimerMap[uid]=timer=new Timer(PROPERTY_CHANGE_DELAY, 1);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerPropertyChangeComplete);
                _timerUniqueIdMap[timer]=uid;
            }
            timer.reset();
            timer.start();
            setMCINewValue(mci, e);
        }

        private function getChangeType(e:Event):String {
            if (e is PropertyChangeEvent) {
                var pce:PropertyChangeEvent=e as PropertyChangeEvent;
                if (pce.property == "x" || pce.property == "y" || pce.property == "rotation")
                    return ModelChangeItem.POSITION_CHANGE;
                else if (pce.property == "width" || pce.property == "height")
                    return ModelChangeItem.DIMENSION_CHANGE;
                else
                    return ModelChangeItem.PROPERTY_CHANGE;
            } else if (e is CollectionEvent) {
                var ce:CollectionEvent=e as CollectionEvent;
                if (ce.kind == CollectionEventKind.ADD) {
                    if (DragManager.isDragging) {
                        if (_slideReplaceMCI != null) {
                            return ModelChangeItem.SLIDE_REORDERED;
                        } else {
                            return ModelChangeItem.SLIDES_ADDED;
                        }
                    } else {
                        return ModelChangeItem.SLIDES_ADDED;
                    }
                } else if (ce.kind == CollectionEventKind.REMOVE) {
                    if (DragManager.isDragging) {
                        return ModelChangeItem.SLIDE_REORDERED;
                    } else {
                        return ModelChangeItem.SLIDES_REMOVED;
                    }
                }
            }
            return "";
        }

        private function setMCIOldValue(mci:ModelChangeItem, e:PropertyChangeEvent):void {
            var sovo:MediaObject;
            if (mci.type == ModelChangeItem.POSITION_CHANGE) {
                sovo=e.target as MediaObject;
                mci.oldValue=new Position(sovo.x, sovo.y, sovo.rotation);
                mci.oldValue[e.property]=e.oldValue;
                mci.newValue=(mci.oldValue as Position).clone();
                mci.newValue[e.property]=e.newValue;
            } else if (mci.type == ModelChangeItem.DIMENSION_CHANGE) {
                sovo=e.target as MediaObject;
                mci.oldValue=new Dimension(sovo.width, sovo.height);
                mci.oldValue[e.property]=e.oldValue;
                mci.newValue=(mci.oldValue as Dimension).clone();
                mci.newValue[e.property]=e.newValue;
            } else {
                mci.propertyName=e.property as String;
                mci.oldValue=e.oldValue;
            }
        }

        private function setMCINewValue(mci:ModelChangeItem, e:PropertyChangeEvent):void {
            if (mci.type == ModelChangeItem.POSITION_CHANGE || mci.type == ModelChangeItem.DIMENSION_CHANGE) {
                mci.newValue[e.property]=e.newValue;
            } else {
                mci.newValue=e.newValue;
            }
        }

        private function updateUndoRedoAvailability():void {
            undoEnabled=_actions.length && _currentIndex <= _actions.length - 1;
            redoEnabled=_actions.length && _currentIndex > 0;
        }

        private function onTimerPropertyChangeComplete(e:TimerEvent):void {
            var uid:String=_timerUniqueIdMap[e.target];
            var mci:ModelChangeItem=_uniqueIdItemMap[uid];
            addToActions(mci);

            _uniqueIdItemMap[uid]=_timerUniqueIdMap[e.target]=_uniqueIdTimerMap[uid]=null;
            trace(mci.propertyName + ": oldValue: " + mci.oldValue + " newValue: " + mci.newValue);
        }

        private function resetCurrentIndex():void {
            if (_currentIndex > 0) {
                _actions.splice(0, _currentIndex);
                if (_lastSaveIndex < _currentIndex)
                    _lastSaveIndex=-2;
                else
                    _lastSaveIndex-=_currentIndex;
                _currentIndex=0;
            }
        }

        [Mediate(event="ServiceEvent.CONTENT_SAVED")]
        public function onLessonSaved():void {
            _lastSaveIndex=_currentIndex;
            saveRequired=false;
        }

        private function updateCache():void {
            if (_actions.length > MAX_CACHE_SIZE)
                _actions.splice(MAX_CACHE_SIZE - 1, _actions.length - MAX_CACHE_SIZE);
            updateUndoRedoAvailability();
        }

        private function getObjectPropertyId(e:Event, changeType:String=null):String {
            if (changeType) {
                return UIDUtil.getUID(e.target) + changeType;
            } else {
                var postfix:String="";
                if (e is PropertyChangeEvent) {
                    postfix=getChangeType(e);
                    if (postfix == ModelChangeItem.PROPERTY_CHANGE)
                        postfix+=(e as PropertyChangeEvent).property;
                }
                return UIDUtil.getUID(e.target) + postfix;
            }
        }

        private function updateSaveRequired(mci:ModelChangeItem=null):void {
            if (mci) {
                if (mci.type != ModelChangeItem.SLIDE_SELECTION_CHANGE)
                    saveRequired=true;
                if (_lastSaveIndex > -2) {
                    _lastSaveIndex++;
                    if (_lastSaveIndex >= MAX_CACHE_SIZE) {
                        _lastSaveIndex=-2;
                    }
                }
            } else {
                if (_actions.length && (_currentIndex < _actions.length || _lastSaveIndex > -2)) {
                    var start:int;
                    var end:int;
                    if (_lastSaveIndex == -2) {
                        start=_currentIndex;
                        end=_actions.length;
                    } else if (_lastSaveIndex == _currentIndex) {
                        saveRequired=false;
                        return;
                    } else if (_lastSaveIndex > _currentIndex) {
                        start=_currentIndex;
                        end=_lastSaveIndex;
                    } else {
                        start=_lastSaveIndex;
                        end=_currentIndex;
                    }
                    for (var i:int=start; i < end; i++) {
                        if (_actions[i].type != ModelChangeItem.SLIDE_SELECTION_CHANGE) {
                            saveRequired=true;
                            return;
                        }
                    }
                    saveRequired=false;
                } else {
                    saveRequired=false;
                }
            }
        }
    }
}
