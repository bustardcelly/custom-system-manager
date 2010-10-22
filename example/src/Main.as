package
{
	import com.custardbelly.manager.example.ApplicationContextProxy;
	import com.custardbelly.manager.example.ICustomStyleSheetManager;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	/**
	 * Declare custom system manager for initialization frame. 
	 */
	[Frame(factoryClass="com.custardbelly.application.CustomSystemManager")]
	public class Main extends Application
	{
		protected var _applicationContext:ApplicationContextProxy;
		
		public function Main()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, handleCreationComplete, false, 0, true );
		}
		
		protected function handleCreationComplete( evt:FlexEvent ):void
		{
			_applicationContext = ApplicationContextProxy.instance;
			// Access the ICustomStyleSheetManager implementation defined in the application context.
			var styleManager:ICustomStyleSheetManager = _applicationContext.getObject( "styleSheetManager" );
			styleManager.loadCustomStyleSheet();
		}
	}
}