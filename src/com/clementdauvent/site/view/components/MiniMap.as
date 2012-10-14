package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.controller.events.DragEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class MiniMap extends Sprite
	{
		public static const MAX_WIDTH:Number = 100;
		
		protected var _containerScale:Number;
		protected var _logo:Bitmap;
		protected var _logoContainer:Sprite;
		protected var _logoBackground:Shape;
		protected var _container:Sprite;
		protected var _background:Bitmap;
		protected var _viewportHandle:Sprite;
		protected var _elementsContainer:Sprite;
		protected var _isDraggingViewportHandle:Boolean;
		
		public function prepare(bmpData:BitmapData):void
		{
			_container = new Sprite();
			addChild(_container);
			
			_isDraggingViewportHandle = false;
			
			buildLogoAndBackground(bmpData);
			buildViewportHandle();
		}
		
		public function addElement(b:Bitmap):void
		{
			_elementsContainer.addChild(b);
		}
		
		public function rescale(scale:Number):void
		{
			// Setup the viewport handle a first time.
			adjustViewportHandle();
			
			// Set a first scale adjustement to match that of the movable surface.
			_elementsContainer.scaleX = _elementsContainer.scaleY = _background.scaleX = _background.scaleY = scale;
			
			// Apply now the scale relevant to the desired size of the minimap.
			_containerScale = MAX_WIDTH / _background.width;
			_container.scaleX = _container.scaleY = _containerScale;
			
			// Adjust Logo to desired dimensions.
			var r:Number = _logo.height / _logo.width;
			_logo.width = MAX_WIDTH - 2;
			_logo.height = MAX_WIDTH * r;
			_logo.x = 1;
			_logoBackground.graphics.beginFill(0xCCCCCC, 0);
			_logoBackground.graphics.drawRect(0, -5, MAX_WIDTH, _logo.height + 5);
			_logoBackground.graphics.endFill();
		}
		
		public function adjustViewportHandle():void
		{
			if (_viewportHandle) {
				_viewportHandle.width = stage.stageWidth;
				_viewportHandle.height = stage.stageHeight;
			}
			
			_container.y = _logo.y + _logo.height;
		}
		
		public function setViewportHandlePosition(p:Point):void
		{
			_viewportHandle.x = _background.x + p.x * -1;
			_viewportHandle.y = _background.y + p.y * -1;
		}
		
		public function get isDraggingViewportHandle():Boolean
		{
			return _isDraggingViewportHandle;
		}
		
		protected function buildLogoAndBackground(bmpData:BitmapData):void
		{
			_logoContainer = new Sprite();
			addChild(_logoContainer);
			
			_logoBackground = new Shape();
			_logoContainer.addChild(_logoBackground);
			
			var bmpd:BitmapData = new BlackLogo();
			_logo = new Bitmap(bmpd, PixelSnapping.AUTO, true);
			_logoContainer.addChild(_logo);
			
			_background = new Bitmap(bmpData, PixelSnapping.AUTO, true);
			_background.alpha = 0;
			_container.addChild(_background);
			
			_elementsContainer = new Sprite();
			_container.addChild(_elementsContainer);
			
			_container.y = _logo.y + _logo.height;
		}
		
		protected function buildViewportHandle():void
		{
			_viewportHandle = new Sprite();
			_viewportHandle.graphics.lineStyle(1, 0x111111);
			_viewportHandle.graphics.beginFill(0x555555, .4);
			_viewportHandle.graphics.drawRect(0, 0, _background.width,_background.height);
			_viewportHandle.graphics.endFill();
			_viewportHandle.buttonMode = true;
			_container.addChild(_viewportHandle);
			
			_viewportHandle.addEventListener(MouseEvent.MOUSE_DOWN, viewportHandle_mouseDownHandler);
		}
		
		protected function dispatchDragSignal(dispatch:Boolean):void
		{
			if (dispatch) {
				addEventListener(Event.ENTER_FRAME, dragSignal);
			} else {
				removeEventListener(Event.ENTER_FRAME, dragSignal);
			}
			var p:Point = new Point();
			p.x = _viewportHandle.x;
			p.y = _viewportHandle.y;
			dispatchEvent(new DragEvent(DragEvent.DRAG_MINIMAP_VIEWPORT, p));
		}
		
		protected function viewportHandle_mouseDownHandler(e:MouseEvent):void
		{
			_isDraggingViewportHandle = true;
			_viewportHandle.removeEventListener(MouseEvent.MOUSE_DOWN, viewportHandle_mouseDownHandler);
			_viewportHandle.addEventListener(MouseEvent.MOUSE_UP, viewportHandle_mouseOutHandler);
			_viewportHandle.addEventListener(MouseEvent.MOUSE_OUT, viewportHandle_mouseOutHandler);
			
			dispatchDragSignal(true);
			
			_viewportHandle.startDrag(false, new Rectangle(0, 0, _background.width - _viewportHandle.width, _background.height - _viewportHandle.height));
		}
		
		protected function viewportHandle_mouseOutHandler(e:MouseEvent):void
		{
			dispatchDragSignal(false);
			
			_isDraggingViewportHandle = false;
			_viewportHandle.removeEventListener(MouseEvent.MOUSE_UP, viewportHandle_mouseOutHandler);
			_viewportHandle.removeEventListener(MouseEvent.MOUSE_OUT, viewportHandle_mouseOutHandler);
			_viewportHandle.addEventListener(MouseEvent.MOUSE_DOWN, viewportHandle_mouseDownHandler);
			_viewportHandle.stopDrag();
		}
		
		protected function dragSignal(e:Event):void
		{
			var p:Point = new Point(_viewportHandle.x, _viewportHandle.y);
			dispatchEvent(new DragEvent(DragEvent.DRAG_MINIMAP_VIEWPORT, p));
		}
	}
}