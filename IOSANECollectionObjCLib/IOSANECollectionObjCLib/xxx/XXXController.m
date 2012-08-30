//
//  StoreKitContext.m
//  ANESDKObjCLib
//
//  Created by labuser on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XXXController.h"

void IOSANECollectionXXXExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering IOSANECollectionXXXExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOSANECollectionXXXContextInitializer;
    *ctxFinalizerToSet = &IOSANECollectionXXXContextFinalizer;
    
    NSLog(@"Exiting IOSANECollectionXXXExtInitializer()");
}

void IOSANECollectionXXXExtFinalizer(void* extData) 
{
    NSLog(@"Entering IOSANECollectionXXXExtFinalizer()");
    
    // Nothing to clean up.
    NSLog(@"Exiting IOSANECollectionXXXExtFinalizer()");
    return;
}

void IOSANECollectionXXXContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering IOSANECollectionXXXContextInitializer()");
    NSLog(@"Exiting IOSANECollectionXXXInitializer()");
}

void IOSANECollectionXXXContextFinalizer(void* extData)
{
    NSLog(@"Entering IOSANECollectionXXXContextFinalizer()");
    
    //TODO: clear g_skContext
   
    NSLog(@"Exiting IOSANECollectionXXXContextFinalizer()");
}
