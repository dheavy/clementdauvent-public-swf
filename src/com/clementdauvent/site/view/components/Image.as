package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.model.vo.ImageVO;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.IDraggable;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * <p>The Image view used to represent image content on the Surface</p>
	 */
	public class Image extends Sprite implements IDraggable
	{
		/**
		 * @private	The unique ID for this instance.
		 */
		protected var _id:uint;
		
		/**
		 * @private	URL for the image resource of this Image instance.
		 */
		protected var _src:String;
		
		/**
		 * @private	Expected width of this element.
		 */
		protected var _elementWidth:Number;
		
		/**
		 * @private	Expected height of this element.
		 */
		protected var _elementHeight:Number;
		
		/**
		 * @private	The image container.
		 */
		protected var _img:Sprite;
		
		/**
		 * @private	The Loader loading the image resource.
		 */
		protected var _imgLoader:Loader;
		
		/**
		 * @private	The loading bar used to show progress of image loading.
		 */
		protected var _progressBar:Shape;
		
		/**
		 * @private	Whether or not this is the opening element on the website.
		 */
		protected var _isFirst:Boolean = false;
		
		/**
		 * @private	The scale of the image.
		 */
		protected var _scale:Number;
		
		/**
		 * @private	The description of this image.
		 */
		protected var _desc:String;
		
		/**
		 * @public	Image
		 * @param	id:uint				Unique ID for this instance.
		 * @param	src:String			URL for this image resource.
		 * @param	w:Number			Basic witdh for this element.
		 * @param	h:Number			Basic height for this element.
		 * @param	scale:Number		The scale to apply to the image.
		 * @param	desc:String			The image description.
		 * @return	this
		 * 
		 * Creates an instance of draggable, resizable Image element.
		 */
		public function Image(id:uint, src:String, w:Number, h:Number, scale:Number, desc:String)
		{
			_id = id;
			_src = src;
			_elementWidth = w;
			_elementHeight = h;
			_scale = scale;
			_desc = desc;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @public	id
		 * @return	The uint unique id of this instance.
		 */
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of the image.
		 */
		public function get elementWidth():Number
		{
			return _img.width;
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of the image.
		 */
		public function get elementHeight():Number
		{
			return _img.height;
		}
		
		/**
		 * @public	scale
		 * @return	The current scale of the image.
		 */
		public function get scale():Number
		{
			return _img.scaleY;
		}
		
		/**
		 * @public	isFirst
		 * @return	Whether or not this is the opening element on the website.
		 */
		public function get isFirst():Boolean
		{
			return _isFirst;
		}
		
		/**
		 * @public	toString
		 * @return	A String representation of the instance.
		 */
		override public function toString():String
		{
			return "[Image — id: " + id + ", src: " + _src + ", elementWidth: " + elementWidth + ", elementHeight: " + elementHeight + ", scale: " + scale + "]";
		}
		
		/**
		 * @public	serialize
		 * @return	An ImageVO instance, serialized version of this Image instance.
		 */
		public function serialize():ImageVO
		{
			return new ImageVO(_src, elementWidth, elementHeight, isFirst, x, y, scale, _desc);
		}
		
		/**
		 * @public	init
		 * @return	void
		 * 
		 * Initializes the instance.
		 */
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Creates graphical elements (image and handle containers).
			_img = new Sprite();
			_img.graphics.beginFill(0x000000);
			_img.graphics.drawRect(0, 0, _elementWidth, _elementHeight);
			addChild(_img);
			
			// Creates progress bar and leave it ready for loading action...
			_progressBar = new Shape();
			var g:Graphics = _progressBar.graphics;
			g.beginFill(0x999999);
			g.moveTo(0, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
			_progressBar.scaleX = 0;
			addChild(_progressBar);			
			
			// Load Image resource.
			_imgLoader = new Loader();
			_imgLoader.contentLoaderInfo.addEventListener(Event.INIT, imgLoader_initHandler);
			_imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imgLoader_progressHandler);
			_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoader_ioErrorHandler);
			_imgLoader.load(new URLRequest(_src));
		}
		
		/**
		 * @private	removeImgLoaderListeners
		 * @return	void
		 * 
		 * Removes the listeners used by the image loader.
		 */
		protected function removeImgLoaderListeners():void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(Event.INIT, imgLoader_initHandler);
			_imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, imgLoader_progressHandler);
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoader_ioErrorHandler);
			_imgLoader = null;
		}
		
		/**
		 * @private imgLoader_initHandler
		 * @return	void
		 * 
		 * Event handler triggered when image has loaded successfully. 
		 * Adds image to display list.
		 */
		protected function imgLoader_initHandler(e:Event):void
		{
			TweenMax.to(_img, 0, { autoAlpha: 0 });
			
			var bmp:Bitmap = _imgLoader.content as Bitmap;
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = _scale;
			_img.addChild(bmp);
			
			TweenMax.to(_img, .1, { autoAlpha: 1 });
			TweenMax.to(_progressBar, .5, { autoAlpha: 0, onComplete: 
				function():void {
					removeChild(_progressBar);
					_progressBar = null;
				}
			});
			
			removeImgLoaderListeners();
			
			Logger.print("[INFO] Image " + id + " is ready.");
		}
		
		/**
		 * @private	imgLoader_progressHandler
		 * @return	void
		 * 
		 * Event handler triggered on load progress. Updates progress bar.
		 */
		protected function imgLoader_progressHandler(e:ProgressEvent):void
		{
			_progressBar.scaleX = e.bytesLoaded / e.bytesTotal;
		}
		
		/**
		 * @private	imgLoader_ioErrorHandler
		 * @return	void
		 * 
		 * Event handler triggered when image loading fails. 
		 */
		protected function imgLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			removeImgLoaderListeners();
			Logger.print("[ERROR] Image " + id + " couldn't load its photograph: " + e.text);
		}
	}
}