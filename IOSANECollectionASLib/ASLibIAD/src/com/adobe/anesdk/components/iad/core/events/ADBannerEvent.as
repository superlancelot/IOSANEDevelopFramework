package com.adobe.anesdk.components.iad.core.events
{
	import com.adobe.anesdk.components.ANEDataEventBase;
	
	public class ADBannerEvent extends ANEDataEventBase
	{
		static public const WILL_LOAD_AD								:String = "ADBannerEvent:WILL_LOAD_AD";
		static public const DID_LOAD_AD									:String = "ADBannerEvent:DID_LOAD_AD";
		static public const ACTION_SHOULD_BEGIN							:String = "ADBannerEvent:ACTION_SHOULD_BEGIN";
		static public const ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION	:String = "ADBannerEvent:ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION";
		static public const ACTION_DID_FINISH							:String = "ADBannerEvent:ACTION_DID_FINISH";
		static public const DID_FAIL_TO_RECEIVE_AD_WITH_ERROR			:String = "ADBannerEvent:DID_FAIL_TO_RECEIVE_AD_WITH_ERROR";
		
		/**@param type @copy flash.events.Event#type
		 * @param bubbles @copy flash.events.Event#bubbles
		 * @param cancelable @copy flash.events.Event#cancelable
		 */
		public function ADBannerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}