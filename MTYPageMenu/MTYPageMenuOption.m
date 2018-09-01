//
//  MTYPageMenuOption.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYPageMenuOption.h"

@implementation MTYPageMenuOption

- (instancetype)init {
    if (self = [super init]) {
        [self _defaults];
    }
    return self;
}

- (void)_defaults {
    
    _widthEqualAdaptiveItem = NO;
    _adaptiveWidth = YES;
    _springEffectEnabled = YES;
    _showAnimatedView = YES;
    _showMenuView = YES;
    _contentInset = UIEdgeInsetsZero;
    _tranferRate = 10;
    
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColor = UIColor.grayColor;
    _selectedTitleFont = [UIFont boldSystemFontOfSize:16];
    _selectedTitleColor = UIColor.darkGrayColor;
    
    _animatedHeight = 2;
    _animatedBottomSpace = 0;
    _timingFunction = kCAMediaTimingFunctionDefault;
    
    _trackColor = UIColor.orangeColor;
    _trackWidth = 0;
    _trackCornerRadius = 0;
    _contentsGravity = kCAGravityResize;
    
    _itemWidth = 35;
    _itemMargin = 0;
    _extraWidth = 0;
}

/// Create font by fontWithName: may return nil.
- (UIFont *)titleFont {
    return _titleFont ?: [UIFont systemFontOfSize:15];
}

- (UIFont *)selectedTitleFont {
    return _selectedTitleFont ?: [UIFont boldSystemFontOfSize:16];
}

- (NSString *)timingFunction {
    return _timingFunction ?: kCAMediaTimingFunctionDefault;
}

- (NSString *)contentsGravity {
    return _contentsGravity ?: kCAGravityResize;
}

@end
