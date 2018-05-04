//
//  HZYNetworkManager.m
//  AFNetworking
//
//  Created by haozhenyi on 2018/4/26.
//

#import "HZYNetworkManager.h"
#import "HZYNetworkAgent.h"
#import "HZYNetworkDefine.h"
#import "HZYNetworkTaskOperationQueue.h"

@interface HZYNetworkManager ()

@property (nonatomic, strong) HZYNetworkTaskOperationQueue *taskQueue;

@end

@implementation HZYNetworkManager

+ (instancetype)sharedManager {
    static HZYNetworkManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _taskQueue = [HZYNetworkTaskOperationQueue defaultQueue];
    }
    return self;
}

- (NSUInteger)addTask:(HZYNetworkTask *)task {
    HZYNetworkTaskOperation *op = [[HZYNetworkTaskOperation alloc] initWithTask:task];
    [self.taskQueue addTaskOperation:op];
    return op.task.taskIdentifier;
}

- (void)cancelRequestsWithRequestIds:(NSArray<NSNumber *> *)requstIds {
    [self.taskQueue cancelOperationsWithRequestIds:requstIds];
}

- (void)cancelAll {
    [self.taskQueue cancelAll];
}

- (void)startMonitoringConnectivity {
    [self.agent startMonitoringConnectivity];
}

- (void)stopMonitoringConnectivity {
    [self.agent stopMonitoringConnectivity];
}

#pragma mark - Getter & Setter

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount {
    self.taskQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

- (void)setWaitsForConnectivity:(BOOL)waitsForConnectivity {
    self.agent.waitsForConnectivity = waitsForConnectivity;
}

- (BOOL)waitsForConnectivity {
    return self.agent.waitsForConnectivity;
}

- (HZYNetworkAgent *)agent {
    return [HZYNetworkAgent sharedAgent];
}
@end
