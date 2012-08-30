/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "Utils+StoreKit.h"

@implementation UTILS_CLASSNAME (StoreKit)

+(FREResult)FRENewObjectFromSKProduct:(SKProduct*)value object:(FREObject*)output thrownException:(FREObject*)exception
{
    NSLog(@"Entering FRENewObjectFromSKProduct()");
    
    if(value == nil || output == NULL)
    {
        return FRE_INVALID_ARGUMENT;
    }
    
    FREResult result;
    
    //create productId
    FREObject productId;
    result = FRENewObjectFromUTF8(value.productIdentifier.length, (const uint8_t*)[value.productIdentifier UTF8String], &productId);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 productId Error");
        return result;
    }
    
    //create localizedTitle
    FREObject localizedTitle;
    result = FRENewObjectFromUTF8(value.localizedTitle.length, (const uint8_t*)[value.localizedTitle UTF8String], &localizedTitle);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 localizedTitle Error");
        return result;
    }
    
    //create localizedDescription
    FREObject localizedDescription;
    result = FRENewObjectFromUTF8(value.localizedDescription.length, (const uint8_t*)[value.localizedDescription UTF8String], &localizedDescription);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 localizedDescription Error");
        return result;
    }
    
    //create price
    FREObject price;
    result = FRENewObjectFromDouble([value.price doubleValue], &price);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromDouble price Error");
        return result;
    }
    
    //create output
    FREObject productArgv[4] = {productId, localizedTitle, localizedDescription, price};
    result = FRENewObject((const uint8_t*)"com.adobe.anesdk.components.storekit.core.SKProduct", 4, productArgv, output, exception);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObject output Error");
        return result;
    }
    
    NSLog(@"Exiting FRENewObjectFromSKProduct()");
    return FRE_OK;
}

+(FREResult)FRENewObjectFromSKPayment:(SKPayment*)value object:(FREObject*)output thrownException:(FREObject*)exception
{
    NSLog(@"Entering FRENewObjectFromSKPayment()");
    
    FREResult result;
    
    //create productId
    FREObject productId;
    result = FRENewObjectFromUTF8(value.productIdentifier.length, (const uint8_t*)[value.productIdentifier UTF8String], &productId);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 productId Error");
        return result;
    }
    
    //create quantity
    FREObject quantity;
    result = FRENewObjectFromInt32(value.quantity, &quantity);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromInt32 quantity Error");
        return result;
    }
    
    //create output
    FREObject paymentArgv[2] = {productId, quantity};
    result = FRENewObject((const uint8_t*)"com.adobe.anesdk.components.storekit.core.SKPayment", 2, paymentArgv, output, exception);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObject output Error");
        return result;
    }
    
    NSLog(@"Exiting FRENewObjectFromSKPayment()");
    return FRE_OK; 
}

+(FREResult)FRENewObjectFromSKPaymentTransaction:(SKPaymentTransaction*)value object:(FREObject*)output thrownException:(FREObject*)exception
{
    NSLog(@"Entering FRENewObjectFromSKPaymentTransaction()");
    
    if(value == nil || output == NULL)
    {
        return FRE_INVALID_ARGUMENT;
    }
    
    FREResult result;
    
    //create transactionId
    FREObject transactionId;
    NSString* transactionIdStr = value.transactionIdentifier != nil ? value.transactionIdentifier : @"";
    result = FRENewObjectFromUTF8(transactionIdStr.length, (const uint8_t*)[transactionIdStr UTF8String], &transactionId);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 transactionId Error");
        return result;
    }
    
    //create transactionState
    FREObject transactionState;
    
    result = FRENewObjectFromInt32(value.transactionState, &transactionState);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromInt32 quantity Error");
        return result;
    }
    
    //create transactionTime
    FREObject transactionTime;
    
    result = FRENewObjectFromDouble([value.transactionDate timeIntervalSince1970], &transactionTime);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromDouble transactionTime Error");
        return result;
    }
    
    //create transactionReceipt
    FREObject transactionReceipt;
    NSString* receiptStr = value.transactionState == SKPaymentTransactionStatePurchased ? 
    [[NSString alloc] initWithData:value.transactionReceipt encoding:NSASCIIStringEncoding] : @"";
    
    result = FRENewObjectFromUTF8(receiptStr.length, (const uint8_t*)[receiptStr UTF8String], &transactionReceipt);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 transactionReceipt Error");
        return result;
    }
    
    //create payment
    FREObject payment;
    result = [UTILS_CLASSNAME FRENewObjectFromSKPayment:value.payment object:&payment thrownException:exception];
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromSKPayment payment Error");
        return result;
    }
    
    //create originalTransaction
    FREObject originalTransaction;
    if(value.transactionState == SKPaymentTransactionStateRestored)
    {
        result = [UTILS_CLASSNAME FRENewObjectFromSKPaymentTransaction:value.originalTransaction object:&originalTransaction thrownException:exception];
        if(FRE_OK != result)
        {
            NSLog(@"FRENewObjectFromSKPaymentTransaction originalTransaction Error");
            return result;
        }
    }
    
    //create error
    FREObject error;
    NSString* errorStr = value.transactionState == SKPaymentTransactionStateFailed ? value.error.localizedDescription : @"";
    result = FRENewObjectFromUTF8(errorStr.length, (const uint8_t*)[errorStr UTF8String], &error);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromUTF8 error Error");
        return result;
    }
    
    //create output
    //FREObject transactionArgv[7] = {transactionId, transactionState, transactionTime, transactionReceipt, payment, originalTransaction, error};
    FREObject transactionArgv[5] = {transactionId, transactionState, transactionTime, transactionReceipt, payment};
    result = FRENewObject((const uint8_t*)"com.adobe.anesdk.components.storekit.core.SKPaymentTransaction", 5, transactionArgv, output, exception);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObject output Error");
        return result;
    }
    
    NSLog(@"Exiting FRENewObjectFromSKPaymentTransaction()");
    return FRE_OK;
}

@end
