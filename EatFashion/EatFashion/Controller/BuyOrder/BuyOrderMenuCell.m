//
//  BuyOrderMenuCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BuyOrderMenuCell.h"
#import "BuyOrdersController.h"
#import "EntityFood.h"

@interface BuyOrderMenuCell(){
    CallBackBuyOrderMenuCellOnclick callbackOnclick;
}
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lablePrice;
@property (strong, nonatomic) IBOutlet UILabel *lableNum;
@property (strong, nonatomic) IBOutlet UIButton *buttonMinus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlus;

@end

@implementation BuyOrderMenuCell

- (void)awakeFromNib {
    [_buttonMinus addTarget:self action:@selector(onclickMinus)];
    [_buttonPlus addTarget:self action:@selector(onclickPlus)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    NSString *name = food.name;
    NSNumber *price = food.price;
    NSNumber *number = food.amount;
    _lableName.text = name;
    _lablePrice.text = [NSString stringWithFormat:@"￥%@",[price stringValue] ];
    _lableNum.text = [number stringValue];
}
-(void) setCallBackBuyOrderMenuCellOnclick:(CallBackBuyOrderMenuCellOnclick) callBack{
    callbackOnclick = callBack;
}
-(void) onclickPlus{
    NSString *value = _lableNum.text;
    int num = [value intValue];
    num = MIN(99, ++num);
    _lableNum.text = [NSString stringWithFormat:@"%d",num];
    _food.amount = [NSNumber numberWithInt:num];
    if (callbackOnclick) {
        callbackOnclick(_food);
    }
}
-(void) onclickMinus{
    NSString *value = _lableNum.text;
    int num = [value intValue];
    num = MAX(0, --num);
    _lableNum.text = [NSString stringWithFormat:@"%d",num];
    _food.amount = [NSNumber numberWithInt:num];
    if (callbackOnclick) {
        callbackOnclick(_food);
    }
}

@end
