//
//  MTYPageMenu.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/7/17.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYPageMenu.h"
#import "UIView+MTYExtension.h"

/// Store responsiveness in bit field.
struct DelegateFlags {
    unsigned willDisplayPage : 1;
    unsigned didDisplayPage  : 1;
};

@interface MTYPageMenu () <UIScrollViewDelegate>

/// Interface
@property (nonatomic) MTYMenuView *menuView;
@property (nonatomic) MTYScrollView *contentView;
@property (nonatomic) struct DelegateFlags delegateFlags;

/// Managing Pages
@property (nonatomic) NSMutableIndexSet *displayedIndexSet;
@property (nonatomic) NSMutableDictionary<NSNumber *, UIViewController *> *childPages;
@property (nonatomic, readwrite) UIViewController *currentPage;
@property (nonatomic, readwrite) NSInteger currentIndex;
@property (nonatomic) CGFloat previousOffset;
@property (nonatomic) NSInteger intendIndex;

@property (nonatomic) NSInteger pageCount;
@property (nonatomic) BOOL didTapMenuView;
@property (nonatomic) BOOL willDisappear;  ///< Mark current child page will disappear state.
@property (nonatomic) BOOL willDidAppear;  ///< Mark page menu did already show.
@property (nonatomic) BOOL beyondRange;  ///< Mark whether scroll to content area.

@end

static const CGFloat MTYMenuViewHeight = 45;

@implementation MTYPageMenu

#pragma mark - Designated Initializer

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil option:(MTYPageMenuOption *)option {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _menuOption = option;
        [self _defaults];
        [self _registerForKVO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder option:(MTYPageMenuOption *)option {
    if (self = [super initWithCoder:aDecoder]) {
        _menuOption = option;
        [self _defaults];
        [self _registerForKVO];
    }
    return self;
}

#pragma mark - Convenience Initializer

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil option:MTYPageMenuOption.new];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCoder:aDecoder option:MTYPageMenuOption.new];
}

- (instancetype)initWithOption:(MTYPageMenuOption *)option {
    return [self initWithNibName:nil bundle:nil option:option];
}

- (instancetype)init {
    return [self initWithOption:MTYPageMenuOption.new];
}

#pragma mark - Life Period

- (void)dealloc {
    [self _unregisterFromKVO];
    _contentView.delegate = nil;
    MTYLog(@"MTYPageMenu released!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _setupContentView];
    [self _setupMenuView];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_currentPage beginAppearanceTransition:YES animated:animated];
    if (_delegateFlags.willDisplayPage) {
        [_delegate pageMenu:self willDisplayPage:_currentPage atIndex:_currentIndex];
    }
    _willDidAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_currentPage endAppearanceTransition];
    if (_delegateFlags.didDisplayPage) {
        [_delegate pageMenu:self didDisplayPage:_currentPage atIndex:_currentIndex];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_currentPage beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_currentPage endAppearanceTransition];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    /// Resize Content
    if ([_dataSource respondsToSelector:@selector(numberOfPagesInPageMenu:)]) {
        NSInteger numberOfPages = [_dataSource numberOfPagesInPageMenu:self];
        _currentPage.view.frame = CGRectMake(_currentIndex * _contentView.mty_width, 0, _contentView.mty_width, _contentView.mty_height);
        _contentView.contentSize = CGSizeMake(numberOfPages * _contentView.mty_width, 0);
        [_contentView setContentOffset:CGPointMake(_currentIndex * _contentView.mty_width, 0) animated:NO];
    }
    [self.view layoutIfNeeded];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    if ([_delegate respondsToSelector:@selector(pageMenu:didMoveToParentViewController:)]) {
        [_delegate pageMenu:self didMoveToParentViewController:parent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self _disposeResources];
}

#pragma mark - Private

- (void)_defaults {
    _startIndex = 0;
    _bounces = YES;
    _scrollEnabled = YES;
    _displayedOnNavigationBar = NO;
    _interactivePopGestureEnabled = NO;
    _appearanceStyle = MTYAppearanceStyleDisplayed;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _childPages = [[NSMutableDictionary alloc] init];
    _displayedIndexSet = [[NSMutableIndexSet alloc] init];
}

