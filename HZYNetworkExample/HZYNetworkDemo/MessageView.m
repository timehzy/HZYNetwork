//
//  MessageView.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "MessageView.h"
#import "HZYNetworkRequest.h"
#import "HZYDemoReformer.h"

@implementation MessageView
- (void)requestDidSuccess:(HZYNetworkRequest *)request {
    HZYDemoModel *model = (HZYDemoModel *)request.response.responseObject;
    self.text = model.msg;
}

- (void)requestDidFailed:(HZYNetworkRequest *)request {
    self.text = [NSString stringWithFormat:@"request error : %@", request.response.error];
}
@end
