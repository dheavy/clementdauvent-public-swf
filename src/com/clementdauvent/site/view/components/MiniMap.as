package com.clementdauvent.site.view.components
{
	import BlackLogo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class MiniMap extends Sprite
	{
		protected var _logo:Bitmap;
		protected var _background:Bitmap;
		
		protected var _elementsContainer:Sprite;
		
		public function prepare(bmpData:BitmapData):void
		{
			var bmpd:BitmapData = new BlackLogo();
			_logo = new Bitmap(bmpd, PixelSnapping.AUTO, true);
			addChild(_logo);
			
			_background = new Bitmap(bmpData, PixelSnapping.AUTO, true);
			_background.alpha = 0;
			addChild(_background);
			
			_elementsContainer = new Sprite();
			addChild(_elementsContainer);
			
			_background.y = _elementsContainer.y = _logo.y + _logo.height;
		}
		
		public function addElement(b:Bitmap):void
		{
			_elementsContainer.addChild(b);
		}
		
		public function rescaleTo(maxWidth:Number):void
		{
			if (_logo) {
				var ratio:Number = _logo.height / _logo.width;
				_logo.width = maxWidth;
				_logo.height = ratio * maxWidth;
			}
			
			if (_background && _elementsContainer) {
				ratio = maxWidth / _background.width;
				_background.scaleX = _background.scaleY = _elementsContainer.scaleX = _elementsContainer.scaleY = ratio;
				_background.y = _elementsContainer.y = _logo.y + _logo.height;
			}
		}
	}
}