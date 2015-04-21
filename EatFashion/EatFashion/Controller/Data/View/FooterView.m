//
//  FooterView.m
//  Data
//
//  Created by torin on 14/11/20.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "FooterView.h"
#import "EntityOrder.h"
#import "Common.h"

@interface FooterView()
@property(nonatomic,weak) UILabel *leftLabel;
@property(nonatomic,weak) UILabel *rightLabel;
@property(nonatomic,weak) UILabel *bottomLabel;
@property(nonatomic,weak) UIButton *cancelBtn;
@property(nonatomic,weak) UIView *separatorView;
@end

@implementation FooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:leftLabel];
    self.leftLabel = leftLabel;
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:bottomLabel];
    self.bottomLabel = bottomLabel;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"作废" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setCornerRadiusAndBorder:4 BorderWidth:1 BorderColor:[UIColor grayColor]];
    self.cancelBtn = cancelBtn;
    [self addSubview:cancelBtn];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    [self addSubview:view];
    self.separatorView = view;
    
}
-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    NSString *amount = [NSString stringWithFormat:@"合计: ¥%@",dict[KeyOrderTotalPay]];
    NSString *payable = [NSString stringWithFormat:@"应付: ¥%@",dict[KeyOrderNeedPay]];
    NSString *desc = [NSString stringWithFormat:@"选填: %@",dict[KeyOrderExtranInfo]];
    
    self.leftLabel.text = amount;
    self.rightLabel.text = payable;
    self.bottomLabel.text = desc;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 15;
    CGFloat w = [UIScreen mainScreen].applicationFrame.size.width;
    CGRect rect = self.frame;
    rect.origin.x = margin;
    rect.size.width = w - margin * 2;
    rect.size.height = 90;
    self.frame = rect;
    
    CGFloat LabelW = 150.0;
    self.leftLabel.frame = CGRectMake(0, 0, LabelW, 25);
    
    self.rightLabel.frame = CGRectMake(LabelW, 0, LabelW, 25);
    
    self.bottomLabel.frame = CGRectMake(0, CGRectGetMaxY(self.leftLabel.frame)+10, 100, 25);
    
    self.cancelBtn.frame = CGRectMake(w-80, CGRectGetMaxY(self.leftLabel.frame)+15, 50, 30);
    self.userInteractionEnabled = YES;
    self.separatorView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomLabel.frame)+10, self.frame.size.width, 1);
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}
- (void)cancelOrder
{
    if ([_delegate respondsToSelector:@selector(cancelOrder:)]) {
        [_delegate cancelOrder:self.section];
    }
}

@end
