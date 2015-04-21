//
//  ShiShangDataPickerView.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovableView.h"
@interface ShiShangDataPickerView :UIView
@property (nonatomic,strong) NSDate *date;

-(void) addTarget:(id) target action:(SEL)action;
@end
