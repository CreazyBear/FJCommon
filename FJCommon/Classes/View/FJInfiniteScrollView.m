//
//  FJInfiniteScrollView.m
//  FJCommon
//
//  Created by 熊伟 on 2019/10/19.
//

#import "FJInfiniteScrollView.h"

@implementation FJInfiniteScrollViewConfiguration

+(instancetype)defaultConfig {
    FJInfiniteScrollViewConfiguration * config = [FJInfiniteScrollViewConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.direction = FJInfiniteScrollDirectionFromDownToUp;
//    config.direction = FJInfiniteScrollDirectionFromLeftToRight;
    config.autoScrollTimeInterval = 4;
    return config;
}

@end

@interface FJInfiniteScrollView ()

@property (nonatomic, strong) FJInfiniteScrollViewConfiguration *config;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) UIScrollView * innerScrollView;
@end

@implementation FJInfiniteScrollView

- (id)initWithFrame:(CGRect)frame
             config:(FJInfiniteScrollViewConfiguration*)config{
    
    self = [super init];
    if (self) {
        self.frame = frame;
        self.config = config;
        self.currentIndex = 0;
        self.backgroundColor = self.config.backgroundColor;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self configInnerScrollView];
        [self configPageViews];
        [self configNotify];

    }
    return self;
}

- (void)dealloc {
    self.innerScrollView.delegate = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPages];
}

#pragma mark - Public

-(void)startAutoScroll {
    if (self.config.pageViews.count < 2) {
        return;
    }
    [self stopAutoScroll];
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.config.autoScrollTimeInterval
                                                  target:self
                                                selector:@selector(scrollPageView)
                                                userInfo:nil
                                                 repeats:YES];
    [self.autoScrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.config.autoScrollTimeInterval]];
}

-(void)stopAutoScroll {
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)scrollToPreviousPage
{
    [self scrollToDirection:1 animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:)
               withObject:self.innerScrollView
               afterDelay:0.5f];
}

- (void)scrollToNextPage
{
    [self scrollToDirection:-1 animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:)
               withObject:self.innerScrollView
               afterDelay:0.5f];
}


#pragma mark - action
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tapRecognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteScrollView:didClickIndex:)]) {
        [self.delegate infiniteScrollView:self didClickIndex:self.currentIndex];
    }
}

#pragma mark - getter and setter
- (void)configInnerScrollView {
    self.innerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.innerScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.innerScrollView.delegate = self;
    self.innerScrollView.clipsToBounds = NO;
    self.innerScrollView.pagingEnabled = YES;
    self.innerScrollView.scrollEnabled = YES;
    self.innerScrollView.showsHorizontalScrollIndicator = NO;
    self.innerScrollView.showsVerticalScrollIndicator = NO;
    self.innerScrollView.scrollsToTop = NO;
    self.innerScrollView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.innerScrollView];

}

#pragma mark - Private
-(UIView*)copyView:(UIView*)view {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)configNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseAnimationTimer)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeAnimationTimer)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}


- (void)resumeAnimationTimer {
    if (self.autoScrollTimer) {
        [self.autoScrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.config.autoScrollTimeInterval]];
    }
}

