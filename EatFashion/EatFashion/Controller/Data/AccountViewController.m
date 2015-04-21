//
//  MerchantViewController.m
//  Data
//
//  Created by torin on 14/11/22.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "AccountViewController.h"
#import "Common+Expand.h"
#import "ModifyUserInfoViewController.h"

@interface AccountViewController (){
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet UILabel *telephoneNum;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *ticket;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

@end

@implementation AccountViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appWidth(), CGRectGetMaxY(self.ticket.frame))];
    tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapView];
    [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyUserInfo)]];
    [self.buttonEdit addTarget:self action:@selector(modifyUserInfo)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
    
    self.userName.text = [ConfigManage getLoginUser].phoneNumber;
    self.nickName.text = [ConfigManage getLoginUser].name;
    self.merchantName.text = [ConfigManage getLoginUser].shopName;
    self.telephoneNum.text = [ConfigManage getLoginUser].phoneNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)modifyUserInfo
{
    ModifyUserInfoViewController *modifyUserInfo = [[ModifyUserInfoViewController alloc] init];
    [super goNextController:modifyUserInfo];
}

@end
