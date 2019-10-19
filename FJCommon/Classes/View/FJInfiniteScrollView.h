//
//  FJInfiniteScrollView.h
//  FJCommon
//
//  Created by 熊伟 on 2019/10/19.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FJInfiniteScrollDirection) {
    FJInfiniteScrollDirectionFromLeftToRight,
    FJInfiniteScrollDirectionFromRightToLeft,
    FJInfiniteScrollDirectionFromUpToDown,
    FJInfiniteScrollDirectionFromDownToUp
};


@class FJInfiniteScrollView;

@protocol FJInfiniteScrollViewDelegate <NSObject>
@optional
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView willBeginDragging:(UIScrollView *)scrollView;
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didScroll:(UIScrollView *)scrollView;
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didEndDragging:(UIScrollView *)scrollView;
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView willBeginDecelerating:(UIScrollView *)scrollView;
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didEndDecelerating:(UIScrollView *)scrollView ;
- (void)infiniteScrollView:(FJInfiniteScrollView *)infiniteScrollView didClickIndex:(NSInteger)index;
@end

@interface FJInfiniteScrollViewConfiguration : NSObject
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSArray<UIView*> * pageViews;
@property (nonatomic, assign) FJInfiniteScrollDirection direction;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
+(instancetype)defaultConfig;

@end


@interface FJInfiniteScrollView : UIView <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<FJInfiniteScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
             config:(FJInfiniteScrollViewConfiguration*)config;


/// 如果你调用了这个方法，那在页面退出的时候，也需要调用stop。内部会开启一个计时器
- (void)startAutoScroll;

-(void)stopAutoScroll;

- (void)scrollToPreviousPage;

- (void)scrollToNextPage;

@end

