//
//  MTYPageMenu.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/7/17.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTYMenuView.h"
#import "MTYScrollView.h"
#import "MTYPageMenuOption.h"

typedef NS_ENUM(NSUInteger, MTYAppearanceStyle) {
    MTYAppearanceStyleVisible,
    MTYAppearanceStyleDisplayed,
};

NS_ASSUME_NONNULL_BEGIN

@class MTYPageMenu;

/**
 Page menu's data source.
 */
@protocol MTYPageMenuDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInPageMenu:(MTYPageMenu *)pageMenu;
- (NSString *)pageMenu:(MTYPageMenu *)pageMenu titleForIndex:(NSInteger)index;
- (UIViewController *)pageMenu:(MTYPageMenu *)pageMenu pageForIndex:(NSInteger)index;

@optional
- (CGRect)pageMenu:(MTYPageMenu *)pageMenu preferredFrameForMenuView:(MTYMenuView *)menuView;
- (CGRect)pageMenu:(MTYPageMenu *)pageMenu preferredFrameForContentView:(UIScrollView *)contentView;
- (NSAttributedString *)pageMenu:(MTYPageMenu *)pageMenu attributeTitleForIndex:(NSInteger)index; ///TODO.

@end

/**
 Page menu's delegate.
 */
@protocol MTYPageMenuDelegate <NSObject>

@optional
- (void)pageMenu:(MTYPageMenu *)pageMenu willDisplayPage:(__kindof UIViewController *)page atIndex:(NSInteger)index;
- (void)pageMenu:(MTYPageMenu *)pageMenu didDisplayPage:(__kindof UIViewController *)page atIndex:(NSInteger)index;
- (void)pageMenu:(MTYPageMenu *)pageMenu didMoveToParentViewController:(__kindof UIViewController *)parent;

@end

/**
 Managing pages like ByteDance's TouTiao App.
 */
@interface MTYPageMenu : UIViewController 

@property (nullable, nonatomic, weak) id<MTYGestureRecognizerDelegate> grDelegate;
@property (nullable, nonatomic, weak) id<MTYPageMenuDataSource> dataSource;
@property (nullable, nonatomic, weak) id<MTYPageMenuDelegate> delegate;
@property (nullable, nonatomic, readonly) NSDictionary<NSNumber *, __kindof UIViewController *> *managedPages;
@property (nullable, nonatomic, readonly) UIViewController *currentPage;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic) NSInteger startIndex;

/**
 You'd better set these before viewDidLoad: called, or at least before set data souce.
 */
@property (nonatomic) BOOL bounces;
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL displayedOnNavigationBar;
@property (nonatomic) BOOL interactivePopGestureEnabled;
@property (nonatomic) MTYPageMenuOption *menuOption;
@property (nonatomic) MTYAppearanceStyle appearanceStyle;

/// Initializer
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil option:(MTYPageMenuOption *)option NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder option:(MTYPageMenuOption *)option NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithOption:(MTYPageMenuOption *)option;

- (void)resetOption:(MTYPageMenuOption *)option;  ///< You can reset option to update interface.
- (void)selectPageAtIndex:(NSInteger)index;  ///< You may want to change the selected page by code.
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
