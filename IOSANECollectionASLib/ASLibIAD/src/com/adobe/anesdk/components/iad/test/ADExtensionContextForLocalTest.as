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

package com.adobe.anesdk.components.iad.test
{
	import com.adobe.anesdk.components.ANEDataEventBase;
	import com.adobe.anesdk.components.ANESDKExtensionContextEventDispatcher;
	import com.adobe.anesdk.components.iad.ADExtensionContext;
	import com.adobe.anesdk.components.iad.IADExtensionContext;
	import com.adobe.anesdk.components.iad.core.ADBannerContentSizeIdentifier;
	import com.adobe.anesdk.components.iad.core.ADBannerView;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**This class is designed for local test.
	 */
	public class ADExtensionContextForLocalTest extends ANESDKExtensionContextEventDispatcher implements IADExtensionContext
	{	
		private var _nativeAdBannerViewRenderer:Class;
		private var bannerDictionary:Dictionary;
		
		public function ADExtensionContextForLocalTest()
		{
			bannerDictionary = new Dictionary();
		}
		
		public function getSizeByAdBannerContentSizeIdentifier(contentSizeId:ADBannerContentSizeIdentifier):Point
		{
			return new Point();
		}
		
		public function createAdBannerView(aneId:String):Boolean
		{
			var bannerView:INativeAdBannerViewForLocalTest = this.createNewNativeAdBannerView();
			bannerDictionary[aneId] = bannerView;
			
			bannerView.addEventListener(NativeAdBannerViewEventForLocalTest.EVENT_DID_LOAD_AD, bannerView_onReceiveEvent);
			bannerView.init();
			return true;
		}
		
		public function destoryAdBannerView(aneId:String):void
		{
			removeAdBannerViewFromMainWindow(aneId);
			var bannerView:INativeAdBannerViewForLocalTest = bannerDictionary[aneId] as INativeAdBannerViewForLocalTest;
			bannerView.destory();
			delete bannerDictionary[aneId];
		}
		
		public function addAdBannerViewToMainWindow(aneId:String, contentSizeId:ADBannerContentSizeIdentifier = null,y:Number = 0):void
		{
			var bannerView:INativeAdBannerViewForLocalTest = bannerDictionary[aneId] as INativeAdBannerViewForLocalTest;
			bannerView.currentContentSizeIdentifier = contentSizeId.value;
			bannerView.y = y;
			bannerView.addEventListener(NativeAdBannerViewEventForLocalTest.EVENT_ACTION_SHOULD_BEGIN, bannerView_onReceiveEvent);
			bannerView.addEventListener(NativeAdBannerViewEventForLocalTest.EVENT_ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION, bannerView_onReceiveEvent);
			bannerView.addEventListener(NativeAdBannerViewEventForLocalTest.EVENT_ACTION_DID_FINISH, bannerView_onReceiveEvent);
			bannerView.addToMainWindow();
		}
		
		public function removeAdBannerViewFromMainWindow(aneId:String):void
		{
			var bannerView:INativeAdBannerViewForLocalTest = bannerDictionary[aneId] as INativeAdBannerViewForLocalTest;
			bannerView.removeFromMainWindow();
		}
		
		public function setAdBannerViewProperty(aneId:String, property:String, value:Object):void
		{
			var bannerView:INativeAdBannerViewForLocalTest = bannerDictionary[aneId] as INativeAdBannerViewForLocalTest;
			
			switch(property)
			{
			case "y":
				bannerView.y = Number(value);
				break;
			case "currentContentSizeIdentifier":
				bannerView.currentContentSizeIdentifier = String(value);
				break;
			default:
				break;
			}
		}
		
		public function cancelBannerViewAction(aneId:String):void
		{
			var bannerView:INativeAdBannerViewForLocalTest = bannerDictionary[aneId] as INativeAdBannerViewForLocalTest;
			bannerView.cancelBannerViewAction();
		}
		
		private function bannerView_onReceiveEvent(event:NativeAdBannerViewEventForLocalTest):void
		{
			var aneId:String = getAneIdFromNativeAdBannderView(event.target as INativeAdBannerViewForLocalTest);
			
			if(aneId == "")
			{
				trace("bannerView_onReceiveEvent " + event.type + " with invalid aneId");
				return;
			}
			
			var eventCode:String;
			switch(event.type)
			{
				case NativeAdBannerViewEventForLocalTest.EVENT_DID_LOAD_AD:
					eventCode = ADExtensionContext.STATUSEVENT_BANNER_VIEW_DID_LOAD_AD;
					break;
				case NativeAdBannerViewEventForLocalTest.EVENT_DID_FAIL_TO_RECEIVE_AD_WITH_ERROR:
					eventCode = ADExtensionContext.STATUSEVENT_BANNER_VIEW_DID_FAIL_TO_RECEIVE_AD_WITH_ERROR;
					break;
				case NativeAdBannerViewEventForLocalTest.EVENT_ACTION_SHOULD_BEGIN:
					eventCode = ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN;
					break;
				case NativeAdBannerViewEventForLocalTest.EVENT_ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION:
					eventCode = ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION;
					break;
				case NativeAdBannerViewEventForLocalTest.EVENT_ACTION_DID_FINISH:
					eventCode = ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_DID_FINISH;
					break;
			}
			
			var e:StatusEvent = new StatusEvent(StatusEvent.STATUS, false, false, eventCode, aneId);
			this.dispatchEvent(e);
		}
		
		private function getAneIdFromNativeAdBannderView(banner:INativeAdBannerViewForLocalTest):String
		{
			for each(var key:String in bannerDictionary)
			{
				if(bannerDictionary[key] == banner)
				{
					return key;
				}
			}
			
			return "";
		}
		
		private function createNewNativeAdBannerView():INativeAdBannerViewForLocalTest
		{
			return new _nativeAdBannerViewRenderer() as INativeAdBannerViewForLocalTest;
		}
		
		public function get nativeAdBannerViewRenderer():Class
		{
			return _nativeAdBannerViewRenderer;
		}

		public function set nativeAdBannerViewRenderer(value:Class):void
		{
			if(_nativeAdBannerViewRenderer == value)
			{
				return;
			}
			
			if(new value() is INativeAdBannerViewForLocalTest)
			{
				_nativeAdBannerViewRenderer = value;
			}
		}
	}
}