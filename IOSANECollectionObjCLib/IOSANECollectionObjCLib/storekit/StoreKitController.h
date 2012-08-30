/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#ifndef IOSANECollectionObjCLib_StoreKitController_h
#define IOSANECollectionObjCLib_StoreKitController_h

#import "FlashRuntimeExtensions.h"
#import "StoreKitContext.h"
#import "StoreKitDelegate.h"

const char* g_storeKitContextType = "StoreKit";
StoreKitContext* g_storeKitContext;
StoreKitDelegate* g_storeKitDelegate = nil;


void IOSANECollectionStoreKitExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                            FREContextFinalizer* ctxFinalizerToSet);
void IOSANECollectionStoreKitExtFinalizer(void* extData);

void IOSANECollectionStoreKitContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void IOSANECollectionStoreKitContextFinalizer(void* extData);


FREObject StoreKitCanMakePayments(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitStartProductsRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitCancelProductsRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitGetRequestResponse(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitGetRequestError(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitAddPaymentToQueue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitGetUpdatedTransactions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitFinishTransaction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject StoreKitRestoreCompletedTransactions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

#endif
