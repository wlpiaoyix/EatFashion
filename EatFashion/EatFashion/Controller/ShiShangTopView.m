//
//  ShiShangTopView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangTopView.h"
#import "Common+Expand.h"
#import "SkinDictionary.h"
@implementation ShiShangTopView
-(id) init{
    if (self=[super init]) {
        CGRect r = CGRectMake(0, 0, appWidth(), 64);
        self.frame = r;
        [self autoresizingMask_BLR];
        [self initParam];
    }
    return self;
}
-(void) initParam{
    
    UIImageView *imageview = [UIImageView new];
    imageview.frame = self.frame;
    imageview.image = [[SkinDictionary getSingleInstance] getSkinImage:@"global_topbar_bg.png"];
    [imageview setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:imageview];
    
    _buttonReback = [UIButton new];
    _lableTitle = [UILabel new];
    
    
    [self addSubview:_buttonReback];
    [self addSubview:_lableTitle];
    
    CGRect r = _buttonReback.frame;
    r.origin.y = 20;
    r.size.width = 47;
    r.size.height = 44;
    r.origin.x = self.frame.size.width-r.size.width-5;
    _buttonReback.frame = r;
    [_buttonReback setBackgroundImage:[[SkinDictionary getSingleInstance] getSkinImage:@"gloable_button_reback_bg.png"] forState:UIControlStateNormal];
    [_buttonReback setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonReback.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_buttonReback setContentMode:UIViewContentModeScaleToFill];
    [_buttonReback autoresizingMask_TBL];
    
    r.origin.x = r.size.width;
    r.size.width = self.frame.size.width-r.size.width*2;
    _lableTitle.frame =r;
    [_lableTitle setParamTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter numberOfLines:0 font:[UIFont systemFontOfSize:22]];
    [_lableTitle autoresizingMask_BW];
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
