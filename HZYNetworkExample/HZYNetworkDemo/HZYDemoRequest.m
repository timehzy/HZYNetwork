//
//  MMDemoRequest.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYDemoRequest.h"
#import "HZYDemoReformer.h"

@implementation HZYDemoRequest 
- (id<HZYNetworkResponseReformer>)responseReformer {
    return [HZYDemoReformer reformerWithClass:_modelClass];
}

- (nonnull NSString *)url { 
    return @"";
}
@end

@implementation HZYGetMessage
- (instancetype)initWithMethod:(HZYNetworkRequestMethod)method {
    if (self = [super initWithMethod:method]) {
        self.parameterSource = self;
    }
    return self;
}

- (NSDictionary *)parameterForRequest:(HZYNetworkRequest *)request {
    return _param;
}

- (NSString *)url {return @"http://www.mocky.io/v2/5adef15a3300002500e4d6bb";}
@end

@implementation HZYUploadUserInfo
- (NSString *)url {return @"http://www.mocky.io/v2/5ad9abf02f00005400cfde68";}
@end

@implementation HZYUploadImageRequest
- (NSString *)url {return @"http://www.mocky.io/v2/5ad9abf02f00005400cfde68";}
@end

