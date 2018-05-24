//
//  HZYNetworkDefine.h
//
//  Created by haozhenyi on 2018/4/27.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#ifndef HZYNetworkDefine_h
#define HZYNetworkDefine_h

FOUNDATION_EXPORT NSUInteger const HZYNetworkRequestInitErrorID;
FOUNDATION_EXPORT NSString * const HZYNetworkRequestErrorDomain;
FOUNDATION_EXPORT NSInteger const HZYNetworkRequestInvalidParameterErrorCode;
FOUNDATION_EXPORT NSInteger const HZYNetworkRequestInvalidResponseErrorCode;

FOUNDATION_EXPORT NSTimeInterval const HZYNetworkRequestDefaultTimeoutInterval;

/** 网络连接状态改变的通知 */
FOUNDATION_EXPORT NSNotificationName const HZYNetworkReachabilityDidChangedNotification;
/** HZYNetworkReachabilityDidChangedNotification通知的userInfo中该key存储对应HZYNetworkReachabilityStatus的值 */
FOUNDATION_EXPORT NSString * const HZYNetworkReachabilityNotificationStatusKey;

/**
 网络连接状态
 
 - HZYNetworkReachabilityStatusUnknown: 未知
 - HZYNetworkReachabilityStatusNotReachable: 无连接
 - HZYNetworkReachabilityStatusReachableViaWWAN: 通过蜂窝网络连接
 - HZYNetworkReachabilityStatusReachableViaWiFi: 通过Wi-Fi连接
 */
typedef NS_ENUM(NSInteger, HZYNetworkReachabilityStatus) {
    HZYNetworkReachabilityStatusUnknown          = -1,
    HZYNetworkReachabilityStatusNotReachable     = 0,
    HZYNetworkReachabilityStatusReachableViaWWAN = 1,
    HZYNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef void(^HZYNetworkRequestCompletionHandler)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error);
typedef void(^HZYNetworkProgressCallback)(NSProgress *progress);

#endif /* HZYNetworkDefine_h */
