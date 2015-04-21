//
//  ManagerOptCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerOptCell.h"
#import "Common+Expand.h"

@interface ManagerOptCell(){
@private
    CallBackManagerOptReturn callBackManagerOptReturn;
}

@property (strong, nonatomic) IBOutlet UIButton *buttonOpt;

@end


@implementation ManagerOptCell

- (void)awakeFromNib {
    // Initialization code
    [_buttonOpt addTarget:self action:@selector(onclickOpt)];
}
-(void) setCallBackManagerOptReturn:(CallBackManagerOptReturn)callback{
    callBackManagerOptReturn = callback;
}
-(void) onclickOpt{
    if (callBackManagerOptReturn) {
        callBackManagerOptReturn(self.foodType);
    }
}



@end
