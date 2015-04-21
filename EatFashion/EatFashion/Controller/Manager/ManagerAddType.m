//
//  ManagerAddType.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/11.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerAddType.h"

@interface ManagerAddType()
@end


@implementation ManagerAddType
- (void)awakeFromNib {
    [self setTypeLast:nil];
}
-(void) setTypeLast:(NSString *)typeLast{
    _typeLast = typeLast;
    if (_typeLast) {
        self.lableTitle.text = @"修改类型";
        _textFieldFoodType.text = _typeLast;
    }else{
        self.lableTitle.text = @"新增类型";
        _textFieldFoodType.text = @"";
    }
}


-(BOOL) resignFirstResponder{
    [self.textFieldFoodType resignFirstResponder];
    return [super resignFirstResponder];
}
-(void) dealloc{
    [self resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
