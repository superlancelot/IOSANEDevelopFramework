/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "Utils+StoreKit.h"
#import "StoreKitController.h"

void IOSANECollectionStoreKitExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering IOSANECollectionStoreKitExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOSANECollectionStoreKitContextInitializer;
    *ctxFinalizerToSet = &IOSANECollectionStoreKitContextFinalizer;
    
    NSLog(@"Exiting IOSANECollectionStoreKitExtInitializer()");
}

void IOSANECollectionStoreKitExtFinalizer(void* extData) 
{
    NSLog(@"Entering IOSANECollectionStoreKitExtFinalizer()");
    
    // Nothing to clean up.
    NSLog(@"Exiting IOSANECollectionStoreKitExtFinalizer()");
    return;
}

void IOSANECollectionStoreKitContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering IOSANECollectionStoreKitContextInitializer()");
    
    g_storeKitContext = [[StoreKitContext alloc] initWithExtensionContext: ctx];
    
    [UTILS_CLASSNAME registerContextFunction:numFunctionsToTest functionsToSet:functionsToSet, 
                                    "StoreKitCanMakePayments",      
                                    &StoreKitCanMakePayments,       NULL,
                                    "StoreKitStartProductsRequest", 
                                    &StoreKitStartProductsRequest,  NULL,
                                    "StoreKitCancelProductsRequest", 
                                    &StoreKitCancelProductsRequest, NULL,     
                                    "StoreKitGetRequestResponse",
                                    &StoreKitGetRequestResponse,    NULL,
                                    "StoreKitGetRequestError",
                                    &StoreKitGetRequestError,       NULL,
                                    "StoreKitAddPaymentToQueue",
                                    &StoreKitAddPaymentToQueue,     NULL,
                                    "StoreKitGetUpdatedTransactions",
                                    &StoreKitGetUpdatedTransactions, NULL, 
                                    "StoreKitFinishTransaction", 
                                    &StoreKitFinishTransaction,     NULL, 
                                    "StoreKitRestoreCompletedTransactions",
                                    &StoreKitRestoreCompletedTransactions, NULL, nil];
    
    g_storeKitDelegate = [[StoreKitDelegate alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:g_storeKitDelegate];
    
    NSLog(@"Exiting IOSANECollectionStoreKitContextInitializer()");
}

void IOSANECollectionStoreKitContextFinalizer(void* extData)
{
    NSLog(@"Entering IOSANECollectionStoreKitContextFinalizer()");
    
    //TODO: clear g_skContext
   
    NSLog(@"Exiting IOSANECollectionStoreKitContextFinalizer()");
}

FREObject StoreKitCanMakePayments(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return [SKPaymentQueue canMakePayments] == YES ? [UTILS_CLASSNAME FRETrue] : [UTILS_CLASSNAME FREFalse];     
}

FREObject StoreKitStartProductsRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitStartProductsRequest()");

//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
//get argv[1]
    
    uint32_t arrayLength = 0;
    if(FRE_OK != FREGetArrayLength(argv[1], &arrayLength))
    {
        NSLog([NSString stringWithFormat:@"FREGetArrayLength argv[1] Error"],nil);
        return [UTILS_CLASSNAME FREFalse];
    }
    
    NSMutableSet* productIds = [[NSMutableSet alloc] initWithCapacity:arrayLength];
    NSString* productId;
    
    for(uint32_t i = 0; i < arrayLength; i++)
    {
        FREObject strObj;
        if(FRE_OK != FREGetArrayElementAt(argv[1], i, &strObj))
        {
            NSLog([NSString stringWithFormat:@"FREGetArrayElementAt argv[1], %d Error", i],nil);
            return [UTILS_CLASSNAME FREFalse];
        }
        
        productId = nil;
        productId = [UTILS_CLASSNAME FREGetObjectAsNSString: strObj];
        if(productId == nil)
        {
            NSLog([NSString stringWithFormat:@"GetFREObjectAsNSString argv[1], %d Error", i],nil);
            return [UTILS_CLASSNAME FREFalse];
        }
        
        [productIds addObject:productId];
    }
    
//start request
    
    SKProductsRequest* productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    [g_storeKitContext.requestDictionary setObject:productRequest forKey:aneId];
    
    productRequest.delegate = g_storeKitDelegate;
    [productRequest start];
    
    NSLog(@"Exiting StoreKitStartProductsRequest()");
    
    return [UTILS_CLASSNAME FRETrue];
}

