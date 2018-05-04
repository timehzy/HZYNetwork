//
//  HZYNetworkResponse.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYNetworkResponse.h"

@interface HZYNetworkResponse ()

@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) NSUInteger requestId;
@property (nonatomic, strong) NSURLResponse *originResponse;

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
