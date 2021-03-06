package org.openPyro.painters
{
	import org.openPyro.core.Padding;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Paints 45 degree inclined stripes on the 
	 * Graphics context of a DisplayObject
	 */  
	public class StripesPainter implements IPainter
	{
		private var _padding:Padding;
		private var _stripeWidth:Number;
		
		/**
		 * constructor 
		 */ 
		public function StripesPainter(stripeWidth:Number=10){
			_stripeWidth = stripeWidth;		
		}
		
		/**
		 * Sets the width of the stripe that will be painted
		 * on the graphics context
		 */
		public function set stripeWidth(n:Number):void{
			_stripeWidth = n;
		} 
		
		/**
		 * @private
		 */ 
		public function get stripeWidth():Number{
			return _stripeWidth;
		}
		
		/**
		 * Paints the graphics context with Stripes of width specified by
		 * the stripeWidth property
		 * 
		 * @see #stripeWidth()
		 */
		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			var bdata:BitmapData = new BitmapData(2*_stripeWidth,2*_stripeWidth, true);
			var rect1:Rectangle = new Rectangle(0,0,_stripeWidth,2*_stripeWidth);
			var rect2:Rectangle = new Rectangle(_stripeWidth,0,_stripeWidth,2*_stripeWidth);
			
			//Create 2 black rectangles: one semitransparent and other invisible 
			bdata.fillRect(rect1, 0x00000000);
			bdata.fillRect(rect2, 0x10000000);
			
			//Create the skew-matrix
			var m:Matrix = new Matrix();
			m.c=-1;
			
			//Fill the MovieClip with the BitmapData.
			gr.beginBitmapFill(bdata, m)
			gr.drawRect(0,0,w,h);
			gr.endFill();
		}
		
		/**
		 * @private
		 */  
		public function toString():String{
			return ("stripeWidth: "+_stripeWidth)
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set padding(p:Padding):void
		{
			_padding = p
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get padding():Padding
		{
			return _padding;
		}

	}
}