//
//  HZYNetworkAgent.h
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZYNetworkDefine.h"

@class HZYNetworkAgent;

/**
 @brief HZYNetworkAgent 用于隔离三方库与HZYNetwork，所有HZYNetwork的请求都会从该类递交给三方库
 @discussion HZYNetworkAgent 会用递交给它的 NSURLRequest 通过 AFHTTPSessionManager 创建 NSURLSessionDataTask，并全部存入缓存池，直到请求响应完成或被取消才将其从池中删除，从而提供了取消请求的功能。
 */
@interface HZYNetworkAgent : NSObject

/**
 单例方法

 @return 单例对象
 */
+ (instancetype)sharedAgent;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** 当网络连接不可用时，是否等待网络恢复连接后再发送请求。如果设置为YES，则等待网络恢复连接后发送，如果为NO，则会立即发送并执行失败回调。默认NO */
@property (nonatomic, assign) BOOL waitsForConnectivity;
@property (nonatomic, assign, readonly) BOOL isReachable;

- (NSURLSessionTask *)beginRequest:(NSURLRequest *)requst
                          complete:(HZYNetworkRequestCompletionHandler)completeBlock
                    uploadProgress:(HZYNetworkProgressCallback)uploadProgressBlock
                  downloadProgress:(HZYNetworkProgressCallback)downloadProgressBlock;

- (void)startMonitoringConnectivity;
- (void)stopMonitoringConnectivity;
@end
