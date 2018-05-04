//
//  MMDemoRequest.h
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYNetworkRequest.h"

@interface HZYDemoRequest : HZYNetworkRequest
@property (nonatomic, assign) Class modelClass;
@end

@interface HZYGetMessage : HZYDemoRequest<HZYNetworkRequestParameterSource>
@property (nonatomic, strong) id param;
@end

@interface HZYUploadUserInfo : HZYDemoRequest
@end

@interface HZYUploadImageRequest : HZYDemoRequest
@end
