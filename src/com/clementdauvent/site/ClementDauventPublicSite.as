package com.clementdauvent.site
{
	import com.clementdauvent.site.context.ApplicationContext;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * <p>Main class for ClementDauvent.com public frontend.</p>
	 */
	[SWF(width="1024", height="768", backgroundColor="#E8E8E8", frameRate="30")]
	
	public class ClementDauventPublicSite extends Sprite
	{
		/**
		 * @public	ClementDauventPublicSite
		 * @return	this
		 * 
		 * Creates ClementDauventPublicSite; ClementDauvent.com public frontend.
		 */
		public function ClementDauventPublicSite()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @private	init
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Sets up the Stage and invokes app start.
		 */
		protected function init(e:Event = null):void
		{
			trace("[INFO] ClementDauventPublicSite initialized");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			startApplication();
		}
		
		/**
		 * @private	startApplication
		 * @return	void
		 * 
		 * Effectively start the app via the Robotlegs apparatus.
		 */
		protected function startApplication():void
		{
			new ApplicationContext(this);
		}
	}
}