package com.custardbelly.manager.example
{
	import com.custardbelly.application.preloader.CustomPreloader;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	
	import mx.events.RSLEvent;
	import mx.graphics.RectangularDropShadow;
	
	/**
	 * CustomContextPreloader is an extension of the CustomPreloader to trap frame suspension and resume. 
	 * @author toddanderson
	 */
	public class CustomContextPreloader extends CustomPreloader
	{
		protected var _isOnDisplay:Boolean;
		protected var _messageField:TextField;
		
		protected var _applicationContextProxy:ApplicationContextProxy;
		
		/**
		 * Constructor.
		 */
		public function CustomContextPreloader() 
		{ 
			super();
		}
		
		override public function set preloader(value:Sprite):void
		{
			super.preloader = value;
		}
		
		/**
		 * @private 
		 * 
		 * Adds event handlers to the appliction context proxy.
		 */
		protected function addApplicationContextHandlers():void
		{
			_applicationContextProxy.addEventListener( Event.COMPLETE, handleApplicationContextLoadComplete, false, 0, true );
			_applicationContextProxy.addEventListener( IOErrorEvent.IO_ERROR, handleApplicationContextLoadError, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers form the application context proxy.
		 */
		protected function removeApplicationContextHandlers():void
		{
			_applicationContextProxy.removeEventListener( Event.COMPLETE, handleApplicationContextLoadComplete, false );
			_applicationContextProxy.removeEventListener( IOErrorEvent.IO_ERROR, handleApplicationContextLoadError, false );
		}
		
		/**
		 * @inherit
		 */
		override protected function onFrameSuspension():void
		{
			if( !_isOnDisplay ) createChildren();
			
			_applicationContextProxy = ApplicationContextProxy.instance;
			// Add handlers and update ui.
			addApplicationContextHandlers();
			_messageField.text = "Loading application context...";
			//load the application context.
			_applicationContextProxy.loadApplicationContext();
			// Faking progress for this example. Unfortunately SAS does not dispatch a progress event when loading context :(
			setInitProgress( 75, 100 );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for complete load of application context. 
		 * @param evt Event
		 */
		protected function handleApplicationContextLoadComplete( evt:Event ):void
		{
			removeApplicationContextHandlers();
			_customSystemManager.resumeNextFrame();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for error inload of application context. 
		 * @param evt Event
		 */
		protected function handleApplicationContextLoadError( evt:IOErrorEvent ):void
		{
			removeApplicationContextHandlers();
			// Notify of error.
		}
		
		/**
		 * @inherit
		 */
		override protected function rslProgressHandler( event:RSLEvent ):void
		{
			if( !_isOnDisplay ) createChildren();
			
			// Percent computation attributed to : http://www.developmentarc.com/site/2010/09/rsl-calculations-new-flex-4-preloader
			var percent:Number = Math.round( ( ( event.bytesLoaded / event.bytesTotal ) + event.rslIndex ) / event.rslTotal * 100 );
			_messageField.text = "Loading " + event.rslIndex + " RSL of " + event.rslTotal + "...";
			setInitProgress( percent, 100 );
		}
		
		/**
		 * @inherit
		 */
		override protected function createChildren():void
		{
			// Just modifying already existing content from SparkDownloadProgressBar.
			// Not really recommended if creating a custom preloader, just a quick change to ui to get the point across.
			if( !_isOnDisplay ) 
			{
				_isOnDisplay = true;
				
				super.createChildren();
				
				var g:Graphics = graphics;
				
				// Determine the size
				var totalWidth:Number = Math.min(stageWidth - 10, 207);
				var totalHeight:Number = 72;
				var startX:Number = Math.round((stageWidth - totalWidth) / 2);
				var startY:Number = Math.round((stageHeight - totalHeight) / 2);
				
				getChildAt( 1 ).y += 14;
				getChildAt( 2 ).y += 14;
				
				// Draw the background/shadow
				g = ( getChildAt( 0 ) as Sprite ).graphics;
				g.lineStyle(1, 0x636363);
				g.beginFill(0xE8E8E8);
				g.drawRect(startX, startY, totalWidth, totalHeight);
				g.endFill();
				g.lineStyle();
				
				g = graphics;
				var ds:RectangularDropShadow = new RectangularDropShadow();
				ds.color = 0x000000;
				ds.angle = 90;
				ds.alpha = .6;
				ds.distance = 2;
				ds.drawShadow(g, 
					startX,
					startY,
					totalWidth,
					totalHeight);
				
				_messageField = new TextField();
				_messageField.multiline = true;
				_messageField.wordWrap = true;
				_messageField.width = totalWidth - 10;
				_messageField.x = startX + 5;
				_messageField.y = startY + 5;
				addChild( _messageField );
				
				setDownloadProgress( 100, 100 );
			}
		}
	}
}