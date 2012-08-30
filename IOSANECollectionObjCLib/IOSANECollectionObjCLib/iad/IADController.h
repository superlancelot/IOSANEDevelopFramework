/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#ifndef IOSANECollectionObjCLib_ADController_h
#define IOSANECollectionObjCLib_ADController_h

#import "FlashRuntimeExtensions.h"
#import "IADContext.h"
//#import "IADDelegate.h"

const char* g_iADContextType = "IAD";
IADContext* g_iADContext;

void IOSANECollectionIADExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                            FREContextFinalizer* ctxFinalizerToSet);
void IOSANECollectionIADExtFinalizer(void* extData);

void IOSANECollectionIADContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void IOSANECollectionIADContextFinalizer(void* extData);


FREObject IADTest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

FREObject IADGetSizeByAdBannerContentSizeIdentifier(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADCreateAdBannerView(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADDestoryAdBannerView(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADAddAdBannerViewToMainWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADRemoveAdBannerViewFromMainWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADSetAdBannerViewProperty(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject IADCancelBannerViewAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
#endif
