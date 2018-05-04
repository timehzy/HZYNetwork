//
//  HZYNetworkService.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYNetworkTransformer.h"
#import "HZYNetwork.h"
#import "AFNetworking.h"
#import "HZYNetworkRequestFileData.h"
#import "HZYNetworkDefine.h"

@interface HZYNetworkTransformer ()

@property (nonatomic, weak) HZYNetworkRequest *request;
@property (nonatomic, strong) AFJSONRequestSerializer *httpRequestSerializer;

@end

@implementation HZYNetworkTransformer

- (instancetype)initWithRequest:(HZYNetworkRequest *)request {
    if (self = [super init]) {
        _request = request;
        _httpRequestSerializer = [AFJSONRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

- (NSURLRequest *)constructRequstWithError:(NSError *__autoreleasing *)error {
    NSString *urlString = [self getUrlString];
    id param = [self getParameter];
    if (![self isParameterValid:param error:error]) {return nil;}
    param = [self configureParameter:param];
    
    NSMutableURLRequest *req;
    NSArray<id<HZYNetworkRequestFileDataProtocol>> *filesData = [self getFilesData];
    
    if (filesData) {
        req = [self.httpRequestSerializer multipartFormRequestWithMethod:self.request.method URLString:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [filesData enumerateObjectsUsingBlock:^(id<HZYNetworkRequestFileDataProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [formData appendPartWithFileData:obj.data name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
            }];
        } error:error];
    } else {
        req = [self.httpRequestSerializer requestWithMethod:self.request.method URLString:urlString parameters:param error:error];
    }
    [self configRequest:req];
    
    return req.copy;
}

- (NSString *)getUrlString {
    NSURL *requestUrl;
    if ([self.request.configurator respondsToSelector:@selector(baseURL)]) {
        requestUrl = [NSURL URLWithString:self.request.url relativeToURL:self.request.configurator.baseUrl];
    } else {
        requestUrl = [NSURL URLWithString:self.request.url];
    }
    return requestUrl.absoluteString;
}

- (id)getParameter {
    if ([self.request.parameterSource respondsToSelector:@selector(parameterForRequest:)]) {
        id param = [self.request.parameterSource parameterForRequest:self.request];
        if ([self.request.requestReformer respondsToSelector:@selector(request:reformParameter:)]) {
            param = [self.request.requestReformer request:self.request reformParameter:param];
        }
        return param;
    } else {
        return @{};
    }
}

- (BOOL)isParameterValid:(id)param error:(NSError **)error {
    if ([self.request.validator respondsToSelector:@selector(request:isValidForParameter:error:)]) {
        if (![self.request.validator request:self.request isValidForParameter:param error:error]) {
            if (!error) {
                *error = [NSError errorWithDomain:HZYNetworkRequestErrorDomain code:HZYNetworkRequestInvalidParameterErrorCode userInfo:@{NSLocalizedDescriptionKey : @"请求参数验证失败"}];
            }
            return NO;
        }
    }
    return YES;
}

- (id)configureParameter:(id)param {
    if ([self.request.configurator respondsToSelector:@selector(adjustParamters:)]) {
        return [self.request.configurator adjustParamters:param];
    } else {
        return param;
    }
}

- (NSArray<id<HZYNetworkRequestFileDataProtocol>> *)getFilesData {
    if (self.request.parameterSource) {
        if ([self.request.parameterSource respondsToSelector:@selector(filesDataForRequest:)]) {
            return [self.request.parameterSource filesDataForRequest:self.request];
        }
    }
    return nil;
}

- (void)configRequest:(NSMutableURLRequest *)req {
    id<HZYNetworkRequestConfiguration> configurator = self.request.configurator;
    if (configurator) {
        if ([configurator respondsToSelector:@selector(cachePolicy)]) {
            req.cachePolicy = configurator.cachePolicy;
        }
        if ([configurator respondsToSelector:@selector(timeoutInterval)]) {
            req.timeoutInterval = configurator.timeoutInterval;
        } else {
            req.timeoutInterval = HZYNetworkRequestDefaultTimeoutInterval;
        }
        if ([configurator respondsToSelector:@selector(additionalHeaders)]) {
            [configurator.additionalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [req addValue:obj forHTTPHeaderField:key];
            }];
        } else if ([configurator respondsToSelector:@selector(resetAllHeaders)]) {
            [req setAllHTTPHeaderFields:[configurator resetAllHeaders]];
        }
    }
}

- (HZYNetworkResponse *)constructResponse:(NSURLResponse *)response responseObject:(id)object error:(NSError **)error requestId:(NSUInteger)requestId {
    HZYNetworkResponse *res = [[HZYNetworkResponse alloc] initWithRequestId:requestId response:response responseObject:object error:*error];
    [self reformResponseObjectForResponse:res];
    [self isResponseValid:res error:error];
    return res;
}

- (void)reformResponseObjectForResponse:(HZYNetworkResponse *)response {
    if ([self.request.responseReformer respondsToSelector:@selector(request:reformResponseObject:)]) {
        response.responseObject = [self.request.responseReformer request:self.request reformResponseObject:response.responseObject];
    }
}

- (void)isResponseValid:(id)responseObject error:(NSError **)error {
    if ([self.request.validator respondsToSelector:@selector(request:isValidForResponseObject:error:)]) {
        if (![self.request.validator request:self.request isValidForResponseObject:responseObject error:error]) {
            if (!error) {
                *error = [NSError errorWithDomain:HZYNetworkRequestErrorDomain code:HZYNetworkRequestInvalidResponseErrorCode userInfo:@{NSLocalizedDescriptionKey : @"响应数据验证失败"}];
            }
        }
    }
}

@end

NSUInteger const HZYNetworkRequestInitErrorID = 0;
NSString * const HZYNetworkRequestErrorDomain = @"com.58.HZYNetwork";
NSInteger const HZYNetworkRequestInvalidParameterErrorCode = 58001;
NSInteger const HZYNetworkRequestInvalidResponseErrorCode = 58002;
NSTimeInterval const HZYNetworkRequestDefaultTimeoutInterval = 30;
