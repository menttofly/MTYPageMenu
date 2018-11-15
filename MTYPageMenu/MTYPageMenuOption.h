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
@property (nullable, nonatomic, copy) NSString *timingFunction;  ///< Time fuction of the animated part, default is kCAMediaTimingFunctionDefault.

@property (nonatomic) UIColor *trackColor;  ///< Fill color of the track view.
@property (nonatomic) CGFloat trackWidth;  ///< Width of the track view.
@property (nonatomic) CGFloat trackCornerRadius;  ///< Corner radius of the track view.
@property (nullable, nonatomic) UIImage *trackImage;  ///< Animated image of the track view, this will cover 'trackColor' and other attribute.
@property (nullable, nonatomic, copy) NSString *contentsGravity;  ///< Content mode for track image view, default is 'kCAGravityResize'.

@property (nonatomic) CGFloat leading;  /// Leading margin before first item.
@property (nonatomic) CGFloat trailing;  /// Trailing margin after last item.
@property (nonatomic) CGFloat itemWidth;  ///< Menu item width.
@property (nonatomic) CGFloat itemMargin;  ///< Margin between menu item.
@property (nonatomic) CGFloat extraWidth;  ///< Extra item width when use automatic calculate item width.

@end

NS_ASSUME_NONNULL_END
