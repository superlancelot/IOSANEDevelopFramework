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

package com.adobe.anesdk.components.storekit.test
{
	import com.adobe.anesdk.components.ANESDKExtensionContextEventDispatcher;
	import com.adobe.anesdk.components.storekit.ISKExtensionContext;
	import com.adobe.anesdk.components.storekit.SKExtensionContext;
	import com.adobe.anesdk.components.storekit.core.SKPayment;
	import com.adobe.anesdk.components.storekit.core.SKPaymentQueue;
	import com.adobe.anesdk.components.storekit.core.SKPaymentTransaction;
	import com.adobe.anesdk.components.storekit.core.SKPaymentTransactionState;
	import com.adobe.anesdk.components.storekit.core.SKProduct;
	import com.adobe.anesdk.components.storekit.core.SKProductsRequest;
	import com.adobe.anesdk.components.storekit.core.SKProductsResponse;
	import com.adobe.anesdk.components.storekit.core.events.SKPaymentQueueEvent;
	import com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent;
	import com.adobe.anesdk.utils.ANEIDObjectManager;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.Dictionary;
	
	/**This class is designed for local test.
	 */
	public class SKExtensionContextForLocalTest extends ANESDKExtensionContextEventDispatcher implements ISKExtensionContext
	{
		private var responseDictionary:Dictionary;
		private var updatedTransactions:Array;
		private var pendingTransactions:Array;
		
		public function SKExtensionContextForLocalTest()
		{
			responseDictionary = new Dictionary();
			updatedTransactions = new Array();
			pendingTransactions = new Array();
		}
		
		/**@inheritDoc
		 */
		public function canMakePayments():Boolean
		{
			return true;
		}
		
		/**@inheritDoc
		 */
		public function startProductsRequest(requestAneId:String, productIds:Array):void
		{
			var products:Array = new Array();
			for each(var productId:String in productIds)
			{
				var product:SKProduct = new SKProduct(productId,productId + ":Title", productId + ":Description", 0.99);
				products.push(product);
			}
			
			var response:SKProductsResponse = new SKProductsResponse(products);
			responseDictionary[requestAneId] = response;
			
			var event:StatusEvent = new StatusEvent(StatusEvent.STATUS, false, false, SKExtensionContext.STATUSEVENT_REQUEST_DID_RECEIVE_RESPONSE, requestAneId);
			this.dispatchEvent(event);
		}
		
		/**@inheritDoc
		 */
		public function cancelProductsRequest(requestAneId:String):void
		{}
		
		/**@inheritDoc
		 */
		public function getRequestResponse(requestAneId:String):SKProductsResponse
		{
			return responseDictionary[requestAneId] as SKProductsResponse;
		}
		
		/**@inheritDoc
		 */
		public function getRequestError(requestAneId:String):String
		{
			return "";
		}
		
		/**@inheritDoc
		 */
		public function addPaymentToQueue(productIdentifier:String, quantity:uint):void
		{
			updatedTransactions.push(new SKPaymentTransaction("", 0, (new Date()).time, null, new SKPayment(productIdentifier, quantity)));
			var event:StatusEvent = new StatusEvent(StatusEvent.STATUS, false, false, SKExtensionContext.STATUSEVENT_TRANSACTIONS_UPDATED, "");
			this.dispatchEvent(event);
			
			updatedTransactions.push(new SKPaymentTransaction("", 1, (new Date()).time, null, new SKPayment(productIdentifier, quantity)));
			event = new StatusEvent(StatusEvent.STATUS, false, false, SKExtensionContext.STATUSEVENT_TRANSACTIONS_UPDATED, "");
			this.dispatchEvent(event);
		}
		
		/**@inheritDoc
		 */
		public function getUpdatedTransactions():Array
		{
			pendingTransactions.push.apply(pendingTransactions, updatedTransactions);
			var output:Array = updatedTransactions;
			updatedTransactions = new Array();
			return output;
		}
		
		/**@inheritDoc
		 */
		public function finishTransaction(transactionId:String):Boolean
		{
			var length:int =  pendingTransactions.length;
			for(var i:int = 0; i < length; i++)
			{
				if((pendingTransactions[i] as SKPaymentTransaction).transactionIdentifier == transactionId)
				{
					if(i != length - 1)
					{
						pendingTransactions[i] = pendingTransactions[length - 1];
					}
					pendingTransactions.pop();
					return true;
				}
			}
			return false;
		}
		
		/**@inheritDoc
		 */
		public function restoreCompletedTransactions():void
		{}
	}
}