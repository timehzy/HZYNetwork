//
//  HZYNetworkTransformer.h
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZYNetworkRequest;
@class HZYNetworkResponse;
@protocol HZYNetworkRequestFileDataProtocol;

@interface HZYNetworkTransformer : NSObject

@property (nonatomic, weak, readonly) HZYNetworkRequest *request;

- (instancetype)initWithRequest:(HZYNetworkRequest *)request NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 构建NSURLRequest，使用HZYNetworkRequest的参数构造NSURLRequest

 @param error 错误
 @return NSURLRequest对象，用于递交HZYNetworkAgent创建NSURLSessionDataTask
 */
- (NSURLRequest *)constructRequstWithError:(NSError *__autoreleasing *)error;

/**
 构建HZYNetworkResponse，将请求返回的NSURLResponse、响应体和error包装成HZYNetworkResponse

 @param response 接受原始的NSURLResponse对象
 @param object 响应体
 @param error 错误
 @param requestId 请求id，对应NSURLSessionDataTask的taskIdentifier属性
 @return HZYNetworkResponse对象，是HZYNetworkRequest最终递交给业务层的响应
 */
- (HZYNetworkResponse *)constructResponse:(NSURLResponse *)response responseObject:(id)object error:(NSError **)error requestId:(NSUInteger)requestId;

@end

