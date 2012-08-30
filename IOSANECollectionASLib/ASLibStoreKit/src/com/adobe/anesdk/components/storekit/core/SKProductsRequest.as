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
	import com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent;
	import com.adobe.anesdk.utils.ANEIDObjectManager;
	import com.adobe.anesdk.utils.Set;
	
	import flash.events.StatusEvent;

	/**An SKProductsRequest object is used to retrieve localized information about
	 *  a list of products from the Apple App Store. 
	 * Your application uses this request to present localized prices
	 *  and other information to the user without having to maintain that list itself.
	 *  <p>To use an SKProductsRequest object, you initialize it with
	 *  a list of product identifier strings, attach a listener,
	 *  and then call the request’s start method. When the request completes,
	 *  your listener function receives an SKProductsResponse object.</p>
	 * @see com.adobe.anesdk.components.storekit.core.SKProductsResponse
	 */
	public class SKProductsRequest extends SKRequest
	{
		/** Dispatch when the Apple App Store responds to the product request.
		 * @eventType com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent.DID_RECEIVE_RESPONSE
		 */
		[Event(name="didReceiveResponse",type="com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent")]
		/** Dispatch when the request failed to execute.
		 * @eventType com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent.STATUSEVENT_REQUEST_DID_FAIL_WITH_ERROR
		 */
		[Event(name="didFailWithError",type="com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent")]
		/** Dispatch when the request has completed.
		 * @eventType com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent.DID_FINISH
		 */
		[Event(name="didFinish",type="com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent")]
		
		
		private var _productIds:Set;
		
		/**
		 * @param values A list of product identifier strings.
		 * @see #start()
		 * @see #cancel()
		 */
		public function SKProductsRequest(values:Array)
		{
			super();
			init(values);
		}
		
		private function init(values:Array):void
		{
			_productIds = new Set();
			_productIds.push.apply(_productIds, values);
			ANEIDObjectManager.instance.registerID(this);
		}
		
		/** List the product identifier strings.
		 */
		public function get productIds():Array
		{
			return _productIds.array;
		}
		
		/** @copy com.adobe.anesdk.components.storekit.core.SKRequest#start()
		 */
		override public function start():void
		{
			super.start();
			SKExtensionContext.instance.startProductsRequest(_aneId, _productIds.array);
		}
		
		/**@copy com.adobe.anesdk.components.storekit.core.SKRequest#cancel()
		 */
		override public function cancel():void
		{
			super.cancel();
			SKExtensionContext.instance.cancelProductsRequest(_aneId);
		}
		
		/** @private
		 */
		override protected function context_onStatus(event:StatusEvent):void
		{
			if(event.level == this.aneId)
			{
				var e:SKProductsRequestEvent;
				if(event.code == SKExtensionContext.STATUSEVENT_REQUEST_DID_RECEIVE_RESPONSE)
				{
					e = new SKProductsRequestEvent(SKProductsRequestEvent.DID_RECEIVE_RESPONSE);
					e.data = SKExtensionContext.instance.getRequestResponse(_aneId);
					this.dispatchEvent(e);
				}
				else if(event.code == SKExtensionContext.STATUSEVENT_REQUEST_DID_FAIL_WITH_ERROR)
				{
					e = new SKProductsRequestEvent(SKProductsRequestEvent.DID_FAIL_WITH_ERROR);
					e.data = SKExtensionContext.instance.getRequestError(_aneId);
					this.dispatchEvent(e);
				}
				else if(event.code == SKExtensionContext.STATUSEVENT_REQUEST_DID_FINISH)
				{
					e = new SKProductsRequestEvent(SKProductsRequestEvent.DID_FINISH);
					this.dispatchEvent(e);
				}
			}
		}
	}
}