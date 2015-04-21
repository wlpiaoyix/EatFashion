//
//  FDEntityManagerTest.m
//  Common
//
//  Created by wlpiaoyi on 15/1/13.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

//
//  NSObject_JSON_Tests.m
//  Common
//
//  Created by wlpiaoyi on 15/1/12.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDEntityManager.h"
#import "EntityCallRecord.h"

@interface FDEntityManagerTest : XCTestCase
@property (nonatomic,strong) EntityCallRecord *entity;
@end
@implementation FDEntityManagerTest

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
    _entity = [EntityCallRecord new];
    _entity.contentId = @1;
    _entity.shopName = @"testName";
    _entity.remark = @"adfadf";
    _entity.isSyn = @YES;
    [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] merge:_entity];
    int key = _entity.keyId.intValue;
    EntityCallRecord *test = (EntityCallRecord*)[[FDEntityManager getSingleInstanceWithDBName:@"test.db"] find:[NSNumber numberWithInt:key] Clazz:[EntityCallRecord class]];
    NSDictionary *json = [test toInstanceJson];
    test = (EntityCallRecord*)[[FDEntityManager getSingleInstanceWithDBName:@"test.db"] find:[NSNumber numberWithInt:key] Clazz:[EntityCallRecord class]];
    test.shopName = @"fffff";
    [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] merge:test];
    
    test = (EntityCallRecord*)[[FDEntityManager getSingleInstanceWithDBName:@"test.db"] find:[NSNumber numberWithInt:key] Clazz:[EntityCallRecord class]];
    json = [test toInstanceJson];
    
    NSArray *array = [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] queryBySql:@"select c.* from EntityCallRecord c where c.keyId < ?" Params:@[@15]];
    for (NSDictionary *rc in array) {
        NSLog(@"%@",[rc JSONRepresentation]);
    }
    array = [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] queryBySql:@"select c.* from EntityCallRecord c where c.keyId < ?" Clazz:[EntityCallRecord class] Params:@[@18]];
    
    for (EntityCallRecord *rc in array) {
        json = [rc toInstanceJson];
        NSLog(@"%@",[json JSONRepresentation]);
    }
    [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] remove:[array objectAtIndex:2]];
    array = [[FDEntityManager getSingleInstanceWithDBName:@"test.db"] queryBySql:@"select c.* from EntityCallRecord c where c.keyId < ?" Params:@[@15]];
    for (NSDictionary *rc in array) {
        NSLog(@"%@",[rc JSONRepresentation]);
    }
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

