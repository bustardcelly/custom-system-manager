package com.custardbelly.manager.example
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import org.springextensions.actionscript.context.support.XMLApplicationContext;
	import org.springextensions.actionscript.ioc.factory.config.flex.FlexPropertyPlaceholderConfigurer;

	/**
	 * ApplicationContextProxy is a proxy for the SAS IoC container. 
	 * @author toddanderson
	 */
	public class ApplicationContextProxy extends EventDispatcher
	{
		// Need to compile in FlexPropertyPlaceholderConfigurer when using XMLApplicationContext else we get runtime errors.
		private static var compiledClasses:Array = [FlexPropertyPlaceholderConfigurer];
		
		protected var _startTime:Number;
		protected var _pendingEvent:Event;
		protected var _timer:Timer;
		protected const MIN_ELAPSE:int = 3000; 
		
		protected var _contextURL:String = "application-context.xml";
		// Use XMLApplicationContext over FlexXMLApplicationContext as the latter tried to access the application stage upon init. That is not available from custom system manager.
		protected var _applicationContext:XMLApplicationContext;
		
		private static var _instance:ApplicationContextProxy = new ApplicationContextProxy();
		
		/**
		 * Singleton access.
		 */
		public static function get instance():ApplicationContextProxy
		{
			return _instance;
		}
		
		/**
		 * Constructor. 
		 * @throws IllegalOperationError
		 */
		public function ApplicationContextProxy()
		{
			if( _instance != null )
			{
				throw new IllegalOperationError( "[" + getQualifiedClassName( this ) + "] WARNING:: ApplicationContextProxy cannot be instantiated directly. Use AppicationContextProxy.instance to gain access." );
			}
			_applicationContext = new XMLApplicationContext();
			_timer = new Timer( MIN_ELAPSE, 1 );
		}
		
		/**
		 * @private 
		 * 
		 * Assigns Event handlers for load of the application context.
		 */
		protected function addApplicationContextHandlers():void
		{
			_applicationContext.addEventListener( Event.COMPLETE, handleApplicationContextLoadComplete, false, 0, true );
			_applicationContext.addEventListener( IOErrorEvent.IO_ERROR, handleApplicationContextLoadError, false, 0, true );
		}
		
		/**
		 * @private 
		 * 
		 * Removes event handlers on the aplication context.
		 */
		protected function removeApplicationContextHandlers():void
		{
			_applicationContext.removeEventListener( Event.COMPLETE, handleApplicationContextLoadComplete, false );
			_applicationContext.removeEventListener( IOErrorEvent.IO_ERROR, handleApplicationContextLoadError, false );
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
			
			_pendingEvent = evt.clone();
			
			// Run false load timer if elapse time is shorter than minimum load time.
			// This is mainly used in order to demonstrate that the frame is suspended.
			var elapse:Number = ( getTimer() - _startTime );
			if( elapse < MIN_ELAPSE )
			{
				_timer.delay = MIN_ELAPSE;
				_timer.repeatCount = 1;
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, handleFalseLoadTimer, false, 0, true );
				_timer.start();
			}
			else
			{
				dispatchEvent( _pendingEvent );
				_pendingEvent = null;
			}
		}
		
		/**
		 * @private
		 * 
		 * Event handler for error in load of application context. 
		 * @param evt Event
		 */
		protected function handleApplicationContextLoadError( evt:Event ):void
		{
			removeApplicationContextHandlers();
			dispatchEvent( evt.clone() );
		}
		
		/**
		 * @private
		 * 
		 * Event handler for false timer on load. 
		 * @param evt TimerEvent
		 */
		protected function handleFalseLoadTimer( evt:TimerEvent ):void
		{
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, handleFalseLoadTimer, false );
			dispatchEvent( _pendingEvent );
		}
		
		/**
		 * Loads the application context file.
		 */
		public function loadApplicationContext():void
		{
			_startTime = getTimer();
			addApplicationContextHandlers();
			
			_applicationContext.addConfigLocation( _contextURL );
			_applicationContext.load();
		}
		
		/**
		 * Proxy access to objects held on the application context. 
		 * @param key String
		 * @param constructorArgs Array
		 * @return *
		 */
		public function getObject( key:String, constructorArgs:Array = null ):*
		{
			return _applicationContext.getObject( key, constructorArgs );
		}
	}
}