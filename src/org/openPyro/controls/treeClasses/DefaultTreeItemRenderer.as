package org.openPyro.controls.treeClasses
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.events.TreeEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.layout.HLayout;
	import org.openPyro.painters.TrianglePainter;
	
	[Event(name="rotatorClick", type="org.openPyro.controls.events.TreeEvent")]

	public class DefaultTreeItemRenderer extends DefaultListRenderer
	{
		
		/*
		The Folder Symbol is embedded in the graphic_assets.swc 
		generated from the graphics_assets.fla	
		*/
		protected var folderIconClass:Class = folderSymbol;
		
		public function DefaultTreeItemRenderer()
		{
			super();
		}
		
		private var folderIcon:DisplayObject;
		private var leafIcon:DisplayObject;
		private var rotator:Sprite;
		private var arrow:Sprite;
		
		override protected function createChildren():void{
			super.createChildren()
		}
		
		override public function set data(value:Object):void{
			if(_data && _data is IEventDispatcher){
				IEventDispatcher(_data).removeEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			super.data = value;
			
			if(_data is IEventDispatcher){
				IEventDispatcher(_data).addEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			
			if(!XMLNodeDescriptor(value).isLeaf()){
				if(!folderIcon){
					folderIcon = new folderIconClass();
				}
				if(!folderIcon.parent){
					addChild(folderIcon);
				}
				if(!rotator){
					rotator = new Sprite();
					rotator.graphics.beginFill(0x000000,0)
					rotator.graphics.drawRect(0,0, 20,20);
					rotator.graphics.endFill()
					
					
					arrow = new Sprite();
					
					var trianglePainter:TrianglePainter = new TrianglePainter(TrianglePainter.CENTERED);
					trianglePainter.draw(arrow.graphics, 8,8)
					//rotator.addChild(arrow)
					addChild(arrow)
					arrow.cacheAsBitmap = true;
					
					rotator.buttonMode = true;
					rotator.useHandCursor = true
					
					rotator.addEventListener(MouseEvent.CLICK, onRotatorClick)//,true,1,true)
					rotator.mouseChildren=false;
				}
				if(!rotator.parent){
					addChild(rotator);
				}
			}
			else{
				if(folderIcon && folderIcon.parent){
					removeChild(folderIcon);
					folderIcon =  null;
				}
				if(rotator && rotator.parent){
					removeChild(rotator);
					rotator = null
				}
				if(arrow && arrow.parent){
					removeChild(arrow);
					arrow = null
				}
				
				
			}
			this.forceInvalidateDisplayList=true
			this.invalidateDisplayList()
		}
		
		private function onRotatorClick(event:MouseEvent):void{
			event.stopImmediatePropagation()
			event.preventDefault();
			var treeEvent:TreeEvent = new TreeEvent(TreeEvent.ROTATOR_CLICK);
			treeEvent.nodeDescriptor = XMLNodeDescriptor(_data);
			dispatchEvent(treeEvent);
		}
		
		private function setRotatorDirection(event:Event=null):void{
			
			if(!rotator || !rotator.parent) return;
			if(XMLNodeDescriptor(_data).open){
				arrow.rotation = 90
			}
			else{
				arrow.rotation = 0
			}
		}
		
		private var rendererLayout:HLayout = new HLayout(5)
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(rotator && rotator.parent){
				rotator.y = (unscaledHeight-rotator.height)/2
			}
			
			setRotatorDirection()
			
			rendererLayout.initX = XMLNodeDescriptor(_data).depth*15+10
			rendererLayout.initY = 5;
			var children:Array = []
			if(rotator && rotator.parent){
				children.push(rotator)
			}
			else{
				rendererLayout.initX+=10;
			}
			if(folderIcon && folderIcon.parent){
				children.push(folderIcon)
			}
			else{
				rendererLayout.initX+=10
			}
			children.push(_labelField);
			
			if(arrow){
				arrow.x = rotator.x+ (rotator.width - arrow.width)/2+arrow.width/2
				arrow.y =  rotator.y+ (rotator.height - arrow.height)/2+arrow.height/2;
				
			}
			
			
			rendererLayout.layout(children);
		}
	}
}