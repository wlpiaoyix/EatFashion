//
//  DataController.m
//  ShiShang
//
//  Created by torin on 14/12/20.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "DataController.h"
#import "NavigationScrollView.h"
#import "ScrollButtonOpt.h"
#import "UserService.h"
#import "LoginController.h"
#import "Utils+Expand.h"

#import "OrdersViewController.h"
#import "SettingViewController.h"
#import "StatisticViewController.h"
#import "AccountViewController.h"

@interface DataController ()
@property (weak, nonatomic) IBOutlet NavigationScrollView *scrollView;
@property (strong, nonatomic) UserService *userService;
@property (nonatomic,strong) NSArray *controllers;
@property (nonatomic, strong) ScrollButtonOpt *viewButton;
@end

@implementation DataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"数 据"];
    self.scrollView.frameWidth = appWidth();
    self.scrollView.parsentController = self;
    OrdersViewController *orders = [[OrdersViewController alloc] init];
    SettingViewController *setting = [[SettingViewController alloc] init];
    StatisticViewController *statistic = [[StatisticViewController alloc] init];
    AccountViewController *account = [[AccountViewController alloc] init];
    _controllers = @[statistic,orders,account,setting];
    _userService = [UserService new];
    [self setHiddenCloseButton:NO];
    [self.topView.buttonReback addTarget:self action:@selector(onclickExitLogin)];
    [self.topView.buttonReback setTitle:@"注销" forState:UIControlStateNormal];
    _viewButton = [ScrollButtonOpt new];
    _viewButton.frame = CGRectMake(0, SSCON_TOP, appWidth(), SSCON_TIT);
    _viewButton.backgroundColor = [UIColor colorWithRed:243./255. green:243./255. blue:243./255. alpha:1];
    _viewButton.normaltextColor = [UIColor blackColor];
    _viewButton.selectedtextColor = [UIColor redColor];
    _viewButton.values = @[@"统计",@"订单",@"帐户",@"设置"];
    
    __weak typeof(self) weakself = self;
    [_scrollView setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        weakself.viewButton.showIndex = showIndex;
        return 1;
    }];
    [_viewButton setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        [weakself.scrollView setShowIndex:showIndex];
        return 1;
    }];
    [self.view addSubview:_viewButton];
    
    [self.scrollView setArrayControllers:_controllers];
    _scrollView.showIndex = 0;
    _viewButton.showIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = appHeight()-SSCON_TOP-SSCON_BUTTOM-SSCON_TIT;
    self.scrollView.contentSize = contentSize;
}

-(void) onclickExitLogin{
    [_userService exitLogin];
    UIViewController *c = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [Utils setShiShangController:c];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
