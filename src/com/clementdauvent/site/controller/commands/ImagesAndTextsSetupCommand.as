package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.controller.events.ElementEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command in charge of setting up images and texts on the MainView.</p>
	 */
	public class ImagesAndTextsSetupCommand extends Command
	{
		/**
		 * The injected singleton instance of the main application model, where the data is contained for building these elements. 
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command, effectively building and adding to the ContainerView the set of Image and Text instances constitutive of this application.
		 */
		override public function execute():void
		{
			// This event will trigger container and minimap building.
			dispatch(new DataFetchEvent(DataFetchEvent.DATA_READY, model.data));
			
			// Show opening element.
			dispatch(new ElementEvent(ElementEvent.SELECT, model.currentIndex));
		}
	}
}