- (void)_registerForKVO {
    for (NSString *keyPath in [self _observableKeyPaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)_unregisterFromKVO {
    for (NSString *keyPath in [self _observableKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath context:NULL];
    }
}

- (NSArray *)_observableKeyPaths {
    return @[@"startIndex" ,@"bounces", @"scrollEnabled", @"interactivePopGestureEnabled", @"menuOption", @"grDelegate"];
}

- (void)_setupContentView {
    MTYScrollView *contentView = [[MTYScrollView alloc] init];
    contentView.grDelegate = self.grDelegate;
    contentView.delegate = self;
    contentView.scrollsToTop = NO;
    contentView.pagingEnabled = YES;
    contentView.bounces = self.bounces;
    contentView.scrollEnabled = self.scrollEnabled;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 11.0, *)) contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (_interactivePopGestureEnabled && self.navigationController.interactivePopGestureRecognizer) {
        [contentView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    self.contentView = contentView;
}

- (void)_setupMenuView {
    if (!_menuOption.showAnimatedView) return;
    
    MTYMenuView *menuView = [[MTYMenuView alloc] initWithFrame:CGRectZero option:_menuOption];
    menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    menuView.startIndex = self.startIndex;
    self.menuView = menuView;
    
    /// Tap menu view action.
    __weak typeof(self) wself = self;
    menuView.TapItemBlock = ^(NSInteger index) {
        if (wself.currentIndex == index) return;
        wself.intendIndex = index;
        wself.didTapMenuView = YES;
        
        [wself _processWhenTapMenuItem];
    };
}

- (void)_processMenuView {
    if (_menuOption.showMenuView && !_menuView) {
        [self _setupMenuView];
        [self _coordination];
    } else if (!_menuOption.showMenuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    } else {
        [_menuView resetMenuOption:_menuOption];
    }
}

- (void)_updateMenuView {
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_pageCount];
    for (int i = 0; i < _pageCount; ++i) {
        NSString *title = [_dataSource pageMenu:self titleForIndex:i];
        [titleArray addObject:title ?:@""];
    }
    self.menuView.menuTitles = titleArray;
}


- (void)_coordination {
    
    CGRect contentRect = CGRectZero;
    CGRect menuRect = CGRectMake(0, 0, self.view.mty_width, MTYMenuViewHeight);
    /// Preferred frame.
    if ([_dataSource respondsToSelector:@selector(pageMenu:preferredFrameForMenuView:)]) {
        menuRect = [_dataSource pageMenu:self preferredFrameForMenuView:_menuView];
    }
    if ([_dataSource respondsToSelector:@selector(pageMenu:preferredFrameForContentView:)]) {
        contentRect = [_dataSource pageMenu:self preferredFrameForContentView:_contentView];
    }
    _menuView.frame = menuRect;
    if (self.displayedOnNavigationBar) {
        if (@available(iOS 11.0, *)) {  /// Navigation bar use AutoLayout since iOS11.
            _menuView.translatesAutoresizingMaskIntoConstraints = NO;
            [_menuView.widthAnchor constraintEqualToConstant:menuRect.size.width].active = YES;
            [_menuView.heightAnchor constraintEqualToConstant:menuRect.size.height].active = YES;
        }
        self.contentView.frame = CGRectEqualToRect(contentRect, CGRectZero) ? self.view.bounds : contentRect;
        if (!_menuView.superview) self.navigationItem.titleView = _menuView;
        if (!_contentView.superview) [self.view addSubview:_contentView];
    } else {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(menuRect), self.view.mty_width, self.view.mty_height - menuRect.size.height);
        _contentView.frame = CGRectEqualToRect(contentRect, CGRectZero) ? frame : contentRect;
        if (!_contentView.superview) [self.view insertSubview:_contentView atIndex:0];
        if (!_menuView.superview) [self.view insertSubview:_menuView aboveSubview:_contentView];
    }
}

- (void)_disposeResources {
    NSDictionary *enumerator = [_childPages copy];
    for (NSNumber *number in enumerator) {
        NSInteger index = number.integerValue;
        if (index != _currentIndex) {
            [self _removePageAtIndex:index];
            [_childPages removeObjectForKey:number];
        }
    }
}

#pragma mark - Setter

- (void)setDataSource:(id<MTYPageMenuDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.isViewLoaded) {
        [self reloadData];
    }
}

- (void)setDelegate:(id<MTYPageMenuDelegate>)delegate {
    _delegate = delegate;
    _delegateFlags.willDisplayPage = [_delegate respondsToSelector:@selector(pageMenu:willDisplayPage:atIndex:)];
    _delegateFlags.didDisplayPage = [_delegate respondsToSelector:@selector(pageMenu:didDisplayPage:atIndex:)];
}

#pragma mark - Getter

- (NSDictionary<NSNumber *, __kindof UIViewController *> *)managedPages {
    return _childPages.copy;
}

