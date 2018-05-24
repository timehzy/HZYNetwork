//
//  HZYNetworkTaskOperationQueue.h
//
//  Created by haozhenyi on 2018/4/27.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZYNetworkTask;

@interface HZYNetworkTaskOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLSessionTask *task;

- (instancetype)initWithTask:(HZYNetworkTask *)task NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface HZYNetworkTaskOperationQueue : NSObject

@property (nonatomic, strong, readonly, class) HZYNetworkTaskOperationQueue *defaultQueue;
@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;

- (void)addTaskOperation:(HZYNetworkTaskOperation *)taskOp;
- (void)cancelOperationsWithRequestIds:(NSArray<NSNumber *> *)requstIds;
- (void)cancelAll;

@end
