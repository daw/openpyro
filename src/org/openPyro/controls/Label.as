package org.openPyro.controls
{
	import org.openPyro.core.UIControl;
	import org.openPyro.utils.StringUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Label extends UIControl
	{
		protected var _textField:TextField;
		
		public function Label()
		{
			super();
		}
		
		override protected function createChildren():void{
			_textField = new TextField();
			setTextFieldProperties()
			addChild(_textField);
			
			if(_format){
				_textField.defaultTextFormat = _format;
			}
			if(_text){
				_textField.text = _text
			}
		}
		
		protected function setTextFieldProperties():void{
			_textField.selectable = false;
			//_textField.border = true;
		}
		
		/**
		 * Returns the raw textfield used to render
		 * the text
		 */
		public function get textField():TextField
		{
			return _textField;
		}
		
		protected var _format:TextFormat;
		
		/**
		 * Sets the <code>TextFormat</code> on the
		 * label.
		 * 
		 * @see flash.text.TextFormat
		 */  
		public function set textFormat(tf:TextFormat):void
		{
			_format = tf;
			if(!_textField)return;
			
			_textField.defaultTextFormat = tf;
			if(_text){
				this.text = _text;
			}
		}
		
		public function get textFormat():TextFormat{
			return _format
		}
		
		
		protected var _text:String = "";
		
		/**
		 * Sets the string that will be displayed
		 * on the label
		 */ 
		public function set text(str:String):void
		{
			if(_text == str) return;
			this._text = str;
			if(!_textField)return;
			this.invalidateSize();
			this.forceInvalidateDisplayList=true
			this.invalidateDisplayList();
		}
		
		public function get text():String{
			return _text;
		}
		
		override protected function doChildBasedValidation():void
		{
			//
			// Set the _textField's text so that we can measure based on
			// the textWidths
			//
			if(!_textField) return;
			_textField.text = _text;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				var computedWidth:Number = this._textField.textWidth+5 + _padding.left + _padding.right;
				if(!isNaN(_maximumWidth)){
					computedWidth = Math.min(computedWidth, _maximumWidth);
				}
				super.measuredWidth = computedWidth;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				var computedHeight:Number = this._textField.textHeight+5 + _padding.top + _padding.bottom;
				if(!isNaN(_maximumHeight)){
					computedHeight = Math.min(computedHeight, _maximumHeight)
				}
				super.measuredHeight = computedHeight;
			}
			
			//
			// Measured Width and height may not have changed so updateDisplaylist may not 
			// be called. So do the text truncation again (may be redundant though)
			//
			if(_textField.textWidth > _textField.width){
				
				StringUtil.omitWordsToFit(_textField);
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_textField.x = this._padding.left;
			_textField.y = this._padding.top;
			_textField.width = unscaledWidth - _padding.left - _padding.right;
			_textField.height = unscaledHeight - _padding.top - _padding.bottom;
			_textField.text = _text;
			if(_textField.textWidth > _textField.width){
				StringUtil.omitWordsToFit(_textField);
			}
			
		}

	}
}