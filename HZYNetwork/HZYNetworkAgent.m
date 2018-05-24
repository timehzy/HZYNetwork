//
//  HZYNetworkAgent.m
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import "HZYNetworkAgent.h"
#import "AFNetworking.h"

NSNotificationName const HZYNetworkReachabilityDidChangedNotification = @"HZYNetworkReachabilityDidChangedNotification";
NSString * const HZYNetworkReachabilityNotificationStatusKey = @"HZYNetworkReachabilityNotificationStatusKey";

@interface HZYNetworkAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HZYNetworkAgent

+ (instancetype)sharedAgent {
    static HZYNetworkAgent *sharedAgent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgent = [[self alloc] init];
    });
    return sharedAgent;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public method
- (NSURLSessionTask *)beginRequest:(NSURLRequest *)requst complete:(HZYNetworkRequestCompletionHandler)completeBlock uploadProgress:(HZYNetworkProgressCallback)uploadProgressBlock downloadProgress:(HZYNetworkProgressCallback)downloadProgressBlock {
    return [self.manager dataTaskWithRequest:requst uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completeBlock];
}

- (void)reachabilityStatusChanged:(NSNotification *)note {
    AFNetworkReachabilityStatus status = [note.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:HZYNetworkReachabilityDidChangedNotification object:nil userInfo:@{HZYNetworkReachabilityNotificationStatusKey : @(status)}];
}

- (void)startMonitoringConnectivity {
    [_manager.reachabilityManager startMonitoring];
}

- (void)stopMonitoringConnectivity {
    [_manager.reachabilityManager stopMonitoring];
}

- (void)setWaitsForConnectivity:(BOOL)waitsForConnectivity {
    _waitsForConnectivity = waitsForConnectivity;
    if (@available(iOS 11.0, *)) {
        _manager.session.configuration.waitsForConnectivity = _waitsForConnectivity;
    } else {
        if (_waitsForConnectivity) {
            [_manager.reachabilityManager startMonitoring];
        } else {
            [_manager.reachabilityManager stopMonitoring];
        }
    }
}

- (BOOL)isIsReachable {
    return self.manager.reachabilityManager.isReachable;
}
@end
