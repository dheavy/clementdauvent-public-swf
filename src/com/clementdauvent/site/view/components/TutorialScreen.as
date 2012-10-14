package com.clementdauvent.site.view.components
{
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * <p>Screen showing the usage tutorial.</p>
	 */
	public class TutorialScreen extends Sprite
	{
		protected var _background:Shape;
		protected var _ns:NetStream;
		protected var _latestStatus:String;
		protected var _vid:Video;
		
		/**
		 * @public
		 * 
		 * Builds an instance of TutorialScreen, screen showing the usage tutorial.
		 */
		public function TutorialScreen()
		{
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function dispose(e:MouseEvent = null):void
		{
			TweenMax.to(_vid, .5, { autoAlpha: 0 });
			TweenMax.to(this, .5, { autoAlpha: 0, delay: .5 });
			this.removeEventListener(MouseEvent.CLICK, dispose);
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);	
		}
		
		public function play():void
		{
			_ns.resume();
		}
		
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			buildBackground();
			buildTutorialMovie();
			redrawContent();
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, dispose);			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		protected function buildBackground():void
		{
			_background = new Shape();
			_background.graphics.beginFill(0);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
			addChild(_background);
		}
		
		protected function buildTutorialMovie():void
		{
			_latestStatus = '';
			
			_vid = new Video(640, 480);
			addChild(_vid);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			
			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			
			_ns = new NetStream(nc);
			_ns.client = customClient;
			_ns.play('vid/tutorial.f4v');
			_ns.pause();
			_ns.seek(0);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			
			_vid.attachNetStream(_ns);
		}
		
		protected function redrawContent():void
		{
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_vid.x = (stage.stageWidth - _vid.width) / 2;
			_vid.y = (stage.stageHeight - _vid.height) / 2;
		}
		
		protected function stage_resizeHandler(e:Event):void
		{
			redrawContent();
		}
		
		protected function metaDataHandler(infoObject:Object):void
		{
			// Ignore. 
		}
		
		private function netStatusEventHandler(e:NetStatusEvent):void
		{
			if (_latestStatus == "NetStream.Buffer.Flush" && e.info.code == "NetStream.Buffer.Empty") {
				// Ended.
				dispatchEvent(new Event(Event.COMPLETE));
			} else if (_latestStatus ==  "NetStream.Buffer.Flush" && e.info.code == "NetStream.Buffer.Empty") {
				// Sometimes it throws the Flush event.
				_latestStatus = "";
			} else if (e.info.code == "NetStream.Buffer.Flush") {
				_latestStatus = "NetStream.Buffer.Flush";
			}
		}
	}
}