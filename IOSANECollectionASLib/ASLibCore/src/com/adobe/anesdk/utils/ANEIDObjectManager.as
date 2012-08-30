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

package com.adobe.anesdk.utils
{
	import flash.utils.Dictionary;

	/**ANEIDObjectManager is used for managing IANEObjects. It can allocate an available aneId for each IANEIDObject 
	 *  and return a specific IANEIDObject by its registed aneId. This class is a singleton.
	 */
	public class ANEIDObjectManager
	{
		static private var _instance:ANEIDObjectManager;
		/**Get the single instance of this class.
		 */
		static public function get instance():ANEIDObjectManager
		{
			if(!_instance)
			{
				_instance = new ANEIDObjectManager(hide);
			}
			return _instance;
		}
		static private function hide():void{}
		
		private var maxId:int = 0;
		private var objDictionary:Dictionary;
		/**You shouldn't call the constructor because this class is a singleton.
		 */
		public function ANEIDObjectManager(caller:Function)
		{
			if(caller != hide || _instance)
			{
				throw new Error("This is a singleton. Use instance property instead.");
				return;
			}
			objDictionary = new Dictionary(true);
		}
		
		/**Create an aneId for an object that implements IANEIDObject.
		 */
		public function registerID(aneIdObj:IANEIDObject):Boolean
		{
			if(aneIdObj.aneId != "")
			{
				trace((aneIdObj as Object).toString() + " already has aneId " + aneIdObj.aneId);
				return false;
			}
			
			aneIdObj.aneId = (++maxId).toString();
			objDictionary[aneIdObj.aneId] = aneIdObj;
			return true;
		}
		
		/**Return an object that implements IANEIDObject by a aneId.
		 * @aneId @copy com.adobe.anesdk.utils. IANEIDObject#aneId
		 */
		public function getObjByAneId(aneId:String):IANEIDObject
		{
			return objDictionary[aneId];
		}
	}
}