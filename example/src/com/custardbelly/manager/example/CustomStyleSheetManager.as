package com.custardbelly.manager.example
{
	import mx.styles.StyleManager;

	/**
	 * CustomStyleSheetManager manages the load of a custom Runtime CSS SWF file for updatr to the Applicaiton UI. 
	 * @author toddanderson
	 */
	public class CustomStyleSheetManager implements ICustomStyleSheetManager
	{
		protected var _styleSheetURL:String;
		
		/**
		 * Constructor.
		 */
		public function CustomStyleSheetManager() {}
		
		/**
		 * @copy ICustomStyleSheetManager#loadCustomStyleSheet()
		 */
		public function loadCustomStyleSheet():void
		{
			StyleManager.getStyleManager( null ).loadStyleDeclarations( _styleSheetURL, true );
		}
		
		/**
		 * @copy ICustomStyleSheetManager#styleSheetURL
		 */
		public function get styleSheetURL():String
		{
			return _styleSheetURL;
		}
		public function set styleSheetURL( value:String ):void
		{
			_styleSheetURL = value;
		}
	}
}