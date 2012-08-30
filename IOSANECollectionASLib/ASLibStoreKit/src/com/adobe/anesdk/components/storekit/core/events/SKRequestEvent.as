package com.adobe.anesdk.components.storekit.core.events
{
	import com.adobe.anesdk.components.ANEDataEventBase;
	
	import flash.events.Event;
	
	public class SKRequestEvent extends ANEDataEventBase
	{
		/**The request has completed.
		 */
		static public const DID_FINISH:String = "SKRequestEvent:DID_FINISH";
		
		/**The request failed to execute.
		 */
		static public const DID_FAIL_WITH_ERROR:String = "SKRequestEvent:DID_FAIL_WITH_ERROR";
		
		/**@param type @copy flash.events.Event#type
		 * @param bubbles @copy flash.events.Event#bubbles
		 * @param cancelable @copy flash.events.Event#cancelable
		 */
		public function SKRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}