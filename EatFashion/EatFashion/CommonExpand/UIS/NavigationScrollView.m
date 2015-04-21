//
//  NavigationScrollView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/19.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "NavigationScrollView.h"
#import "Common+Expand.h"
@implementation NavigationScrollView
-(void) setArrayControllers:(NSArray *)arrayControllers{
    self.backgroundColor = [UIColor clearColor];
    if (!self.parsentController) {
        return;
    }
    
    _arrayControllers = [NSArray arrayWithArray:arrayControllers];
    for (UIViewController *childController in _parsentController.childViewControllers) {
        [childController removeFromParentViewController];
    }
    for (UIViewController *childController in _arrayControllers) {
        [self.parsentController addChildViewController:childController];
        CGRect r = self.frame;
        r.origin = CGPointMake(0, 0);
        childController.view.frame = r;
        [childController.view autoresizingMask_TBH];
        UIView *view = [UIView new];
        view.frame = r;
        view.backgroundColor= [UIColor clearColor];
        [view addSubview:childController.view];
        [super addSubview:view];
    }
}
-(void) addSubview:(UIView *)view{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
