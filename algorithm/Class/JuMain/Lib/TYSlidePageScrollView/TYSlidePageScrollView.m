//
//  TYSlidePageScrollView.m
//  TYSlidePageScrollViewDemo
//
//  Created by tanyang on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TYSlidePageScrollView.h"
#import "UIScrollView+ty_swizzle.h"

@interface TYBasePageTabBar ()
@property (nonatomic, weak) id<TYBasePageTabBarPrivateDelegate> praviteDelegate;
@end

@interface TYSlidePageScrollView ()<UIScrollViewDelegate,TYBasePageTabBarPrivateDelegate>{
    struct {
        unsigned int horizenScrollToPageIndex   :1;
        unsigned int horizenScrollViewDidScroll :1;
        unsigned int horizenScrollViewDidEndDecelerating :1;
        unsigned int horizenScrollViewWillBeginDragging :1;
        unsigned int verticalScrollViewDidScroll :1;
        unsigned int pageTabBarScrollOffset :1;
    }_delegateFlags;
}

@property (nonatomic, weak) UIScrollView    *horScrollView;     // horizen scroll View
@property (nonatomic, weak) UIView          *headerContentView; // contain header and pageTab
@property (nonatomic, strong) NSArray       *pageViewArray;
@property(nonatomic, strong) NSArray *childViewArray;


@property (nonatomic,assign) BOOL isForbiden;
@property (nonatomic,assign) CGFloat moveHeight;

@property (nonatomic,assign) CGFloat headContentViewY;

@property (nonatomic,assign) CGFloat scrollViewContentOffsetY;
@end

@implementation TYSlidePageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setPropertys];
        
        [self addHorScrollView];
        
        [self addHeaderContentView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setPropertys];
        
        [self addHorScrollView];
        
        [self addHeaderContentView];
    }
    return self;
}

#pragma mark - setter getter

- (void)setPropertys
{
    _curPageIndex = 0;
    _pageTabBarStopOnTopHeight = 0;
    _pageTabBarIsStopOnTop = YES;
    _automaticallyAdjustsScrollViewInsets = NO;
    _changeToNextIndexWhenScrollToWidthOfPercent = 0.5;
}

- (void)resetPropertys
{
    [self addPageViewKeyPathOffsetWithOldIndex:_curPageIndex newIndex:-1];
//    _curPageIndex = 0;
    [_headerContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_footerView removeFromSuperview];
    [_childViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setDelegate:(id<TYSlidePageScrollViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.horizenScrollToPageIndex = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollToPageIndex:)];
    _delegateFlags.horizenScrollViewDidScroll = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewDidScroll:)];
    _delegateFlags.horizenScrollViewDidEndDecelerating = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewDidEndDecelerating:)];
    _delegateFlags.horizenScrollViewWillBeginDragging = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewWillBeginDragging:)];
    _delegateFlags.verticalScrollViewDidScroll = [delegate respondsToSelector:@selector(slidePageScrollView:verticalScrollViewDidScroll:)];
    _delegateFlags.pageTabBarScrollOffset = [delegate respondsToSelector:@selector(slidePageScrollView:pageTabBarScrollOffset:state:)];
}

#pragma mark - add subView

- (void)addHorScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    
    scrollView.scrollEnabled = NO;
    
    [self addSubview:scrollView];
    _horScrollView = scrollView;
}

- (void)addHeaderContentView
{
    UIView *headerContentView = [[UIView alloc]init];
    [self addSubview:headerContentView];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panACtion:)];
    [headerContentView addGestureRecognizer:gesture];
    _headerContentView = headerContentView;
}

#pragma mark - private method

