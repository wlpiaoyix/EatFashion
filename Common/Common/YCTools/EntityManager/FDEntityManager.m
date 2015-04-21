//
//  FDEntityManager.m
//  Common
//
//  Created by wlpiaoyi on 15/1/13.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDEntityManager.h"
#import "FMDB.h"
#import "Utils.h"
#import "NSString+Expand.h"
#import "ReflectClass.h"

static NSMapTable *maptable;
static NSMapTable *mapEntityManger;


@implementation FDEntityManager{
@protected
    FMDatabase *database;
    NSString *entitydbName;
}
+(void) initialize{
    maptable = [NSMapTable strongToStrongObjectsMapTable];
    mapEntityManger = [NSMapTable strongToStrongObjectsMapTable];
}
+(instancetype) getSingleInstance{
    return [self getSingleInstanceWithDBName:nil];
}
+(instancetype) getSingleInstanceWithDBName:(NSString*) dbName{
    FDEntityManager *entityManager;
    @synchronized(self){
        entityManager = [mapEntityManger objectForKey:dbName];
        if (!entityManager) {
            entityManager = [[FDEntityManager alloc] initWithDBName:dbName];
            [mapEntityManger setObject:entityManager forKey:dbName];
        }
    }
    return entityManager;
}
-(void) initParams:(NSString*) dbName{
    self->entitydbName = dbName?dbName:@"entities.db";
    self->database = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",documentDir, self->entitydbName]];
    if(![database open]){
        printf("open database faild!\n");
        return;
    }
    printf("open database success!\n");
}
-(id) init{
    if(self = [super init]){
        [self initParams:nil];
    }
    return self;
}
-(id) initWithDBName:(NSString *) dbName{
    if(self = [super init]){
        [self initParams:dbName];
    }
    return self;
}

-(id) getDatabase{
    return self->database;
}

//==> 事务管理

-(BOOL) beginTransation{
    BOOL b = [database executeUpdate:@"begin"];
    return b;
}
-(int) commitTarnsation{
    int b = [database executeUpdate:@"commit"];
    return b;
}
- (BOOL)rollbackTarnsation {
    BOOL b = [database executeUpdate:@"rollback"];
    return b;
}
//<==

-(int) excuSql:(NSString*) sql Params:(NSArray*) params{
    if (params) {
        return [self->database executeUpdate:sql withArgumentsInArray:params];
    }else{
        return [self->database executeUpdate:sql];
    }
}
/**
 根据关键字提取实体
 */
-(id<ProtocolEntity>) find:(NSNumber*)  key Clazz:(Class<ProtocolEntity>) clazz{
    if (![maptable objectForKey:clazz]) {
        [[self class] checkAllTables:@[clazz] dbName:entitydbName];
    }
    NSString *sql = [FDObject getFindeSqlByEnity:clazz];
    FMResultSet *result = [database executeQuery:sql,key];
    NSArray *array = [[self class] parseResult:result toClazz:clazz];
    return (array&&[array count])?array[0]:nil;
}
/**
 新增实体
 */
-(int) persist:(id<ProtocolEntity>) entity{
    @try {
        NSDictionary *dicEntityInfo = [maptable objectForKey:[entity class]];
        if (!dicEntityInfo) {
            [[self class] checkAllTables:@[[entity class]] dbName:entitydbName];
            dicEntityInfo = [maptable objectForKey:[entity class]];
        }
        NSDictionary *dicColums = [dicEntityInfo valueForKey:EM_MAP_ENTITY_COLUM];
        NSString *sql = [FDObject getInsertSqlByEnity:[entity class]];
        NSMutableArray *values = [NSMutableArray new];
        for (NSString *columKey in [[entity class] getColums]) {
            NSString *property = [[dicColums objectForKey:columKey] objectForKey:EM_MAP_ENTITY_COLUM_PROPERTY];
            id value = [ReflectClass getPropertyValue:property Target:entity];
            if (value) {
                [values addObject:value];
            }else{
                [values addObject:[NSNull null]];
            }
        }
        int _id = [database executeUpdate:sql withArgumentsInArray:values];
        if(_id>0){
            return _id;
        }
        return 0;
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"persistException" reason:exception.reason userInfo:nil];
    }
}
/**
 更新实体
 */
