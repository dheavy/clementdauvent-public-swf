package com.clementdauvent.site.view.components
{
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * <p>Screen showing the usage tutorial.</p>
	 */
	public class TutorialScreen extends Sprite
	{
		protected var _background:Shape;
		
		/**
		 * @public
		 * 
		 * Builds an instance of TutorialScreen, screen showing the usage tutorial.
		 */
		public function TutorialScreen()
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
			this.removeEventListener(MouseEvent.CLICK, dispose);
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			buildBackground();
			buildTutorialMovie();
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, dispose);			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		protected function buildBackground():void
		{
			_background = new Shape();
			_background.graphics.beginFill(0);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
			addChild(_background);
		}
		
		protected function buildTutorialMovie():void
		{
			
		}
		
		protected function stage_resizeHandler(e:Event):void
		{
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
		}
	}
}