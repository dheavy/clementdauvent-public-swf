package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.controller.events.DragEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	import com.clementdauvent.site.model.vo.*;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.MiniMap;
	import com.clementdauvent.site.view.components.TextElement;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MiniMapMediator extends Mediator
	{
		[Inject]
		public var model:ApplicationModel;
		
		[Inject]
		public var map:MiniMap;
		
		override public function onRegister():void
		{
			map.addEventListener(Event.ADDED_TO_STAGE, initView);
			map.addEventListener(DragEvent.DRAG_MINIMAP_VIEWPORT, map_dragViewportHandler);
			eventDispatcher.addEventListener(DataFetchEvent.DATA_READY, eventBus_dataReadyHandler);
			eventDispatcher.addEventListener(DragEvent.DRAG_SURFACE, eventBus_dragMainScreenHandler);
		}
		
		public function build(vo:DataVO):void
		{
			var images:Vector.<ImageVO> = vo.images;
			var texts:Vector.<TextVO> = vo.texts;
			
			var i:int = 0, j:int = 0;
			var length:int = images.length;
			var refScale:Number = 1;
			
			for (i; i < length; i++) {
				var iVo:ImageVO = images[i];
				var img:Bitmap = new Bitmap(new BitmapData(iVo.originalWidth, iVo.originalHeight, false, 0x111111), PixelSnapping.AUTO, false);
				img.x = iVo.xOffset;
				img.y = iVo.yOffset;
				map.addElement(img);
			}
			
			/* -- uncomment to show text blocks in minimap
			var k:int = 0, l:int = 0;
			length = texts.length;
			for (k; k < length; k++) {
				var tVo:TextVO = texts[k];
				var t:Bitmap = new Bitmap(new BitmapData(TextElement.WIDTH, TextElement.HEIGHT, false, 0x111111), PixelSnapping.AUTO, false);
				t.x = tVo.xOffset;
				t.y = tVo.yOffset;
				t.scaleX = t.scaleY = model.referenceScale;
				map.addElement(t);
			}*/
			
			map.rescale(model.mainScreenScale);
			
			Logger.print("[INFO] MiniMapMediator finished configuring the minimap");
			
			// Next call: will trigger building/positioning the menu under the minimap.
			eventDispatcher.dispatchEvent(new DataFetchEvent(DataFetchEvent.FINISH, vo));
		}
		
		protected function adjustViewportHandle(e:Event):void
		{
			map.adjustViewportHandle();
		}
		
		protected function initView(e:Event):void
		{
			map.removeEventListener(Event.ADDED_TO_STAGE, initView);
			map.addEventListener(Event.ENTER_FRAME, adjustViewportHandle);
		}
		
		protected function eventBus_dataReadyHandler(e:DataFetchEvent):void
		{
			eventDispatcher.removeEventListener(DataFetchEvent.DATA_READY, eventBus_dataReadyHandler);
			build(e.vo);
		}
		
		protected function eventBus_dragMainScreenHandler(e:DragEvent):void
		{
			if (!map.isDraggingViewportHandle) 
				map.setViewportHandlePosition(e.pos);
		}
		
		protected function map_dragViewportHandler(e:DragEvent):void
		{
			dispatch(e);
		}
	}
}