-(id<ProtocolEntity>) merge:(id<ProtocolEntity>) entity{
    @try {
        NSNumber *keyId = [ReflectClass getPropertyValue:[[entity class] getKey] Target:entity];
        if (!keyId) {
            int keyValue = [self persist:entity];
            [ReflectClass setPropertyValue:[NSNumber numberWithInt:keyValue] selName:[[entity class] getKey] Target:entity];
            return entity;
        }
        
        NSDictionary *dicEntityInfo = [maptable objectForKey:[entity class]];
        if (!dicEntityInfo) {
            [[self class] checkAllTables:@[[entity class]] dbName:entitydbName];
        }
        NSDictionary *dicColum = [dicEntityInfo objectForKey:EM_MAP_ENTITY_COLUM];
        NSString *sql = [FDObject getUpdateSqlByEnity:[entity class]];
        NSMutableArray *values = [NSMutableArray new];
        for (NSString *key in [[entity class] getColums]) {
            NSDictionary *dic = [dicColum objectForKey:key];
            NSString *property = [dic objectForKey:EM_MAP_ENTITY_COLUM_PROPERTY];
            id value = [ReflectClass getPropertyValue:property Target:entity];
            if (value) {
                [values addObject:value];
            }else{
                [values addObject:[NSNull null]];
            }
        }
        [values addObject:keyId];
        
        if([database executeUpdate:sql withArgumentsInArray:values]){
            return entity;
        }
        return nil;
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"mergeException" reason:exception.reason userInfo:nil];
    }
}
/**
 删除实体
 */
-(bool) remove:(id<ProtocolEntity>) entity{
    @try {
        if (![maptable objectForKey:[entity class]]) {
            [[self class] checkAllTables:@[[entity class]] dbName:entitydbName];
        }
        NSString *sql = [FDObject getDeleteSqlByEnity:[entity class]];
        NSNumber *key = [ReflectClass getPropertyValue:[[entity class] getKey] Target:entity];
        return [database executeUpdate:sql,key];
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"removeException" reason:exception.reason userInfo:nil];
    }
}

/**
 查询实体
 @resultType NSArray
 */
-(NSArray*) queryBySql:(NSString *)sql Params:(NSArray *)params{
    FMResultSet *result;
    if (params&&[params count]) {
        result = [database executeQuery:sql withArgumentsInArray:params];
    }else{
        result = [database executeQuery:sql];
    }
    NSArray *array = [[self class] parseResultToDictionary:result];
    return array;
}

/**
 查询实体
 @resultType Entity
 */
-(NSArray*) queryBySql:(NSString*) sql Clazz:(Class<ProtocolEntity>) clazz Params:(NSArray*) params{
    if (![maptable objectForKey:clazz]) {
        return nil;
    }
    FMResultSet *result;
    if (params&&[params count]) {
        result = [database executeQuery:sql withArgumentsInArray:params];
    }else{
        result = [database executeQuery:sql];
    }
    NSArray *array = [[self class] parseResult:result toClazz:clazz];
    return array;
}


+(id) parseResultToDictionary:(FMResultSet*) result{
    NSMutableArray *array = [NSMutableArray new];
    while ([result next]) {
        int index = 0;
        NSMutableDictionary *dicvalue = [NSMutableDictionary new];
        while (index<[result columnCount]) {
            id value = [result objectForColumnIndex:index];
            NSString *name = [result columnNameForIndex:index];
            if (name&&value&&value!=[NSNull null]) {
                [dicvalue setObject:value forKey:name];
            }
            index++;
        }
        [array addObject:dicvalue];
    }
    return array;
}


+(id) parseResult:(FMResultSet*) result toClazz:(Class<ProtocolEntity>) clazz{
    NSMutableArray *array = [NSMutableArray new];
    NSDictionary *clazzInfo = [maptable objectForKey:clazz];
    if (!clazzInfo) {
        printf("the reflect info for entity is null");
        return nil;
    }
    NSDictionary *dicColums = [clazzInfo objectForKey:EM_MAP_ENTITY_COLUM];
    NSArray *dicResults = [self parseResultToDictionary:result];
    for (NSDictionary *dicResult in dicResults) {
        NSString *className = NSStringFromClass(clazz);
        id<ProtocolEntity> entity =  (id<ProtocolEntity>)[[NSClassFromString(className) alloc] init];
        NSNumber *keyValue = [dicResult objectForKey:[clazz getKey]];
        if (keyValue) {
            [ReflectClass setPropertyValue:keyValue selName:[clazz getKey] Target:entity];
        }
        for (NSString *key in [clazz getColums]) {
            NSDictionary *colum = [dicColums objectForKey:key];
            NSString *property = [colum objectForKey:EM_MAP_ENTITY_COLUM_PROPERTY];
            id value = [dicResult objectForKey:key];
            if (value) {
                [ReflectClass setPropertyValue:value selName:property Target:entity];
            }
        }
        [array addObject:entity];
    }
    return array;
}
/**
 检查table sql 并生成 反射的参数
 */
