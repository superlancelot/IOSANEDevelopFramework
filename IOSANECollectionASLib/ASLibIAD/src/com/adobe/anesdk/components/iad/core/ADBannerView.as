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

package com.adobe.anesdk.components.iad.core
{
	import com.adobe.anesdk.components.iad.ADExtensionContext;
	import com.adobe.anesdk.components.iad.core.events.ADBannerEvent;
	import com.adobe.anesdk.utils.ANEIDObjectManager;
	import com.adobe.anesdk.utils.IANEIDObject;
	import com.adobe.anesdk.utils.Set;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ADBannerView extends EventDispatcher implements IANEIDObject
	{
		protected var _y		:Number = 0;
		protected var _width	:Number = 0;
		protected var _height	:Number = 0;
		
		protected var _alpha	:Number = 0;
		protected var _visible	:Boolean = false;
		
		protected var _requiredContentSizeIdentifiers:Set;
		protected var _currentContentSizeIdentifier:ADBannerContentSizeIdentifier = ADBannerContentSizeIdentifier.NULL;
		
		protected var _bannerLoaded:Boolean = false;
		protected var _bannerViewActionInProgress:Boolean = false;
		
		/** @private
		 */
		protected var _aneId:String = "";
		
		static public function sizeFromBannerContentSizeIdentifier(contentSizeId:ADBannerContentSizeIdentifier):Point
		{
			return ADExtensionContext.instance.getSizeByAdBannerContentSizeIdentifier(contentSizeId);
		}
		
		public function ADBannerView()
		{
			super();
			_requiredContentSizeIdentifiers = new Set();
		}
		
		public function init():Boolean
		{
			ANEIDObjectManager.instance.registerID(this);
			_requiredContentSizeIdentifiers.push(ADBannerContentSizeIdentifier.Portrait, ADBannerContentSizeIdentifier.Landscape);
			_alpha = 1;
			
			ADExtensionContext.instance.addStatusEventListener(context_onStatus);
			return ADExtensionContext.instance.createAdBannerView(_aneId);
		}
		
		public function destory():void
		{
			ADExtensionContext.instance.destoryAdBannerView(_aneId);
			ADExtensionContext.instance.removeStatusEventListener(context_onStatus);
		}
		
		public function show(contentSizeId:ADBannerContentSizeIdentifier = null, y:Number = 0):void
		{
			if(_visible)
			{
				return;
			}
			_visible = true;
			ADExtensionContext.instance.addAdBannerViewToMainWindow(_aneId, contentSizeId, y);
		}
		
		public function hide():void
		{
			if(!_visible)
			{
				return;
			}
			_visible = false;
			ADExtensionContext.instance.removeAdBannerViewFromMainWindow(_aneId);
		}
		
		public function cancelBannerViewAction():void
		{
			ADExtensionContext.instance.cancelBannerViewAction(_aneId);
		}
		
		protected function context_onStatus(event:StatusEvent):void
		{
			if(event.level == this.aneId)
			{
				var e:ADBannerEvent;
				switch(event.code)
				{
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_WILL_LOAD_AD:
						e = new ADBannerEvent(ADBannerEvent.WILL_LOAD_AD);
						this.dispatchEvent(e);
						break;
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_DID_LOAD_AD:
						e = new ADBannerEvent(ADBannerEvent.DID_LOAD_AD);
						this.dispatchEvent(e);
						break;
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN:
						_bannerViewActionInProgress = true;
						e = new ADBannerEvent(ADBannerEvent.ACTION_SHOULD_BEGIN);
						this.dispatchEvent(e);
						break;
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION:
						e = new ADBannerEvent(ADBannerEvent.ACTION_SHOULD_BEGIN_WILL_LEAVE_APPLICATION);
						this.dispatchEvent(e);
						break;
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_ACTION_DID_FINISH:
						_bannerViewActionInProgress = false;
						e = new ADBannerEvent(ADBannerEvent.ACTION_DID_FINISH);
						this.dispatchEvent(e);
						break;
					case ADExtensionContext.STATUSEVENT_BANNER_VIEW_DID_FAIL_TO_RECEIVE_AD_WITH_ERROR:
						e = new ADBannerEvent(ADBannerEvent.DID_FAIL_TO_RECEIVE_AD_WITH_ERROR);
						this.dispatchEvent(e);
						break;
					default:
						break;
					
				}
			}
		}
		
		/**@inheritDoc
		 */
		public function get aneId():String
		{
			return _aneId;
		}
		
		public function set aneId(value:String):void
		{
			_aneId = value;
		}

		public function get x():Number
		{
			return 0;
		}
		
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y == value)
			{
				return;
			}
			_y = Number(ADExtensionContext.instance.setAdBannerViewProperty(_aneId, "y", value));
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}

		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha(value:Number):void
		{
			if(_y == value)
			{
				return;
			}
			_alpha = Number(ADExtensionContext.instance.setAdBannerViewProperty(_aneId, "alpha", value));
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function get requiredContentSizeIdentifiers():Array
		{
			return _requiredContentSizeIdentifiers.array;
		}
		public function set requiredContentSizeIdentifiers(value:Array):void
		{
			ADExtensionContext.instance.setAdBannerViewProperty(_aneId, "requiredContentSizeIdentifiers", value) as Array;
			_requiredContentSizeIdentifiers.clear();
			_requiredContentSizeIdentifiers.push.apply(_requiredContentSizeIdentifiers, value);
		}

		public function get currentContentSizeIdentifier():ADBannerContentSizeIdentifier
		{
			return _currentContentSizeIdentifier;
		}

		public function set currentContentSizeIdentifier(value:ADBannerContentSizeIdentifier):void
		{
			if(_currentContentSizeIdentifier == value)
			{
				return;
			}
			ADExtensionContext.instance.setAdBannerViewProperty(_aneId, "currentContentSizeIdentifier", value.value)
			_currentContentSizeIdentifier = value;
		}

		public function get bannerLoaded():Boolean
		{
			return _bannerLoaded;
		}

		public function get bannerViewActionInProgress():Boolean
		{
			return _bannerViewActionInProgress;
		}
	}
}