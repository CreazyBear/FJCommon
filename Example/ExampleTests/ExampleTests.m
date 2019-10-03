//
//  ExampleTests.m
//  ExampleTests
//
//  Created by 熊伟 on 2019/10/3.
//  Copyright © 2019 熊伟. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+FJExtension.h"
#import "NSDate+FJUtilities.h"
#import "NSData+FJExtension.h"

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
    
    NSString * str = @"123456";
    NSData * data = [str fj_convertToHexStyleData];
    NSString * convertStr = [data fj_toHexString];
    NSInteger convertNum = [data fj_toUInt32];
    
    
    NSInteger hexInt = 0xfff;
    NSInteger intInt = hexInt;
    NSString * strHex = [NSString stringWithFormat:@"%lx",hexInt];
    NSData * convertData = [strHex fj_convertToHexStyleData];
    NSInteger reConvertInt = [convertData fj_toUInt32];
    
    
    NSData * utf8Data = [[NSData alloc] initWithBytes:str.UTF8String length:str.length];
    NSString * convertUTF8Str = [[NSString alloc] initWithData:utf8Data encoding:NSUTF8StringEncoding];
    
    NSLog(@"xxx");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
