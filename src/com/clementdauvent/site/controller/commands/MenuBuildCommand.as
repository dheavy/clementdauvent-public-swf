package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.Menu;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command to build the menu.</p>
	 */
	public class MenuBuildCommand extends Command
	{
		/**
		 * Injected instance of the container view.
		 */
		[Inject]
		public var containerView:ContainerView;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes command, creating and adding menu to the container view.
		 */
		override public function execute():void
		{
			var menu:Menu = new Menu();
			containerView.addMenu(menu);
		}
	}
}