//
//  UIView+MTYExtension.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/12.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define MTYLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define MTYLog(format, ...)
#endif

@interface UIView (MTYExtension)

@property (nonatomic) CGFloat mty_left;
@property (nonatomic) CGFloat mty_top;
@property (nonatomic) CGFloat mty_right;
@property (nonatomic) CGFloat mty_bottom;
@property (nonatomic) CGFloat mty_width;
@property (nonatomic) CGFloat mty_height;
@property (nonatomic) CGFloat mty_centerX;
@property (nonatomic) CGFloat mty_centerY;
@property (nonatomic) CGPoint mty_origin;
@property (nonatomic) CGSize  mty_size;

@end