-(void)panACtion:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self];
    
    UIScrollView *scrollView = self.pageViewArray[_curPageIndex];
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            self.isForbiden = YES;
            self.moveHeight = 0;
            self.scrollViewContentOffsetY = scrollView.contentOffset.y;
            
            self.headContentViewY = _headerContentView.frame.origin.y;
            
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            
            self.moveHeight = self.moveHeight - point.y;
            
            CGPoint changePoint = CGPointMake(scrollView.contentOffset.x, self.scrollViewContentOffsetY+self.moveHeight);
            
            if (self.headContentViewY-self.moveHeight<= 0 && self.headContentViewY-self.moveHeight>= -(self.headerContentView.bounds.size.height-self.pageTabBarStopOnTopHeight-self.pageTabBar.bounds.size.height) ) {
                
                [scrollView setContentOffset:changePoint];
                _headerContentView.frame = CGRectMake(_headerContentView.frame.origin.x, self.headContentViewY-self.moveHeight, _headerContentView.frame.size.width, _headerContentView.frame.size.height);
                
            }
            
            
            NSLog(@"%f", self.moveHeight);
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        UIGestureRecognizerStateCancelled:
        UIGestureRecognizerStateFailed:{
            
            self.isForbiden = NO;
            self.moveHeight = 0;
            
            [self pageScrollViewDidScroll:scrollView changeOtherPageViews:NO];
            
            break;
        }
            
            
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:self];
}

