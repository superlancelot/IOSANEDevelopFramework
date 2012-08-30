/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FlashRuntimeExtensions.h"
#import "UIKit/UIKit.h"

#ifndef UTILS_CLASSNAME

#define MERGE(x,y,z) x##y##z
#define _MERGE(x,y,z) MERGE(x,y,z)
#define FRE_TRUE _MERGE(static,UTILS_CLASSNAME,FRETrue)
#define FRE_FALSE _MERGE(static,UTILS_CLASSNAME,FREFalse)
#define UTILS_CLASSNAME _MERGE(IOSANECollection,LIB_TYPE,Utils)

#endif

@interface UTILS_CLASSNAME : NSObject

+(FREObject)FRETrue;
+(FREObject)FREFalse;

+(BOOL)registerContextFunction:(uint32_t*)numFunctionsToTest functionsToSet:(const FRENamedFunction**)functionsToSet, ...;
+(NSString*)FREGetObjectAsNSString:(FREObject)object;
+(UIView*)applicationView;

@end
