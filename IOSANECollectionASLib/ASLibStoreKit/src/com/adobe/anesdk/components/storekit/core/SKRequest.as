/*******************************************************************
 * Copyright (C) 2012 CHENGUANG LIU
 *
 * Permission is hereby granted, free of charge, 
 * to any person obtaining a copy of this software 
 * and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, 
 * including without limitation the rights to use, 
 * copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit 
 * persons to whom the Software is furnished to do so, 
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice 
 * shall be included in all copies or substantial portions 
 * of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY 
 * OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS 
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 ********************************************************************/

package com.adobe.anesdk.components.storekit.core
{
	import com.adobe.anesdk.components.storekit.SKExtensionContext;
	import com.adobe.anesdk.utils.ANEIDObjectManager;
	import com.adobe.anesdk.utils.IANEIDObject;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	
	/**SKRequest is an abstract class representing a request to the Apple App Store. 
	 * Subclasses of SKRequest represent different kinds of requests.
	 */
	public class SKRequest extends EventDispatcher implements IANEIDObject
	{
		/** @private
		 */
		protected var _aneId:String = "";
		
		public function SKRequest()
		{
			super();
		}
		
		/**Sends the request to the Apple App Store.
		 */
		public function start():void
		{
			SKExtensionContext.instance.addStatusEventListener(context_onStatus);
		}
		/**Cancels a previously started request.
		 */
		public function cancel():void
		{
			SKExtensionContext.instance.removeStatusEventListener(context_onStatus);
		}
		
		/** @private
		 */
		protected function context_onStatus(event:StatusEvent):void
		{
		}
		
		/**@inheritDoc
		 */
		public function get aneId():String
		{
			return _aneId;
		}
		
		public function set aneId(value:String):void
		{
			_aneId = value;
		}
	}
}