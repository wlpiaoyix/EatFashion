//
//  ExpendtureTailCell.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/15.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureTailCell.h"
#import "Common+Expand.h"

@interface ExpendtureTailCell(){
    dispatch_block_ettc_cancel blockCancel;
}
@property (weak, nonatomic) IBOutlet UILabel *lableSum;
@property (weak, nonatomic) IBOutlet UILabel *lableDescrible;
@property (weak, nonatomic) IBOutlet UIButton *buttonCanel;
@property (strong,nonatomic) NSDictionary *params;

@end

@implementation ExpendtureTailCell

- (void)awakeFromNib {
    [self.buttonCanel addTarget:self action:@selector(onclickCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonCanel setCornerRadiusAndBorder:5 BorderWidth:1 BorderColor:[UIColor grayColor]];
}
- (void) setParams:(NSDictionary*) params{
    _params = params;
    NSNumber *sum = [params objectForKey:@"totalCost"];
    NSString *describle = [params objectForKey:@"extraInfo"];
    describle = describle?describle:@"";
    self.lableSum.text = [sum stringValue];
    self.lableDescrible.text = describle;
}
- (void) setBlockCancel:(dispatch_block_ettc_cancel) block{
    blockCancel = block;
}
- (void) onclickCancel{
    if(blockCancel){
        blockCancel(self.params);
    }
}
+(float) getHeight{
    return 81;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
