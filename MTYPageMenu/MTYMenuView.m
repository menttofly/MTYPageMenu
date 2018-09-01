//
//  MTYMenuView.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYMenuView.h"
#import "MTYMenuItem.h"
#import "MTYAnimatedView.h"
#import "MTYPageMenuOption.h"
#import "UIView+MTYExtension.h"

@interface MTYMenuView () <MTYMenuItemDelegate>

/// Rewrite
@property (nonatomic, readwrite) NSInteger selectedIndex;

/// Interface
@property (nonatomic) UIScrollView *scrollView;  ///< UICollectionView will also work.
@property (nonatomic) MTYPageMenuOption *option;
@property (nonatomic) MTYMenuItem *selectedItem;
@property (nonatomic) MTYAnimatedView *animatedView;
@property (nonatomic) NSMutableArray<MTYMenuItem *> *menuItems;
@property (nonatomic) NSMutableArray<NSValue *> *itemFrames;

@end

@implementation MTYMenuView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame option:(MTYPageMenuOption *)option {
    if (self = [super initWithFrame:frame]) {
        _option = option;
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame option:MTYPageMenuOption.new];
}

#pragma mark - Life Period

- (void)dealloc {
    MTYLog(@"MTYMenuView released!");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _layoutItems];
    [self _layoutAnimatedView];
    /// Make sure if start index exceed half width of scroll view, can also automatic distribute.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _distributeNaturally];
    });
}

#pragma mark - Private

- (void)_setup {
    self.menuItems = [[NSMutableArray alloc] init];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 11.0, *)) scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentInset = _option.contentInset;
    scrollView.scrollsToTop = NO;
    scrollView.bounces = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (!_option.showAnimatedView) return;
    [self _setupAnimatedView];
}

- (void)_setupAnimatedView {
    self.animatedView = [[MTYAnimatedView alloc] initWithFrame:CGRectZero];
    _animatedView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self _configureAnimatedView:_option];
    [_scrollView insertSubview:_animatedView atIndex:0];
}

- (void)_removeAllItems {
    for (MTYMenuItem *item in self.menuItems) {
        [item removeFromSuperview];
    }
    [self.menuItems removeAllObjects];
    [self.itemFrames removeAllObjects];
    _scrollView.contentSize = CGSizeZero;
}

- (void)_setupNewItems {
    if (!_menuTitles || !_menuTitles.count) return;
    
    for (int index = 0; index < _menuTitles.count; ++index) {
        NSString *title = _menuTitles[index];
        MTYMenuItem *item = [[MTYMenuItem alloc] initWithFrame:CGRectZero];
        item.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        item.text = title;
        item.textColor = _option.titleColor;
        item.delegate = self;
        [self _configureItem:item with:_option];
        if (_startIndex == index) {
            [item setSelected:YES animated:NO];
            _selectedIndex = index;
        } else {
            [item setSelected:NO animated:NO];
        }
        [_scrollView addSubview:item];
        [_menuItems addObject:item];
    }
    if (_startIndex < 0 || _startIndex > _menuTitles.count - 1) {
        _selectedIndex = 0;
        MTYMenuItem *item = self.menuItems[_selectedIndex];
        [item setSelected:YES animated:NO];
    }
}

- (void)_configureAnimatedView:(MTYPageMenuOption *)option {
    _animatedView.trackColor = option.trackColor;
    _animatedView.trackImage = option.trackImage;
    _animatedView.tranferRate = option.tranferRate;
    _animatedView.timingFunction = option.timingFunction;
    _animatedView.contentsGravity = option.contentsGravity;
    _animatedView.trackCornerRadius = option.trackCornerRadius;
    _animatedView.springEffectEnabled = option.springEffectEnabled;
}

- (void)_configureItem:(MTYMenuItem *)item with:(MTYPageMenuOption *)option {
    item.titleFont = option.titleFont;
    item.titleColor = option.titleColor;
    item.tranferRate = option.tranferRate;
    item.selectedTitleFont = option.selectedTitleFont;
    item.selectedTitleColor = option.selectedTitleColor;
}

