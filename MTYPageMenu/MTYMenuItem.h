//
//  MTYMenuItem.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTYAnimatableLabel.h"

NS_ASSUME_NONNULL_BEGIN

@class MTYMenuItem;

@protocol MTYMenuItemDelegate <NSObject>

@optional
- (void)didSelectedMenuItem:(MTYMenuItem *)menuItem;

@end

/**
 Menu item of menu view.
 */
@interface MTYMenuItem : MTYAnimatableLabel

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIFont *selectedTitleFont;
@property (nonatomic) UIColor *selectedTitleColor;

@property (nonatomic) CGFloat progress;
@property (nonatomic) NSInteger tranferRate;  ///< Transfer rate of select state. Popularly speaking, it's frame number of CADisplayLink.
@property (nullable, nonatomic, weak) id<MTYMenuItemDelegate> delegate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
