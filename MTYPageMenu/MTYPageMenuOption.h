//
//  MTYPageMenuOption.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTYPageMenuOption : NSObject

@property (nonatomic) BOOL widthEqualAdaptiveItem;  ///< Animated part's width equal to adaptive item width or not.
@property (nonatomic) BOOL adaptiveWidth;  ///< Menu item's width base on text. Will invalidate the 'itemWidth' attribute.
@property (nonatomic) BOOL springEffectEnabled;  ///< Decide awesome effect enable or not.
@property (nonatomic) BOOL showAnimatedView;  ///< Show animated view or not
@property (nonatomic) BOOL showMenuView;  ///< Show menu view or not. You can use your own menu view instead.
@property (nonatomic) UIEdgeInsets contentInset;  ///< Content inset of the top menu scroll view.
@property (nonatomic) NSInteger tranferRate;  ///< Tranfer rate of menu item to change select state.

@property (nonatomic) UIFont *titleFont;  ///< Title font of the menu item.
@property (nonatomic) UIColor *titleColor;  ///< Title color of the menu item.
@property (nonatomic) UIFont *selectedTitleFont;  ///< Selected title font of the menu item, used to calculate the item width.
@property (nonatomic) UIColor *selectedTitleColor;  ///< Selected title color of the menu item.

@property (nonatomic) CGFloat animatedHeight;  ///< Animated view height.
@property (nonatomic) CGFloat animatedBottomSpace;  ///< Animated view bottom space to menu view.
@property (nonatomic) UIColor *animatedColor;  ///< Progress color of the animate view.
@property (nonatomic) CGFloat animatedWidth;  ///< Progress width of the animate view.
@property (nonatomic) CGFloat animatedCornerRadius;  ///< Corner radius of the progress.

@property (nonatomic) CGFloat itemWidth;  ///< Menu item width.
@property (nonatomic) CGFloat itemMargin;  ///< Margin between menu item.
@property (nonatomic) CGFloat extraWidth;  ///< Extra item width when use automatic calculate item width.

@end

NS_ASSUME_NONNULL_END
