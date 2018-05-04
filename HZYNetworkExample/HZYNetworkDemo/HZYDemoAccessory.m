//
//  HZYDemoAccessory.m
//  HZYFoundationDemo
//
//  Created by haozhenyi on 2018/5/3.
//  Copyright © 2018年 com.58.MIS-Foundation. All rights reserved.
//

#import "HZYDemoAccessory.h"

@interface HZYDemoAccessory ()

@end

@implementation HZYDemoAccessory
- (void)requestDidFinished:(HZYNetworkRequest *)request {
    [self showLabelWithText:@"request did finish"];
}

- (void)requestWillStart:(HZYNetworkRequest *)request {
    [self showLabelWithText:@"request will start"];
}

- (void)showLabelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:44];
    [label sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    label.center = CGPointMake(200, 400);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}
@end
