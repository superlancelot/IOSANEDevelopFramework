/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "StoreKitDelegate.h"
#import "StoreKitContext.h"

extern StoreKitContext* g_storeKitContext;

@implementation StoreKitDelegate

////SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"Entering paymentQueue updatedTransactions");
    
    [g_storeKitContext.updatedTransactions addObjectsFromArray:transactions];
    
    if(FRE_OK != FREDispatchStatusEventAsync(g_storeKitContext.extensionContext, (const uint8_t*)"transactionsUpdated", (const uint8_t*)""))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting paymentQueue updatedTransactions");
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
   
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	
}

////SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Entering productsRequest didReceiveResponse");
    
    NSString* aneId = [[g_storeKitContext.requestDictionary allKeysForObject:request] lastObject];
    [g_storeKitContext.requestDictionary setObject:response forKey:aneId];
    
    for(SKProduct* p in response.products)
    {
        NSLog([NSString stringWithFormat:@"product: %@", p.productIdentifier], nil);
    }
    
    for(NSString* pid in response.invalidProductIdentifiers)
    {
        NSLog([NSString stringWithFormat:@"invalidProductIdentifiers: %@", pid], nil);
    }

    if(FRE_OK != FREDispatchStatusEventAsync(g_storeKitContext.extensionContext, (const uint8_t*)"requestDidReceiveResponse", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting productsRequest didReceiveResponse");
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Entering request didFailWithError");
    
    NSString* aneId = [[g_storeKitContext.requestDictionary allKeysForObject:request] lastObject];
    [g_storeKitContext.requestDictionary setObject:error forKey:aneId];
    if(FRE_OK != FREDispatchStatusEventAsync(g_storeKitContext.extensionContext, (const uint8_t*)"requestDidFailWithError", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting request didFailWithError");
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"Entering requestDidFinish");
    
    NSString* aneId = [[g_storeKitContext.requestDictionary allKeysForObject:request] lastObject];
    if(FRE_OK != FREDispatchStatusEventAsync(g_storeKitContext.extensionContext, (const uint8_t*)"requestDidFinish", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
        return;
    }
    
    SKProductsRequest* productRequest = [g_storeKitContext.requestDictionary objectForKey:aneId];
    productRequest.delegate = nil;
    [g_storeKitContext.requestDictionary removeObjectForKey:aneId];
    
    NSLog(@"Exiting requestDidFinish");
}

@end
