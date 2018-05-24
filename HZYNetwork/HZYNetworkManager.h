//
//  HZYNetworkManager.h
//
//  Created by haozhenyi on 2018/4/26.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZYNetworkTask;

@interface HZYNetworkManager : NSObject
/** 设置请求的最大并发数，默认5 */
@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;
/** 当网络连接不可用时，是否等待网络恢复连接后再发送请求。如果设置为YES，则等待网络恢复连接后发送，如果为NO，则会立即发送并执行失败回调。默认NO */
@property (nonatomic, assign) BOOL waitsForConnectivity API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));

+ (instancetype)sharedManager;

/**
 添加一个HZYNetworkTask，被添加的task会立即加入请求队列，如果队列中的task数量小于最大并发数，则会立即发起请求，否则会等到队列中的任务少于最大并发数再发起请求。

 @param task 请求任务
 @return 请求的identifier
 */
- (NSUInteger)addTask:(HZYNetworkTask *)task;

/**
 批量取消指定Id的请求

 @param requstIds 要取消请求的id数组
 */
- (void)cancelRequestsWithRequestIds:(NSArray<NSNumber *> *)requstIds;

/**
 取消全部尚未结束的请求
 */
- (void)cancelAll;

/**
 开始监听网络状态
 */
- (void)startMonitoringConnectivity;

/**
 结束监听网络状态
 */
- (void)stopMonitoringConnectivity;
@end