- (void)setViewControllerAdjustsScrollView
{
    UIViewController *viewController = [self viewController];
    if ([viewController respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        viewController.automaticallyAdjustsScrollViewInsets = _automaticallyAdjustsScrollViewInsets;
    }
}

- (void)updateHeaderContentView
{
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat headerContentViewHieght = 0;
    
    if (_headerView) {
        _headerView.frame = CGRectMake(0, 0, viewWidth, CGRectGetHeight(_headerView.frame));
        [_headerContentView addSubview:_headerView];
        headerContentViewHieght += CGRectGetHeight(_headerView.frame);
    }
    
    if (_pageTabBar) {
        _pageTabBar.praviteDelegate = self;
        _pageTabBar.frame = CGRectMake(0, headerContentViewHieght, viewWidth, CGRectGetHeight(_pageTabBar.frame));
        [_headerContentView addSubview:_pageTabBar];
        headerContentViewHieght += CGRectGetHeight(_pageTabBar.frame);
    }
    
    _headerContentView.frame = CGRectMake(0, 0, viewWidth, headerContentViewHieght);
}

- (void)updateFooterView
{
    if (_footerView) {
        CGFloat footerViewY = CGRectGetHeight(self.frame)-CGRectGetHeight(_footerView.frame);
        _footerView.frame = CGRectMake(0, footerViewY, CGRectGetWidth(self.frame), CGRectGetHeight(_footerView.frame));
        [self addSubview:_footerView];
    }
}

- (void)updatePageViews
{
    _horScrollView.frame = self.bounds;
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHight = CGRectGetHeight(self.frame);
    CGFloat headerContentViewHieght = CGRectGetHeight(_headerContentView.frame);
    CGFloat footerViewHieght = CGRectGetHeight(_footerView.frame);
    
    NSInteger pageNum = [_dataSource numberOfPageViewOnSlidePageScrollView];
    NSMutableArray *scrollViewArray = [NSMutableArray arrayWithCapacity:pageNum];
    NSMutableArray *childViewArray = [NSMutableArray arrayWithCapacity:pageNum];
    
    for (NSInteger index = 0; index < pageNum; ++index) {
        UIScrollView *pageVerScrollView = [_dataSource slidePageScrollView:self pageVerticalScrollViewForIndex:index];
        UIView *childView = [_dataSource slidePageChildView:self pageVerticalScrollViewForIndex:index];
        
        
        
        
        childView.frame = CGRectMake(index * viewWidth, 0, viewWidth, viewHight);
        [_horScrollView addSubview:childView];
        [scrollViewArray addObject:pageVerScrollView];
        [childViewArray addObject:childView];
        
        pageVerScrollView.contentInset = UIEdgeInsetsMake(headerContentViewHieght, 0, footerViewHieght, 0);
        pageVerScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(headerContentViewHieght, 0, footerViewHieght, 0);
    }
    
    _pageViewArray = [scrollViewArray copy];
    _childViewArray = [childViewArray copy];
    _horScrollView.contentSize = CGSizeMake(viewWidth*pageNum, 0);

}

- (void)addPageViewKeyPathOffsetWithOldIndex:(NSInteger)oldIndex newIndex:(NSInteger)newIndex
{
    if (oldIndex == newIndex) {
        return;
    }
    
    if (oldIndex >= 0 && oldIndex < _pageViewArray.count) {
        [_pageViewArray[oldIndex] removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    if (newIndex >= 0 && newIndex < _pageViewArray.count) {
        [_pageViewArray[newIndex] addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self pageScrollViewDidScroll:object changeOtherPageViews:NO];
    }
}

- (CGFloat)scrollViewMinContentSizeHeight
{
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat pageTabBarHieght = CGRectGetHeight(_pageTabBar.frame);
    CGFloat footerHeight = CGRectGetHeight(_footerView.frame);
    
    NSInteger scrollMinContentSizeHeight = viewHeight - (pageTabBarHieght + _pageTabBarStopOnTopHeight + footerHeight);
    
    if (!_pageTabBarIsStopOnTop) {
        scrollMinContentSizeHeight = viewHeight - footerHeight;
    }
    return scrollMinContentSizeHeight;
}

- (void)dealPageScrollViewMinContentSize:(UIScrollView *)pageScrollView
{
    NSInteger scrollMinContentSizeHeight = [self scrollViewMinContentSizeHeight];
    pageScrollView.minContentSizeHeight = scrollMinContentSizeHeight;
    
    if (pageScrollView.contentSize.height < scrollMinContentSizeHeight) {
        pageScrollView.contentSize = CGSizeMake(pageScrollView.contentSize.width, scrollMinContentSizeHeight);
    }
}

- (void)dealAllPageScrollViewMinContentSize
{
    // 处理所有scrollView contentsize
    [_pageViewArray enumerateObjectsUsingBlock:^(UIScrollView *obj, NSUInteger idx, BOOL *stop) {
        [self dealPageScrollViewMinContentSize:obj];
    }];
}

- (void)changeAllPageScrollViewOffsetY:(CGFloat)offsetY isOnTop:(BOOL)isOnTop
{
    [_pageViewArray enumerateObjectsUsingBlock:^(UIScrollView *pageScrollView, NSUInteger idx, BOOL *stop) {
        if (idx != _curPageIndex && !(isOnTop && pageScrollView.contentOffset.y > offsetY)) {
            [pageScrollView setContentOffset:CGPointMake(pageScrollView.contentOffset.x, offsetY)];
        }
    }];
}

- (void)resetPageScrollViewContentOffset
{
    if (_curPageIndex >= 0 && _curPageIndex < _pageViewArray.count) {
        UIScrollView *pagescrollView = _pageViewArray[_curPageIndex];
        pagescrollView.contentOffset = CGPointMake(pagescrollView.contentOffset.x, -CGRectGetHeight(_headerContentView.frame));
    }
}

#pragma mark - public method

- (void)reloadData
{
    [self resetPropertys];
    
    [self setViewControllerAdjustsScrollView];
    
    [self updateHeaderContentView];
    
    [self updateFooterView];
    
    [self updatePageViews];
    
    [self addPageViewKeyPathOffsetWithOldIndex:-1 newIndex:_curPageIndex];
    
    [self dealAllPageScrollViewMinContentSize];
    
    [self resetPageScrollViewContentOffset];
}

- (void)scrollToPageIndex:(NSInteger)index nimated:(BOOL)animated
{
    if (index < 0 || index >= _pageViewArray.count) {
        NSLog(@"scrollToPageIndex index illegal");
        return;
    }
    
    [self pageScrollViewDidScroll:_pageViewArray[_curPageIndex] changeOtherPageViews:YES];
    
    [_horScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(_horScrollView.frame), 0) animated:animated];
}

- (UIScrollView *)pageScrollViewForIndex:(NSInteger)index
{
    if (index < 0 || index >= _pageViewArray.count) {
        NSLog(@"pageScrollViewForIndex index illegal");
        return nil;
    }
    
    return _pageViewArray[index];
}

- (NSInteger)indexOfPageScrollView:(UIScrollView *)pageScrollView
{
    return [_pageViewArray indexOfObject:pageScrollView];
}

#pragma mark - delegate
// horizen scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewWillBeginDragging) {
        [_delegate slidePageScrollView:self horizenScrollViewWillBeginDragging:scrollView];
    }
    
    [self pageScrollViewDidScroll:_pageViewArray[_curPageIndex] changeOtherPageViews:YES];
}

