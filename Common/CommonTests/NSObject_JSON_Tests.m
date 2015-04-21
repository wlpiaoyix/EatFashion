//
//  NSObject_JSON_Tests.m
//  Common
//
//  Created by wlpiaoyi on 15/1/12.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Expand.h"

@interface NSObject_JSON_Tests : XCTestCase<ProtocolObjectJson>
@property (nonatomic,strong) NSNumber *value1;
@property (nonatomic,strong) NSString *value2;

@end
@implementation NSObject_JSON_Tests

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
    NSObject_JSON_Tests *a = [NSObject_JSON_Tests instanceWithJson:@{@"value1":@1,@"value2":@"fff"}];
    NSDictionary *json = [a toInstanceJson];
    json = json;
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

+ (NSArray*) getJsonKeys{
    return @[@"value1",@"value2"];
}
@end
