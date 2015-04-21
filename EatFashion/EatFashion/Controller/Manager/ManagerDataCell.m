//
//  ManagerDataCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerDataCell.h"

UIColor *ColorCellBackground;

@interface ManagerDataCell()
@property (strong, nonatomic) IBOutlet UILabel *lableFoodName;
@end

@implementation ManagerDataCell

+(void) initialize{
    ColorCellBackground = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
}
- (void)awakeFromNib {
    self.backgroundColor = ColorCellBackground;
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    _lableFoodName.text = _food.name;
}

@end