+(void) checkAllTables:(NSArray*) clazzs dbName:(NSString*) dbName{
    for (Class<ProtocolEntity> clazz in clazzs) {
        [self checkTable:clazz dbName:dbName];
        [self alertTable:clazz dbName:dbName];
    }
}
+(void) checkTable:(Class) clazz dbName:(NSString*) dbName{
    BOOL hasDic;
    NSDictionary *dicEntityInfo = [self createDiceEntityInfoWithClass:clazz hasDic:&hasDic];
    if (hasDic) {
        NSString *sql = [FDObject getCreateSqlByEntity:clazz];
        printf("check table:%s\n",[sql UTF8String]);
        [[self getSingleInstanceWithDBName:dbName] excuSql:sql Params:nil];
    }else{
        printf("checked table:%s\n",[((NSString*)[dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE]) UTF8String]);
    }
    
}
+(void) alertTable:(Class) clazz dbName:(NSString*) dbName{
    BOOL hasDic;
    static NSString *FALGALERTEDTABLE = @"FALGALERTEDTABLE";
    NSMutableDictionary *dicEntityInfo = [self createDiceEntityInfoWithClass:clazz hasDic:&hasDic];
    if (hasDic) {
        [self checkTable:clazz dbName:dbName];
    }
    if ([dicEntityInfo objectForKey:FALGALERTEDTABLE]) {
        return;
    }
    
    NSString *tableName = [dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE];
    if (![NSString isEnabled:tableName]) {
        printf("faild find table:%s\n",[((NSString*)[dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE]) UTF8String]);
        return;
    }
    NSString *structSql = [FDObject getTableStructByTableName:tableName];
    FMResultSet *resultSet = [[[self getSingleInstanceWithDBName:dbName]getDatabase] executeQuery:structSql,nil];
    
    NSArray *array = [self parseResultToDictionary: resultSet];
    if (!array||![array count]) {
        printf("faild struct table:%s\n",[((NSString*)[dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE]) UTF8String]);
        return;
    }
    
    NSString *createSql = [[array firstObject] objectForKey:@"sql"];
    if (![NSString isEnabled:createSql]) {
        printf("faild sql table:%s\n",[((NSString*)[dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE]) UTF8String]);
        return;
    }
    
    const char* creatSqlChar = [createSql UTF8String];
    NSUInteger charLength = [createSql length];
    NSUInteger startIndex = 0;
    NSUInteger endIndex = 0;
    for (NSUInteger i=0; i<charLength; i++) {
        char c = creatSqlChar[i];
        if (c=='(') {
            startIndex = i;
            break;
        }
    }
    for (NSUInteger i=charLength; i>0; --i) {
        char c = creatSqlChar[i];
        if (c==')') {
            endIndex = i;
            break;
        }
    }
    createSql = [[createSql substringToIndex:endIndex] substringFromIndex:startIndex+1];
    NSArray *columInfos = [createSql componentsSeparatedByString:@","];
    NSMutableDictionary *dicTableColum = [NSMutableDictionary new];
    
    for (NSString *columInfo in columInfos) {
        NSString *_columInfo = [self removeStartBlack:columInfo];
        NSArray *colums = [_columInfo componentsSeparatedByString:@" "];
        if ([colums count]<2) {
            printf("alert table colum exception");
            break;
        }
        NSString *colum = colums.firstObject;
        NSString *type = [colums objectAtIndex:1];
        NSString *rule = @"";
        if ([colums count]>2) {
            for (int i=2; i<[colums count]; i++) {
                if(i!=2){
                    rule = [rule stringByAppendingString:@" "];
                }
                rule = [rule stringByAppendingString:[colums objectAtIndex:i]];
            }
        }
        NSMutableDictionary *dicColum = [[NSMutableDictionary alloc] init];
        if ([NSString isEnabled:rule]) {
            if ([[rule uppercaseString] stringStartWith:@"PRIMARY KEY"]) {
                continue;
            }
            [dicColum setObject:rule forKey:EM_MAP_ENTITY_COLUM_RULE];
        }
        [dicColum setObject:type forKey:EM_MAP_ENTITY_COLUM_TYPE];
        [dicTableColum setObject:dicColum forKey:colum];
    }
    NSDictionary *dicEntityColum = [dicEntityInfo objectForKey:EM_MAP_ENTITY_COLUM];
    NSMutableArray* addTableColums = [self compareAddTableColums:dicTableColum dicEntityColum:dicEntityColum];
    for(NSString *colum in addTableColums){
        NSString *alertSql = [FDObject getAddColumSqlByEnity:clazz addColum:colum];
        [[self getSingleInstanceWithDBName:dbName] excuSql:alertSql Params:nil];
        
    }
    [dicEntityInfo setValue:@YES forKey:FALGALERTEDTABLE];
    printf("alertTable table:%s\n",[((NSString*)[dicEntityInfo objectForKey:EM_MAP_ENTITY_TABLE]) UTF8String]);
    
}

