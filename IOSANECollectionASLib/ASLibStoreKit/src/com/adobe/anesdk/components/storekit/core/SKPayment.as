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
	/**The SKPayment class defines a request to the 
	 * Apple App Store to process payment for additional 
	 * functionality offered by your application.
	 *  A payment encapsulates a string that identifies a 
	 * particular product and the quantity of those items 
	 * the user would like to purchase.
	 * @see com.adobe.anesdk.components.storekit.core.SKPaymentQueue
	 */
	public class SKPayment
	{
		private var _productIdentifier:String;
		private var _quantity:uint = 0;
		
		/**@param productId @copy #productIdentifier
		 * @param quantity @copy #quantity
		 */
		public function SKPayment(productId:String, quantity:uint = 1)
		{
			_productIdentifier = productId;
			_quantity = quantity;
		}
		
		/**A string used to identify a product that can be purchased from within your application.
		 */
		public function get productIdentifier():String
		{
			return _productIdentifier;
		}

		/**The number of items the user wants to purchase. 
		 */
		public function get quantity():uint
		{
			return _quantity;
		}

		public function set quantity(value:uint):void
		{
			_quantity = value;
		}
	}
}