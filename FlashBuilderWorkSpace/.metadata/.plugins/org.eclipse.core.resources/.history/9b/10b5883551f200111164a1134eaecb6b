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
package com.adobe.anesdk.components
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	//Abstract Class
	/**Base class of all extension context classes. This class is an abstract class.
	 */
	public class ANESDKExtensionContextBase extends ANESDKExtensionContextEventDispatcher
	{	
		private var _extensionContext:ExtensionContext;
		
		/**This class shouln't be instantiated because it is an abstract class.
		 */
		public function ANESDKExtensionContextBase(self:ANESDKExtensionContextBase, extensionID:String, contextType:String)
		{
			super();
			if(self!= this)
			{
				throw new ArgumentError("Can't new ANESDKExtensionContextBase instance!")
			}
			
			CONFIG::ALL_FEATURE
			{
				extensionID = "com.adobe.IOSANECollectionAll";
			}
			
			if(!init(extensionID, contextType))
			{
				throw new Error("Can't create ExtensionContext: " + extensionID + " " + contextType);
			}
		}
		
		/** @private
		 */
		protected function init(extensionID:String, contextType:String):Boolean
		{
			if(_extensionContext)
			{
				trace("Warnning: ANESDKExtensionContextBase:init extensionContext already inited");
				return true;
			}
			_extensionContext = ExtensionContext.createExtensionContext(extensionID,contextType);
			if(!_extensionContext)
			{
				return false;
			}
			_extensionContext.addEventListener(StatusEvent.STATUS, extensionContext_onStatus);
			return true;
		}
		
		/** @private
		 */
		
		protected function extensionContext_onStatus(event:StatusEvent):void
		{
			this.dispatchEvent(event);
		}
		
		/** @private
		 */
		protected function get extensionContext():ExtensionContext
		{
			return _extensionContext;
		}
	}
}