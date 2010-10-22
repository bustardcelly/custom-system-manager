package com.custardbelly.manager.example
{
	/**
	 * ICustomStyleSheetManager handles loading custom Runtime CSS SWF styles. 
	 * @author toddanderson
	 */
	public interface ICustomStyleSheetManager
	{
		/**
		 * Loads the specified style sheet.
		 */
		function loadCustomStyleSheet():void;
		
		/**
		 * Accessor/Modifier for the url of the Runtime CSS SWF file to load. 
		 * @return String
		 */
		function get styleSheetURL():String;
		function set styleSheetURL( value:String ):void;
	}
}