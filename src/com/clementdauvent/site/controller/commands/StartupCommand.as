package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	import com.clementdauvent.site.model.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
	{
		/**
		 * An injected singleton instance of the main model class. 
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * An injected singleton instance of the main view class. 
		 */
		[Inject]
		public var mainView:ClementDauventPublicSite;
		
		override public function execute():void
		{
			var dataSrc:String = mainView.loaderInfo.parameters.data || 'data/public-data.json'; 
			model.loadJSON(dataSrc);
		}
	}
}