FREObject StoreKitCancelProductsRequest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitCancelProductsRequest()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
//cancel request
    SKProductsRequest* productRequest = [g_storeKitContext.requestDictionary objectForKey:aneId];
    [productRequest cancel];
    productRequest.delegate = nil;
    [g_storeKitContext.requestDictionary removeObjectForKey:aneId];
    
    NSLog(@"Exiting StoreKitCancelProductsRequest()");
    
    return [UTILS_CLASSNAME FRETrue];
}

FREObject StoreKitGetRequestResponse(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitGetRequestResponse()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//get data from dictionary
    SKProductsResponse* response = [g_storeKitContext.requestDictionary objectForKey:aneId];
    if(response == nil)
    {
        NSLog(@"requestDictionary objectForKey Error");
        return NULL;
    }
    
//prepare response output args
    FREObject exception;
    
    //create products array
    uint32_t productsCount = response.products.count;
    
    FREObject products;
    
    if(FRE_OK != FRENewObject((const uint8_t*)"Array", 0, NULL, &products, &exception))
    {
        NSLog(@"FRENewObject Array products Error");
        return NULL;
    }
    
    if(FRE_OK != FRESetArrayLength(products, productsCount))
    {
        NSLog([NSString stringWithFormat:@"FRESetArrayLength products %d Error", productsCount], nil);
        return NULL;
    }
    //fill products array
    for(uint32_t i =0; i < productsCount; i++)
    {
        FREObject product;
        SKProduct* skProduct = [response.products objectAtIndex:i];
        [g_storeKitContext.productDictionary setValue:skProduct forKey:skProduct.productIdentifier];
        if(FRE_OK != [UTILS_CLASSNAME FRENewObjectFromSKProduct:skProduct object:&product thrownException:&exception])
        {
            NSLog([NSString stringWithFormat: @"NewFREObjectFromSKProduct response.products[%d] Error", i], nil);
            return NULL;
        }
        if(FRE_OK != FRESetArrayElementAt(products, i, product))
        {
            NSLog([NSString stringWithFormat: @"FRESetArrayElementAt products[%d] Error", i], nil);
            return NULL;
        }
    }
    
    //create invalidProductidentifiers array
    uint32_t invalidProductidentifiersCount = response.invalidProductIdentifiers.count;
    
    FREObject invalidProductidentifiers;
    
    if(FRE_OK != FRENewObject((const uint8_t*)"Array", 0, NULL, &invalidProductidentifiers, &exception))
    {
        NSLog(@"FRENewObject Array invalidProductidentifiers Error");
        return NULL;
    }
    
    if(FRE_OK != FRESetArrayLength(invalidProductidentifiers, invalidProductidentifiersCount))
    {
        NSLog([NSString stringWithFormat:@"FRESetArrayLength invalidProductidentifiers %d Error", invalidProductidentifiersCount], nil);
        return NULL;
    }
    
    //fill invalidProductidentifiers array
    for(uint32_t i =0; i < invalidProductidentifiersCount; i++)
    {
        FREObject productIdentifier;
        
        NSString* productIdentifierStr = [response.invalidProductIdentifiers objectAtIndex:i];
        if(FRE_OK != FRENewObjectFromUTF8(productIdentifierStr.length, (const uint8_t*)[productIdentifierStr UTF8String], &productIdentifier))
        {
            NSLog([NSString stringWithFormat:@"FRENewObjectFromUTF8 response.invalidProductIdentifiers[%d] Error", i], nil);
            return NULL;
        }
        if(FRE_OK != FRESetArrayElementAt(invalidProductidentifiers, i, productIdentifier))
        {
            NSLog([NSString stringWithFormat:@"RESetArrayElementAt invalidProductidentifiers[%d] Error", i], nil);
            return NULL;
        }
    }
    
//create response output
    FREObject output;
    FREObject responseArgv[2] = {products, invalidProductidentifiers};
    if(FRE_OK != FRENewObject((const uint8_t*)"com.adobe.anesdk.components.storekit.core.SKProductsResponse" , 2, responseArgv, &output, &exception))
    {
        NSLog(@"FRENewObject SKProductsResponse Error");
        return NULL;
    }
    
    NSLog(@"Exiting StoreKitGetRequestResponse()");
    return output;
}