#pragma mark - Managing Pages

- (void)_addPageAtIndex:(NSInteger)index {
    if (index < 0) return;
    if (index > _pageCount - 1) return;
    if ([self.displayedIndexSet containsIndex:index]) return;
    
    UIViewController *newPageVC = self.childPages[@(index)];
    if (!newPageVC) {
        newPageVC = [_dataSource pageMenu:self pageForIndex:index];
        NSAssert(newPageVC, @"page can't be nil!");
        self.childPages[@(index)] = newPageVC;
    }
    [newPageVC willMoveToParentViewController:self];
    newPageVC.view.frame = CGRectMake(index * self.contentView.mty_width, 0, self.contentView.mty_width, self.contentView.mty_height);
    [self addChildViewController:newPageVC];
    [self.contentView addSubview:newPageVC.view];
    [newPageVC didMoveToParentViewController:self];
    [self.displayedIndexSet addIndex:index];
}

- (void)_removePageAtIndex:(NSInteger)index {
    if (![self.displayedIndexSet containsIndex:index]) return;
    
    UIViewController *previousPageVC = self.childPages[@(index)];
    [previousPageVC willMoveToParentViewController:nil];
    [previousPageVC.view removeFromSuperview];
    [previousPageVC removeFromParentViewController];
    [previousPageVC didMoveToParentViewController:nil];
    [self.displayedIndexSet removeIndex:index];
}

- (void)_startCompleteAppearanceTransition {
    [_currentPage beginAppearanceTransition:YES animated:NO];
    if (_delegateFlags.willDisplayPage) {
        [_delegate pageMenu:self willDisplayPage:_currentPage atIndex:_currentIndex];
    }
    [_currentPage endAppearanceTransition];
    if (_delegateFlags.didDisplayPage) {
        [_delegate pageMenu:self didDisplayPage:_currentPage atIndex:_currentIndex];
    }
}

- (void)_processWhenEndScrolling {
    
    NSInteger newIndex = _contentView.contentOffset.x / _contentView.mty_width;
    if (newIndex == _currentIndex) {
        if (_willDisappear || !_beyondRange) [self _startCompleteAppearanceTransition];
    } else {
        NSInteger previousIndex = self.currentIndex;
        _currentIndex = newIndex;
        /// End appearance forwarding for previous page.
        [self _removePageAtIndex:previousIndex];
        UIViewController *previousPage = _childPages[@(previousIndex)];
        [previousPage endAppearanceTransition];
        
        /// Appearance forwarding for current page.
        _currentPage = _childPages[@(_currentIndex)];
        [self _startCompleteAppearanceTransition];
    }
    _willDisappear = NO;
    
    /// Remove all displayed pages from its' parent except current page.
    [_displayedIndexSet.copy enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.currentIndex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _removePageAtIndex:idx];
            });
        }
    }];
}

- (void)_processWhenTapMenuItem {
    /// Remove current page.
    [self _removePageAtIndex:_currentIndex];
    [_currentPage beginAppearanceTransition:NO animated:NO];
    [_currentPage endAppearanceTransition];
    
    /// Add new page.
    [self _addPageAtIndex:_intendIndex];
    _currentIndex = _intendIndex;
    _currentPage = _childPages[@(_intendIndex)];
    [self _startCompleteAppearanceTransition];
    [_contentView setContentOffset:CGPointMake(_contentView.mty_width * _intendIndex, 0) animated:NO];
}

- (void)_removeAllPages {
    NSDictionary *enumerator = [_childPages copy];
    for (NSNumber *index in enumerator) {
        [self _removePageAtIndex:index.integerValue];
        if (index.integerValue == _currentIndex) {
            UIViewController *childPage = _childPages[index];
            /// Appearance Forwarding
            if (!_willDisappear) [childPage beginAppearanceTransition:NO animated:NO];
            [childPage endAppearanceTransition];
        }
        [self.childPages removeObjectForKey:index];
    }
    _willDisappear = NO;
}

- (void)_reAddNewPage {
    _pageCount = [_dataSource numberOfPagesInPageMenu:self];
    if (_pageCount == 0) {
        MTYLog(@"Number of pages is zero!");
        return;
    }
    if (_startIndex > _pageCount - 1) {
        _startIndex = _pageCount - 1;
    }
    [self _addPageAtIndex:_startIndex];
    _currentIndex = self.startIndex;
    _currentPage = self.childPages[@(_currentIndex)];
    
    /// Mark need re-layout until next runloop, otherwise some process in viewDidLayoutSubviews won't be done.
    [self.view setNeedsLayout];
    /// If reload after page appearance called, we need control appearance forward by ourselves.
    if (_willDidAppear) [self _startCompleteAppearanceTransition];
}


