//
//  NavigationScrollView.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/19.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ScrollViewOpt.h"

@interface NavigationScrollView : ScrollViewOpt
@property (nonatomic,assign) UIViewController *parsentController;
@property (nonatomic,strong) NSArray *arrayControllers;
@end
