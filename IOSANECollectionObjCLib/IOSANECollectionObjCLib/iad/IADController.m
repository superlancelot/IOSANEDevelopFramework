/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Utils.h"
#import "IADController.h"
#import "IADDelegate.h"

void IOSANECollectionIADExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering IOSANECollectionIADExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &IOSANECollectionIADContextInitializer;
    *ctxFinalizerToSet = &IOSANECollectionIADContextFinalizer;
    
    NSLog(@"Exiting IOSANECollectionIADExtInitializer()");
}

void IOSANECollectionIADExtFinalizer(void* extData) 
{
    NSLog(@"Entering IOSANECollectionIADExtFinalizer()");
    
    // Nothing to clean up.
    NSLog(@"Exiting IOSANECollectionIADExtFinalizer()");
    return;
}

void IOSANECollectionIADContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                           uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering IOSANECollectionIADContextInitializer()");
    
    g_iADContext = [[IADContext alloc] initWithExtensionContext: ctx];
    
    
    [UTILS_CLASSNAME registerContextFunction:numFunctionsToTest functionsToSet:functionsToSet, 
                                    "IADGetSizeByAdBannerContentSizeIdentifier",
                                    &IADGetSizeByAdBannerContentSizeIdentifier, NULL,
                                    "IADCreateAdBannerView",
                                    &IADCreateAdBannerView, NULL,
                                    "IADDestoryAdBannerView",
                                    &IADDestoryAdBannerView, NULL,
                                    "IADAddAdBannerViewToMainWindow",
                                    &IADAddAdBannerViewToMainWindow, NULL,
                                    "IADRemoveAdBannerViewFromMainWindow",
                                    &IADRemoveAdBannerViewFromMainWindow, NULL,
                                    "IADSetAdBannerViewProperty",
                                    &IADSetAdBannerViewProperty, NULL,
                                    "IADCancelBannerViewAction",
                                    &IADCancelBannerViewAction, NULL,
                                    nil];
    
    //g_storeKitDelegate = [[StoreKitDelegate alloc] init];
    
    NSLog(@"Exiting IOSANECollectionIADContextInitializer()");
}

void IOSANECollectionIADContextFinalizer(void* extData)
{
    NSLog(@"Entering IOSANECollectionIADContextFinalizer()");
    
    //TODO: clear g_skContext
   
    NSLog(@"Exiting IOSANECollectionIADContextFinalizer()");
}

FREObject IADGetSizeByAdBannerContentSizeIdentifier(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADGetSizeByAdBannerContentSizeIdentifier()");
    
//get argv[0]
    NSString* contentSizeId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(contentSizeId == nil)
    {
        NSLog(@"IADGetSizeByAdBannerContentSizeIdentifier argv[0] Error");
        return NULL;
    }
    
    CGSize size;
    if([contentSizeId isEqualToString:@"protrait"])
    {
        contentSizeId = ADBannerContentSizeIdentifierPortrait;
        size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSizeId];
    }
    else if([contentSizeId isEqualToString: @"landscape"])
    {
        contentSizeId = ADBannerContentSizeIdentifierLandscape;
        size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSizeId];
    }
    else
    {
        size.width = 0;
        size.height = 0;;
    }
    
    FREResult result;
    FREObject exception;
    
//create width and height
    FREObject width;
    FREObject height;
    result =  FRENewObjectFromDouble(size.width, &width);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromDouble size.width Error");
        return NULL;
    }
    
    result =  FRENewObjectFromDouble(size.height, &height);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObjectFromDouble size.height Error");
        return NULL;
    }
    
//create size output
    FREObject output;
    FREObject pointArgv[2] = {width, height};
    result = FRENewObject((const uint8_t*)"flash.geom.Point", 2, pointArgv, &output, &exception);
    if(FRE_OK != result)
    {
        NSLog(@"FRENewObject output Error");
        return NULL;
    }
    
    NSLog(@"Exiting IADGetSizeByAdBannerContentSizeIdentifier()");
    return output;
}

