//
//  ManageAddData.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManageAddData.h"
#import "Common+Expand.h"

@interface ManageAddData()
@property (assign,nonatomic) id target;
@property (nonatomic) SEL action;
@property (strong, nonatomic) IBOutlet UILabel *lableTitle;
@property (strong, nonatomic) IBOutlet UITextField *textFieldName;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPrice;

@end

@implementation ManageAddData

- (void)awakeFromNib{
    _textFieldName.delegate = _textFiledPrice.delegate = self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField==_textFieldName) {
        [_textFiledPrice becomeFirstResponder];
    }else if(textField==_textFiledPrice){
        if (_target&&_action&&[_target respondsToSelector:_action]) {
            [_target respondsToSelector:_action];
        }
    }
    return YES;
}

-(EntityFood*) getFood{
    if (_food) {
        _food.name = _textFieldName.text;
        if ([NSString isEnabled:_textFiledPrice.text]) {
            _food.price = [NSNumber numberWithFloat:_textFiledPrice.text.floatValue];
        }
    }
    return _food;
}
-(void) setFood:(EntityFood *)food{
    _food = [EntityFood entityWithJson:[food toJson]];
    if (_food.name) {
        _textFieldName.text = _food.name;
    }
    if(_food.price){
        _textFiledPrice.text = _food.price.stringValue;
    }
}


-(BOOL) resignFirstResponder{
    [self.textFieldName resignFirstResponder];
    [self.textFiledPrice resignFirstResponder];
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
