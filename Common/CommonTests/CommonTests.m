//
//  CommonTests.m
//  CommonTests
//
//  Created by wlpiaoyi on 14/12/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "RegexPredicate.h"
#import "NSObject+Expand.h"

@interface CommonTests : XCTestCase

@end
@interface testEntity : NSObject <ProtocolObjectJson>
@property (nonatomic,strong) NSString *keyId;
@property (nonatomic,strong) NSString *keyValue;
@property (nonatomic,strong) testEntity *entity;
@property (nonatomic,strong) NSArray *entitys;

@end

@implementation testEntity

+ (NSArray*) getJsonKeys{
    return @[@{JSON_KEY:@"jsonKey",JSON_PROPERTY:@"keyId"},
             @{JSON_KEY:@"jsonvlaue",JSON_PROPERTY:@"keyValue"},
             @{JSON_KEY:@"jsonentity",JSON_PROPERTY:@"entity",JSON_PROPERTY_CLASS:[testEntity class]},
             @{JSON_KEY:@"jsonentitys",JSON_PROPERTY:@"entitys",JSON_PROPERTY_CLASS:[testEntity class]}];
}

@end

@implementation CommonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    testEntity *entity = [testEntity new];
    entity.keyId = @"1";
    entity.keyValue = @"t";
    testEntity *entity1 = [testEntity instanceWithJson:[entity toInstanceJson]];
    testEntity *entity2 = [testEntity instanceWithJson:[entity toInstanceJson]];
    testEntity *entity3 = [testEntity instanceWithJson:[entity toInstanceJson]];
    entity.entity = entity3;
    entity.entitys = @[entity1,entity2];
    NSDictionary *json = [entity toInstanceJson];
    
    entity = nil;
    entity = [testEntity instanceWithJson:json];
    
    
    BOOL flag = [RegexPredicate matchFloat:@"123.44"];
    flag = [RegexPredicate matchFloat:@"1234"];
    flag = [RegexPredicate matchInteger:@"123.4"];
    flag = [RegexPredicate matchInteger:@"1234"];
    flag = [RegexPredicate matchMobliePhone:@"18228088049"];
    flag = [RegexPredicate matchMobliePhone:@"38228088049"];
    flag = [RegexPredicate matchMobliePhone:@"1822808804"];
    flag = [RegexPredicate matchMobliePhone:@"+8618228088042"];
    flag = [RegexPredicate matchHomePhone:@"6585294"];
    flag = [RegexPredicate matchHomePhone:@"028-6585294"];
    flag = [RegexPredicate matchHomePhone:@"-6585294"];
    flag = [RegexPredicate matchHomePhone:@"G6585294"];
    flag = [RegexPredicate matchEmail:@"qqpiaoyi@126.com"];
    flag = [RegexPredicate matchEmail:@"126.com"];
    flag = [RegexPredicate matchEmail:@"afaf@126"];
    flag = [RegexPredicate matchEmail:@"qqpiaoyi@eei.com"];
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

