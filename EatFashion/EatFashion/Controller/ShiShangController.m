//
//  ShiShangController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangController.h"
#import "MessageService.h"

@interface ShiShangController ()
@end

@implementation ShiShangController

- (void)viewDidLoad {
    _dicskin = [SkinDictionary getSingleInstance];
    [super viewDidLoad];
    if ([NSString isEnabled:super.title]) {
        [self setTitle:super.title];
    }
    [self.navigationController setNavigationBarHidden:YES];
    [Utils setStatusBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
//    [[MessageService new] getApplicantsWithSuccess:^(id data, NSDictionary *userInfo) {
//        
//    } faild:^(id data, NSDictionary *userInfo) {
//        
//    }];
//    [[MessageService new] searchWithItem:@"g" success:^(id data, NSDictionary *userInfo) {
//        
//    } faild:^(id data, NSDictionary *userInfo) {
//        
//    }];
}
-(void) setHiddenCloseButton:(BOOL) hidden{
    [_topView.buttonReback setHidden:hidden];
}
-(void) setHiddenTopView:(BOOL) hidden{
    [_topView setHidden:hidden];
}
-(void) setTitle:(NSString *)title{
    [super setTitle:title];
    if (!_topView) {
        _topView = [ShiShangTopView new];
        [_topView.buttonReback addTarget:self action:@selector(backPreviousController)];
        [_topView.buttonReback setHidden:YES];
        [self.view addSubview:_topView];
    }
    if ([NSString isEnabled:title]) {
        _topView.lableTitle.text = title;
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [Utils setStatusBarHidden:NO];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[[SkinDictionary getSingleInstance] getSkinImage:@"global_topbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void) dealloc{
    NSLog(@"%d",[self hash]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
