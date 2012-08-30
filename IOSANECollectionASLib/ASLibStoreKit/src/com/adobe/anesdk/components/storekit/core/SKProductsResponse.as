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
	/**An SKProductsResponse object is returned by the Apple App 
	 * Store in response to a request for information about a list of products.
	 */
	public class SKProductsResponse
	{
		private var _products:Array;
		private var _invalidProductidentifiers:Array;
		
		public function SKProductsResponse(products:Array = null, invalidProductidentifiers:Array = null)
		{
			init(products, invalidProductidentifiers);
		}
		
		private function init(products:Array, invalidProductidentifiers:Array):void
		{
			_products = new Array();
			_invalidProductidentifiers = new Array();
			
			if(products)
			{
				for each (var p:SKProduct in products)
				{
					if(p)
					{
						_products.push(p);
					}
					else
					{
						trace("SKProductsResponse:SKProductsResponse <products>argument contains invalid value");
					}
				}
			}

			if(invalidProductidentifiers)
			{
				for each (var pid:String in invalidProductidentifiers)
				{
					if(pid)
					{
						_invalidProductidentifiers.push(pid);
					}
					else
					{
						trace("SKProductsResponse:SKProductsResponse <invalidProductidentifiers>argument contains invalid value");
					}
				}
			}
		}

		/**A list of products, one product for each valid product identifier provided in the original request.
		 */
		public function get products():Array
		{
			return _products;
		}

		/**An array of product identifier strings that were not recognized by the Apple App Store.
		 */
		public function get invalidProductidentifiers():Array
		{
			return _invalidProductidentifiers;
		}
	}
}