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

@interface BuyOrderMenuCell()<UITextFieldDelegate>{
    CallBackBuyOrderMenuCellOnclick callbackOnclick;
}
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lablePrice;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) BOOL shouldEndEditing;
@end

@implementation BuyOrderMenuCell

- (void)awakeFromNib {
    _textField.delegate = self;
    _shouldEndEditing = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textField.delegate = self;

    // Configure the view for the selected state
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    NSString *name = food.name;
    NSNumber *price = food.price;
    NSNumber *number = food.amount;
    _lableName.text = name;
    _lablePrice.text = [NSString stringWithFormat:@"￥%@",[price stringValue] ];
    _textField.text = [number stringValue];
}
-(void) setCallBackBuyOrderMenuCellOnclick:(CallBackBuyOrderMenuCellOnclick) callBack{
    callbackOnclick = callBack;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *value = _textField.text;
    _textField.text = value;
    _food.amount = [NSNumber numberWithFloat:value.floatValue];
    if (callbackOnclick) {
        callbackOnclick(_food);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    @try {
        return self.shouldEndEditing;
    }
    @finally {
        _shouldEndEditing = true;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.shouldEndEditing = false;
    NSString *value = [_textField.text stringByReplacingCharactersInRange:range withString:string];
    _food.amount = [NSNumber numberWithFloat:value.floatValue];
    if (callbackOnclick) {
        callbackOnclick(_food);
    }
    return true;
}

@end
