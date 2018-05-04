//
//  HZYNetworkTask.h
//  Pods
//
//  Created by haozhenyi on 2018/4/27.
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
