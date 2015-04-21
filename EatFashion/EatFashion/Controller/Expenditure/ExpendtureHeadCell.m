//
//  ExpendtureHeadCell.m
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/14.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ExpendtureHeadCell.h"

@interface ExpendtureHeadCell()
@property (weak, nonatomic) IBOutlet UILabel *lableName;
@property (weak, nonatomic) IBOutlet UILabel *lableTime;
@property (weak, nonatomic) IBOutlet UILabel *lableNum;

@end

@implementation ExpendtureHeadCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) setParams:(NSDictionary*) params{
    NSString *name = [[params objectForKey:@"customer"] objectForKey:@"name"];
    NSString *time = [params objectForKey:@"deliverTime"];
    NSNumber *num = [params objectForKey:@"id"];
    self.lableName.text = name;
    self.lableTime.text = time;
    self.lableNum.text = [num stringValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(float) getHeight{
    return 51;
}

@end
