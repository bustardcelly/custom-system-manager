/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: CustomPreloader.as</p>
 * <p>Version: 0.1</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */
package com.custardbelly.application.preloader
{
	import com.custardbelly.application.ICustomSystemManager;
	import com.custardbelly.application.event.CustomSystemManagerEvent;
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import mx.preloaders.SparkDownloadProgressBar;
	
	/**
	 * CustomPreloader is a base preloader listening for the frame suspension from an ICustomSystemManager implementation. 
	 * @author toddanderson
	 */
	public class CustomPreloader extends SparkDownloadProgressBar
	{
		protected var _customSystemManager:ICustomSystemManager;
		
		/**
		 * Constructor.
		 */
		public function CustomPreloader() { super(); }
		
		/**
		 * @inherit
		 */
		override public function set preloader( value:Sprite ):void
		{
			super.preloader = value;
			// Add listener for frame suspension from preloader. The ICustomSystemManager will dispatch this event through the preloader for stalling the 1st frame.
			value.addEventListener( CustomSystemManagerEvent.FRAME_SUSPENDED, handleFrameSuspension );
		}
		
		/**
		 * @private 
		 * 
		 * Abstract method to be override by subclass in order to perform any operations during the suspension of the 1st frame.
		 * In order to resume movement to the 2nd frame, the subclass must call resumeInitialization() when the required operation is complete.
		 */
		protected function onFrameSuspension():void
		{
			// abstract method.
			// Override to perform any other initialization tasks on the first frame.
		}
		
		/**
		 * @private 
		 * 
		 * Invokes the ICustomSystemManager to resume its loading and movement to the 2nd frame.
		 */
		protected function resumeInitialization():void
		{
			_customSystemManager.resumeNextFrame();
		}
		
		/**
		 * @private
		 * 
		 * Event handler for frame suspension from the ICustomSystemManager. 
		 * @param evt CustomSystemManagerEvent
		 */
		protected function handleFrameSuspension( evt:CustomSystemManagerEvent ):void
		{
			( evt.target as IEventDispatcher ).removeEventListener( CustomSystemManagerEvent.FRAME_SUSPENDED, handleFrameSuspension );
			_customSystemManager = evt.manager;
			onFrameSuspension();
		}
	}
}