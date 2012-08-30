
#ifndef ANESDKObjCLib_XXXController_h
#define ANESDKObjCLib_XXXController_h

#import "FlashRuntimeExtensions.h"


const char* g_xxxContextType = "XXX";

void IOSANECollectionXXXExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void IOSANECollectionXXXExtFinalizer(void* extData);

void IOSANECollectionXXXContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void IOSANECollectionXXXContextFinalizer(void* extData);


#endif
