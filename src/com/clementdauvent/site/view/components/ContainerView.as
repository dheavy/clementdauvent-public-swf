package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.view.components.MainScreen;
	import com.clementdauvent.site.view.components.TitleScreen;
	import com.clementdauvent.site.view.components.TutorialScreen;
	
	import flash.display.Sprite;
	
	/**
	 * <p>Container holding all screens.
	 */
	public class ContainerView extends Sprite
	{
		/**
		 * @private	The main app screen.
		 */
		protected var _mainScreen:MainScreen;
		
		/**
		 * @private	Title screen with logo.
		 */
		protected var _titleScreen:TitleScreen;
		
		/**
		 * @private	Tutorial screen, between title screen and main screen.
		 */
		protected var _tutorialScreen:TutorialScreen;
		
		/**
		 * @public ContainerView
		 * 
		 * Builds an instance of ContainerView, container holding all screen.
		 */
		public function ContainerView()
		{
			init();
		}
		
		/**
		 * @private	init
		 * 
		 * Initializes the visual content.
		 */
		protected function init():void
		{
			_mainScreen = new MainScreen();
			addChild(_mainScreen);
			
			_tutorialScreen = new TutorialScreen();
			addChild(_tutorialScreen);
			
			_titleScreen = new TitleScreen();
			addChild(_titleScreen);
		}
	}
}