- (void)pauseAnimationTimer {
    if (self.autoScrollTimer) {
        [self.autoScrollTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)scrollPageView {
    if (self.config.direction == FJInfiniteScrollDirectionFromLeftToRight) {
        [self scrollToPreviousPage];
    }
    else if (self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
        [self scrollToPreviousPage];
    }
    else if (self.config.direction == FJInfiniteScrollDirectionFromRightToLeft) {
        [self scrollToNextPage];
    }
    else if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp) {
        [self scrollToNextPage];
    }
}

- (void)configPageViews {
    
    if (self.config.pageViews.count <= 0) {
        return;
    }

    [self.leftView removeFromSuperview];
    [self.centerView removeFromSuperview];
    [self.rightView removeFromSuperview];
    self.leftView = nil;
    self.rightView = nil;
    self.centerView = nil;
    
    NSArray *scrollViewSubViews = [self.innerScrollView subviews];
    [scrollViewSubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self layoutPages];
}

- (void)layoutPages {
    
    if (self.config.pageViews.count <= 0) {
        return;
    }
    
    if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp ||
        self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
        if(self.config.pageViews.count == 1){
            self.innerScrollView.contentSize = self.innerScrollView.frame.size;
        }
        else {
            self.innerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), 3 * CGRectGetHeight(self.frame));
        }
        self.innerScrollView.contentOffset = CGPointMake(0.f , CGRectGetHeight(self.frame));
    }
    else {
        if(self.config.pageViews.count == 1){
            self.innerScrollView.contentSize = self.innerScrollView.frame.size;
        }
        else {
            self.innerScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        self.innerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame) , 0.f);
    }
    if(self.config.pageViews.count == 1){
        self.leftView = [[UIView alloc] initWithFrame:self.bounds];
        self.leftView = self.config.pageViews.firstObject;
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1;
        singleFingerOne.numberOfTapsRequired = 1;
        singleFingerOne.delegate = self;
        [self.leftView addGestureRecognizer:singleFingerOne];
    }
    else if(self.config.pageViews.count == 2){
        self.centerView = [[UIView alloc] initWithFrame:self.bounds];
        self.rightView = [[UIView alloc] initWithFrame:self.bounds];
        self.leftView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self.rightView addSubview:[self copyView:self.config.pageViews[1]]];
        [self.leftView addSubview:self.config.pageViews[1]];
        [self.centerView addSubview:self.config.pageViews[0]];
        
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1;
        singleFingerOne.numberOfTapsRequired = 1;
        singleFingerOne.delegate = self;
        [self.centerView addGestureRecognizer:singleFingerOne];
    }
    else {
        self.centerView = [[UIView alloc] initWithFrame:self.bounds];
        self.rightView = [[UIView alloc] initWithFrame:self.bounds];
        self.leftView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self.leftView addSubview: self.config.pageViews.lastObject];
        [self.centerView addSubview: self.config.pageViews[0]];
        [self.rightView addSubview: self.config.pageViews[1]];
            
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1;
        singleFingerOne.numberOfTapsRequired = 1;
        singleFingerOne.delegate = self;
        [self.centerView addGestureRecognizer:singleFingerOne];
    }
    
    if(self.config.pageViews.count == 1){
        [self.innerScrollView addSubview:self.leftView];
        self.leftView.center = self.innerScrollView.center;
    }
    else {
        [self.innerScrollView addSubview:self.centerView];
        [self.innerScrollView addSubview:self.rightView];
        [self.innerScrollView addSubview:self.leftView];
        
        if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp ||
            self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
            
            self.leftView.center =  CGPointMake(self.innerScrollView.center.x , self.innerScrollView.frame.size.height/2);
            self.centerView.center = CGPointMake(self.innerScrollView.center.x , self.innerScrollView.frame.size.height*1.5);
            self.rightView.center = CGPointMake(self.innerScrollView.center.x , self.innerScrollView.frame.size.height*2.5);
        }
        else {
            self.leftView.center =  CGPointMake(self.innerScrollView.frame.size.width/2 , self.innerScrollView.center.y);
            self.centerView.center = CGPointMake(self.innerScrollView.frame.size.width*1.5 , self.innerScrollView.center.y);
            self.rightView.center = CGPointMake(self.innerScrollView.frame.size.width*2.5 , self.innerScrollView.center.y);
        }
    }

}

