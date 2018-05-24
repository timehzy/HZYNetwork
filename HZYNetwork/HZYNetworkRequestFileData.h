//
//  HZYNetworkRequestFileData.h
//
//  Created by haozhenyi on 2018/4/24.
//  Copyright © 2018年 郝振壹. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 要将文件以二进制形式加入请求体中上传时，需将数据包装在遵守此协议的对象中
 */
@protocol HZYNetworkRequestFileDataProtocol

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, strong) NSData *data;

@end

@interface HZYNetworkRequestFileData : NSObject<HZYNetworkRequestFileDataProtocol>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, strong) NSData *data;

- (instancetype)initWithName:(NSString *)name
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)type
                        data:(NSData *)data;

@end
