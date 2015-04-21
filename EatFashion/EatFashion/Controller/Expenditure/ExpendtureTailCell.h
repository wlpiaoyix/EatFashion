//
//  ExpendtureTailCell.h
//  EatFashion
//
//  Created by wlpiaoyi on 15/4/15.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^dispatch_block_ettc_cancel)(NSDictionary* json);
@interface ExpendtureTailCell : UITableViewCell{
}
- (void) setParams:(NSDictionary*) params;
- (void) setBlockCancel:(dispatch_block_ettc_cancel) block;
+(float) getHeight;
@end
