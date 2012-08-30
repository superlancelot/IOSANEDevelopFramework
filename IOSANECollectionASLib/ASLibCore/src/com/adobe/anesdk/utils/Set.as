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
	/** A collection structure that contains a array of elements with no repeat.
	 */
	public class Set
	{
		private var _array:Array;
		/**
		 * @param values The initial elements in this set.
		 */
		public function Set(...values)
		{
			_array = new Array();
			this.push.apply(this, values);
		}
		
		/**Adds new elements to the set.
		 * @param values One or more values to append to the set. 
		 */
		public function push(...values):void
		{
			var l:int = values.length;
			for(var i:int; i<l; i++)
			{
				if(!this.contains(values[i]))
				{
					_array.push(values[i]);
				}
			}
		}
		
		/**Removes a specific element from an set.
		 * @param e Element you want to remove.
		 * @return The result of this operation.
		 */
		public function removeElement(e:*):Boolean
		{
			var index:int = _array.indexOf(e);
			if(index > -1)
			{
				if(index != _array.length - 1)
				{
					_array[index] = _array.pop();
				}
				else
				{
					_array.pop();
				}
				return true;
			}
			return false;
		}
		
		/**Clear the set.
		 */
		public function clear():void
		{
			_array = new Array();
		}
		
		/**Test if the set contains a specific element.
		 * @param e Element you want to test.
		 * @return The test result whether the set contains the element.
		 */
		public function contains(e:*):Boolean
		{
			var index:int = _array.indexOf(e);
			return index > -1;
		}
		
		/**Return the inner array collection of the set.
		 */
		public function get array():Array
		{
			return _array.concat();
		}
		
		/**Return the length of the set.
		 */
		public function get length():uint
		{
			return _array.length;
		}
	}
}