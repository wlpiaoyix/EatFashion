//
//  HttpUtilUpLoad.m
//  Common
//
//  Created by wlpiaoyi on 15/2/27.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "HttpUtilUpLoad.h"

@implementation HttpUtilUpLoad
-(void) setUpLoadString:(NSString*) upLoadString{
}
-(void) setUpLoadingSuccessCallBack:(CallBackHttpUtilUpLoading) callback{
}
-(void) setUpLoadingFaildCallBack:(CallBackHttpUtilUpLoading) callback{
}
-(void) resumeUpLoad{
}
-(void) suspendUpLoad{
}
-(void) cancelUpLoad{
}

-(NSURLSession*) createSession{
    //这个sessionConfiguration 很重要， com.zyprosoft.xxx  这里，这个com.company.这个一定要和 bundle identifier 里面的一致，否则ApplicationDelegate 不会调用handleEventsForBackgroundURLSession代理方法
    NSURLSessionConfiguration *configuration;
    if ([systemVersion floatValue]>=8.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"%@%lu",CONFIGURATIONSESSIONBGSUFFIX,(unsigned long)[self hash]]];
#endif
    }else{
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:[NSString stringWithFormat:@"%@%lu",CONFIGURATIONSESSIONBGSUFFIX,(unsigned long)[self hash]]];
    }
    configuration.URLCache =   [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024*1024 diskCapacity:100 * 1024*1024 diskPath:@"downloadcache"];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    return [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
}

@end
