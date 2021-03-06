//
//  ExpendtureAddProductCell.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/18.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureAddProductCell.h"
#import "Common+Expand.h"
@interface ExpendtureAddProductCell()<UITextFieldDelegate>{
    void (^_dispatch_block) (UITextField *filed,NSString* text);
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (weak, nonatomic) NSDictionary *params;
@end

@implementation ExpendtureAddProductCell

- (void)awakeFromNib {
    // Initialization code
    self.textFieldName.delegate = self.textFieldPrice.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setParams:(NSDictionary*) params{
    _params = params;
    
    NSString *name = [params objectForKey:@"itemName"];
    NSString *price = [params objectForKey:@"itemValue"];
    self.textFieldName.text = name ? name:@"";
    self.textFieldPrice.text = price ? price:@"";
}
- (void) setDispatchBlockShouldEndEdit:(void (^)(UITextField *field,NSString* text)) dispatch_block{
    _dispatch_block = dispatch_block;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *name = self.textFieldName.text;
    
    
    NSString *price = self.textFieldPrice.text;
    price = [[NSNumber numberWithFloat:price.floatValue] stringValueWithPrecision:2];
    [self.params setValue:name?name:@"" forKey:@"itemName"];
    [self.params setValue:price?price:@"" forKey:@"itemValue"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(_dispatch_block != nil){
        _dispatch_block(textField, string);
    }
    return true;
}

- (BOOL) resignFirstResponder{
    [self.textFieldName resignFirstResponder];
    [self.textFieldPrice resignFirstResponder];
    return [super resignFirstResponder];
}

+(float) getHeight{
    return 44.0f;
}

@end
