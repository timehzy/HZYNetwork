//
//  ViewController.m
//  HZYNetworkingDev
//
//  Created by haozhenyi on 2018/4/17.
//  Copyright © 2018年 com.58.HZY-Foundation. All rights reserved.
//

#import "HZYNetworkDemoController.h"
#import "LoginView.h"
#import "HZYDemoRequest.h"
#import "MessageView.h"
#import "HZYDemoReformer.h"
#import "HZYNetwork.h"
#import "HZYDemoAccessory.h"

// 本demo演示了：
// - 自定义service。为同一业务线下的所有请求指定baseUrl、HTTPHeader、固定参数
// - 自定义request。为request添加根据类自动在请求成功时对json进行字典转模型，见HZYDemoRequest
// - 定义基类request，将相同的内容集中的基类处理。见HZYDemoRequest
// - 自定义reformer，只要传入JSONModel的子类，就可以对响应json进行字典转模型
// - 使用代理获取请求参数，消除类间参数传递，见LoginView
// - 使用代理处理响应，消除类间参数传递。见MessageView
// - 上传图片见-uploadImageBtnTouched:
// - block处理请求回调见-uploadImageBtnTouched:

@interface HZYNetworkDemoController ()<HZYNetworkRequestDelegate, HZYNetworkRequestParameterSource>
@property (nonatomic, strong) IBOutlet LoginView *userView;
@property (weak, nonatomic) IBOutlet MessageView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *requestParamLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadImageProgressBar;
@property (nonatomic, strong) HZYUploadImageRequest *uploadImageInfo;
@end

@implementation HZYNetworkDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

// 批量请求，统一回调
- (void)batchRequest {
    HZYGetMessage *message = [HZYGetMessage requstUsingGETMethod];
    message.modelClass = HZYDemoModel.class;
    HZYUploadUserInfo *useInfo = [HZYUploadUserInfo requstUsingPOSTMethod];
    useInfo.parameterSource = self.userView;
    [HZYNetworkBatchRequest sendReqeusts:@[message, useInfo] success:^(NSArray<HZYNetworkRequest *> *responses, HZYNetworkBatchRequest *batchRequest) {
        NSLog(@"su");
    } failure:^(NSArray<HZYNetworkRequest *> *successes, NSArray<HZYNetworkRequest *> *failures, HZYNetworkBatchRequest *batchRequest) {
        NSLog(@"fa");
    }];
}

// 从view直接获取请求参数数据源，发起请求，用delegate接收回调
- (IBAction)loginBtnTouched:(id)sender {
    [self.view endEditing:YES];
    HZYUploadUserInfo *userInfo = [HZYUploadUserInfo requstUsingPOSTMethod];
    [userInfo.accessories addObject:[HZYDemoAccessory new]];
    userInfo.parameterSource = self.userView;
    [userInfo startWithDelegate:self];
    NSLog(@"%@", userInfo);
    self.requestParamLabel.text = [NSString stringWithFormat:@"%@", [userInfo.parameterSource parameterForRequest:userInfo]];
}

// 上传图片
- (IBAction)uploadImageBtnTouched:(id)sender {
    HZYUploadImageRequest *uploadImage = [HZYUploadImageRequest requstUsingPOSTMethod];
    uploadImage.parameterSource = self;
    [uploadImage startWithSuccess:^(HZYNetworkRequest * _Nonnull request) {
        NSLog(@"upload image success");
    } failure:^(HZYNetworkRequest * _Nonnull request) {
        NSLog(@"upload image failed");
    }];
    uploadImage.delegate = self;
    self.uploadImageInfo = uploadImage;
}

// 取消上传图片的请求
- (IBAction)cancelBtnTouched:(id)sender {
    [self.uploadImageInfo cancelAll];
}

- (void)requestDidFailed:(HZYNetworkRequest *)request {
    NSLog(@"error:%@", request.response.error);
}

- (void)requestDidSuccess:(HZYNetworkRequest *)request {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请求成功" message:@"点击确定获取信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HZYGetMessage *message = [HZYGetMessage requstUsingGETMethod];
        message.modelClass = HZYDemoModel.class;
        [message startWithDelegate:self.messageView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray<id<HZYNetworkRequestFileDataProtocol>> *)filesDataForRequest:(HZYNetworkRequest *)request {
    if ([request isKindOfClass:[HZYUploadImageRequest class]]) {
        HZYNetworkRequestFileData *data = [[HZYNetworkRequestFileData alloc] initWithName:@"image" fileName:@"testImage.png" mimeType:@"image/png" data:UIImagePNGRepresentation([UIImage imageNamed:@"test_image"])];
        return @[data];
    }
    return nil;
}

- (void)request:(HZYNetworkRequest *)request uploadProgress:(NSProgress *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.uploadImageProgressBar setProgress:progress.fractionCompleted animated:YES];
    });
}

- (IBAction)resetBtnTouched:(id)sender {
    [self.uploadImageProgressBar setProgress:0 animated:YES];
}
@end
