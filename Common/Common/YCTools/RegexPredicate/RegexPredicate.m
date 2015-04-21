//
//  RegexPredicate.m
//  Common
//
//  Created by wlpiaoyi on 14/12/31.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//



#import "RegexPredicate.h"

@implementation RegexPredicate

/**
 整数
 */
+(BOOL) matchInteger:(NSString*) arg{
    return [self matchArg:arg regex:REGEX_INTEGER];
}
/**
 小数
 */
+(BOOL) matchFloat:(NSString*) arg{
    return [self matchArg:arg regex:REGEX_FLOAT];
}
/**
 手机号码
 */
+(BOOL) matchMobliePhone:(NSString*) arg{
    return [self matchArg:arg regex:REGEX_MOBILEPHONE];
}
/**
 座机号码
 */
+(BOOL) matchHomePhone:(NSString*) arg{
    return [self matchArg:arg regex:REGEX_HOMEHONE];
}
/**
 邮箱
 */
+(BOOL) matchEmail:(NSString*) arg{
    return [self matchArg:arg regex:REGEX_EMAIL];
}

+(BOOL) matchArg:(NSString*) arg regex:(NSString*) regex{
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:arg];
}
@end
