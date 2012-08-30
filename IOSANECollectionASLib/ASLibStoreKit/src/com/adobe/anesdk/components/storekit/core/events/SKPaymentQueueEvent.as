package com.adobe.anesdk.components.storekit.core.events
{
	import com.adobe.anesdk.components.ANEDataEventBase;
	
	import flash.events.Event;
	
	/**SKPaymentQueueEvent would be dispatched after a payment is finished.
	 * @see com.adobe.anesdk.components.storekit.core.SKPaymentQueue
	 */
	public class SKPaymentQueueEvent extends ANEDataEventBase
	{
		/**One or more transactions have been updated.
		 */
		static public const TRANSACTIONS_UPDATED:String = "SKPaymentQueueEvent:TRANSACTIONS_UPDATED"; 
		/**One or more transactions have been removed from the queue.
		 */
		static public const TRANSACTIONS_REMOVED:String = "SKPaymentQueueEvent:TRANSACTIONS_REMOVED"; 
		
		/**@param type @copy flash.events.Event#type
		 * @param bubbles @copy flash.events.Event#bubbles
		 * @param cancelable @copy flash.events.Event#cancelable
		 */
		public function SKPaymentQueueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}