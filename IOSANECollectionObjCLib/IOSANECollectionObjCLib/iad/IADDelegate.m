/*
 
 Copyright (C) 2012 CHENGUANG LIU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "IADDelegate.h"
#import "IADContext.h"

extern IADContext* g_iADContext;

@implementation IADDelegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"Entering bannerViewWillLoadAd");
    
    NSString* aneId = [[g_iADContext.bannerViewDictionary allKeysForObject:banner] lastObject];
    if(FRE_OK != FREDispatchStatusEventAsync(g_iADContext.extensionContext, (const uint8_t*)"bannerViewWillLoadAd", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    NSLog(@"Exiting bannerViewWillLoadAd");
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Entering bannerViewDidLoadAd");
    
    NSString* aneId = [[g_iADContext.bannerViewDictionary allKeysForObject:banner] lastObject];
    if(FRE_OK != FREDispatchStatusEventAsync(g_iADContext.extensionContext, (const uint8_t*)"bannerViewDidLoadAd", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    NSLog(@"Exiting bannerViewDidLoadAd");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Entering bannerViewDidFailToReceiveAdWithError");
    
    NSString* aneId = [[g_iADContext.bannerViewDictionary allKeysForObject:banner] lastObject];
    if(FRE_OK != FREDispatchStatusEventAsync(g_iADContext.extensionContext, (const uint8_t*)"bannerViewDidFailToReceiveAdWithError", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting bannerViewDidFailToReceiveAdWithError");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Entering bannerViewActionShouldBegin");
    
    NSString* aneId = [[g_iADContext.bannerViewDictionary allKeysForObject:banner] lastObject];
    NSString* eventCode = willLeave ? @"bannerViewActionShouldBeginWillLeaveApplication" : @"bannerViewActionShouldBegin";
    
    if(FRE_OK != FREDispatchStatusEventAsync(g_iADContext.extensionContext, (const uint8_t*)eventCode.UTF8String, (const uint8_t*)aneId.UTF8String))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting bannerViewActionShouldBegin");
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"Entering bannerViewActionDidFinish");
    
    NSString* aneId = [[g_iADContext.bannerViewDictionary allKeysForObject:banner] lastObject];
    if(FRE_OK != FREDispatchStatusEventAsync(g_iADContext.extensionContext, (const uint8_t*)"bannerViewActionDidFinish", (const uint8_t*)[aneId UTF8String]))
    {
        NSLog(@"FREDispatchStatusEventAsync Error");
    }
    
    NSLog(@"Exiting bannerViewActionDidFinish");
}

@end
