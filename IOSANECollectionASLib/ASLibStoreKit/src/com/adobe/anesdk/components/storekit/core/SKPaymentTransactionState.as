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
	/*
	enum {
	SKPaymentTransactionStatePurchasing,    // Transaction is being added to the server queue.
	SKPaymentTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
	SKPaymentTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
	SKPaymentTransactionStateRestored       // Transaction was restored from user's purchase history.  Client should complete the transaction.
	};
	*/
	
	public class SKPaymentTransactionState
	{
		/**Transaction is being added to the server queue.
		 */
		static public const SKPaymentTransactionStatePurchasing	:SKPaymentTransactionState  = new SKPaymentTransactionState();
		/**Transaction is in queue, user has been charged.  Client should complete the transaction.
		 */
		static public const SKPaymentTransactionStatePurchased	:SKPaymentTransactionState  = new SKPaymentTransactionState();
		/**Transaction was cancelled or failed before being added to the server queue.
		 */
		static public const SKPaymentTransactionStateFailed		:SKPaymentTransactionState  = new SKPaymentTransactionState();
		/**Transaction was restored from user's purchase history.  Client should complete the transaction.
		 */
		static public const SKPaymentTransactionStateRestored	:SKPaymentTransactionState  = new SKPaymentTransactionState();
		
		/**Return the transaction state by enumeration type.
		 * @return Return SKPaymentTransactionStatePurchasing when value is 0,
		 * <p>Return SKPaymentTransactionStatePurchased when value is 1,</p>
		 * <p>return SKPaymentTransactionStateFailed when value is 2,</p>
		 * <p>return SKPaymentTransactionStateRestored when value is 3,</p>
		 * <p>return <code>null</code> for other value input.</p>
		 */
		static public function getInstanceByEnum(value:int):SKPaymentTransactionState
		{
			switch(value)
			{
				case 0:
					return SKPaymentTransactionStatePurchasing;
				case 1:
					return SKPaymentTransactionStatePurchased;
				case 2:
					return SKPaymentTransactionStateFailed;
				case 3:
					return SKPaymentTransactionStateRestored;
				default:
					break;
			}
			trace("SKPaymentTransactionState:getInstanceByEnum Error. value:" + value.toString());
			return null;
		}
		
		/**You shouldn't call the constructor because this class is an enumerate.
		 */
		public function SKPaymentTransactionState()
		{
		}
	}
}