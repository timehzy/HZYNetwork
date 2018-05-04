//
//  HZYDemoReformer.h
//  MISNetworkingDev
//
//  Created by haozhenyi on 2018/4/24.
//  Copyright © 2018年 com.58.MIS-Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZYNetwork.h"
#import "JSONModel.h"

@class HZYDemoResponse;
@interface HZYDemoReformer : NSObject<HZYNetworkResponseReformer>
+ (instancetype)reformerWithClass:(Class)modelClass;
@end

@protocol HZYDemoModel;
@interface HZYDemoModel : JSONModel
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *other;
@end
