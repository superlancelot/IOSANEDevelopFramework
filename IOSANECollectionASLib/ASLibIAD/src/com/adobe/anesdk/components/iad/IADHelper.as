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
	import com.adobe.anesdk.components.iad.core.ADBannerContentSizeIdentifier;
	import com.adobe.anesdk.components.iad.core.ADBannerView;
	import com.adobe.anesdk.components.iad.core.events.ADBannerEvent;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class IADHelper
	{
		static public const USER_ACTION_BEGIN:String ="IADHelper:UserActionBegin";
		static public const USER_ACTION_BEGIN_WILL_LEAVE_APP:String ="IADHelper:UserActionBeginWillLeaveApp";
		static public const USER_ACTION_FINISHED:String ="IADHelper:UserActionFinished";
		
		static private var _instance:IADHelper;
		static private function hide():void{}
		
		/**Get the single instance of this Class.
		 */
		static public function get instance():IADHelper
		{
			if(!_instance)
			{
				_instance = new IADHelper(hide);
			}
			return _instance;
		}
		
		private var _adBannerViewDictionary:Dictionary;
		private var _callbackDictionary:Dictionary;
		
		public function IADHelper(caller:Function)
		{
			if(caller != hide || _instance)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
			_adBannerViewDictionary = new Dictionary();
			_callbackDictionary = new Dictionary(true);
		}
		
		public function getSizeFromBannerContentSizeIdentifier(contentSizeId:ADBannerContentSizeIdentifier):Point
		{
			return ADBannerView.sizeFromBannerContentSizeIdentifier(contentSizeId);
		}
		
		//callBack: handleUserAction(action:String)
		public function createNewAdBannerView(callBack:Function, contentSizeId:ADBannerContentSizeIdentifier = null, y:Number = 0):ADBannerView
		{
			var bannerView:ADBannerView = new ADBannerView();
			if(!bannerView.init())
			{
				return null;
			}

			_adBannerViewDictionary[bannerView.aneId] = bannerView;
			_callbackDictionary[bannerView.aneId] = callBack;
			bannerView.addEventListener(ADBannerEvent.DID_LOAD_AD, adBannerView_onDidLoadAd);
			bannerView.addEventListener(ADBannerEvent.DID_FAIL_TO_RECEIVE_AD_WITH_ERROR, adBannerView_onFailToReceiveAdWithError);
			bannerView.addEventListener(ADBannerEvent.ACTION_SHOULD_BEGIN, adBannerView_onAction);
			bannerView.addEventListener(ADBannerEvent.ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION, adBannerView_onAction);
			bannerView.addEventListener(ADBannerEvent.ACTION_DID_FINISH, adBannerView_onAction);
			
			if(contentSizeId)
			{
				bannerView.currentContentSizeIdentifier = contentSizeId;
			}
			if(y != 0)
			{
				bannerView.y = y;
			}
			
			return bannerView;
		}
		
		public function destoryNewAdBannerView(bannerView:ADBannerView):void
		{
			if(_adBannerViewDictionary[bannerView.aneId] != bannerView)
			{
				//bannerView doesn't exist
				return;
			}
			
			bannerView.removeEventListener(ADBannerEvent.DID_LOAD_AD, adBannerView_onDidLoadAd);
			bannerView.removeEventListener(ADBannerEvent.DID_FAIL_TO_RECEIVE_AD_WITH_ERROR, adBannerView_onFailToReceiveAdWithError);
			bannerView.removeEventListener(ADBannerEvent.ACTION_SHOULD_BEGIN, adBannerView_onAction);
			bannerView.removeEventListener(ADBannerEvent.ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION, adBannerView_onAction);
			bannerView.removeEventListener(ADBannerEvent.ACTION_DID_FINISH, adBannerView_onAction);
			
			delete _callbackDictionary[bannerView.aneId];
			delete _adBannerViewDictionary[bannerView.aneId];
			
			bannerView.destory();
		}
		
		private function adBannerView_onDidLoadAd(event:ADBannerEvent):void
		{
			var sender:ADBannerView = event.target as ADBannerView;
			sender.show(sender.currentContentSizeIdentifier, sender.y);
		}
		
		private function adBannerView_onFailToReceiveAdWithError(event:ADBannerEvent):void
		{
			var sender:ADBannerView = event.target as ADBannerView;
			sender.hide();
		}
		
		private function adBannerView_onAction(event:ADBannerEvent):void
		{
			trace("adBannerView_onAction: " + event.type);
			var sender:ADBannerView = event.target as ADBannerView;
			var callback:Function = (_callbackDictionary[sender.aneId] as Function);
			if(callback != null)
			{
				var userAction:String;
				switch(event.type)
				{
					case ADBannerEvent.ACTION_SHOULD_BEGIN:
						userAction = USER_ACTION_BEGIN;
						break;
					case ADBannerEvent.ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION:
						userAction = USER_ACTION_BEGIN_WILL_LEAVE_APP;
						break;
					case ADBannerEvent.ACTION_DID_FINISH:
						userAction = USER_ACTION_FINISHED;
						break;
					default:
						trace("IADHelper:adBannerView_onAction event.type error");
						return;
				}
				try
				{
					callback(userAction);
				}
				catch(e:Error)
				{
					trace("IADHelper:adBannerView_onActionShouldBegin callBack error");
					return;
				}
			}
		}
	}
}