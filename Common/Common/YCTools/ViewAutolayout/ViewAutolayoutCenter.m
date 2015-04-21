//
//  ViewAutolayoutCenter.m
//  Common
//
//  Created by wlpiaoyi on 15/1/5.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ViewAutolayoutCenter.h"
#import "UIView+Expand.h"

@implementation ViewAutolayoutCenter

+(void) removeConstraints:(UIView*) subView{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraints = [subView constraints];
    [subView removeConstraints:constraints];
    UIView *superView = [subView superview];
    constraints = [superView constraints];
    if (constraints&&[constraints count]) {
        for (NSLayoutConstraint *constraint in constraints) {
            if (constraint.secondItem==subView||constraint.firstItem==superView) {
                [superView removeConstraint:constraint];
            }
        }
    }
}


+(void) persistConstraintRelation:(UIView*) subView margins:(UIEdgeInsets) margins toItems:(NSDictionary*) toItems{
    
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    if ([self isValueEnable:margins.top]) {
        UIView *superView = [toItems objectForKey:@"top"];
        NSLayoutAttribute superAtt = NSLayoutAttributeBottom;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeTop;
        }
        NSLayoutConstraint *marginsTop = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:margins.top];
        [[subView superview] addConstraint:marginsTop];
    }
    if ([self isValueEnable:margins.bottom]) {
        UIView *superView = [toItems objectForKey:@"bottom"];
        
        NSLayoutAttribute superAtt = NSLayoutAttributeTop;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeBottom;
        }
        NSLayoutConstraint *marginsBottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:-margins.bottom];
        [[subView superview] addConstraint:marginsBottom];
    }
    if ([self isValueEnable:margins.left]) {
        UIView *superView = [toItems objectForKey:@"left"];
        NSLayoutAttribute superAtt = NSLayoutAttributeRight;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeLeft;
        }
        NSLayoutConstraint *marginsLeft = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:margins.left];
        [[subView superview] addConstraint:marginsLeft];
    }
    if ([self isValueEnable:margins.right]) {
        UIView *superView = [toItems objectForKey:@"right"];
        NSLayoutAttribute superAtt = NSLayoutAttributeLeft;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeRight;
        }
        NSLayoutConstraint *marginsRight = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:-margins.right];
        [[subView superview] addConstraint:marginsRight];
    }
}

+(void) persistConstraintSize:(UIView*) subView{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    CGSize size = subView.frameSize;
    NSMutableArray *constraints = [NSMutableArray new];
    if ([self isValueEnable:size.width]) {
        NSLayoutConstraint *sizeWith = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.width];
        [constraints addObject:sizeWith];
    }
    if ([self isValueEnable:size.height]) {
        NSLayoutConstraint *sizeHeight= [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height];
        [constraints addObject:sizeHeight];
    }
    [subView addConstraints:constraints];
    
}
+(void) persistConstraintCenter:(UIView*) subView{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *superView = [subView superview];
    CGPoint offPoint = subView.frameOrigin;
    NSMutableArray *constraints = [NSMutableArray new];
    if ([self isValueEnable:offPoint.x]) {
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:offPoint.x];
        [constraints addObject:centerX];
    }
    if ([self isValueEnable:offPoint.y]) {
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:offPoint.y];
        [constraints addObject:centerY];
    }
    [superView addConstraints:constraints];
}

+(BOOL) isValueEnable:(float) value{
    if (value<DisableConstrainsValueMAX-1&&value>=DisableConstrainsValueMIN+1) {
        return YES;
    }
    return NO;
}

@end
