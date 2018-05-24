//
//  HZYNetworkRequestFileData.h
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HZYNetworkRequest;
@class HZYNetworkResponse;

@protocol HZYNetworkRequestDelegate;
@protocol HZYNetworkRequestValidator;
@protocol HZYNetworkResponseReformer;
@protocol HZYNetworkRequestParameterSource;
@protocol HZYNetworkRequestFileDataProtocol;
@protocol HZYNetworkRequestConfiguration;
@protocol HZYNetworkRequestReformer;
@protocol HZYNetworkRequestAccessory;

typedef NSString *HZYNetworkRequestMethod;
FOUNDATION_EXPORT HZYNetworkRequestMethod const GET;
FOUNDATION_EXPORT HZYNetworkRequestMethod const POST;
FOUNDATION_EXPORT HZYNetworkRequestMethod const HEAD;
FOUNDATION_EXPORT HZYNetworkRequestMethod const PUT;
FOUNDATION_EXPORT HZYNetworkRequestMethod const DELETE;

typedef NS_ENUM(NSUInteger, HZYNetworkRequestStrategy) {
    /// 允许相同的请求多次发起
    HZYNetworkRequestStrategyAllowMultiple = 0,
    /// 在发起请求前检查如果有相同的请求尚未完成，则取消之前的请求
    HZYNetworkRequestStrategyCancelPreviousWhenStart,
    /// 在发起请求前检查如果有相同的请求尚未完成，则取消当前的请求
    HZYNetworkRequestStrategyDiscardIfPreviousOnLoading,
};

typedef NS_ENUM(NSUInteger, HZYNetworkParameterType) {
    HZYNetworkFormParameter,
    HZYNetworkJSONParameter,
};

/*
 关于错误链的说明：
 - 如果HTTP请求出现错误，错误会带给request:reformResponseObject:error:方法，所以建议使用该方法时，先判断error
 - 上一步的错误会继续传递到request:isValidForResponseObject:error:，同样，建议使用时先判断error
 - 最后如果error仍不为空，则此请求会被判断为失败，走失败回调
 使用建议，在以上任意一个环节实现相应方法时，先判断error是否为空，如果不为空则不要做任何操作，直接将第一错误抛给上层。
 */

@interface HZYNetworkRequest : NSObject

/**
 代理方法
 @discussion 可以通过代理获得请求的响应和上传下载的进度。如果使用block回调的方式，并且不需要进度，则不需要设置
 */
@property (nonatomic, weak, nullable) id<HZYNetworkRequestDelegate> delegate;
@property (nonatomic, weak, nullable) id<HZYNetworkRequestParameterSource> parameterSource;
/** 验证器 */
@property (nonatomic, weak, nullable) id<HZYNetworkRequestValidator> validator;
/** 对请求参数进行自定义构造 */
@property (nonatomic, weak, nullable) id<HZYNetworkRequestReformer> requestReformer;
/** 对响应进行自定义构造 */
@property (nonatomic, weak, nullable) id<HZYNetworkResponseReformer> responseReformer;
/** 配置请求*/
@property (nonatomic, weak) id<HZYNetworkRequestConfiguration> configurator;
/** 插件 */
@property (nonatomic, strong) NSMutableArray<id<HZYNetworkRequestAccessory>> *accessories;
@property (nonatomic, readonly) HZYNetworkRequestMethod method;
@property (nonatomic, readonly) HZYNetworkResponse *response;
/** 请求策略，用于管理相同请求多发的方式 */
@property (nonatomic, assign) HZYNetworkRequestStrategy strategy;
/** 由该类发出的请求是否完成，全部完成时返回NO，否则返回YES */
@property (nonatomic, readonly) BOOL isLoading;

#pragma mark - override method
- (NSString *)url;

#pragma mark - init method

- (instancetype)initWithMethod:(HZYNetworkRequestMethod)method NS_DESIGNATED_INITIALIZER;

/** GET请求 */
+ (instancetype)requstUsingGETMethod;
/** POST请求 */
+ (instancetype)requstUsingPOSTMethod;

#pragma mark - action method
/**
 发起请求，用代理的方式接收响应

 @param delegate 代理对象
 @return 请求的ID，可以用于后续取消该请求
 */
- (NSUInteger)startWithDelegate:(id<HZYNetworkRequestDelegate> _Nullable)delegate;

/**
 发起请求，用block方式接收响应

 @param successCallback 成功的回调
 @param failureCallback 失败的回调
 @return 请求的ID，可以用于后续取消该请求
 */
