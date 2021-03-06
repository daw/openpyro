package org.openPyro.managers.toolTipClasses
{
	import org.openPyro.controls.Label;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.Padding;
	import org.openPyro.core.UIControl;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.painters.FillPainter;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;

	public class DefaultToolTipRenderer extends Label implements IDataRenderer
	{
		protected var _labelFormat:TextFormat;
		
		public function DefaultToolTipRenderer()
		{
			super();
		}
		
		override protected function createChildren():void{
			//_label = new Label()
			super.createChildren()
			this.padding = new Padding(0,5,0,5);
			if(!_labelFormat){
				_labelFormat = new TextFormat("Arial", 12, 0);
			}
			this.textFormat = _labelFormat;
			var painter:FillPainter = new FillPainter(0xffffcc,1)
			this.backgroundPainter = painter;
			this.filters = [new DropShadowFilter(2,90,0,.5,2,2)]
			if(_data){
				data = _data;
			}
		}
		
		private var _data:Object;
		public function set data(d:Object):void{
			_data = d;
			this.text = (d) as String;
			
		}
		
		public function get data():Object{
			return _data;
		}
		
		
	}
}