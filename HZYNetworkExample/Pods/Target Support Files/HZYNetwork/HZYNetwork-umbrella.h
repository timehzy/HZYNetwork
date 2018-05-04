#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HZYNetwork.h"
#import "HZYNetworkAgent.h"
#import "HZYNetworkBatchRequest.h"
#import "HZYNetworkDefine.h"
#import "HZYNetworkManager.h"
#import "HZYNetworkRequest.h"
#import "HZYNetworkRequestFileData.h"
#import "HZYNetworkResponse.h"
#import "HZYNetworkTask.h"
#import "HZYNetworkTaskOperationQueue.h"
#import "HZYNetworkTransformer.h"

FOUNDATION_EXPORT double HZYNetworkVersionNumber;
FOUNDATION_EXPORT const unsigned char HZYNetworkVersionString[];

