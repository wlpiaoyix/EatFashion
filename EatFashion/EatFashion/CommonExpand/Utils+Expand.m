//
//  Util+Expand.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "Common+Expand.h"
#import "SkinDictionary.h"
#import "EntityFood.h"


static FDEntityManager *em;


@implementation Utils(Expand)
+(void) initialize{
    [self initParams];
    em = [[FDEntityManager alloc] initWithDBName:@"sqllit"];
    [FDEntityManager checkAllTables:@[[EntityFood class]] dbName:@"sqllit"];
}
+(id<HttpUtilRequestDelegate>) getHttpUtilRequest{
    HttpUtilRequest *nwh = [HttpUtilRequest new];
    [nwh setHttpEncoding:NSUTF8StringEncoding];
    [nwh addRequestHeadValue:@{@"Content-Type":@"application/json"}];
    [nwh addRequestHeadValue:@{@"Connection":@"keep-alive"}];
    [nwh addRequestHeadValue:@{@"Charset":@"UTF-8"}];
    return nwh;
}
+(UIWindow*) setShiShangController:(UIViewController*) vc{
    UIWindow *w = [Utils setRootController:vc];
    [Utils setStatusBarHidden:NO];
    w.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"window_bg_color"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return w;
}
+(id) getEntityManger{
    return em;
}
@end
