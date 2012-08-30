/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "IOSANECollectionObjCLib.h"
#import "IOSANEControllers.h"


void IOSANECollectionExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering IOSANECollectionExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOSANECollectionContextInitializer;
    *ctxFinalizerToSet = &IOSANECollectionContextFinalizer;
    
    NSLog(@"Exiting IOSANECollectionExtInitializer()");
}

void IOSANECollectionExtFinalizer(void* extData) 
{
    NSLog(@"Entering IOSANECollectionExtFinalizer()");

    NSLog(@"Exiting IOSANECollectionExtFinalizer()");
    return;
}

void IOSANECollectionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering IOSANECollectionContextInitializer()");
    
    const char* type = (const char*)ctxType;
    
    if(strcmp(type, g_storeKitContextType) == 0)
    {
        IOSANECollectionStoreKitContextInitializer(extData, ctxType, ctx, numFunctionsToTest, functionsToSet);
    }
    else if(strcmp(type, g_iADContextType) == 0)
    {
        IOSANECollectionIADContextInitializer(extData, ctxType, ctx, numFunctionsToTest, functionsToSet);
    }
    else
    {
        NSLog(@"Context type is invalid");
        *numFunctionsToTest = 0;
    }

    NSLog(@"Exiting IOSANECollectionContextInitializer()");
}

void IOSANECollectionContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering IOSANECollectionContextFinalizer()");

    NSLog(@"Exiting IOSANECollectionContextFinalizer()");
    return;
}