#pragma mark - Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.isViewLoaded) return;
    
    if ([keyPath isEqualToString:@"startIndex"]) {
        _menuView.startIndex = self.startIndex;
    } else if ([keyPath isEqualToString:@"bounces"]) {
        _contentView.bounces = self.bounces;
    } else if ([keyPath isEqualToString:@"scrollEnabled"]) {
        _contentView.scrollEnabled = self.scrollEnabled;
    } else if ([keyPath isEqualToString:@"interactivePopGestureEnabled"]) {
        if (_interactivePopGestureEnabled && self.navigationController.interactivePopGestureRecognizer) {
            [_contentView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        }
    } else if ([keyPath isEqualToString:@"menuOption"]) {
        /// Hide menu view if need.
        [self _processMenuView];
    } else if ([keyPath isEqualToString:@"grDelegate"]) {
        _contentView.grDelegate = self.grDelegate;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != _contentView) return;
    _menuView.userInteractionEnabled = NO;
    _intendIndex = _currentIndex;
    _didTapMenuView = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != _contentView) return;
    if (decelerate) return;
    
    /// In this case scrollViewDidEndDecelerating: won't be called.
    [self _processWhenEndScrolling];
    _menuView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _contentView) return;
    if (self.didTapMenuView) return;
    
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger pItendIndex = _intendIndex;

    /// Update intend index according to scroll direction.
    if (_previousOffset < offset) {
        _intendIndex = ceil(offset / scrollView.mty_width);
    } else if (_previousOffset > offset) {
        _intendIndex = floor(offset / scrollView.mty_width);
    }
    if (_intendIndex >= 0 && _intendIndex < _pageCount) {
        /// Add page once it become visible if possible.
        if (_intendIndex != pItendIndex && _intendIndex != _currentIndex) {
            [self _addPageAtIndex:_intendIndex];
            
            /// Start appearance forwarding.
            if (!_willDisappear) {
                [_currentPage beginAppearanceTransition:NO animated:NO];
                _willDisappear = YES;
            }
        }
    }
    /// Update menu view progress.
    [_menuView updateWithProgress:offset / scrollView.mty_width];
    
    /// If start dragging before the last scroll decelerate, the horizontal translation of pan gesture may be zero.
    /// So do not use translationInView: to determine the relevant processing, because _intendIndex won't updated.
    _previousOffset = offset;

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _contentView) return;
    
    /// Mark whether beyond range before end decelerating, somehow keep dragging make it beyond range will change direction once before end.
    CGFloat offset = scrollView.contentOffset.x;
    _beyondRange = offset < 0 || offset > scrollView.mty_width * (_pageCount - 1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _contentView) return;
    
    //// Avoid repeated calls when the area is exceeded, because this situation will also decelerate.
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0 || offset > scrollView.mty_width * (_pageCount - 1)) return;
    
    _menuView.userInteractionEnabled = YES;
    /// Process appearance forwarding when scroll end.
    [self _processWhenEndScrolling];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView != _contentView) return;
}

#pragma mark - Appearance Callbacks

/**
 Taking over responsibility for appearance callbacks by override this method.
 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - Public

- (void)selectPageAtIndex:(NSInteger)index {
    if (!self.isViewLoaded) return;
    if (_currentIndex == index) return;
    if (index < 0 || index > _pageCount - 1) return;
    
    _intendIndex = index;
    _didTapMenuView = YES;   /// Avoid repeat process in scrollViewDidScroll:
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _processWhenTapMenuItem];
        [self.menuView selectItemAtIndex:self.currentIndex];
    });
}

- (void)resetOption:(MTYPageMenuOption *)option {
    if (!self.isViewLoaded) return;
    _menuOption = option;
    [self _processMenuView];
}

- (void)reloadData {
    if (![_dataSource respondsToSelector:@selector(numberOfPagesInPageMenu:)]) return;
    if (![_dataSource respondsToSelector:@selector(pageMenu:titleForIndex:)]) return;
    if (![_dataSource respondsToSelector:@selector(pageMenu:pageForIndex:)]) return;
    if (!self.isViewLoaded) return;
    
    /// Coordinate content view and menu view.
    [self _coordination];
    /// Remove all pages.
    [self _removeAllPages];
    /// Re-add Page.
    [self _reAddNewPage];
    
    /// Update menu view.
    [self _updateMenuView];
}

@end