- (void)scrollToDirection:(NSInteger)moveDirection
                 animated:(BOOL)animated {
    
    CGRect adjustScrollRect;
    
    
    if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp ||
        self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
        
        if (0 != fmodf(self.innerScrollView.contentOffset.y, CGRectGetHeight(self.innerScrollView.frame))) return ;
        adjustScrollRect = CGRectMake(self.innerScrollView.contentOffset.x,
                                      self.innerScrollView.contentOffset.y - CGRectGetHeight(self.innerScrollView.frame) * moveDirection,
                                      self.innerScrollView.frame.size.width,
                                      self.innerScrollView.frame.size.height);
    }
    else {
        if (0 != fmodf(self.innerScrollView.contentOffset.x, CGRectGetWidth(self.innerScrollView.frame))) return ;
        adjustScrollRect = CGRectMake(self.innerScrollView.contentOffset.x - CGRectGetWidth(self.innerScrollView.frame) * moveDirection,
                                      self.innerScrollView.contentOffset.y,
                                      self.innerScrollView.frame.size.width,
                                      self.innerScrollView.frame.size.height);
    }
    

    [self.innerScrollView scrollRectToVisible:adjustScrollRect animated:animated];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self pauseAnimationTimer];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteScrollView:willBeginDragging:)]) {
        [self.delegate infiniteScrollView:self willBeginDragging:self.innerScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resumeAnimationTimer];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteScrollView:didEndDragging:)]) {
        [self.delegate infiniteScrollView:self didEndDragging:self.innerScrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteScrollView:didScroll:)]) {
        [self.delegate infiniteScrollView:self didScroll:self.innerScrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self pauseAnimationTimer];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infiniteScrollView:willBeginDecelerating:)]) {
        [self.delegate infiniteScrollView:self willBeginDecelerating:self.innerScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger pageCount = self.config.pageViews.count;
    if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp ||
        self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
        
        CGFloat deltaOffset = scrollView.contentOffset.y - scrollView.bounds.size.height;
        if (deltaOffset < 0) {//上滑
            self.currentIndex = (self.currentIndex - 1 + pageCount) % pageCount;
        }
        else if(deltaOffset > 0) {
            self.currentIndex = (self.currentIndex + 1 + pageCount) % pageCount;
        }
    }
    else {
        CGFloat deltaOffset = scrollView.contentOffset.x - scrollView.bounds.size.width;
        if (deltaOffset < 0) {//左滑
            self.currentIndex = (self.currentIndex - 1 + pageCount) % pageCount;
        }
        else if(deltaOffset > 0) {
            self.currentIndex = (self.currentIndex + 1 + pageCount) % pageCount;
        }
    }

    [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.centerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if(self.config.pageViews.count == 2){
        if (self.currentIndex == 0) {
            [self.leftView addSubview:self.config.pageViews[1]];
            [self.rightView addSubview:[self copyView:self.config.pageViews[1]]];
        }
        else {
            [self.leftView addSubview:self.config.pageViews[0]];
            [self.rightView addSubview:[self copyView:self.config.pageViews[0]]];
        }
        [self.centerView addSubview:self.config.pageViews[self.currentIndex]];
    }
    else {
        if (self.currentIndex == 0) {
            [self.leftView addSubview: self.config.pageViews.lastObject];
            [self.rightView addSubview: self.config.pageViews[self.currentIndex + 1]];
        }
        else if (self.currentIndex == self.config.pageViews.count - 1) {
            [self.leftView addSubview: self.config.pageViews[self.currentIndex -1]];
            [self.rightView addSubview: self.config.pageViews[0]];
        }
        else {
            [self.rightView addSubview: self.config.pageViews[self.currentIndex + 1]];
            [self.leftView addSubview: self.config.pageViews[self.currentIndex -1]];
        }
        [self.centerView addSubview: self.config.pageViews[self.currentIndex]];
    }
    
    if (self.config.direction == FJInfiniteScrollDirectionFromDownToUp ||
        self.config.direction == FJInfiniteScrollDirectionFromUpToDown) {
        self.innerScrollView.contentOffset = CGPointMake(0.f , CGRectGetHeight(self.frame));
    }
    else {
        self.innerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame) , 0.f);
    }
    
    [self resumeAnimationTimer];
}



@end