// horizen scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewDidScroll) {
        [_delegate slidePageScrollView:self horizenScrollViewDidScroll:_horScrollView];
    }
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame) + _changeToNextIndexWhenScrollToWidthOfPercent);
    
    if (_curPageIndex != index) {
        if (index >= _pageViewArray.count) {
            index = _pageViewArray.count-1;
        }
        if (index < 0) {
            index = 0;
        }
        
        [self addPageViewKeyPathOffsetWithOldIndex:_curPageIndex newIndex:index];
        _curPageIndex = index;
        
        if (_pageTabBar) {
            [_pageTabBar switchToPageIndex:_curPageIndex];
        }
        if (_delegateFlags.horizenScrollToPageIndex) {
            [_delegate slidePageScrollView:self horizenScrollToPageIndex:_curPageIndex];
        }
    }
}

// page scrollView
- (void)pageScrollViewDidScroll:(UIScrollView *)pageScrollView changeOtherPageViews:(BOOL)isNeedChange
{
    if (_delegateFlags.verticalScrollViewDidScroll) {
        [_delegate slidePageScrollView:self verticalScrollViewDidScroll:pageScrollView];
    }
    
    CGFloat headerContentViewheight = CGRectGetHeight(_headerContentView.frame);
    CGFloat pageTabBarHieght = CGRectGetHeight(_pageTabBar.frame);
    
    NSInteger pageTabBarIsStopOnTop = _pageTabBarStopOnTopHeight;
    if (!_pageTabBarIsStopOnTop) {
        pageTabBarIsStopOnTop = - pageTabBarHieght;
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat offsetY = pageScrollView.contentOffset.y;
    if (offsetY <= -headerContentViewheight) {
        // headerContentView full show
        CGRect frame = CGRectMake(0, 0, viewWidth, headerContentViewheight);
        if (!CGRectEqualToRect(_headerContentView.frame, frame)) {
            _headerContentView.frame = frame;

            if (_delegateFlags.pageTabBarScrollOffset) {
                [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateStopOnButtom];
            }
        }
        
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:-headerContentViewheight isOnTop:NO];
        }
    }else if (offsetY < -pageTabBarHieght - pageTabBarIsStopOnTop) {
        // scroll headerContentView
        CGRect frame = CGRectMake(0, -(offsetY+headerContentViewheight), viewWidth, headerContentViewheight);
        _headerContentView.frame = frame;
        
        if (_delegateFlags.pageTabBarScrollOffset) {
            [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateScrolling];
        }
        
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:pageScrollView.contentOffset.y isOnTop:NO];
        }
        
    }else {
        // pageTabBar on the top
        CGRect frame = CGRectMake(0, -headerContentViewheight+pageTabBarHieght + pageTabBarIsStopOnTop, viewWidth, headerContentViewheight);
        if (!CGRectEqualToRect(_headerContentView.frame, frame)) {
            _headerContentView.frame = frame;

            if (_delegateFlags.pageTabBarScrollOffset) {
                [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateStopOnTop];
            }
        }
        
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:-pageTabBarHieght-pageTabBarIsStopOnTop isOnTop:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewDidEndDecelerating) {
        [_delegate slidePageScrollView:self horizenScrollViewDidEndDecelerating:_horScrollView];
    }
}

- (void)basePageTabBar:(TYBasePageTabBar *)basePageTabBar clickedPageTabBarAtIndex:(NSInteger)index
{
    [self scrollToPageIndex:index nimated:NO];
}

-(void)dealloc
{
    [self resetPropertys];
}

@end
