//
//  GokiGameAppTests.m
//  GokiGameAppTests
//
//  Created by 石毛 和夫 on 2014/09/27.
//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface GokiGameAppTests : XCTestCase

@end

@implementation GokiGameAppTests

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
