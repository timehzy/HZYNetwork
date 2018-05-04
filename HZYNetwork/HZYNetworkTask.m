//
//  HZYNetworkTask.m
//  Pods
//
//  Created by haozhenyi on 2018/4/27.
//

#import "HZYNetworkTask.h"

@implementation HZYNetworkTask
+ (instancetype)taskWithRequest:(NSURLRequest *)request complete:(HZYNetworkRequestCompletionHandler)completeBlock uploadProgress:(HZYNetworkProgressCallback)uploadProgressBlock download:(HZYNetworkProgressCallback)downloadBlock {
    HZYNetworkTask *task = [self new];
    task.request = request;
    task.completeBlock = completeBlock;
    task.uploadProgressBlock = uploadProgressBlock;
    task.downloadBlock = downloadBlock;
    return task;
}
@end
