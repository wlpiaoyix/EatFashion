//
//  ReflectClass.m
//  Common
//
//  Created by wlpiaoyi on 14-5-9.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ReflectClass.h"
#import "NSString+Expand.h"
@implementation ReflectClass
+(bool) setPropertyValue:(id)value selName:(NSString *) selName Target:(id) target{
    if ([self getProperty:selName Target:target]) {
        [target setValue:value forKey:selName];
        return true;
    }
    return false;
}
+(id) getPropertyValue:(NSString*) selName Target:(id) target{
    if ([self getProperty:selName Target:target]) {
        return [target valueForKey:selName];
    }
    return nil;
}
+(NSArray*) getAllPropertys:(Class) clazz{
    unsigned int outCount, i;
    objc_property_t *properties;
    @try {
        properties = class_copyPropertyList(clazz , &outCount);
        //如果你知道大概要放多少东西，那么最好用initWithCapacity,这个会提高程序内存运用效率
        NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            NSString *className = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            className = [[className substringToIndex:[className intIndexOf:1 Suffix:'"']] substringFromIndex:[className intIndexOf:0 Suffix:'"']+1];
            Class clazz = NSClassFromString(className);
            [keys addObject:@{@"propertyName":propertyName,@"class":clazz}];
        }
        return keys;
    }
    @finally {
        free(properties);
    }
}
+(NSString*) getVarName:(int) index clazz:(Class) clazz{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(clazz, &numIvars);
    @try {
        for(int i = 0; i < numIvars; i++) {
            if (i!=index) {
                continue;
            }
            NSString *key=nil;
            Ivar thisIvar = vars[i];
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
            if (![NSString isEnabled:key]) {
                return nil;
            }
            if([key stringStartWith:@"_"]){
                key = [key substringFromIndex:1];
            }
            return key;
        }
    }
    @finally {
        free(vars);
    }
    return nil;
}
+(Class) getVarType:(NSString*) varName clazz:(Class) clazz{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(clazz, &numIvars);
    for(int i = 0; i < numIvars; i++) {
        
        NSString *key=nil;
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        if (![NSString isEnabled:key]) {
            return nil;
        }
        if([key stringStartWith:@"_"]){
            key = [key substringFromIndex:1];
        }
        if (![key isEqualToString:varName]) {
            continue;
        }
        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        key = [key stringByReplacingOccurrencesOfString:@"@" withString:@""];
        key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (![NSString isEnabled:key]) {
            continue;
        }
        Class cl = NSClassFromString(key);
        return cl;
    }
    free(vars);
    return nil;
}
+(SEL) getPropertySEL:(NSString*) propertyName Target: (id) target;{
    objc_property_t property = [self getProperty:propertyName Target:target];
    if (property) {
        return NSSelectorFromString(propertyName);
    }
    return nil;
}
+(SEL) getMethodSEL:(NSString*) methodName Target:(id) target{
    unsigned int outCount, i;
    Method *methods = class_copyMethodList([target class], &outCount);
    @try {
        for (i = 0; i < outCount; i++) {
            Method method = methods[i];
            SEL sel = method_getName(method);
            NSString *_methodName = [[NSString alloc] initWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
            if ([_methodName isEqualToString:methodName]) {
                return sel;
            }
        }
        return false;
    }
    @finally {
        free(methods);
    }
}
+(objc_property_t) getProperty:(NSString*) propertName Target:(id) target{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([target class], &outCount);
    @try {
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *_propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if ([_propertyName isEqualToString:propertName]) {
                return property;
            }
        }
        return false;
    }
    @finally {
        free(properties);
    }
}
@end
