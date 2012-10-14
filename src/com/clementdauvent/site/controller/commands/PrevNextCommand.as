package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.model.ApplicationModel;
	
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class PrevNextCommand extends Command
	{
		[Inject]
		public var e:KeyboardEvent;
		
		[Inject]
		public var model:ApplicationModel;
		
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