//
//  HZYNetworkResponse.h
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZYNetworkResponse : NSObject

/** HTTP级别以下的错误 */
@property (nonatomic, readonly) NSError *error;
/** 对应请求的Id */
@property (nonatomic, readonly) NSUInteger requestId;
/** 由NSURLSessionDataTask返回的response */
@property (nonatomic, readonly) NSURLResponse *originResponse;
/** 响应内容 */
@property (nonatomic, readonly) id responseObject;

/**
 指定初始化方法

 @param requestId 请求id
 @param response 相应对象
 @param responseObject 相应内容
 @param error 错误
 @return 初始化对象
 */
- (instancetype)initWithRequestId:(NSUInteger)requestId
                         response:(NSURLResponse *)response
                   responseObject:(id)responseObject
                            error:(NSError *)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
