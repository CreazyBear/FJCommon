//
//  ViewController.m
//  Example
//
//  Created by 熊伟 on 2019/10/3.
//  Copyright © 2019 熊伟. All rights reserved.
//

#import "ViewController.h"
#import <NSString+FJExtension.h>
#import <NSData+FJExtension.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * str = @"123456";
    NSData * data = [str fj_convertToHexStyleData];
    NSString * convertStr = [data fj_toHexString];
    NSInteger convertNum = [data fj_toUInt32];
    
    NSLog(@"xxxx");
    
    
}


@end
