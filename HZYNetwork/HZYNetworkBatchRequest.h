//
//  HZYNetworkBatchRequest.h
//  AFNetworking
//
//  Created by haozhenyi on 2018/4/28.
//

#import <Foundation/Foundation.h>
#import "HZYNetworkRequest.h"

@class HZYNetworkBatchRequest;
typedef void(^HZYNetworkRequestsSuccessBlock)(NSArray<HZYNetworkRequest *> *responses, HZYNetworkBatchRequest *batchRequest);
typedef void(^HZYNetworkRequestsFailurBlock)(NSArray<HZYNetworkRequest *> *successes, NSArray<HZYNetworkRequest *> *failures, HZYNetworkBatchRequest *batchRequest);

@interface HZYNetworkBatchRequest : NSObject

/**
 批量发出请求，统一回调。

 @param requests 要发送的请求
 @param success 成功的回调，只有每个请求都成功才会执行这个回调
 @param fail 只要有一个以上的请求失败，就会走这个回调
 */
+ (void)sendReqeusts:(NSArray<HZYNetworkRequest *> *)requests
             success:(HZYNetworkRequestsSuccessBlock)success
             failure:(HZYNetworkRequestsFailurBlock)fail;

@end
