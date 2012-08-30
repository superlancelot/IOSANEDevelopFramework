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
	/**SKProduct objects are returned as part of an SKProductsResponse object
	 *  and are used to provide information about a product previously 
	 * registered with the Apple App Store.
	 * @see com.adobe.anesdk.components.storekit.core.SKProductsResponse
	 */
	public class SKProduct
	{
		private var _productIdentifier:String;
		private var _localizedTitle:String;
		private var _localizedDescription:String;
		private var _price:Number;
		private var _priceLocale:String;//todo type is Locale		
		
		/** @param productIdentifier @copy #productIdentifier
		 * @param localizedTitle @copy #localizedTitle
		 * @param localizedDescription @copy #localizedDescription
		 * @param price @copy #price
		 */
		public function SKProduct(	productIdentifier:String,
									localizedTitle:String,
									localizedDescription:String,
									price:Number)
		{
			_localizedDescription = localizedDescription;
			_localizedTitle = localizedTitle;
			_price = price;
			_productIdentifier = productIdentifier;
		}
		
		/** A description of the product.
		 */
		public function get localizedDescription():String
		{
			return _localizedDescription;
		}

		/**The name of the product.
		 */
		public function get localizedTitle():String
		{
			return _localizedTitle;
		}

		/**The cost of the product in the local currency. 
		 */
		public function get price():Number
		{
			return _price;
		}

		/**The string that identifies the product to the Apple App Store.
		 */
		public function get productIdentifier():String
		{
			return _productIdentifier;
		}
	}
}