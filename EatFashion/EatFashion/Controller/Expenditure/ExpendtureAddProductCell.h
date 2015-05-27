//
//  ExpendtureAddProductCell.h
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/18.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExpendtureAddProductCell : UITableViewCell
- (void) setParams:(NSDictionary*) params;
- (void) setDispatchBlockShouldEndEdit:(void (^)(UITextField *field,NSString* text)) dispatch_block;
+(float) getHeight;
@end