FREObject IADCreateAdBannerView(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADCreateAdBannerView()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return [UTILS_CLASSNAME FREFalse];
    }
    
//create AdBannerView
    ADBannerView* bannerView  = [[ADBannerView alloc] init];
    bannerView.delegate = [[IADDelegate alloc] init];
    [g_iADContext.bannerViewDictionary setObject:bannerView forKey:aneId];
    
    NSLog(@"Exiting IADCreateAdBannerView()");
    return [UTILS_CLASSNAME FRETrue];
}

FREObject IADDestoryAdBannerView(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADDestoryAdBannerView()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//destory AdBannerView
    ADBannerView* banner = (ADBannerView*)[g_iADContext.bannerViewDictionary objectForKey:aneId];
    [banner removeFromSuperview];
    banner.delegate = nil;
    [g_iADContext.bannerViewDictionary removeObjectForKey:aneId];
    
    NSLog(@"Exiting IADDestoryAdBannerView()");
    return NULL;
}

FREObject IADAddAdBannerViewToMainWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADAddAdBannerViewToMainWindow()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//add AdBannerView as subview of appView
    [[UTILS_CLASSNAME applicationView] addSubview:(ADBannerView*)[g_iADContext.bannerViewDictionary objectForKey:aneId]];
    
    NSLog(@"Exiting IADAddAdBannerViewToMainWindow()");
    return NULL;
}

FREObject IADRemoveAdBannerViewFromMainWindow(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADRemoveAdBannerViewFromMainWindow()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }

//remove AdBannerView from superview    
    [(ADBannerView*)[g_iADContext.bannerViewDictionary objectForKey:aneId] removeFromSuperview];
    
    NSLog(@"Exiting IADRemoveAdBannerViewFromMainWindow()");
    return NULL;
}

FREObject IADSetAdBannerViewProperty(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADSetAdBannerViewProperty()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//get argv[1]
    NSString* property = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[1]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[1] Error");
        return NULL;
    }
    
//set property value
    ADBannerView* bannerView = [g_iADContext.bannerViewDictionary objectForKey:aneId];
    if([property isEqualToString:@"y"])
    {
        double value = 0;
        if(FRE_OK != FREGetObjectAsDouble(argv[2], &value))
        {
            NSLog(@"FREGetObjectAsDouble argv[2] Error");
            return [UTILS_CLASSNAME FREFalse];
        }
        
        CGRect newFrame = CGRectMake(bannerView.frame.origin.x, value, bannerView.frame.size.width, bannerView.frame.size.height);
        bannerView.frame = newFrame;
    }
    else if([property isEqualToString:@"alpha"])
    {
        
    }
    else if([property isEqualToString:@"requiredContentSizeIdentifiers"])
    {
        
    }
    else if([property isEqualToString:@"currentContentSizeIdentifier"])
    {
        NSString* value = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[2]];
        if(value == nil)
        {
            NSLog(@"GetFREObjectAsNSString argv[2] Error");
            return NULL;
        }
        if([value isEqualToString:@"protrait"])
        {
            value = ADBannerContentSizeIdentifierPortrait;
        }
        else if([value isEqualToString:@"landscape"])
        {
            value = ADBannerContentSizeIdentifierLandscape;
        }
        else 
        {
            value = @"";
        }
        bannerView.currentContentSizeIdentifier = value;
    }
    
    NSLog(@"Exiting IADSetAdBannerViewProperty()");
    return NULL;
}

FREObject IADCancelBannerViewAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering IADCancelBannerViewAction()");
    
//get argv[0]
    NSString* aneId = [UTILS_CLASSNAME FREGetObjectAsNSString: argv[0]];
    if(aneId == nil)
    {
        NSLog(@"GetFREObjectAsNSString argv[0] Error");
        return NULL;
    }
    
//cancel AdBannerView action
    [(ADBannerView*)[g_iADContext.bannerViewDictionary objectForKey:aneId] cancelBannerViewAction];
    
    NSLog(@"Exiting IADCancelBannerViewAction()");
    return NULL;
}