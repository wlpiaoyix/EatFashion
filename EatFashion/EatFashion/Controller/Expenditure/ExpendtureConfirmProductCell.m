//
//  ExpendtureConfirmProductCell.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/18.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureConfirmProductCell.h"
#import "Common+Expand.h"

@interface ExpendtureConfirmProductCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewExternInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic) NSString* __strong* point;

@end

@implementation ExpendtureConfirmProductCell

- (void)awakeFromNib {
    [self.buttonConfirm setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:nil];
    [self.textViewExternInfo setCornerRadiusAndBorder:5 BorderWidth:0.5f BorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
    self.textViewExternInfo.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setExternInfoPoint:(NSString* __strong*) extrenInfo{
     self.point = extrenInfo;
}
- (void) setTarget:(id) target action:(SEL) action{
    if(self.target && self.action){
        [self.buttonConfirm removeTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    }
    self.target =target;
    self.action = action;
    [self.buttonConfirm addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    *_point = textView.text;
}
- (BOOL) resignFirstResponder{
    [self.textViewExternInfo resignFirstResponder];
    return [super resignFirstResponder];
}
+(float) getHeight{
    return 120.0f;
}

@end
