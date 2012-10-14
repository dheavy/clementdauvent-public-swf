package com.clementdauvent.site.view.components
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * <p>First screen displaying to the user with the title of the website on it.</p>
	 */
	public class TitleScreen extends Sprite
	{
		public static const READY:String = "titleScreenReady";
		
		protected var _background:Shape;
		protected var _logo:Bitmap;
		
		/**
		 * @public	TitleScreen
		 * 
		 * Builds an instance of TitleScreen, first screen displaying to the user with the title of the website on it.
		 */
		public function TitleScreen()
		{
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function dispose(e:MouseEvent = null):void
		{
			TweenMax.to(this, 1, { autoAlpha: 0 });
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
			this.removeEventListener(MouseEvent.CLICK, dispose);
		}
		
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			buildBackground();
			buildLogo();
			redrawScreen();
			dispatchEvent(new Event(TitleScreen.READY));
			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			this.addEventListener(MouseEvent.CLICK, dispose);
			
			this.buttonMode = true;
		}
		
		protected function buildBackground():void
		{
			_background = new Shape();
			_background.graphics.beginFill(0);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
			addChild(_background);
		}
		
		protected function buildLogo():void
		{
			var bmpd:BitmapData = new WhiteLogo as BitmapData;
			_logo = new Bitmap(bmpd, PixelSnapping.AUTO, true);
			addChild(_logo);
		}
		
		protected function redrawScreen():void
		{
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_logo.x = (stage.stageWidth - _logo.width) / 2;
			_logo.y = (stage.stageHeight - _logo.height) / 2;
		}
		
		protected function stage_resizeHandler(e:Event):void
		{
			redrawScreen();
		}
	}
}