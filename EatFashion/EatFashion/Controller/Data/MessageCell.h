//
//  MessageCell.h
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/17.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityMessage.h"
typedef void (^dispatch_block_message_opt) (EntityMessage *message);
@interface MessageCell : UITableViewCell
@property (nonatomic,strong) EntityMessage *message;
-(void) setDispatchBlockMessageOpt:(dispatch_block_message_opt) block;
@end
