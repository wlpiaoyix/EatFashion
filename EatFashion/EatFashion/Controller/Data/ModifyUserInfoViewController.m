//
//  ModifyUserInfoViewController.m
//  ShiShang
//
//  Created by torin on 14/12/31.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "Common+Expand.h"
#import "UserService.h"

@interface ModifyUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *merchantName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setTitle:@"变更信息"];
    [super setHiddenCloseButton:NO];
    self.nickName.text = [ConfigManage getLoginUser].name;
    self.merchantName.text = [ConfigManage getLoginUser].shopName;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveInfo {
    
    NSString *nickName = _nickName.text;
    NSString *merchantName = _merchantName.text;
    
    if (![NSString isEnabled:nickName]) {
        [Utils showAlert:@"请输入昵称!" title:nil];
        return;
    }
    if (![NSString isEnabled:merchantName]) {
        [Utils showAlert:@"请输入店名!" title:nil];
        return;
    }
    
    UserService *userService = [UserService new];
    NSDictionary *dict = @{@"customer":@{@"id":[[ConfigManage getLoginUser].keyId stringValue],@"name":nickName}
                           ,@"shop":@{@"id":[[ConfigManage getLoginUser].shopId stringValue],@"shopName":merchantName}};
    [userService updateProfileWithParams:dict success:^(id data, NSDictionary *userInfo) {
        if (data) {
            [self backPreviousController];
        }
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils showAlert:@"无法连接服务器" title:@""];
    }];
}

@end
