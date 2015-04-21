//
//  SimplePickerCell.m
//  Common
//
//  Created by wlpiaoyi on 14/12/4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SimplePickerCell.h"
#import "UIView+Expand.h"
#import "ViewAutolayoutCenter.h"

@interface SimplePickerCell(){
    CallBackPickerCellStatu callBackPickerCellStatu;
}
@property (nonatomic,strong) UIView *baseView;
@end

@implementation SimplePickerCell

-(id) init{
    if (self = [super init]) {
        [self initParam];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initParam];
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self initParam];
    }
    return self;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initParam];
    }
    return self;
}
-(void) initParam{
    
    _baseView = [UIView new];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_baseView];
    
    CGRect r = self.contentView.frame;
    r.origin = CGPointMake(0, 0);
    _baseView.frame = r;
    [ViewAutolayoutCenter persistConstraintRelation:_baseView margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

-(void) setSelectedStatus:(BOOL) selected{
    if (_selectedStatus!=selected&&callBackPickerCellStatu) {
        callBackPickerCellStatu(self,selected);
    }
    [self setSelected:selected];
    _selectedStatus = selected;
}
-(void) setCallBackPickerCellStatu:(CallBackPickerCellStatu) callback{
    callBackPickerCellStatu = callback;
}

-(void) setSubCell:(UIView *)subCell{
    @synchronized(self.baseView){
        for (UIView *view in self.baseView.subviews) {
            [view removeFromSuperview];
        }
        [self.baseView addSubview:subCell];
        _subCell = subCell;
        
        [ViewAutolayoutCenter persistConstraintRelation:_subCell margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:nil];
    }
}

+(void) setSubCellCenter:(UIView*) view{
    CGSize s = [view frameSize];
    CGSize ps = [view superview].frameSize;
    view.frameX = (ps.width-s.width)/2;
    view.frameY = (ps.height-s.height)/2;
}

@end
