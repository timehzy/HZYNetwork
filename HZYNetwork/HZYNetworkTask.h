//
//  HZYNetworkTask.h
//
//  Created by haozhenyi on 2018/4/27.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZYNetworkDefine.h"

@interface HZYNetworkTask : NSObject
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) HZYNetworkRequestCompletionHandler completeBlock;
@property (nonatomic, copy) HZYNetworkProgressCallback uploadProgressBlock;
@property (nonatomic, copy) HZYNetworkProgressCallback downloadBlock;

+ (instancetype)taskWithRequest:(NSURLRequest *)request
                       complete:(HZYNetworkRequestCompletionHandler)completeBlock
                 uploadProgress:(HZYNetworkProgressCallback)uploadProgressBlock
                       download:(HZYNetworkProgressCallback)downloadBlock;
@end
