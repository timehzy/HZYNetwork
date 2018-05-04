//
//  HZYRequest.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYNetworkRequest.h"
#import "HZYNetworkAgent.h"
#import "HZYNetworkTransformer.h"
#import "HZYNetworkResponse.h"
#import "HZYNetworkManager.h"
#import "HZYNetworkDefine.h"
#import "HZYNetworkTask.h"

typedef struct _DelegateFlags{
    unsigned int requestDidSuccess : 1;
    unsigned int requestDidFailed : 1;
    unsigned int uploadProgress : 1;
    unsigned int downloadProgress : 1;
} DelegateFlags;

@interface HZYNetworkRequest()

@property (nonatomic, copy) HZYNetworkRequestMethod method;
@property (nonatomic, assign) DelegateFlags delegateFlag;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *requestIds;
@property (nonatomic, strong) HZYNetworkResponse *response;
@property (nonatomic, strong) HZYNetworkTransformer *transformer;
@property (nonatomic, copy) HZYNetworkRequestCallback successBlock;
@property (nonatomic, copy) HZYNetworkRequestCallback failureBlock;

@end

@implementation HZYNetworkRequest

#pragma mark - Init method

- (instancetype)initWithMethod:(HZYNetworkRequestMethod)method {
    if (self = [super init]) {
        _method = method;
    }
    return self;
}

- (instancetype)init {
    return [self initWithMethod:GET];
}

+ (instancetype)requstUsingGETMethod {
    return [[self alloc] initWithMethod:GET];
}

+ (instancetype)requstUsingPOSTMethod {
    return [[self alloc] initWithMethod:POST];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] : {\nmethod:%@,\nURL:%@,\nparameter:%@\n}", NSStringFromClass(self.class), self.method, self.url, [self.parameterSource parameterForRequest:self]];
}

#pragma mark - Public method

- (NSUInteger)startWithDelegate:(id<HZYNetworkRequestDelegate>)delegate {
    self.delegate = delegate;
    return [self startRequest];
}

- (NSUInteger)startWithSuccess:(HZYNetworkRequestCallback)successCallback failure:(HZYNetworkRequestCallback)failureCallback {
    self.successBlock = successCallback;
    self.failureBlock = failureCallback;
    return [self startRequest];
}

- (NSUInteger)startRequest {
    __block NSUInteger identifier = HZYNetworkRequestInitErrorID;
    id param = nil;
    if ([self.parameterSource respondsToSelector:@selector(parameterForRequest:)]) {
        param = [self.parameterSource parameterForRequest:self];
    }
    if (![self shouldStartWithParaHZY:param]) {return identifier;}
    // 执行多请求策略
    if ([self perforHZYtrategy]) {return self.requestIds.firstObject.unsignedIntegerValue;}
    // 创建NSURLRequest对象
    NSURLRequest *request = [self createRequest];
    if (!request) {return identifier;}
    
    // 执行请求
    HZYNetworkTask *task = [HZYNetworkTask taskWithRequest:request complete:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        self.response = [self.transformer constructResponse:response responseObject:responseObject error:&error requestId:identifier];
        if (error) {
            if ([self beforePerformFailure]) {
                [self failedResponse];
                [self afterPerformFailure];
            }
        } else {
            if ([self beforePerforHZYuccess]) {
                [self successResponse];
                [self afterPerforHZYuccess];
            }
        }
        @synchronized(self.requestIds) {[self.requestIds removeObject:@(identifier)];}
    } uploadProgress:^(NSProgress *progress) {
        if (self.delegateFlag.uploadProgress) {[self.delegate request:self uploadProgress:progress];}
    } download:^(NSProgress *progress) {
        if (self.delegateFlag.downloadProgress) {[self.delegate request:self downloadProgress:progress];}
    }];
    [self afterStartWithParaHZY:param];
    identifier = [[HZYNetworkManager sharedManager] addTask:task];
    @synchronized(self.requestIds) {[self.requestIds addObject:@(identifier)];}
    return identifier;
}

- (void)cancelWithId:(NSUInteger)requestId {
    if ([self.requestIds containsObject:@(requestId)]) {
        @synchronized(self) {
            [[HZYNetworkManager sharedManager] cancelRequestsWithRequestIds:@[@(requestId)]];
            [self.requestIds removeObject:@(requestId)];
        }
    }
}

