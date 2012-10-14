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
	import flash.events.Event;
	
	/**
	 * <p>Container holding all screens.
	 */
	public class ContainerView extends Sprite
	{
		/**
		 * @private	The container for the oversized bitmap backdrop.
		 */
		protected var _bmp:Bitmap;
		
		protected var _background:Shape;
		
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
		
		protected var _hud:Sprite;
		
		protected var _miniMap:MiniMap;
		
		protected var _menu:Menu;
		
		/**
		 * @public ContainerView
		 * 
		 * Builds an instance of ContainerView, container holding all screen.
		 */
		public function ContainerView()
		{
			_background = new Shape();
			_background.graphics.beginFill(0xE8E8E8);
			_background.graphics.drawRect(0, 0, 1, 1);
			_background.graphics.endFill();
			addChild(_background);
			
			addEventListener(Event.ADDED_TO_STAGE, redrawBackground);
			
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
		
		public function addMiniMap(m:MiniMap):void
		{
			_miniMap = m;
			_hud.addChild(_miniMap);
		}
		
		public function addMenu(m:Menu):void
		{
			_menu = m;
			_menu.addEventListener(Event.ENTER_FRAME, adjustMenu);
			_hud.addChild(_menu);
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
			_mainScreen = new Sprite();
			addChild(_mainScreen);
			
			_hud = new Sprite();
			_hud.x = _hud.y = 5;
			addChild(_hud);
			
			_descriptionBar = new DescriptionBar();
			addChild(_descriptionBar);
			
			_tutorialScreen = new TutorialScreen();
			addChild(_tutorialScreen);
			
			_mainScreen.alpha = _hud.alpha = _descriptionBar.alpha = _tutorialScreen.alpha = 0;
			
			_titleScreen = new TitleScreen();
			_titleScreen.alpha = 0;
			_titleScreen.addEventListener(TitleScreen.READY, titleScreen_readyHandler);
			addChild(_titleScreen);
			
			addEventListener(Event.RESIZE, redrawBackground);
			
			_iter = new Array();
		}
		
		protected function redrawBackground(e:Event = null):void
		{
			if (stage) {
				_background.width = stage.stageWidth;
				_background.height = stage.stageHeight;
			}
		}
		
		protected function adjustMenu(e:Event):void
		{
			_menu.y = _miniMap.y + _miniMap.height;
		}
		
		protected function titleScreen_readyHandler(e:Event):void
		{
			_titleScreen.removeEventListener(TitleScreen.READY, titleScreen_readyHandler);
			TweenMax.to(_titleScreen, 1, { autoAlpha: 1, onComplete: function():void {
					_mainScreen.alpha = _hud.alpha = _descriptionBar.alpha = _tutorialScreen.alpha = 1;
					_tutorialScreen.play();
				}
			});
		}
	}
}