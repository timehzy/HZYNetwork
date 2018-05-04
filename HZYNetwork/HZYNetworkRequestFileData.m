//
//  HZYRequestFileData.m
//  MISNetworkingDev
//
//  Created by haozhenyi on 2018/4/24.
//  Copyright © 2018年 com.58.MIS-Foundation. All rights reserved.
//

#import "HZYNetworkRequestFileData.h"

@implementation HZYNetworkRequestFileData
- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type data:(NSData *)data {
    if (self = [super init]) {
        _name = name;
        _fileName = fileName;
        _mimeType = type;
        _data = data;
    }
    return self;
}
@end
