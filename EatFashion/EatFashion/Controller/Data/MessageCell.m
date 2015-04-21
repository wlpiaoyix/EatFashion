//
//  MessageCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 15/1/17.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell{
@private
    dispatch_block_message_opt blockMessageOpt;
    UILabel *lableMessage;
    UIButton *buttonOpt;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        lableMessage = [UILabel new];
        [lableMessage setParamTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 font:[UIFont systemFontOfSize:14]];
        buttonOpt = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonOpt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonOpt setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[UIColor grayColor]];
        [buttonOpt setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [buttonOpt.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [buttonOpt addTarget:self action:@selector(onclickOpt)];
        [self.contentView addSubview:lableMessage];
        [self.contentView addSubview:buttonOpt];
        
        [ViewAutolayoutCenter persistConstraintRelation:lableMessage margins:UIEdgeInsetsMake(2, 20, 2, 10) toItems:@{@"right":buttonOpt}];
        
        
        buttonOpt.frameWidth = 60;
        buttonOpt.frameHeight = DisableConstrainsValueMAX;
        [ViewAutolayoutCenter persistConstraintRelation:buttonOpt margins:UIEdgeInsetsMake(5, DisableConstrainsValueMAX, 5, 5) toItems:nil];
        [ViewAutolayoutCenter persistConstraintSize:buttonOpt];
    }
    return self;
}
-(void) setMessage:(EntityMessage *)message{
    _message = message;
    lableMessage.text = _message.name?_message.name:@"";
    [buttonOpt setTitle:_message.applyStatus?_message.applyStatus:@"" forState:UIControlStateNormal];
}

-(void) setDispatchBlockMessageOpt:(dispatch_block_message_opt) block{
    blockMessageOpt = block;
}
-(void) onclickOpt{
    if (blockMessageOpt) {
        blockMessageOpt(self.message);
    }
}
@end
