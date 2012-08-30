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
	/**The SKPaymentTransaction class defines objects residing 
	 * in the payment queue. A payment transaction is created 
	 * whenever a payment is added to the payment queue. 
	 * Transactions are delivered to your application 
	 * when the App Store has finished processing the payment. 
	 * Completed transactions provide a receipt and transaction identifier 
	 * that your application can use to save a permanent record of the processed payment.
	 * @see com.adobe.anesdk.components.storekit.core.SKPaymentQueue
	 * @see com.adobe.anesdk.components.storekit.core.SKPaymentTransaction
	 */
	public class SKPaymentTransaction
	{
		private var _transactionIdentifier:String;
		private var _transactionState:SKPaymentTransactionState;
		private var _transactionDate:Date;
		private var _transactionReceipt:String;
		private var _originalTransaction:SKPaymentTransaction;
		private var _payment:SKPayment;
		private var _error:String;
		
		/**
		 * @param transactionIdentifier @copy #transactionIdentifier
		 * @param transactionState @copy #transactionState
		 * @param transactionTime @copy #transactionDate
		 * @param transactionReceipt @copy #transactionReceipt
		 * @param payment @copy #payment
		 * @param originalTransaction @copy #originalTransaction
		 * @param error @copy #error
		 */
		public function SKPaymentTransaction(	transactionIdentifier:String,
												transactionStateEnum:int,
												transactionTime:Number,
												transactionReceipt:String,
												payment:SKPayment,
												originalTransaction:SKPaymentTransaction = null,
												error:String = null)
		{
			_transactionIdentifier = transactionIdentifier;
			_transactionState = SKPaymentTransactionState.getInstanceByEnum(transactionStateEnum);
			_transactionDate = new Date();
			_transactionDate.time = transactionTime;
			_transactionReceipt = transactionReceipt;
			_payment = payment;
			_originalTransaction = originalTransaction;
			_error = error;
		}
		
		/**A string that uniquely identifies a successful payment transaction.
		 */
		public function get transactionIdentifier():String
		{
			return _transactionIdentifier;
		}
		
		/**The current state of the transaction.
		 */
		public function get transactionState():SKPaymentTransactionState
		{
			return _transactionState;
		}
		
		/**The date the transaction was added to the App Store’s payment queue.
		 */
		public function get transactionDate():Date
		{
			return _transactionDate;
		}
		
		/**A signed receipt that records all information about a successful payment transaction.
		 */
		public function get transactionReceipt():String
		{
			return _transactionReceipt;
		}
		
		/**The transaction that was restored by the App Store. 
		 */
		public function get originalTransaction():SKPaymentTransaction
		{
			return _originalTransaction;
		}
		
		/**The payment for the transaction.
		 */
		public function get payment():SKPayment
		{
			return _payment;
		}
		
		/**An string describing the error that occurred while processing the transaction.
		 */ 
		public function get error():String
		{
			return _error;
		}
	}
}