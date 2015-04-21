//
//  ExpendtureProductCell.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/15.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureProductCell.h"

@interface ExpendtureProductCell()
@property (strong, nonatomic) IBOutlet UILabel *lableProductName;
@property (strong, nonatomic) IBOutlet UILabel *lableProductPrice;

@end

@implementation ExpendtureProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setParams:(NSDictionary*) params{
    NSString *name = [params objectForKey:@"itemName"];
    NSNumber *value = [params objectForKey:@"itemValue"];
    self.lableProductName.text = name;
    self.lableProductPrice.text = [value stringValue];
}
+(float) getHeight{
    return 41;
}

@end