#pragma mark - Layout

- (void)_layoutItems {
    if (!_menuItems || !_menuItems.count) return;
    
    NSMutableArray<NSValue *> *itemFrames = [NSMutableArray array];
    CGFloat totalWidth = _option.itemMargin;

    /// Calculate the total width of items.
    for (NSString *title in _menuTitles) {
        
        CGFloat itemWidth = _option.itemWidth;
        if (_option.adaptiveWidth) {
            /// Maybe selected font is smaller than normal font.
            UIFont *font = _option.titleFont <= _option.selectedTitleFont ? _option.selectedTitleFont : _option.titleFont;
            NSStringDrawingOptions drawOption = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            NSDictionary<NSAttributedStringKey, id> *attributes = @{NSFontAttributeName:font};
            itemWidth = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:drawOption attributes:attributes context:nil].size.width;
            itemWidth = ceil(itemWidth);
            itemWidth += _option.extraWidth;
        }
        CGRect itemFrame = CGRectMake(totalWidth, 0, itemWidth, self.mty_height);
        [itemFrames addObject:[NSValue valueWithCGRect:itemFrame]];
        totalWidth += (itemWidth + _option.itemMargin);
    }
    /// If the total width is smaller than the width of the scroll view, make it evenly distributed.
    if (totalWidth < _scrollView.mty_width) {
        CGFloat gap = _scrollView.mty_width - totalWidth;
        CGFloat step = gap / (_menuTitles.count + 1);
        
        for (int index = 0; index < itemFrames.count; ++index) {
            CGRect itemFrame = itemFrames[index].CGRectValue;
            itemFrame.origin.x += step * (index + 1);
            itemFrames[index] = [NSValue valueWithCGRect:itemFrame];
        }
        totalWidth = _scrollView.mty_width;
    }
    self.itemFrames = itemFrames;
    self.scrollView.contentSize = CGSizeMake(totalWidth, 0);
    
    /// Set item frame.
    for (int index = 0; index < _menuItems.count; ++index) {
        MTYMenuItem *item = _menuItems[index];
        item.frame = itemFrames[index].CGRectValue;
    }
}

- (void)_distributeNaturally {
    if (!_itemFrames || !_itemFrames.count) return;
    
    CGRect frame = _itemFrames[_selectedIndex].CGRectValue;
    CGFloat width = _scrollView.contentSize.width;
    CGFloat x = frame.origin.x;
    
    if (x > _scrollView.mty_width / 2) {
        CGFloat offset = 0.0;
        /// Reach right edge.
        if ((width - CGRectGetMidX(frame)) <= _scrollView.mty_width / 2) {
            offset =  width - _scrollView.mty_width;
        } else {
            offset = CGRectGetMidX(frame) - _scrollView.mty_width / 2;
        }
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)_layoutAnimatedView {
    CGFloat y = self.mty_height - _option.animatedHeight - _option.animatedBottomSpace;
    _animatedView.frame = CGRectMake(0, y, _scrollView.contentSize.width, _option.animatedHeight);
    _animatedView.keyFrames = [self _getAnimatedFrames];
    _animatedView.progress = self.selectedIndex;
}

- (NSMutableArray<NSValue *> *)_getAnimatedFrames {
    
    NSMutableArray *animatedFrames = [[NSMutableArray alloc] init];
    for (NSValue *value in _itemFrames) {
        CGRect itemFrame = value.CGRectValue;
        CGFloat x, width;
        
        /// Depending on whether the 'trackWidth' is defined.
        if (_option.trackWidth) {
            x = CGRectGetMidX(itemFrame) - _option.trackWidth / 2;
            width = _option.trackWidth;
        } else {
            CGFloat extraWidth = _option.widthEqualAdaptiveItem ? 0 : _option.extraWidth;
            x = _option.adaptiveWidth ? (itemFrame.origin.x + extraWidth / 2) : itemFrame.origin.x;
            width = _option.adaptiveWidth ? (itemFrame.size.width - extraWidth) : itemFrame.size.width;
        }
        CGRect animatedFrame = CGRectMake(x, 0, width, _option.animatedHeight);
        [animatedFrames addObject:[NSValue valueWithCGRect:animatedFrame]];
    }
    return animatedFrames;
}

#pragma mark - Setter

- (void)setMenuTitles:(NSArray<__kindof NSString *> *)menuTitles {
    _menuTitles = [menuTitles copy];
    
    /// Remove all menu items from menu view.
    [self _removeAllItems];
    /// Re-add menu items.
    [self _setupNewItems];
    /// Mark need re-layout until next runloop.
    [self setNeedsLayout];
}

#pragma mark - MTYMenuItemDelegate

- (void)didSelectedMenuItem:(MTYMenuItem *)menuItem {
    NSInteger index = [_menuItems indexOfObject:menuItem];
    if (_selectedIndex == index) return;
    
    [_animatedView animatedWithIndex:index];
    
    MTYMenuItem *previousItem = _menuItems[_selectedIndex];
    [previousItem setSelected:NO animated:YES];
    [menuItem setSelected:YES animated:YES];
    _selectedIndex = index;
    
    /// Tell delegate object.
    if ([_delegate respondsToSelector:@selector(menuView:didSelectItemAtIndex:)]) {
        [_delegate menuView:self didSelectItemAtIndex:_selectedIndex];
    }
    if (self.TapItemBlock) {
        self.TapItemBlock(_selectedIndex);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _distributeNaturally];
    });
}

