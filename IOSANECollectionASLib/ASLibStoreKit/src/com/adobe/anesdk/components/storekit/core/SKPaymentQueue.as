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
	import com.adobe.anesdk.components.storekit.core.events.SKPaymentQueueEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	/**The SKPaymentQueue class defines a queue of payment transactions 
	 * to send to the Apple App Store. To use the payment queue, 
	 * the application adds an event listener to the payment queue, 
	 * and then adds one or more payments. When payments are added to the queue, 
	 * StoreKit connects to the Apple App Store and presents a user interface 
	 * so that the user can authorize payment. 
	 * As payments are fulfilled, the payment queue updates transactions and delivers them 
	 * to its listeners.
	 */
	public class SKPaymentQueue extends EventDispatcher
	{
		/** Tells an listener that one or more transactions have been updated.
		 * @eventType com.adobe.anesdk.components.storekit.core.events.SKPaymentQueueEvent.TRANSACTIONS_UPDATED
		[Event(name="transactionsUpdated",type="com.adobe.anesdk.components.storekit.core.events.SKPaymentQueueEvent")]
		 */
		
		static private var _defaultQueue:SKPaymentQueue;
		/** @private
		 */
		static protected function hide():void{}
		
		/**Returns the singleton payment queue instance.
		 */
		static public function get defaultQueue():SKPaymentQueue
		{
			if(!_defaultQueue)
			{
				_defaultQueue = new SKPaymentQueue(hide);
			}
			return _defaultQueue;
		}
		
		/**You shouldn't call the constructor because this class is a singleton.
		 */
		public function SKPaymentQueue(caller:Function)
		{
			super();
			
			if(caller != hide || _defaultQueue)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
			
			SKExtensionContext.instance.addStatusEventListener(context_onStatus);
		}
		
		/**
		 * @copy com.adobe.anesdk.components.storekit.ISKExtensionContext#canMakePayments()
		 */
		static public function canMakePayments():Boolean
		{
			var output:Boolean = false;
			try
			{
				output = SKExtensionContext.instance.canMakePayments();
			}
			catch(e:Error)
			{}
			
			return output;
		}
		
		/**Adds a payment request to the queue.
		 * @param payment A payment request.
		 */
		public function addPayment(payment:SKPayment):void
		{
			SKExtensionContext.instance.addPaymentToQueue(payment.productIdentifier, payment.quantity);
		}
		
		/**Completes a pending transaction.
		 * @param paymentTransaction The transaction to finish.
		 */
		public function finishTransaction(paymentTransaction:SKPaymentTransaction):Boolean
		{
			return SKExtensionContext.instance.finishTransaction(paymentTransaction.transactionIdentifier);
		}
		
		/**@copy com.adobe.anesdk.components.storekit.ISKExtensionContext#restoreCompletedTransactions()
		 */
		public function restoreCompletedTransactions():void
		{
			SKExtensionContext.instance.restoreCompletedTransactions();
		}
		
		/** @private
		 */
		protected function context_onStatus(event:StatusEvent):void
		{
			if(event.level == "")
			{
				if(event.code == SKExtensionContext.STATUSEVENT_TRANSACTIONS_UPDATED)
				{
					var e:SKPaymentQueueEvent = new SKPaymentQueueEvent(SKPaymentQueueEvent.TRANSACTIONS_UPDATED);
					e.data = SKExtensionContext.instance.getUpdatedTransactions();
					if(e.data)
					{
						this.dispatchEvent(e);
					}
				}
			}
		}
	}
}