- (void)cancelAll {
    @synchronized(self) {
        [[HZYNetworkManager sharedManager] cancelRequestsWithRequestIds:self.requestIds];
        [self.requestIds removeAllObjects];
    }
}

- (void)accessoriesPerforHZYelector:(SEL)selector {
    if (self.accessories.count) {
        [self.accessories enumerateObjectsUsingBlock:^(id<HZYNetworkRequestAccessory>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:selector]) {
                NSInvocation *invo = [NSInvocation invocationWithMethodSignature:[obj.class instanceMethodSignatureForSelector:selector]];
                invo.selector = selector;
                [invo setArgument:(void*)&self atIndex:2];
                [invo invokeWithTarget:obj];
            }
        }];
    }
}

- (BOOL)beforePerforHZYuccess {
    return YES;
}

- (void)afterPerforHZYuccess {
    [self accessoriesPerforHZYelector:@selector(requestDidFinished:)];
}

- (BOOL)beforePerformFailure {
    return YES;
}

- (void)afterPerformFailure {
    [self accessoriesPerforHZYelector:@selector(requestDidFinished:)];
}

- (BOOL)shouldStartWithParaHZY:(NSDictionary *)paraHZY {
    [self accessoriesPerforHZYelector:@selector(requestWillStart:)];
    return YES;
}

- (void)afterStartWithParaHZY:(NSDictionary *)paraHZY {}

#pragma mark - Private method

- (void)failedResponse {
    if (self.delegateFlag.requestDidFailed) {[self.delegate requestDidFailed:self];}
    if (self.failureBlock) {self.failureBlock(self);}
}

- (void)successResponse {
    if (self.delegateFlag.requestDidSuccess) {[self.delegate requestDidSuccess:self];}
    if (self.successBlock) {self.successBlock(self);}
}

/**
 执行请求策略
 
 @return 是否终止当前请求，YES终止，NO执行
 */
- (BOOL)perforHZYtrategy {
    switch (self.strategy) {
        case HZYNetworkRequestStrategyDiscardIfPreviousOnLoading:
            if (self.isLoading) {return YES;}
            break;
            
        case HZYNetworkRequestStrategyCancelPreviousWhenStart:
            [self cancelAll];
            break;
            
        case HZYNetworkRequestStrategyAllowMultiple:
            break;
    }
    return NO;
}

- (NSURLRequest *)createRequest {
    NSError *error;
    NSURLRequest *request;
    request = [self.transformer constructRequstWithError:&error];
    if (error) {
        self.response = [[HZYNetworkResponse alloc] initWithRequestId:HZYNetworkRequestInitErrorID response:nil responseObject:nil error:error];
        [self failedResponse];
        return nil;
    }
    return request;
}

#pragma mark - Getter & Setter

- (void)setDelegate:(id<HZYNetworkRequestDelegate>)delegate {
    _delegate = delegate;
    if (_delegate) {
        _delegateFlag.requestDidSuccess = [_delegate respondsToSelector:@selector(requestDidSuccess:)];
        _delegateFlag.requestDidFailed = [_delegate respondsToSelector:@selector(requestDidFailed:)];
        _delegateFlag.uploadProgress = [_delegate respondsToSelector:@selector(request:uploadProgress:)];
        _delegateFlag.downloadProgress = [_delegate respondsToSelector:@selector(request:downloadProgress:)];        
    }
}

- (NSMutableArray *)requestIds {
    if (!_requestIds) {
        _requestIds = [NSMutableArray array];
    }
    return _requestIds;
}

- (BOOL)isLoading {
    @synchronized(self.requestIds) {
        return !self.requestIds.count;
    }
}

- (HZYNetworkTransformer *)transformer {
    if (!_transformer) {
        _transformer = [[HZYNetworkTransformer alloc] initWithRequest:self];
    }
    return _transformer;
}

- (NSString *)url {
    NSAssert(0, @"子类必须实现此方法，并且在此方法中不要super调用");
    return nil;
}

- (NSMutableArray<id<HZYNetworkRequestAccessory>> *)accessories {
    if (!_accessories) {
        _accessories = [NSMutableArray array];
    }
    return _accessories;
}

@end

HZYNetworkRequestMethod const GET = @"GET";
HZYNetworkRequestMethod const POST = @"POST";
HZYNetworkRequestMethod const HEAD = @"HEAD";
HZYNetworkRequestMethod const PUT = @"PUT";
HZYNetworkRequestMethod const DELETE = @"DELETE";
