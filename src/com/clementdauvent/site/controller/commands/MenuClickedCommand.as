package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.controller.events.MenuEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command invoked when menu is clicked.</p>
	 */
	public class MenuClickedCommand extends Command
	{
		/**
		 * Injected instance of the event responsible to this invoked command.
		 */
		[Inject]
		public var e:MenuEvent;
		
		/**
		 * Injected instance of the app model.
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command, making the model trigger the system to show an element on the surface.
		 */
		override public function execute():void
		{
			model.showElement(e.id);
		}
	}
}