- (NSUInteger)startWithSuccess:(void(^)(HZYNetworkResponse *response))successCallback
                       failure:(void(^)(HZYNetworkResponse *response))failureCallback;

/**
 取消指定的请求
 @discussion 如果该请求已经发出，但尚未完成，通过该方法可以取消，后续的任何响应回调都不会执行。该方法实际会执行NSURLSessionDataTask的-cancel方法，并将该task从HZYNetworkAgent的缓存池中删除。
 @param requestId 请求的id
 */
- (void)cancelWithId:(NSUInteger)requestId;

/**
 取消所有由该对象发起的请求
 */
- (void)cancelAll;
@end

/**
 切面方法，重写时必须super调用，否则会导致插件失效
 */
@interface HZYNetworkRequest (InnerInterceptor)

/** 返回值决定是否最终执行成功回调 */
- (BOOL)beforePerformSuccess;
- (void)afterPerformSuccess;

/** 返回值决定是否最终执行失败回调 */
- (BOOL)beforePerformFailure;
- (void)afterPerformFailure;

/** 返回值决定是否执行请求，优先级在strategy之前 */
- (BOOL)shouldStartWithParams:(NSDictionary *_Nullable)params;
- (void)afterStartWithParams:(NSDictionary *_Nullable)params;

@end

/**
 这个代理提供了请求成功和失败的回调，以及上传和下载进度的回调
 */
@protocol HZYNetworkRequestDelegate<NSObject>

@optional

- (void)request:(HZYNetworkRequest *)request successWithResponse:(HZYNetworkResponse *)response;
- (void)request:(HZYNetworkRequest *)request failWithResponse:(HZYNetworkResponse *)response;
- (void)request:(HZYNetworkRequest *)request uploadProgress:(NSProgress *)progress;
- (void)request:(HZYNetworkRequest *)request downloadProgress:(NSProgress *)progress;

@end

/**
 这是请求的参数数据源，对于有参数的请求需要通过该方法来返回请求参数
 */
@protocol HZYNetworkRequestParameterSource<NSObject>

@optional

- (HZYNetworkParameterType)parameterType;
- (NSDictionary *)parameterForRequest:(HZYNetworkRequest *)request;
- (NSArray<id<HZYNetworkRequestFileDataProtocol>> *)filesDataForRequest:(HZYNetworkRequest *)request;

@end

/**
 参数验证协议，提供对请求参数的验证和请求响应的验证
 */
@protocol HZYNetworkRequestValidator<NSObject>

@optional

- (BOOL)request:(HZYNetworkRequest *)request isValidForParameter:(id)param error:(NSError **)error;
- (BOOL)request:(HZYNetworkRequest *)request isValidForResponseObject:(id)responseObject error:(NSError **)error;

@end

/**
 响应内容自定义处理的协议，通过该方法获取指定请求的响应，并作出自定义的处理，并返回处理后的响应对象
 */
@protocol HZYNetworkResponseReformer<NSObject>

- (id)request:(HZYNetworkRequest *)request reformResponseObject:(id)responseObject error:(NSError **)error;

@end

@protocol HZYNetworkRequestReformer <NSObject>

- (id)request:(HZYNetworkRequest *)request reformParameter:(id)parameter;

@end


@protocol HZYNetworkRequestConfiguration <NSObject>

@optional
- (NSURL *)baseUrl;
- (NSTimeInterval)timeoutInterval;
- (NSURLRequestCachePolicy)cachePolicy;

/**
 为请求头添加自定义的内容，这些内容会在默认请求头之后添加。需要注意的是，该方法和后面的-resetAllHeaders方法只能实现一个，如果两个都实现，会以后者为准。
 
 @return 要添加的请求头对象
 */
- (NSDictionary<NSString *, NSString *> *)additionalHeadersForRequest:(HZYNetworkRequest *)request;

/**
 以自定义的请求头内容完全覆盖默认的请求头
 
 @return 要设置的请求头
 */
- (NSDictionary<NSString *, NSString *> *)resetAllHeadersForRequest:(HZYNetworkRequest *)request;

/**
 对请求参数进行最后配置
 
 @param parameters 配置前的请求参数
 @return 配置好的请求参数
 */
- (id)adjustParamters:(id)parameters;

@end


@protocol HZYNetworkRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(HZYNetworkRequest *)request;
- (void)requestDidFinished:(HZYNetworkRequest *)request;

@end

NS_ASSUME_NONNULL_END
