//
//  HeaderView.m
//  Data
//
//  Created by torin on 14/11/18.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "HeaderView.h"
#import "EntityOrder.h"

@interface HeaderView()
@property(nonatomic,weak) UILabel *leftLabel;
@property(nonatomic,weak) UILabel *rightLabel;
@property(nonatomic,weak) UILabel *loginName;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)setupUI
{
    UILabel *loginName = [[UILabel alloc] init];
    loginName.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:loginName];
    self.loginName = loginName;
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:leftLabel];
    self.leftLabel = leftLabel;
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    NSString *title = [NSString stringWithFormat:@"订单号:%@",dict[KeyOrderId]];
    NSString *nickName = [NSString stringWithFormat:@"下单人(昵称): %@",dict[@"customer"][@"name"]];
    
    self.leftLabel.text = title;
    self.rightLabel.text = dict[KeyOrderDeliverTime];
    self.loginName.text = nickName;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat margin = 15;
    CGFloat w = [UIScreen mainScreen].applicationFrame.size.width;
    CGRect rect = self.frame;
    rect.origin.x = margin;
    rect.size.width = w - margin * 2;
    self.frame = rect;
    
    CGFloat LabelW = 150.0;
//    CGFloat temp  = w - margin * 2 - LabelW;
//    CGFloat labelX = w - temp + margin * 2;
    
    self.loginName.frame = CGRectMake(0, 0, w, 20);
    self.leftLabel.frame = CGRectMake(0, 20, LabelW, 25);
    
    self.rightLabel.frame = CGRectMake(LabelW, 20, LabelW, 25);
}

@end
