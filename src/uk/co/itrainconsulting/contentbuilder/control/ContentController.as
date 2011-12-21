package uk.co.itrainconsulting.contentbuilder.control {

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.net.SharedObject;
    
    import flashx.textLayout.factory.TruncationOptions;
    
    import mx.events.DynamicEvent;
    import mx.events.SliderEvent;
    
    import org.swizframework.controller.AbstractController;
    
    import uk.co.itrainconsulting.common.model.EnumObjectType;
    import uk.co.itrainconsulting.common.model.Slide;
    import uk.co.itrainconsulting.common.model.mediaObjects.AudioMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.ButtonMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.ImageMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
    import uk.co.itrainconsulting.common.model.mediaObjects.ShapeMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.TextMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.VideoMedia;
    import uk.co.itrainconsulting.contentbuilder.control.events.ContentBuiltEvent;
    import uk.co.itrainconsulting.contentbuilder.control.events.ContentLoadedEvent;
    import uk.co.itrainconsulting.contentbuilder.control.events.EditorEvent;
    import uk.co.itrainconsulting.contentbuilder.control.events.SlideEvent;
    import uk.co.itrainconsulting.contentbuilder.model.Constants;
    import uk.co.itrainconsulting.contentbuilder.model.ContentModel;

    public class ContentController extends AbstractController {
        // Service events
        public static const GET_AUDIO_LIST:String="getAudioList";
        public static const GET_VIDEO_LIST:String="getVideoList";
        public static const GET_IMAGE_LIST:String="getImageList";
        public static const GET_ALL_ASSETS_LIST:String="getAllAssetsList";
        public static const GET_TEMPLATE_LIST:String="getTemplateList";
        public static const AUDIO_LIST_RETRIEVED:String="audioListRetrieved";
        public static const VIDEO_LIST_RETRIEVED:String="videoListRetrieved";
        public static const IMAGE_LIST_RETRIEVED:String="imageListRetrieved";
        public static const TEMPLATE_LIST_RETRIEVED:String="templateListRetrieved";
        public static const SAVE_CONTENT:String="saveContent";
        public static const CONTENT_SAVED:String="contentSaved";
        public static const NAVIGATION_UPDATED:String="navigationUpdated";
        public static const FLASHVARS_READY:String="flashVarsReady";

        public static const GENERATE_XML:String="generateXML";
        public static const CLEAR_SELECTION:String="clearSelection";

        // Slide events
        public static const NEW_SLIDE:String="newSlide";
        public static const SLIDE_SELECTED:String="slideSelected";
        public static const SLIDE_ADDED:String="slideAdded";
        public static const SLIDE_MOVED:String="slideMoved";
        public static const DUPLICATE_SLIDE:String="duplicateSlide";
        public static const EXPORT_CANVAS:String="exportCanvas";
        public static const EXPORT_CANVAS_COMPLETED:String="exportCanvasCompleted";
        public static const MOVE_CANVAS_UP:String="moveCanvasUp";
        public static const MOVE_CANVAS_DOWN:String="moveCanvasDown";
        public static const SHOW_TEMPLATES:String="showTemplates";
        public static const NEW_SLIDE_FROM_TEMP:String="newSlideFromTemp";

        //public static const DELETE_CANVAS:String = "deleteCanvas";
        //public static const COMMIT_CANVAS_DELETE:String = "commitCanvasDelete";
        //public static const CANVAS_DELETED:String = "canvasDeleted";

        // Media Events
        public static const MEDIA_SELECTED:String="mediaSelected";
        public static const STOP_PLAYBACK:String="stopPlayback";
        public static const MEDIA_FORWARDS:String="mediaForwards";
        public static const MEDIA_BACKWARDS:String="mediaBackwards";
        public static const MEDIA_TO_FRONT:String="mediaToFront";
        public static const MEDIA_TO_BACK:String="mediaToBack";
        public static const MEDIA_COPIED:String="mediaCopied";
        public static const MEDIA_PASTED:String="mediaPasted";
        public static const OBJECT_COPIED:String="objectCopied";
        public static const OBJECT_PASTED:String="objectPasted";
        public static const CLEAR_FOCUS:String="clearFocus";

        public static const LOAD_PREVIEWER:String="loadPreviewer";
        public static const SHOW_SLIDE_THUMBNAILS:String="showSlideThumbnails";
        public static const SHOW_SLIDE_EDITOR:String="showSlideEditor";

        //public static const CANVAS_UPDATED:String = "canvasUpdated";

        [Inject]
        [Bindable]
        public var contentModel:ContentModel;

        public function ContentController() {
            super();
        }

        [Mediate(event="generateXML", properties="selectedSlideOnly")]
        public function generateXML(selectedSlideOnly:Boolean=false):String {
            contentModel.selectedSlideOnly=selectedSlideOnly;
            var newXML:XML=<content>
                    <properties>
                        <stageColors>
                            <color></color>
                            <color></color>
                        </stageColors>
                    </properties>
                    <slides>
                    </slides>
                </content>;
            newXML.properties.@width=contentModel.contentProps.width;
            newXML.properties.@height=contentModel.contentProps.height;
            newXML.properties.@title=contentModel.contentProps.title;
            newXML.properties.@backgroundColor=contentModel.contentProps.bgColor;
            newXML.properties.@showSlideList=contentModel.contentProps.showSlideList;
            if (contentModel.contentProps.hasBGImage) {
                newXML.properties.@bgImage=contentModel.contentProps.bgImage;
                newXML.properties.@bgImageMethod=contentModel.contentProps.bgImageMethod;
            } else {
                newXML.properties.@bgImage="";
                newXML.properties.@bgImageMethod="";
            }
            newXML.properties.stageColors.color[0]=contentModel.contentProps.stageColors[0];
            newXML.properties.stageColors.color[1]=contentModel.contentProps.stageColors[1];
            for each (var s:Slide in contentModel.slides.getAll()) {
                // check if it's supposed to show up in the navigation first, then:
                XML(newXML.slides).appendChild(s.generateXML(contentModel.contentProps));
            }
            contentModel.previewXML=newXML;
            return newXML.toXMLString();
        }

        [Mediate(event="moveCanvasUp", priority="1")]
        public function moveCanvasUp():void {
            var currI:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide);
            var total:int=contentModel.slides.slidesCount;
            if (currI > 0) {
                contentModel.slides.addSlide(contentModel.slides.removeSlideAt(currI), currI - 1, false);
                var ee:EditorEvent=new EditorEvent(EditorEvent.RESELECT_SLIDE, true);
                dispatcher.dispatchEvent(ee);
            }
        }

        [Mediate(event="moveCanvasDown", priority="1")]
        public function moveCanvasDown():void {
            var currI:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide);
            var total:int=contentModel.slides.slidesCount;
            if (currI < total - 1) {
                contentModel.slides.addSlide(contentModel.slides.removeSlideAt(currI), currI + 1, false);
                var ee:EditorEvent=new EditorEvent(EditorEvent.RESELECT_SLIDE, true);
                dispatcher.dispatchEvent(ee);
            }
        }

        [Mediate(event="ContentLoadedEvent.CONTENT_LOADED", properties="xml")]
        public function handleXMLLoaded(val:XML):void {
            if (val is XML) {
                contentModel.contentProps.setup(val.properties);
            }
            var slidesList:XMLList=val.slides.slide;
            contentModel.slides.unlistenForChange();
            for each (var col:XML in slidesList) {
                contentModel.slides.addSlideAt(col);
            }
            contentModel.slides.listenForChange();
            var ce:ContentBuiltEvent=new ContentBuiltEvent(ContentBuiltEvent.CONTENT_BUILT, true);
            dispatcher.dispatchEvent(ce);
        }

        [Mediate(event="templateListRetrieved", priority="1", properties="xml")]
        public function handleTemplatesRetrieved(val:XML):void {
            if (val is XML) {
                var tempList:XMLList=val.slides.slide;
                contentModel.templates.removeAllSlides();
                for each (var s:XML in tempList) {
                    contentModel.templates.addSlideAt(s);
                }
            }
        }

        [Mediate(event="mediaCopied")]
        public function copiedMedia():void {
            contentModel.copiedType=contentModel.selectedType;
            contentModel.copiedMedia=contentModel.selectedResizableObject.model.clone();
        }

        //mkit tries

        [Mediate(event="objectCopied")]
        public function objectCopied():void {
            contentModel.copiedType=contentModel.selectedType;
            var sharedObject:SharedObject=SharedObject.getLocal('localClipboard');
            if (contentModel.selectedType.equals(EnumObjectType.SLIDE)) {
                sharedObject.data.slide=contentModel.selectedSlide.generateXML(contentModel.contentProps).toXMLString();
                sharedObject.data.slideObject='';
            } else {
                sharedObject.data.slideObject=contentModel.selectedResizableObject.model.convertToXML().toXMLString();
                sharedObject.data.slide='';
            }
            sharedObject.flush();
        }


        [Mediate(event='objectPasted')]
        public function objectPasted():void {
            var sharedObject:SharedObject=SharedObject.getLocal('localClipboard');
            if (sharedObject.data.slideObject.indexOf('<slideObject') == 0) {
                contentModel.copiedMedia=Slide.xmlToMediaObject(XML(sharedObject.data.slideObject));
                if (contentModel.copiedMedia is ImageMedia)
                    contentModel.copiedType=EnumObjectType.IMAGE;
                else if (contentModel.copiedMedia is TextMedia)
                    contentModel.copiedType=EnumObjectType.TEXT;
                else if (contentModel.copiedMedia is VideoMedia)
                    contentModel.copiedType=EnumObjectType.VIDEO;
                else if (contentModel.copiedMedia is AudioMedia)
                    contentModel.copiedType=EnumObjectType.AUDIO;
                else if (contentModel.copiedMedia is ShapeMedia)
                    contentModel.copiedType=EnumObjectType.SHAPE;
                else if (contentModel.copiedMedia is ButtonMedia)
                    contentModel.copiedType=EnumObjectType.BUTTON;
                dispatcher.dispatchEvent(new Event(MEDIA_PASTED, true));
            } else if (sharedObject.data.slide.indexOf('<slide') == 0) {
                var newSlide:Slide=contentModel.slides.addSlideAt(XML(sharedObject.data.slide), contentModel.slides.getSlideIndex(contentModel.selectedSlide) + 1);
                var se:SlideEvent=new SlideEvent(ContentController.SLIDE_ADDED, newSlide, true);
                dispatcher.dispatchEvent(se);
            }
        }

        [Mediate(event="duplicateSlide", priority="1")]
        public function duplicateSlide():void {
            var currI:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide);
            var newSlide:Slide=contentModel.selectedSlide.clone();
            contentModel.slides.addSlide(newSlide, currI + 1, false);
            var se:SlideEvent=new SlideEvent(ContentController.SLIDE_ADDED, newSlide, true);
            dispatcher.dispatchEvent(se);
        }

        [Mediate(event="newSlide", priority="1")]
        public function newSlide():void {
            if (contentModel.selectedSlide != null) {
                var index:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide) + 1;
                contentModel.slides.addNewSlide(index);
            } else {
                contentModel.slides.addNewSlide();
            }
        }

        [Mediate(event="newSlideFromTemp")]
        public function newSlideFromTemp(ev:SlideEvent):void {
            if (contentModel.selectedSlide != null) {
                var index:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide) + 1;
                contentModel.slides.addSlide(ev.slide, index);
            } else {
                contentModel.slides.addSlide(ev.slide);
            }
        }

        [Mediate(event="EditorEvent.DELETE_SLIDE", priority="1")]
        public function commitCanvasDelete():void {
            var e:Event=new Event(ContentController.STOP_PLAYBACK, true);
            dispatcher.dispatchEvent(e);
            var oldIndex:int=contentModel.slides.getSlideIndex(contentModel.selectedSlide);
            contentModel.slides.removeSlideAt(oldIndex);

            clearModelSelection();

            if (contentModel.slides.slidesCount > 0) {
                var ee:EditorEvent=new EditorEvent(EditorEvent.SLIDE_DELETED, true);
                ee.additionalData=oldIndex;
                dispatcher.dispatchEvent(ee);

                if (oldIndex == contentModel.slides.slidesCount) {
                    contentModel.selectedSlide=contentModel.slides.getSlideAt(oldIndex - 1);
                } else {
                    contentModel.selectedSlide=contentModel.slides.getSlideAt(oldIndex);
                }
                contentModel.selectedType=EnumObjectType.SLIDE;
            }
        }

        private function clearModelSelection():void {
            contentModel.selectedResizableObject=null;
            contentModel.selectedType=EnumObjectType.NONE;
        }

        private function informMediaReordered(media:MediaObject, oldIndex:int):void {
            var ee:EditorEvent=new EditorEvent(EditorEvent.MEDIA_REORDERED, true);
            ee.slide=contentModel.selectedSlide;
			ee.media = media;
			ee.additionalData = oldIndex;
            dispatcher.dispatchEvent(ee);
        }

        [Mediate(event="slideSelected", properties="slide", priority="0")]
        public function handleSlideSelected(slide:Slide):void {
            if (slide) {
                contentModel.selectedSlide=slide;
                contentModel.selectedType=EnumObjectType.SLIDE;
            } else {
                contentModel.selectedType=EnumObjectType.NONE;
				contentModel.selectedSlide=null;
            }
        }

        [Mediate(event="mediaForwards")]
        public function mediaForwards():void {
			var mo:MediaObject = contentModel.selectedResizableObject.model;
			informMediaReordered(mo, contentModel.selectedSlide.moveObjectForwards(mo));
        }

        [Mediate(event="mediaBackwards")]
        public function mediaBackwards():void {
			var mo:MediaObject = contentModel.selectedResizableObject.model;
			informMediaReordered(mo, contentModel.selectedSlide.moveObjectBack(mo));
        }

        [Mediate(event="mediaToFront")]
        public function mediaToFront():void {
			var mo:MediaObject = contentModel.selectedResizableObject.model;
			informMediaReordered(mo, contentModel.selectedSlide.moveObjectToFront(mo));
        }

        [Mediate(event="mediaToBack")]
        public function mediaToBack():void {
			var mo:MediaObject = contentModel.selectedResizableObject.model;
			informMediaReordered(mo, contentModel.selectedSlide.moveObjectToBack(mo));
        }
    }
}
