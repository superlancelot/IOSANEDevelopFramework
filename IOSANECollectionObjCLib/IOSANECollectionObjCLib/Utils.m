/*

Copyright (C) 2012 CHENGUANG LIU
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        
*/

#import "Utils.h"

@implementation UTILS_CLASSNAME

FREObject FRE_TRUE = NULL;
FREObject FRE_FALSE = NULL;

+(FREObject)FRETrue
{
    if(!FRE_TRUE)
    {
        FRENewObjectFromBool(true, &FRE_TRUE);
    }
    return FRE_TRUE;
}

+(FREObject)FREFalse
{
    if(!FRE_FALSE)
    {
        FRENewObjectFromBool(false, &FRE_FALSE);
    }
    return FRE_FALSE;
}

+(BOOL)registerContextFunction:(uint32_t*)numFunctionsToTest functionsToSet:(const FRENamedFunction**)functionsToSet, ...
{
    const char* funcName;
    
    va_list argList;
    if(!functionsToSet)
    {
        return NO;
    }
    
    int num = 0;
    va_start(argList, functionsToSet);
    while((funcName=va_arg(argList, const char*)))
    {
        va_arg(argList, FREFunction);
        va_arg(argList, void*);
        ++num;
    }
    
    *numFunctionsToTest = num;
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * num);
    
    va_start(argList, functionsToSet);
    for(int i = 0; i < num; i++)
    {
        func[i].name = (const uint8_t*)va_arg(argList, const char*);
        func[i].function = va_arg(argList, FREFunction);
        func[i].functionData = va_arg(argList, void*);
    }
    
    *functionsToSet = func;
    
    return YES;
}

+(NSString*)FREGetObjectAsNSString:(FREObject)object
{
    uint32_t length;
    const uint8_t* value;
    
    FREResult result = FREGetObjectAsUTF8(object, &length, &value);
    if(result != FRE_OK)
    {
        NSLog([NSString stringWithFormat:@"GetFREObjectAsNSString Error: %d",result], nil);
        return nil;
    }
    
    NSString* output = [NSString stringWithUTF8String:(const char*)value];
    return output;
}

+(UIView*)applicationView
{
    return [[[[[UIApplication sharedApplication] windows] objectAtIndex:0]rootViewController] view];
}

@end
