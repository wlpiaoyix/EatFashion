//
//  BaseNavigationController.m
//  Common
//
//  Created by wlpiaoyi on 14/12/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Common.h"

@interface BaseNavigationController ()
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbarHidden = YES;
    self.navigationBarHidden = NO;
    self.flagCheckInterfaceOrientation = true;
    [self setImageNavigationBarBg:nil position:-1];
    [self setImageToolsBarBg:nil position:-1];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
//重写父类方法判断是否可以旋转
-(BOOL)shouldAutorotate{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc shouldAutorotate];
    }
    return [super shouldAutorotate];
}
//设置导航栏背景位置
-(void) setImageNavigationBarBg:(UIImage *)imagenavigationBarBg position:(UIBarPosition) posistion{
    
    self.navigationItem.hidesBackButton = NO;
    if (imagenavigationBarBg) {
        [self.navigationBar setBackgroundImage:imagenavigationBarBg forBarPosition:posistion<0?UIBarPositionTop:posistion barMetrics:UIBarMetricsDefault];
    }
}
//设置工具栏背景位置
-(void) setImageToolsBarBg:(UIImage *)imageToolsBarBg position:(UIBarPosition) posistion{
    if (imageToolsBarBg) {
        [self.toolbar setBackgroundImage:imageToolsBarBg forToolbarPosition:posistion<0?UIBarPositionBottom:posistion barMetrics:UIBarMetricsDefault];
    }
}
//重写父类方法返回当前方向
-(NSUInteger) supportedInterfaceOrientations{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

//重写父类方法判断支持的旋转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

//⇒ 重写父类方法旋转开始和结束
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    return [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
    return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
//⇐

- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController *vc = [Utils getCurrentController];
    if ([self isGoWithCurrentController:vc]) {
        return [vc preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    UIViewController *vc = [Utils getCurrentController];
    BOOL flag;
    if ([self isGoWithCurrentController:vc]) {
        flag =  [vc prefersStatusBarHidden];
    }else{
        flag = [super prefersStatusBarHidden];
    }
    [Utils setStatusBarHidden:flag];
    return  flag;
}
-(BOOL) isGoWithCurrentController:(UIViewController*) vc{
    NSString *arg = NSStringFromClass(vc.class);
    if (self.flagCheckInterfaceOrientation&&(vc&&![vc isKindOfClass:[UINavigationController class]]&&![arg isEqualToString:@"_UIModalItemAppViewController"])) {
        return true;
    }
    return false;
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
