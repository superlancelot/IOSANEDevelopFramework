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

package com.adobe.anesdk.components.storekit
{
	import com.adobe.anesdk.components.storekit.core.SKPayment;
	import com.adobe.anesdk.components.storekit.core.SKPaymentQueue;
	import com.adobe.anesdk.components.storekit.core.SKPaymentTransaction;
	import com.adobe.anesdk.components.storekit.core.SKProduct;
	import com.adobe.anesdk.components.storekit.core.SKProductsRequest;
	import com.adobe.anesdk.components.storekit.core.SKProductsResponse;
	import com.adobe.anesdk.components.storekit.core.events.SKPaymentQueueEvent;
	import com.adobe.anesdk.components.storekit.core.events.SKProductsRequestEvent;
	
	import flash.utils.Dictionary;

	/**An encapsulated Class that make using StoreKit more easier. 
	 */
	public class StoreKitHelper
	{
		static private var _instance:StoreKitHelper;
		static private function hide():void{}
		
		/**Get the single instance of this Class.
		 */
		static public function get instance():StoreKitHelper
		{
			if(!_instance)
			{
				_instance = new StoreKitHelper(hide);
			}
			return _instance;
		}
		
		private var _requestMapping:Dictionary;
		private var _callbackMapping:Dictionary;
		
		/**You shouldn't call the constructor because this class is a singleton.
		 */
		public function StoreKitHelper(caller:Function)
		{
			if(caller != hide || _instance)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
			_requestMapping = new Dictionary();
			_callbackMapping = new Dictionary(true);
			SKPaymentQueue.defaultQueue.addEventListener(SKPaymentQueueEvent.TRANSACTIONS_UPDATED, paymentQueue_onTransactionsUpdated);
		}
		
		/**Return whether the user is allowed to make payments.
		 */
		static public function isPaymentAllowed():Boolean
		{
			return SKPaymentQueue.canMakePayments();
		}
		
		/**Get the list of products in details.
		 * @param productIds The list of product identifiers being requested.
		 * @param callback Set the callback function which would be called when a products request is returned.
		 */
		public function getProducts(productIds:Array, callback:Function = null):void
		{
			var productRequest:SKProductsRequest = new SKProductsRequest(productIds);
			_requestMapping[productRequest.aneId] = productRequest;
			
			if(callback != null)
			{
				_callbackMapping[productRequest.aneId + SKProductsRequestEvent.DID_RECEIVE_RESPONSE] = callback;
			}

			productRequest.addEventListener(SKProductsRequestEvent.DID_RECEIVE_RESPONSE, productRequest_onReceiveResponse);
			productRequest.addEventListener(SKProductsRequestEvent.DID_FAIL_WITH_ERROR, productRequest_onFailWithError);
			productRequest.start();
		}
		
		/**Purchase a specified product.
		 * @param productId The identifier of the product.
		 * @param quantity The quantity of the product.
		 */
		public function purchaseProduct(productId:String, quantity:uint = 1):void
		{
			SKPaymentQueue.defaultQueue.addPayment(new SKPayment(productId, quantity));
		}
		
		/**Restore previously completed purchases.
		 */
		public function restoreCompletedTransactions():void
		{
			SKPaymentQueue.defaultQueue.restoreCompletedTransactions();
		}
		
		/**Completes a pending transaction.
		 * @param paymentTransaction The transaction to finish.
		 */
		public function finishTransaction(paymentTransaction:SKPaymentTransaction):Boolean
		{
			return SKPaymentQueue.defaultQueue.finishTransaction(paymentTransaction);
		}
		
		private function productRequest_onReceiveResponse(event:SKProductsRequestEvent):void
		{
			var sender:SKProductsRequest = (event.target as SKProductsRequest);
			sender.removeEventListener(SKProductsRequestEvent.DID_RECEIVE_RESPONSE, productRequest_onReceiveResponse);
			
			var response:SKProductsResponse = event.data as SKProductsResponse;
			if(!response)
			{
				trace("StoreKitHelper:productRequest_onReceiveResponse response is null");
				return;
			}
			
			var callback:Function = (_callbackMapping[sender.aneId + event.type] as Function);
			if(callback != null)
			{
				delete _callbackMapping[sender.aneId + event.type];
				try
				{
					callback(response.products, response.invalidProductidentifiers);
				}
				catch(e:Error)
				{
					trace("StoreKitHelper:productRequest_onReceiveResponse callBack error");
					return;
				}
			}
		}
		
		private function productRequest_onFailWithError(event:SKProductsRequestEvent):void
		{
			
		}
		
		private function paymentQueue_onTransactionsUpdated(event:SKPaymentQueueEvent):void
		{
			var transactions:Array = (event.data as Array);
			if(!transactions)
			{
				trace("StoreKitHelper:paymentQueue_onUpdatedTransactions transactions is null");
				return;
			}
			
			if(this.transactionsUpdatedCallBack != null)
			{
				this.transactionsUpdatedCallBack(transactions);
			}
			else
			{
				trace("StoreKitHelper:paymentQueue_onUpdatedTransactions updatedTransactionsCallBack is null");
			}
		}
		
		/** The function which would be called after transactions being updated.
		 */
		public function get transactionsUpdatedCallBack():Function
		{
			return _callbackMapping[SKPaymentQueueEvent.TRANSACTIONS_UPDATED];
		}
		public function set transactionsUpdatedCallBack(value:Function):void
		{
			_callbackMapping[SKPaymentQueueEvent.TRANSACTIONS_UPDATED] = value;
		}
	}
}