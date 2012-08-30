package com.adobe.anesdk.components.storekit.core.events
{
	/**SKRequestEvent would be dispatched after a request from StoreKit to App Store.
	 */
	public class SKProductsRequestEvent extends SKRequestEvent
	{
		/**The Apple App Store responds to the product request.
		 */
		static public const DID_RECEIVE_RESPONSE:String = "SKProductsRequestEvent:DID_RECEIVE_RESPONSE"; 
		/**@inheritDoc
		 */
		static public const DID_FAIL_WITH_ERROR:String = "SKProductsRequestEvent:DID_FAIL_WITH_ERROR"; 
		/**@inheritDoc
		 */
		static public const DID_FINISH:String = "SKProductsRequestEvent:DID_FINISH"; 
		
		/**@param type @copy flash.events.Event#type
		 * @param bubbles @copy flash.events.Event#bubbles
		 * @param cancelable @copy flash.events.Event#cancelable
		 */
		public function SKProductsRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}