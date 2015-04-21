//
//  ExpendtureConfirmProductCell.h
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/18.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpendtureConfirmProductCell : UITableViewCell
- (void) setTarget:(id) target action:(SEL) action;
-(void) setExternInfoPoint:(NSString* __strong*) extrenInfo;
+(float) getHeight;
@end
