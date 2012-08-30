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
	import com.adobe.anesdk.components.ANESDKExtensionContextBase;
	import com.adobe.anesdk.components.storekit.core.SKPaymentTransaction;
	import com.adobe.anesdk.components.storekit.core.SKProductsResponse;
	import com.adobe.anesdk.components.storekit.test.SKExtensionContextForLocalTest;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	/**The extension context of the StoreKit component. ANESDK use this class as the interface to
	 *  invoke native code.
	 */
	public class SKExtensionContext extends ANESDKExtensionContextBase implements ISKExtensionContext
	{
		static public var instanceForLocalTest:SKExtensionContextForLocalTest;
		static private var _instance:SKExtensionContext;
		static private function hide():void{}
		
		/**Get the single instance of this Class.
		 */
		static public function get instance():ISKExtensionContext
		{
			if(!localTest)
			{
				if(!_instance)
				{
					_instance = new SKExtensionContext(hide);
				}
				return _instance;
			}
			if(!instanceForLocalTest)
			{
				instanceForLocalTest = new SKExtensionContextForLocalTest();
			}
			return instanceForLocalTest;
		}
		
		/**A switch can open/close local test mode.
		 * If it is true, property instance will return an instance of SKExtensionContextForLocalTest
		 *  instead of an instance of SKExtensionContext.
		 * @see com.adobe.anesdk.components.storekit.test.SKExtensionContextForLocalTest
		 */ 
		static public var localTest:Boolean = false;
		
		/**Request has received response from AppStore.
		 */
		static public const STATUSEVENT_REQUEST_DID_RECEIVE_RESPONSE:String = "requestDidReceiveResponse";
		/**Request failed with some errors.
		 */
		static public const STATUSEVENT_REQUEST_DID_FAIL_WITH_ERROR:String = "requestDidFailWithError";
		/**Request has finished.
		 */
		static public const STATUSEVENT_REQUEST_DID_FINISH:String = "requestDidFinish";
		/**Some transactions have been updated.
		 */
		static public const STATUSEVENT_TRANSACTIONS_UPDATED:String = "transactionsUpdated";
		
		static private const CONTEXT_TYPE:String = "StoreKit";
		
		static private const FUNCATION_CAN_MAKE_PAYMENTS:String 				= CONTEXT_TYPE + "CanMakePayments";
		static private const FUNCATION_START_PRODUCTSREQUEST:String 			= CONTEXT_TYPE + "StartProductsRequest";
		static private const FUNCATION_CANCEL_PRODUCTSREQUEST:String 			= CONTEXT_TYPE + "CancelProductsRequest";
		static private const FUNCATION_GET_REQUEST_RESPONSE:String 				= CONTEXT_TYPE + "GetRequestResponse";
		static private const FUNCATION_GET_REQUEST_ERROR:String 				= CONTEXT_TYPE + "GetRequestError";
		static private const FUNCATION_ADD_PAYMENT_TO_QUEUE:String 				= CONTEXT_TYPE + "AddPaymentToQueue";
		static private const FUNCATION_GET_UPDATED_TRANSACTIONS:String 			= CONTEXT_TYPE + "GetUpdatedTransactions";
		static private const FUNCATION_FINISH_TRANSACTION:String 				= CONTEXT_TYPE + "FinishTransaction";
		static private const FUNCATION_RESTORE_COMPLETED_TRANSACTIONS:String	= CONTEXT_TYPE + "RestoreCompletedTransactions";
		
		/**You shouldn't call the constructor because this class is a singleton.
		 */
		public function SKExtensionContext(caller:Function)
		{
			super(this, "com.adobe.IOSANECollectionStoreKit", CONTEXT_TYPE);
			if(caller != hide || _instance)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
		}
		
		/**@inheritDoc
		 */
		public function canMakePayments():Boolean
		{
			return Boolean(this.extensionContext.call(FUNCATION_CAN_MAKE_PAYMENTS));
		}
		
		/**@inheritDoc
		 */
		public function startProductsRequest(requestAneId:String, productIds:Array):void
		{
			this.extensionContext.call(FUNCATION_START_PRODUCTSREQUEST, requestAneId, productIds);
		}
		
		/**@inheritDoc
		 */
		public function cancelProductsRequest(requestAneId:String):void
		{
			this.extensionContext.call(FUNCATION_CANCEL_PRODUCTSREQUEST, requestAneId);
		}
		
		/**@inheritDoc
		 */
		public function getRequestResponse(requestAneId:String):SKProductsResponse
		{
			return this.extensionContext.call(FUNCATION_GET_REQUEST_RESPONSE, requestAneId) as SKProductsResponse;
		}
		
		/**@inheritDoc
		 */
		public function getRequestError(requestAneId:String):String
		{
			return String(this.extensionContext.call(FUNCATION_GET_REQUEST_ERROR, requestAneId));
		}
		
		/**@inheritDoc
		 */
		public function addPaymentToQueue(productIdentifier:String, quantity:uint):void
		{
			this.extensionContext.call(FUNCATION_ADD_PAYMENT_TO_QUEUE, productIdentifier, quantity);
		}
		
		/**@inheritDoc
		 */
		public function getUpdatedTransactions():Array
		{
			return this.extensionContext.call(FUNCATION_GET_UPDATED_TRANSACTIONS) as Array;
		}
		
		/**@inheritDoc
		 */
		public function finishTransaction(transactionId:String):Boolean
		{
			return Boolean(this.extensionContext.call(FUNCATION_FINISH_TRANSACTION, transactionId));
		}
		
		/**@inheritDoc
		 */
		public function restoreCompletedTransactions():void
		{
			this.extensionContext.call(FUNCATION_RESTORE_COMPLETED_TRANSACTIONS);
		}
	}
}