//
//  UIView+MTYExtension.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/12.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "UIView+MTYExtension.h"

@implementation UIView (MTYExtension)

#pragma mark - Setter

- (void)setMty_left:(CGFloat)mty_left {
    CGRect frame = self.frame;
    frame.origin.x = mty_left;
    self.frame = frame;
}

- (void)setMty_top:(CGFloat)mty_top {
    CGRect frame = self.frame;
    frame.origin.y = mty_top;
    self.frame = frame;
}

- (void)setMty_right:(CGFloat)mty_right {
    CGRect frame = self.frame;
    frame.origin.x = mty_right - frame.size.width;
    self.frame = frame;
}

- (void)setMty_bottom:(CGFloat)mty_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mty_bottom - self.frame.size.height;
    self.frame = frame;
}

- (void)setMty_width:(CGFloat)mty_width {
    CGRect frame = self.frame;
    frame.size.width = mty_width;
    self.frame = frame;
}

- (void)setMty_height:(CGFloat)mty_height {
    CGRect frame = self.frame;
    frame.size.height = mty_height;
    self.frame = frame;
}

- (void)setMty_centerX:(CGFloat)mty_centerX {
    self.center = CGPointMake(mty_centerX, self.center.y);
}

- (void)setMty_centerY:(CGFloat)mty_centerY {
    self.center = CGPointMake(self.center.x, mty_centerY);
}

- (void)setMty_origin:(CGPoint)mty_origin {
    CGRect frame = self.frame;
    frame.origin = mty_origin;
    self.frame = frame;
}

- (void)setMty_size:(CGSize)mty_size {
    CGRect frame = self.frame;
    frame.size = mty_size;
    self.frame = frame;
}

#pragma mark - Getter

- (CGFloat)mty_left {
    return self.frame.origin.x;
}

- (CGFloat)mty_top {
    return self.frame.origin.y;
}

- (CGFloat)mty_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)mty_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)mty_width {
    return self.frame.size.width;
}

- (CGFloat)mty_height {
    return self.frame.size.height;
}

- (CGFloat)mty_centerX {
    return self.center.x;
}

- (CGFloat)mty_centerY {
    return self.center.y;
}

- (CGPoint)mty_origin {
    return self.frame.origin;
}

- (CGSize)mty_size{
    return self.frame.size;
}

@end
