//
//  ExampleTests.m
//  ExampleTests
//
//  Created by 熊伟 on 2019/10/3.
//  Copyright © 2019 熊伟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Utilities.h"


@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog([NSDate date].fj_shortString);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
