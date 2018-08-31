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
    _titleColor = UIColor.redColor;
    _selectedTitleFont = [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19];
    _selectedTitleColor = UIColor.blueColor;
    
    _animatedHeight = 2;
    _animatedBottomSpace = 0;
    _animatedColor = UIColor.yellowColor;
    _animatedWidth = 0;
    _animatedCornerRadius = 0;
    
    _itemWidth = 35;
    _itemMargin = 0;
    _extraWidth = 0;
}

/// Create font by fontWithName: may return nil.
- (UIFont *)titleFont {
    return _titleFont ?: [UIFont systemFontOfSize:15];
}

- (UIFont *)selectedTitleFont {
    return _selectedTitleFont ?: [UIFont systemFontOfSize:16];
}

@end
