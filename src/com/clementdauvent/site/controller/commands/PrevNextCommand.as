package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.model.ApplicationModel;
	
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command for browsing the elements with keyboard left/right keys.</p>
	 */
	public class PrevNextCommand extends Command
	{
		/**
		 * Injected instance of events responsible for this command invocation.
		 */
		[Inject]
		public var e:KeyboardEvent;
		
		/**
		 * Injected instance of the app model.
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command, invoking proper method on model depending on the arrow key being pressed.
		 */
		override public function execute():void
		{
			switch (e.keyCode) {
				// Left arrow
				case 37:
					model.prev();
					break;
				
				// Right arrow
				case 39:
					model.next();
					break;
			}
		}
	}
}