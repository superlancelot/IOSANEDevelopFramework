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
	import com.adobe.anesdk.components.IANESDKExtensionContextEventDispatcher;
	import com.adobe.anesdk.components.storekit.core.SKPaymentTransaction;
	import com.adobe.anesdk.components.storekit.core.SKProductsResponse;
	
	import flash.events.IEventDispatcher;

	/**The ISKExtensionContext interface is implemented by objects 
	 * that define the interface functions of the StoreKit component.
	 */
	public interface ISKExtensionContext extends IANESDKExtensionContextEventDispatcher
	{
		/**Return whether the user is allowed to make payments.
		 */
		function canMakePayments():Boolean;
		/**Sends the request for listing products to the Apple App Store.
		 * @param requestAneId An identifier using by ANEIDObjectManager.
		 * @param productsIds A list of product identifier strings.
		 */
		function startProductsRequest(requestAneId:String, productIds:Array):void
		/**Cancels a previously started request for listing products.
		 * @param requestAneId An identifier using by ANEIDObjectManager.
		 */
		function cancelProductsRequest(requestAneId:String):void;
		/**Called when the Apple App Store responds to the product request.
		 * @param requestAneId An identifier used by ANEIDObjectManager.
		 */
		function getRequestResponse(requestAneId:String):SKProductsResponse;
		/**Adds a payment request to the queue.
		 * @param productIdentifier A string used to identify a product that can be purchased from within your application.
		 * @param quantity The number of items the user wants to purchase. 
		 */
		
		function getRequestError(requestAneId:String):String;
		
		function addPaymentToQueue(productIdentifier:String, quantity:uint):void;
		/**Return updated transactions in the SKPaymentQueue.
		 */
		function getUpdatedTransactions():Array;
		/**Completes a pending transaction.
		 * @param paymentTransaction The transaction to finish.
		 */
		function finishTransaction(transactionId:String):Boolean;
		/**Asks the payment queue to restore previously completed purchases.
		 */
		function restoreCompletedTransactions():void;
	}
}