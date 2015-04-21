//
//  NSObject+Expand.m
//  CommonSDK
//
//  Created by wlpiaoyi on 15/1/12.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import "ReflectClass.h"
#import "NSString+Expand.h"
@implementation NSObject(Expand)
-(NSDictionary*) toInstanceJson{
    Protocol * protocal = @protocol(ProtocolObjectJson);
    if ([self conformsToProtocol:protocal]) {
        NSArray *keys = [([(id<ProtocolObjectJson>)self class]) getJsonKeys];
        if (keys&&[keys count]) {
            NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
            for (id _key in keys) {
                NSString *property = nil;
                NSString *key = nil;
                Class propertyClazz = nil;
                if (![[self class] checkJSON:_key key:&key property:&property propertycalss:&propertyClazz]) {
                    continue;
                }
                id value = [ReflectClass getPropertyValue:property Target:self];
                if (!value) {
                    continue;
                }
                if (propertyClazz) {
                    if (![[self class] checkPropertyClass:propertyClazz protocal:protocal]) {
                        continue;
                    }
                    if ([value isKindOfClass:[NSArray class]]) {
                        NSMutableArray *dicarray = [NSMutableArray new];
                        for (id entity in value) {
                            NSDictionary *jsonvalue;
                            if ([entity conformsToProtocol:protocal]) {
                                jsonvalue = [entity toInstanceJson];
                            }else{
                                printf("instace with json warn:[%s]","array entity class type is not legal");
                                continue;
                            }
                            if (jsonvalue) {
                                [dicarray addObject:jsonvalue];
                            }
                        }
                        if (dicarray&&[dicarray count]) {
                            value = dicarray;
                        }
                    } else if ([value conformsToProtocol:protocal]) {
                        value = [value toInstanceJson];
                    }else{
                        printf("instace with json warn:[%s]","value class is not legal");
                        continue;
                    }
                }
                [json setObject:value forKey:key];
            }
            return json;
        }
    }
//    地图：百度、google  微博 社交 旅行类
    return nil;
}
+(instancetype) instanceWithJson:(NSDictionary*) json{
    NSObject *instance;
    Protocol * protocal = @protocol(ProtocolObjectJson);
    if ([self conformsToProtocol:protocal]) {
        instance = [self alloc];  //通过alloc这个命令申请一个空间来存放我们实例出来的对象
        instance = [instance init]; //初始化对象
        if (instance) {
            NSArray *keys = [([(id<ProtocolObjectJson>)instance class]) getJsonKeys];
            for (id _key in keys) {
                NSString *property = nil;
                NSString *key = nil;
                Class propertyClazz = nil;
                if (![[self class] checkJSON:_key key:&key property:&property propertycalss:&propertyClazz]) {
                    continue;
                }
                
                id value = [json objectForKey:key];
                if (!value) {
                    continue;
                }
                id result = nil;
                if (propertyClazz) {
                    if (![self checkPropertyClass:propertyClazz protocal:protocal]) {
                        continue;
                    }
                    Class targetClass = [ReflectClass getVarType:property clazz:[instance class]];
                    if (!targetClass) {
                        printf("instace with json warn:[%s]","target class is null");
                        continue;
                    }
                    if ([value isKindOfClass:[NSArray class]]) {
                        if (targetClass!=[NSArray class]) {
                            printf("instace with json warn:[%s]","target class is not NSArray class");
                            continue;
                        }
                        NSMutableArray *propertyValue = [NSMutableArray new];
                        for (id obj in value) {
                            if (![obj isKindOfClass:[NSDictionary class]]) {
                                printf("instace with json warn:[%s]","target class is not NSDictionary class");
                                continue;
                            }
                            id<ProtocolObjectJson> entity = [propertyClazz instanceWithJson:obj];
                            [propertyValue addObject:entity];
                        }
                        result = propertyValue;
                    }else if([value isKindOfClass:[NSDictionary class]]){
                        
                        if (![targetClass conformsToProtocol:protocal]) {
                            printf("instace with json warn:[%s]","property class is not implementation ProtocolObjectJson");
                            continue;
                        }
                        id<ProtocolObjectJson> entity = [propertyClazz instanceWithJson:value];
                        result = entity;
                    }
                    
                }else{
                    result = value;
                }
                [ReflectClass setPropertyValue:value selName:property Target:instance];
            }
        }
        
    }
    return instance;
}
/**
 检查并赋值相应的json主键
 */
+(BOOL) checkJSON:(id) json key:(NSString**) key property:(NSString**) property propertycalss:(Class*) propertyClass{
    if ([json isKindOfClass:[NSDictionary class]]) {
        *key = [json objectForKey:JSON_KEY];
        *property = [json objectForKey:JSON_PROPERTY];
        *propertyClass = [json objectForKey:JSON_PROPERTY_CLASS];
    }else if([json isKindOfClass:[NSString class]]){
        *property = *key = json;
    }
    if (!*key||!*property) {
        printf("instace with json warn:[%s]","key or property is null");
        return false;
    }
    return true;
}
/**
 检查clazz是否是实现了指定的协议
 */
+(BOOL) checkPropertyClass:(Class) clazz protocal:(Protocol*) protocal{
    if (!clazz) {
        printf("instace with json warn:[%s]","property class is null");
        return false;
    }
    if (![clazz conformsToProtocol:protocal]) {
        
        printf("instace with json warn:[%s]","property class is not implementation ProtocolObjectJson");
        return false;
    }
    return true;
}

@end
