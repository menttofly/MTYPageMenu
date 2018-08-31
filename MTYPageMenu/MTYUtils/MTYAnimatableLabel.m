//
//  MTYAnimatableLabel.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/25.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYAnimatableLabel.h"
#import <CoreText/CoreText.h>

/**
 Align text in CATextLayer vertically.
 */
@interface MTYTextLayer: CATextLayer

/// Indicate whether layer's text is attrabuted text or not.
@property (nonatomic) BOOL isAttributedText;

@end

@implementation MTYTextLayer

- (void)drawInContext:(CGContextRef)ctx {
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    UIFont *font = (__bridge UIFont *)self.font;
    CGSize size = CGSizeZero;
    /// According to the CATextLayer string type, measuring text size.
    if (self.isAttributedText) {
        size = [self.string boundingRectWithSize:CGSizeMake(width, INFINITY) options:kNilOptions context:nil].size;
    } else {
        size = [self.string sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    CGFloat y = (height - size.height) / 2.f;  /// Do not ceil size.
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, y);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

@end


/**
 If you want CATextLayer be animatable, you shouldn't use it as root layer.
 */
@interface MTYAnimatableLabel ()

///< The CATextLayer used to form the animation.
@property (nonatomic, strong, readonly) MTYTextLayer *textLayer;

@end

@implementation MTYAnimatableLabel

#pragma mark - Private

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _defaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _defaults];
    }
    return self;
}

- (void)_defaults {
    _textLayer = [[MTYTextLayer alloc] init];
    _textLayer.rasterizationScale = UIScreen.mainScreen.scale;
    _textLayer.contentsScale = UIScreen.mainScreen.scale;
    [self.layer addSublayer:_textLayer];
  
    /// Restore setting from xib UILabel.
    self.text = super.text;
    self.font = self.font;
    self.textColor = self.textColor;
    self.shadowColor = self.shadowColor;
    self.shadowOffset = self.shadowOffset;
    self.textAlignment = self.textAlignment;
    self.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    
    /// Clear UILabel text.
    [super setText:nil];
    [super setAttributedText:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_textLayer.frame, self.bounds)) {
        _textLayer.frame = self.bounds;
    }
}

#pragma mark - UILabel Part of Attributes

/**
 Sicen we use CATransaction to explicitly modify the layer tree, so no need to call setNeedsDisplay.
 */
- (void)setText:(NSString *)text {
    _textLayer.string = text;
}

- (void)setFont:(UIFont *)font {
    super.font = font;
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CTFontRef fontRef = CTFontCreateWithName(fontName, font.pointSize, NULL);
    _textLayer.font = fontRef;
    _textLayer.fontSize = font.pointSize;
    CFRelease(fontRef);
}

- (void)setTextColor:(UIColor *)textColor {
    super.textColor = textColor;
    _textLayer.foregroundColor = textColor.CGColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    super.shadowColor = shadowColor;
    _textLayer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    super.shadowOffset = shadowOffset;
    _textLayer.shadowOffset = shadowOffset;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    super.textAlignment = textAlignment;
    switch (textAlignment) {
        case NSTextAlignmentLeft:
            _textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            _textLayer.alignmentMode = kCAAlignmentRight;
            break;
        case NSTextAlignmentCenter:
            _textLayer.alignmentMode = kCAAlignmentCenter;
            break;
        case NSTextAlignmentJustified:
            _textLayer.alignmentMode = kCAAlignmentJustified;
            break;
        default:
            _textLayer.alignmentMode = kCAAlignmentNatural;
            break;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _textLayer.isAttributedText = attributedText && [attributedText isKindOfClass:NSAttributedString.class];
    _textLayer.string = attributedText;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    super.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    _textLayer.wrapped = adjustsFontSizeToFitWidth;
}

- (NSAttributedString *)attributedText {
    return _textLayer.isAttributedText ? _textLayer.string : nil;
}

- (NSString *)text {
    return !_textLayer.isAttributedText ? _textLayer.string : nil;
}

@end