#pragma mark - Public

- (void)resetMenuOption:(MTYPageMenuOption *)option {
    _option = option;
    
    /// Reset animated view with new option.
    if (option.showAnimatedView && !_animatedView) {
        [self _setupAnimatedView];
    } else if (!option.showAnimatedView) {
        [_animatedView removeFromSuperview];
        _animatedView = nil;
    } else {
        [self _configureAnimatedView:option];
    }
    _scrollView.contentInset = option.contentInset;
    
    /// Reset menu item with new option.
    if (!_menuItems || !_menuItems.count) return;
    for (MTYMenuItem *item in _menuItems) {
        [self _configureItem:item with:option];
        item.progress = item.progress;
    }
    /// Mark need re-layout until next event loop.
    [self setNeedsLayout];
}

- (void)updateWithProgress:(CGFloat)progress {
    if (progress < 0 || progress > _menuItems.count - 1) return;
    
    /// Update animated view progress.
    self.animatedView.progress = progress;
    
    NSInteger index = (NSInteger)progress;
    CGFloat rate = progress - index;
    /// Update menu item progress.
    MTYMenuItem *currentItem = _menuItems[index];
    MTYMenuItem *nextItem = index < _menuItems.count - 1 ? _menuItems[index+1] : nil;
    currentItem.progress = 1 - rate;
    nextItem.progress = rate;
    
    if (rate == 0.0) {
        _selectedIndex = index;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _distributeNaturally];
        });
    }
}

- (void)selectItemAtIndex:(NSInteger)index {
    if (_selectedIndex == index) return;
    if (index < 0 || index > _menuItems.count - 1) return;
    
    /// Deselect previous item.
    MTYMenuItem *previousItem = _menuItems[_selectedIndex];
    [previousItem setSelected:NO animated:YES];
    
    /// Select new item.
    _selectedIndex = index;
    MTYMenuItem *newItem = _menuItems[index];
    [newItem setSelected:YES animated:YES];
    
    /// Animated view move.
    [_animatedView animatedWithIndex:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _distributeNaturally];
    });
}

#pragma mark - Adapt iOS11

- (CGSize)intrinsicContentSize {
    if (@available(iOS 11.0, *)) {
        return UILayoutFittingExpandedSize;
    } else {
        return super.intrinsicContentSize;
    }
}

@end
