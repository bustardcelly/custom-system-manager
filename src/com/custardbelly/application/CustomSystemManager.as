/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: CustomSystemManager.as</p>
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
package com.custardbelly.application
{
	import com.custardbelly.application.event.CustomSystemManagerEvent;
	
	import flash.events.Event;
	
	import mx.core.mx_internal;
	import mx.managers.SystemManager;
	
	use namespace mx_internal;
	
	[Event(name="frameSuspended", type="com.custardbelly.application.event.CustomSystemManagerEvent")]
	/**
	 * CustomSystemManager is an extension of SystemManager that stalls on the 1st frame and notifies a client that will handle any necessary operations on that stall.
	 * Once complete, the notified client should resume to the next frame to complete the loading process. 
	 * @author toddanderson
	 */
	public class CustomSystemManager extends SystemManager implements ICustomSystemManager
	{
		protected var _resumable:Boolean;
		
		/**
		 * Constructor.
		 */
		public function CustomSystemManager() { super(); }
		
		/**
		 * @inherit
		 */
		override mx_internal function docFrameHandler( event:Event = null ):void
		{	
			// Override to protected flag to recognize to continue kickoff.
			if( _resumable )
				kickOff();
		}
		
		/**
		 * @inherit
		 */
		override mx_internal function preloader_completeHandler( event:Event ):void
		{
			// Override to stop super operation and dispatch a frame suspension event for any handling clients.
			preloader.removeEventListener( Event.COMPLETE, preloader_completeHandler );
			preloader.dispatchEvent( new CustomSystemManagerEvent( this ) );
		}
		
		
		/**
		 * @inherit
		 */
		public function resumeNextFrame():void
		{
			if( currentFrame >= 2 )
			{
				_resumable = true;
				kickOff();
			}
		}
	}
}