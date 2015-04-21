//
//  FDBObject.m
//  sdf
//
//  Created by wlpiaoyi on 14-3-25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FDObject.h"
#import "FMDatabase.h"
#import "ReflectClass.h"
#import "Common.h"
@implementation FDObject
+(Enum_EntityType) getEnumEnity:(Class) entity typeName:(NSString*) name{
    Class clazz = [ReflectClass getVarType:name clazz:entity];
    if (clazz==[NSNumber class]) {
        return 2;
    }
    if (clazz==[NSString class]) {
        return 3;
    }
    if (clazz==[NSData class]) {
        return 4;
    }
    return (int)1;
}
+(NSString*) getTableName:(Class<ProtocolEntity>) entity{
    NSString *table;
    if (class_getClassMethod(entity, @selector(getTable))) {
        table = [entity getTable];
    }else{
        table = [[NSString alloc] initWithCString:class_getName(entity) encoding:NSUTF8StringEncoding];
    }
    return table;
}
+(NSArray*) getColums:(Class<ProtocolEntity>) entity{
    NSArray *colums;
    if (class_getClassMethod(entity, @selector(getColums))) {
        colums = [entity getColums];
    }else{
        colums = [ReflectClass getAllPropertys:entity];
        [((NSMutableArray*)colums) removeObject:colums[0]];
    }
    
    return colums;
}
+(NSString*) getCreateSqlByEntity:(Class<ProtocolEntity>) entity{
    NSString *key = [entity getKey];
    NSString *table = [self getTableName:entity];
    NSArray *colums = [self getColums:entity];
    NSString *columsql = [self getCreateColums:colums clazz:entity];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT,%@)",table,key,columsql];
    return sql;
}

+(NSString*) getInsertSqlByEnityImpl:(id<ProtocolEntity>) entity{
    NSString *table = [self getTableName:[entity class]];
    NSArray *colums = [self getColums:[entity class]];
    NSArray *sqls = [self getInsertColums:colums Entity:entity];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES %@",table,((NSString*)sqls[0]),((NSString*)sqls[1])];
    return sql;
}

+(NSString*) getAddColumSqlByEnity:(Class<ProtocolEntity>) entity addColum:(NSString*) addColum{
    NSString *table = [self getTableName:entity];
    NSString *columsql = [self getCreateColums:@[addColum] clazz:entity];
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@",table,columsql];
    return sql;
}

+(NSArray*) getInsertColums:(NSArray*) colums Entity:(id<ProtocolEntity>) entity{
    NSString *columsql = nil;
    NSString *valuesql = @"(";
    for (NSString *arg in colums){
        id value = [((NSObject*)entity) valueForKey:arg];
        if (!value) {
            continue;
        }
        if ([value isKindOfClass:[NSString class]]) {
            if (![NSString isEnabled:value]) {
                continue;
            }
            value = [NSString stringWithFormat:@"'%@'",value];
        }
        
        if(columsql){
            columsql = [NSString stringWithFormat:@"%@,%@",columsql,arg];
            valuesql = [NSString stringWithFormat:@"%@,%@",valuesql,value];
        }else {
            columsql = arg;
            valuesql = [NSString stringWithFormat:@"%@%@",valuesql,value ];
        }
    }
    valuesql = [NSString stringWithFormat:@"%@%c",valuesql,')'];
    
    return [[NSArray alloc]initWithObjects:columsql,valuesql, nil];
}

+(NSString*) getInsertSqlByEnity:(Class<ProtocolEntity>) entity colums:(NSArray*) colums{
    NSString *table = [self getTableName:entity];
    NSArray *sqls = [self getInsertColums:colums];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES %@",table,((NSString*)sqls[0]),((NSString*)sqls[1])];
    return sql;
}


+(NSString*) getInsertSqlByEnity:(Class<ProtocolEntity>) entity{
    NSArray *colums = [self getColums:entity];
    return [self getInsertSqlByEnity:entity colums:colums];;
}
+(NSString*) getUpdateSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *key = [entity getKey];
    NSString *table = [self getTableName:entity];
    NSArray *colums = [self getColums:entity];
    NSString *sqls = [self getUpdateColums:colums];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?",table,sqls,key];
    return sql;
}

+(NSString*) getFindeSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *key = [entity getKey];
    NSString *table = [self getTableName:entity];
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",table,key];
}
+(NSString*) getDeleteSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *key = [entity getKey];
    NSString *table = [self getTableName:entity];
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",table,key];
}

+(NSString*) getUpdateColums:(NSArray*) colums{
    NSString *columsql = nil;
    for (NSString *arg in colums) {
        if (columsql) {
            columsql = [NSString stringWithFormat:@"%@,%@ = ?", columsql,arg];
        }else{
            columsql = [NSString stringWithFormat:@"%@ = ?",arg];
        }
    }
    return columsql;
}
+(NSArray*) getInsertColums:(NSArray*) colums{
    NSString *columsql = nil;
    NSString *valuesql = @"(";
    for (NSString *arg in colums){
        if(columsql){
            columsql = [NSString stringWithFormat:@"%@,%@",columsql,arg];
            valuesql = [NSString stringWithFormat:@"%@,%c",valuesql,'?'];
        }else {
            columsql = arg;
            valuesql = [NSString stringWithFormat:@"%@%c",valuesql,'?'];
        }
    }
    valuesql = [NSString stringWithFormat:@"%@%c",valuesql,')'];
    
    return [[NSArray alloc]initWithObjects:columsql,valuesql, nil];
}
+(NSString*) getCreateColums:(NSArray*) colums clazz:(Class) clazz{
    NSString *columsql = @"";
    int index = 0;
    for (NSString *arg in colums) {
        char* _type_ = "";
        switch ([self getEnumEnity:clazz typeName:arg]) {
            case 1:
                _type_ = "INTEGER";
                break;
            case 2:
                _type_ = "REAL";
                break;
            case 3:
                _type_ = "TEXT";
                break;
            case 4:
                _type_ = "BLOB";
                break;
            default:
                break;
        }
        size_t i = strlen(_type_);
        if(!i){
            printf("Can't find the type on index:%d",index);
            continue;
        }
        if(index==0){
            columsql = [NSString stringWithFormat:@"%@ %s",arg,_type_];
        }else{
            columsql = [NSString stringWithFormat:@"%@,%@ %s",columsql,arg,_type_];
        }
        index++;
    }
    return columsql;
}

+(NSString*) getTableStructByTableName:(NSString*) tableName{
    return [NSString stringWithFormat:@"select sql from sqlite_master where name = '%@'",tableName];
}
@end


