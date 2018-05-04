//
//  DemoView.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/18.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *pswdField;
@end

@implementation LoginView
- (NSDictionary *)parameterForRequest:(HZYNetworkRequest *)request {
    return @{@"user_name" : self.nameField.text,
             @"password" : self.pswdField.text};
}
@end
