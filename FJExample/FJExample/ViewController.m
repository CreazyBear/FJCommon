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
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<FJInfiniteScrollViewDelegate>
@property  (nonatomic, strong) FJInfiniteScrollView *infiniteScrollView;
@end

@implementation ViewController

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
    self.title = @"FJInfiniteScrollView";
    
    CGRect frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 260);
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 2; ++i) {
        
        UIImageView *page = [UIImageView new];
        [page sd_setImageWithURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2019/10/07/13/39/cosmos-4532636_1280.jpg"]];
        page.frame = CGRectMake(0.f, 15.f, [UIScreen mainScreen].bounds.size.width, 230);
        page.contentMode = UIViewContentModeScaleAspectFit;
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d",i];
        label.frame = CGRectMake(0, 10, 100, 100);
        label.font = [UIFont fontWithName:@"Helvetica" size:100];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor blueColor]];
        label.center = page.center;
        [page addSubview:label];
        [imageViews addObject:page];
    }
    FJInfiniteScrollViewConfiguration * config = [FJInfiniteScrollViewConfiguration defaultConfig];
    config.pageViews = imageViews;
    config.backgroundColor = UIColor.blueColor;
    config.direction = FJInfiniteScrollDirectionFromLeftToRight;
    
    self.infiniteScrollView = [[FJInfiniteScrollView alloc] initWithFrame:frame config:config];
    self.infiniteScrollView.delegate = self;
    
    [self.view addSubview:self.infiniteScrollView];
    
    [self.infiniteScrollView startAutoScroll];

}


#pragma mark FJInfiniteScrollViewDelegate
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didClickIndex:(NSInteger)index{
    FJLog(@"%@",@(index));

}



@end
