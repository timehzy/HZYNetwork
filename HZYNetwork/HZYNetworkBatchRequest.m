//
//  HZYNetworkBatchRequest.m
//
//  Created by haozhenyi on 2018/4/28.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import "HZYNetworkBatchRequest.h"
#import "HZYNetworkDefine.h"

@interface HZYNetworkBatchRequest ()<HZYNetworkRequestDelegate>

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, copy) HZYNetworkRequestsSuccessBlock successCallback;
@property (nonatomic, copy) HZYNetworkRequestsSuccessBlock failureCallback;
@property (nonatomic, strong) NSMutableArray *successRequests;
@property (nonatomic, strong) NSMutableArray *failedRequests;

@end

@implementation HZYNetworkBatchRequest

- (instancetype)init {
    if (self = [super init]) {
        _successRequests = [NSMutableArray array];
        _failedRequests = [NSMutableArray array];
    }
    return self;
}

+ (void)sendReqeusts:(NSArray<HZYNetworkRequest *> *)requests success:(HZYNetworkRequestsSuccessBlock)success failure:(HZYNetworkRequestsFailurBlock)fail {
    [[self new] sendRequests:requests success:success failure:fail];
}

- (void)sendRequests:(NSArray<HZYNetworkRequest *> *)requests success:(HZYNetworkRequestsSuccessBlock)success failure:(HZYNetworkRequestsFailurBlock)failure {
    NSParameterAssert(requests);
    self.group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [requests enumerateObjectsUsingBlock:^(HZYNetworkRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(weakSelf.group);
        [obj startWithSuccess:^(HZYNetworkResponse * _Nonnull response) {
            dispatch_group_leave(weakSelf.group);
            [weakSelf.successRequests addObject:obj];
        } failure:^(HZYNetworkResponse * _Nonnull response) {
            dispatch_group_leave(weakSelf.group);
            [weakSelf.failedRequests addObject:obj];            
        }];
    }];

    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [self sortResultRequestsUsingReqeusts:requests];
        if (self.successRequests.count == requests.count) {
            success(self.successRequests.copy, self);
        } else {
            failure(self.successRequests.copy, self.failedRequests.copy, self);
        }
    });
}

- (void)sortResultRequestsUsingReqeusts:(NSArray *)requests {
    NSMutableArray *reqs = [requests mutableCopy];
    NSMutableArray *sucReqs = [NSMutableArray array];
    NSMutableArray *failReqs = [NSMutableArray array];
    [reqs enumerateObjectsUsingBlock:^(id  _Nonnull req, NSUInteger reqIdx, BOOL * _Nonnull stop) {
        [self.successRequests enumerateObjectsUsingBlock:^(id  _Nonnull suc, NSUInteger sucIdx, BOOL * _Nonnull stop) {
            if ([suc isEqual:req]) {
                [sucReqs addObject:req];
            } else {
                [failReqs addObject:req];
            }
        }];
    }];
    self.successRequests = sucReqs;
    self.failedRequests = failReqs;
}

@end
