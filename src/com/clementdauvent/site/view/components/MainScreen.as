package com.clementdauvent.site.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * <p>Screen containing the main app.</p>
	 */
	public class MainScreen extends Sprite
	{
		protected var _background:Shape;
		
		/**
		 * @public
		 * 
		 * Builds an instance of MainScreen, the screen containing the main app.
		 */
		public function MainScreen()
		{
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			
			_background = new Shape();
			_background.graphics.beginFill(0xE8E8E8);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
			addChild(_background);
			
			redrawBackground();
		}
		
		protected function redrawBackground():void
		{
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
		}
		
		protected function stage_resizeHandler(e:Event):void
		{
			redrawBackground();
		}
	}
}