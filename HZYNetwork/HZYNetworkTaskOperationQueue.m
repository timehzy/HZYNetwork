//
//  HZYNetworkTaskQueue.m
//  Pods
//
//  Created by haozhenyi on 2018/4/27.
//

#import "HZYNetworkTaskOperationQueue.h"
#import "HZYNetworkAgent.h"
#import "HZYNetworkTask.h"

@interface HZYNetworkTaskOperation ()

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation HZYNetworkTaskOperation

- (instancetype)initWithTask:(HZYNetworkTask *)task {
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(0);
        _task = [[HZYNetworkAgent sharedAgent] beginRequest:task.request
                                                  complete:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                      dispatch_semaphore_signal(self.semaphore);
                                                      if (task.completeBlock) {
                                                          task.completeBlock (response,responseObject,error);
                                                      }
                                                  }
                                            uploadProgress:task.uploadProgressBlock
                                          downloadProgress:task.downloadBlock];
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        [_task resume];
        dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, self.task.originalRequest.timeoutInterval));
    }
}

- (void)cancel {
    if (self.isCancelled || self.isFinished) {
        return;
    }
    [self.task cancel];
    [super cancel];
}

@end

@interface HZYNetworkTaskOperationQueue ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMapTable<NSNumber *, HZYNetworkTaskOperation *> *operationPool;

@end

@implementation HZYNetworkTaskOperationQueue

+ (HZYNetworkTaskOperationQueue *)defaultQueue {
    static HZYNetworkTaskOperationQueue *_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [self new];
    });
    return _queue;
}

- (void)addTaskOperation:(HZYNetworkTaskOperation *)taskOp {
    [self.queue addOperation:taskOp];
    [self.operationPool setObject:taskOp forKey:@(taskOp.task.taskIdentifier)];
}

- (void)cancelOperationWithRequestId:(NSNumber *)requestId {
    if ([self.operationPool objectForKey:requestId]) {
        HZYNetworkTaskOperation *op = [self.operationPool objectForKey:requestId];
        [op cancel];
        [self.operationPool removeObjectForKey:requestId];
    }
}

- (void)cancelOperationsWithRequestIds:(NSArray<NSNumber *> *)requstIds {
    if (requstIds.count) {
        [requstIds enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self cancelOperationWithRequestId:obj];
        }];
    }
}

- (void)cancelAll {
    [self.queue cancelAllOperations];
    [self.operationPool removeAllObjects];
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.qualityOfService = NSQualityOfServiceUserInitiated;
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSMapTable<NSNumber *,HZYNetworkTaskOperation *> *)operationPool {
    if (!_operationPool) {
        _operationPool = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:5];
    }
    return _operationPool;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount {
    _queue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

- (NSInteger)maxConcurrentOperationCount {
    return _queue.maxConcurrentOperationCount;
}
@end
