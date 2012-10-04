package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.view.components.DescriptionBar;
	import com.clementdauvent.site.view.components.TitleScreen;
	import com.clementdauvent.site.view.components.TutorialScreen;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * <p>Container holding all screens.
	 */
	public class ContainerView extends Sprite
	{
		protected var _background:Shape;
		
		/**
		 * @private	The container for the oversized bitmap backdrop.
		 */
		protected var _bmp:Bitmap;
		
		/**
		 * @private	The main app screen.
		 */
		protected var _mainScreen:Sprite;
		
		/**
		 * @private	Title screen with logo.
		 */
		protected var _titleScreen:TitleScreen;
		
		protected var _descriptionBar:DescriptionBar;
		
		/**
		 * @private	Tutorial screen, between title screen and main screen.
		 */
		protected var _tutorialScreen:TutorialScreen;
		
		protected var _iter:Array;
		
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
		 * @public	create
		 * @param	data:BitmapData	The BitmapData captured from a loaded images, ready to be injected as a backdrop cover in this instance.
		 * @return	void
		 */
		public function create(data:BitmapData):void
		{
			_bmp = new Bitmap(data, PixelSnapping.AUTO, true);
			_mainScreen.addChild(_bmp);
		}
		
		/**
		 * @public	addElement
		 * @param	e:Sprite	An element (images, texts) to add in this container.
		 * @return	void
		 */
		public function addElement(e:Sprite):void
		{
			_mainScreen.addChild(e);
			
			if (e is Image || e is TextElement) {
				_iter.push(e);
			}
		}
		
		public function drawBackground():void
		{
			if (stage) {
				_background.graphics.beginFill(0xE8E8E8);
				_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_background.graphics.endFill();
			}
		}
		
		/**
		 * @public	mainScreen
		 * @return	A reference to MainScreen, the Sprite used as surface for elements.
		 */
		public function get mainScreen():Sprite
		{
			return _mainScreen;
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of this view, after rescale. To be used instead of width.
		 */
		public function get elementWidth():Number
		{
			return _bmp.width;	
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of this view, after rescale. To be used instead of width.
		 */
		public function get elementHeight():Number
		{
			return _bmp.height;
		}
		
		public function get iter():Array 
		{
			return _iter;
		}
		
		/**
		 * @private	init
		 * 
		 * Initializes the visual content.
		 */
		protected function init():void
		{
			_background = new Shape();
			drawBackground();
			addChild(_background);
			
			_mainScreen = new Sprite();
			addChild(_mainScreen);
			
			_descriptionBar = new DescriptionBar();
			addChild(_descriptionBar);
			
			_tutorialScreen = new TutorialScreen();
			addChild(_tutorialScreen);
			
			_titleScreen = new TitleScreen();
			addChild(_titleScreen);
			
			_iter = new Array();
		}
	}
}