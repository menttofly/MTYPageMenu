//
//  MTYMenuView.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTYMenuView, MTYPageMenuOption;

@protocol MTYMenuViewDelegate <NSObject>

@optional
- (void)menuView:(MTYMenuView *)menuView didSelectItemAtIndex:(NSInteger)index;

@end

/**
 Page menu's top view.
 */
@interface MTYMenuView : UIView

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nullable, nonatomic, weak) id<MTYMenuViewDelegate> delegate;
@property (nullable, nonatomic, copy) void (^TapItemBlock)(NSInteger index);
@property (nullable, nonatomic, copy) NSArray<__kindof NSString *> *menuTitles;

- (instancetype)initWithFrame:(CGRect)frame option:(MTYPageMenuOption *)option NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Mainly focused on interface updates.
 */
- (void)resetMenuOption:(MTYPageMenuOption *)option;
- (void)updateWithProgress:(CGFloat)progress;
- (void)selectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
