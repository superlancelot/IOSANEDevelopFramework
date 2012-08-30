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

package com.adobe.anesdk.components.iad
{
	import com.adobe.anesdk.components.ANESDKExtensionContextBase;
	import com.adobe.anesdk.components.iad.core.ADBannerContentSizeIdentifier;
	import com.adobe.anesdk.components.iad.test.ADExtensionContextForLocalTest;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ADExtensionContext extends ANESDKExtensionContextBase implements IADExtensionContext
	{
		static public var instanceForLocalTest:ADExtensionContextForLocalTest;
		static private var _instance:ADExtensionContext;
		static private function hide():void{}
		
		/**Get the single instance of this Class.
		 */
		static public function get instance():IADExtensionContext
		{
			if(!localTest)
			{
				if(!_instance)
				{
					_instance = new ADExtensionContext(hide);
				}
				return _instance;
			}
			if(!instanceForLocalTest)
			{
				instanceForLocalTest = new ADExtensionContextForLocalTest();
			}
			return instanceForLocalTest;
		}
		
		/**A switch can open/close local test mode.
		 * If it is true, property instance will return an instance of ADExtensionContextForLocalTest
		 *  instead of an instance of ADExtensionContext.
		 * @see com.adobe.anesdk.components.storekit.test.ADExtensionContextForLocalTest
		 */ 
		static public var localTest:Boolean = false;
		
		/**Request has received response from AppStore.
		 */
		static public const STATUSEVENT_BANNER_VIEW_WILL_LOAD_AD		:String = "bannerViewWillLoadAd";
		static public const STATUSEVENT_BANNER_VIEW_DID_LOAD_AD			:String = "bannerViewDidLoadAd";
		static public const STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN	:String = "bannerViewActionShouldBegin";
		static public const STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION	:String = "bannerViewActionShouldBeginWillLeaveApplication";
		static public const STATUSEVENT_BANNER_VIEW_ACTION_DID_FINISH	:String = "bannerViewActionDidFinish";
		static public const STATUSEVENT_BANNER_VIEW_DID_FAIL_TO_RECEIVE_AD_WITH_ERROR			:String = "bannerViewDidFailToReceiveAdWithError";
		
		static private const CONTEXT_TYPE:String = "IAD";
		
		static private const FUNCATION_GET_SIZE_BY_AD_BANNER_CONTENT_SIZE_IDENTIFIER	:String = CONTEXT_TYPE + "GetSizeByAdBannerContentSizeIdentifier";
		static private const FUNCATION_CREATE_AD_BANNER_VIEW							:String = CONTEXT_TYPE + "CreateAdBannerView";
		static private const FUNCATION_DESTORY_AD_BANNER_VIEW							:String = CONTEXT_TYPE + "DestoryAdBannerView";
		static private const FUNCATION_ADD_AD_BANNER_VIEW_TO_MAIN_WINDOW				:String = CONTEXT_TYPE + "AddAdBannerViewToMainWindow";
		static private const FUNCATION_REMOVE_AD_BANNER_VIEW_FROM_MAIN_WINDOW			:String = CONTEXT_TYPE + "RemoveAdBannerViewFromMainWindow";
		static private const FUNCATION_SET_AD_BANNER_VIEW_PROPERTY						:String = CONTEXT_TYPE + "SetAdBannerViewProperty";
		static private const FUNCTION_CANCEL_BANNER_VIEW_ACTION							:String = CONTEXT_TYPE + "CancelBannerViewAction";
		/**You shouldn't call the constructor because this class is a singleton.
		 */
		public function ADExtensionContext(caller:Function)
		{
			super(this, "com.adobe.IOSANECollectionIAD", CONTEXT_TYPE);
			if(caller != hide || _instance)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
		}
		
		public function getSizeByAdBannerContentSizeIdentifier(contentSizeId:ADBannerContentSizeIdentifier):Point
		{
			return this.extensionContext.call(FUNCATION_GET_SIZE_BY_AD_BANNER_CONTENT_SIZE_IDENTIFIER, contentSizeId.value) as Point;
		}
		
		public function createAdBannerView(aneId:String):Boolean
		{
			return Boolean(this.extensionContext.call(FUNCATION_CREATE_AD_BANNER_VIEW, aneId));
		}
		public function destoryAdBannerView(aneId:String):void
		{
			this.extensionContext.call(FUNCATION_DESTORY_AD_BANNER_VIEW, aneId);
		}
		
		public function addAdBannerViewToMainWindow(aneId:String, contentSizeId:ADBannerContentSizeIdentifier = null,y:Number = 0):void
		{
			this.extensionContext.call(FUNCATION_ADD_AD_BANNER_VIEW_TO_MAIN_WINDOW, aneId, contentSizeId ? contentSizeId.value : ADBannerContentSizeIdentifier.NULL.value, y);
		}
		
		public function removeAdBannerViewFromMainWindow(aneId:String):void
		{
			this.extensionContext.call(FUNCATION_REMOVE_AD_BANNER_VIEW_FROM_MAIN_WINDOW, aneId);
		}
		
		public function setAdBannerViewProperty(aneId:String, property:String, value:Object):void
		{
			this.extensionContext.call(FUNCATION_SET_AD_BANNER_VIEW_PROPERTY, aneId, property, value);
		}
		
		public function cancelBannerViewAction(aneId:String):void
		{
			this.extensionContext.call(FUNCTION_CANCEL_BANNER_VIEW_ACTION, aneId);
		}
	}
}