+(NSMutableArray*) compareAddTableColums:(NSDictionary*) dicTableColum dicEntityColum:(NSDictionary*) dicEntityColum{
    NSMutableArray *arrayAlert = [NSMutableArray new];
    for (NSString *colum in [dicEntityColum allKeys]) {
        if (![dicTableColum objectForKey:colum]) {
            [arrayAlert addObject:colum];
        }
    }
    return arrayAlert;
}
+(NSMutableDictionary*) createDiceEntityInfoWithClass:(Class) clazz hasDic:(BOOL*) hasDic{
    @synchronized(maptable){
        *hasDic = false;
        NSMutableDictionary *dicEntityInfo = [maptable objectForKey:clazz];
        if (!dicEntityInfo) {
            dicEntityInfo = [[NSMutableDictionary alloc] init];
            NSString *table = [clazz getTable];
            NSArray *colums = [clazz getColums];
            NSString *key = [clazz getKey];
            [dicEntityInfo setObject:table forKey:EM_MAP_ENTITY_TABLE];
            [dicEntityInfo setObject:NSStringFromClass(clazz) forKey:EM_MAP_ENTITY_ENTITY];
            [dicEntityInfo setObject:key forKey:EM_MAP_ENTITY_KEY];
            NSMutableDictionary *dicColum = [NSMutableDictionary new];
            for (id obj in colums) {
                NSString *columKey;
                NSString *property;
                NSString *type;
                [self checkColum:obj name:&columKey property:&property typeName:&type clazz:clazz ];
                if (columKey&&property&&type) {
                    [dicColum setObject:@{EM_MAP_ENTITY_COLUM_PROPERTY:property,EM_MAP_ENTITY_COLUM_TYPE:type} forKey:columKey];
                }
            }
            if ([[dicColum allKeys] count]) {
                [dicEntityInfo setObject:dicColum forKey:EM_MAP_ENTITY_COLUM];
            }
            [maptable setObject:dicEntityInfo forKey:clazz];
            *hasDic = true;
        }
        return dicEntityInfo;
    }
}
+(void) checkColum:(id) dicColum name:(NSString**) name property:(NSString**) property typeName:(NSString**) typeName clazz:(Class) clazz {
    if ([dicColum isKindOfClass:[NSString class]]) {
        if (name) {
            *name = dicColum;
        }
        if (property) {
            *property = dicColum;
        }
    }else if ([dicColum isKindOfClass:[NSDictionary class]]){
        if (name) {
            *name = [dicColum objectForKey:EM_MAP_ENTITY_COLUM_NAME];
        }
        if (property) {
            *property = [dicColum objectForKey:EM_MAP_ENTITY_COLUM_PROPERTY];
        }
    }
    if (*name&&*property) {
        Class typeCalzz = [ReflectClass getVarType:*property clazz:clazz];
        *typeName = NSStringFromClass(typeCalzz);
    }
}
+(NSString*) removeStartBlack:(NSString*) arg{
    const char *argc = [arg UTF8String];
    int index = 0;
    for (int i=0; i<arg.length; i++) {
        char c = argc[i];
        if (c!=' ') {
            index = i;
            break;
        }
    }
    return [arg substringFromIndex:index];
}

//+(void) setEntity:(id<ProtocolEntity>) entity property:(NSString*) property value:(id) value{
//    NSString *method = [NSString stringWithFormat:@"set%@%@:",[[[property substringToIndex:1] substringFromIndex:0] uppercaseString],[[property substringToIndex:property.length] substringFromIndex:1]];
//    SEL sel =  NSSelectorFromString(method);
//    if ([entity respondsToSelector:sel]) {
//        [entity performSelector:sel withObject:value];
//    }else{
//        printf("%s has no property that name is %s",[NSStringFromClass([entity class]) UTF8String],[property UTF8String]);
//    }
//}

@end
