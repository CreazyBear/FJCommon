//
//  ViewController.m
//  Example
//
//  Created by 熊伟 on 2019/10/3.
//  Copyright © 2019 熊伟. All rights reserved.
//

#import "ViewController.h"
#import <FJCommon/FJInfiniteScrollView.h>
#import <FJCommon/FJMacroCommon.h>

@interface ViewController ()<FJInfiniteScrollViewDelegate>
@property  (nonatomic, strong) FJInfiniteScrollView *infiniteScrollView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"FJInfiniteScrollView";
//    self.infiniteScrollView = [[FJInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260) contentSpacing:10];
//    self.infiniteScrollView.delegate = self;
//    self.infiniteScrollView.pageSize = CGSizeMake(535, 260);
//    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
//    for (int i = 1; i <= 6; ++i) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"page%d.jpg", i]];
//        UIImageView *page = [[UIImageView alloc] initWithImage:image];
//        page.frame = CGRectMake(0.f, 0.f, 535, 260);
//        page.contentMode = UIViewContentModeScaleAspectFill;
//        UILabel *label = [[UILabel alloc] init];
//        label.text = [NSString stringWithFormat:@"%d",i];
//        label.frame = CGRectMake(0, 0, 100, 100);
//        label.font = [UIFont fontWithName:@"Helvetica" size:100];
//        label.textAlignment = NSTextAlignmentCenter;
//        [label setTextColor:[UIColor whiteColor]];
//        label.center = page.center;
//        [page addSubview:label];
//        [imageViews addObject:page];
//    }
//    [self.infiniteScrollView addPageViews:imageViews];
//    [self.view addSubview:self.infiniteScrollView];
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollPageView) userInfo:nil repeats:YES];
//    [self.timer setFireDate:[NSDate distantPast]];

}

- (void)scrollPageView{
    [self.infiniteScrollView scrollToPreviousPage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FJInfiniteScrollViewDelegate
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didClickIndex:(int)index{
    FJLog(@"%@",@(index));

}



@end