FREObject StoreKitGetRequestError(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitGetRequestError()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//get data from dictionary
    NSError* error = [g_storeKitContext.requestDictionary objectForKey:aneId];
    if(error == nil)
    {
        NSLog(@"requestDictionary objectForKey Error");
        return NULL;
    }
    
//create response output
    FREObject output;
    if(FRE_OK != FRENewObjectFromUTF8(error.localizedDescription.length, (const uint8_t*)[error.localizedDescription UTF8String], &output))
    {
        NSLog(@"FRENewObjectFromUTF8 error.localizedDescription Error");
        return NULL;
    }
    NSLog(@"Exiting StoreKitGetRequestError()");
    return output;
}


FREObject StoreKitAddPaymentToQueue(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitAddPaymentToQueue()");
    
//get argv[0]
    NSString* productIdentifier = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(productIdentifier == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
//get argv[1]
    uint32_t quantity = 0;
    if(FRE_OK != FREGetObjectAsUint32(argv[1], &quantity))
    {
        NSLog(@"GetFREObjectAsNSString argv[1] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
    SKProduct* product = [g_storeKitContext.productDictionary objectForKey:productIdentifier];
    if(product == nil)
    {
        NSLog([NSString stringWithFormat:@"productDictionary objectForKey %@ Error", productIdentifier], nil);
        return [UTILS_CLASSNAME FREFalse];
    }
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    NSLog(@"Exiting StoreKitAddPaymentToQueue()");
    
    return [UTILS_CLASSNAME FREFalse];
}

FREObject StoreKitGetUpdatedTransactions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitGetUpdatedTransactions()");
    
//create output array
    FREObject exception;
    FREObject output;
    
    if(FRE_OK != FRENewObject((const uint8_t*)"Array", 0, NULL, &output, &exception))
    {
        NSLog(@"FRENewObject Array output Error");
        return NULL;
    }
    
    NSArray* updatedTransactions = [NSArray arrayWithArray:g_storeKitContext.updatedTransactions];
    //NSArray* updatedTransactions = [[SKPaymentQueue defaultQueue] transactions];
    uint32_t updatedTransactionsCount = updatedTransactions.count;
    [g_storeKitContext.updatedTransactions removeAllObjects];
    
    if(FRE_OK != FRESetArrayLength(output, updatedTransactionsCount))
    {
        NSLog([NSString stringWithFormat:@"FRESetArrayLength output %d Error", output], nil);
        return NULL;
    }
    
//fill output array
    for(uint32_t i =0; i < updatedTransactionsCount; i++)
    {
        FREObject transaction;
        SKPaymentTransaction* skPaymentTransaction = [updatedTransactions objectAtIndex:i];

        if(FRE_OK != [UTILS_CLASSNAME FRENewObjectFromSKPaymentTransaction:skPaymentTransaction object:&transaction thrownException:&exception])
        {
            NSLog([NSString stringWithFormat: @"FRENewObjectFromSKPaymentTransaction g_storeKitContext.updatedTransactions[%d] Error", i], nil);
            return NULL;
        }
        if(FRE_OK != FRESetArrayElementAt(output, i, transaction))
        {
            NSLog([NSString stringWithFormat: @"FRESetArrayElementAt output[%d] Error", i], nil);
            return NULL;
        }
    }
    
    
    
    NSLog(@"Exiting StoreKitGetUpdatedTransactions()");
    
    return output;
}

FREObject StoreKitFinishTransaction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitFinishTransaction()");
    
    //get argv[0]
    NSString* transactionIdentifier = [UTILS_CLASSNAME FREGetObjectAsNSString:argv[0]];
    if(transactionIdentifier == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
    //NSArray* transactions = g_storeKitContext.updatedTransactions;
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    
    for(SKPaymentTransaction* t in transactions)
    {
        if([t.transactionIdentifier isEqualToString:transactionIdentifier])
        {
            [[SKPaymentQueue defaultQueue] finishTransaction:t];
            
            NSLog(@"Exiting StoreKitFinishTransaction()");
            return [UTILS_CLASSNAME FRETrue];
        }
    }
    
    NSLog(@"No matched transaction finded");
    NSLog(@"Exiting StoreKitFinishTransaction()");
    return [UTILS_CLASSNAME FREFalse];
}

FREObject StoreKitRestoreCompletedTransactions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering StoreKitRestoreCompletedTransactions()");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    NSLog(@"Exiting StoreKitRestoreCompletedTransactions()");
    return NULL;
}
