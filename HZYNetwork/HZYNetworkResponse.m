//
//  HZYNetworkResponse.m
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import "HZYNetworkResponse.h"

@interface HZYNetworkResponse ()

@property (nonatomic, assign) NSUInteger requestId;
@property (nonatomic, strong) NSURLResponse *originResponse;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id responseObject;

@end

@implementation HZYNetworkResponse

- (instancetype)initWithRequestId:(NSUInteger)requestId response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    if (self = [super init]) {
        _error = error;
        _requestId = requestId;
        _originResponse = response;
        _responseObject = responseObject;
    }
    return self;
}

@end
