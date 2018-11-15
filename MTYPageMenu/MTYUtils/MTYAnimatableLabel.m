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

@end

@implementation MTYTextLayer

- (void)drawInContext:(CGContextRef)ctx {
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(width, INFINITY) options:kNilOptions context:nil].size;
    CGFloat y =  (height - size.height) / 2.f;  /// Do not ceil size.

    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, y);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

@end


/**
 !!!: Must use attribute text instead of text, because text displayed in CATextLayer has diffrent kerning from UILabel's
 */
@interface MTYAnimatableLabel ()

///< The CATextLayer to excute the animation.
@property (nonatomic, strong) MTYTextLayer *textLayer;

@end

@implementation MTYAnimatableLabel

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_textLayer.frame, self.bounds)) {
        _textLayer.frame = self.bounds;
    }
}

#pragma mark - Private

- (void)setup {
    _textLayer = [[MTYTextLayer alloc] init];
    _textLayer.rasterizationScale = UIScreen.mainScreen.scale;
    _textLayer.contentsScale = UIScreen.mainScreen.scale;
    [self.layer addSublayer:_textLayer];
    
    /// Restore setting from xib UILabel.
    self.text = super.text;
    self.font = self.font;
    self.textColor = self.textColor;
    self.textAlignment = self.textAlignment;
    
    /// Clear UILabel text.
    [super setText:nil];
    [super setAttributedText:nil];
}

/**
 Because we use CATransaction to explicitly modify the layer tree, so no need to call setNeedsDisplay.
 */
- (void)addAttributesForTextLayer:(NSDictionary *)attributes {
    
    NSMutableAttributedString *attributedText = [_textLayer.string mutableCopy];
    [attributedText addAttributes:attributes range:NSMakeRange(0, attributedText.length)];
    _textLayer.string = attributedText;
}

#pragma mark - UILabel Part of Attributes

- (void)setText:(NSString *)text {
    if (!text) {
        _textLayer.string = nil;
    } else {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        /// Property font & textColor are both 'null_resettable'
        NSDictionary *attributes = @{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.textColor};
        [attributedText addAttributes:attributes range:NSMakeRange(0, attributedText.length)];
        _textLayer.string = attributedText;
    }
}

- (nullable NSString *)text {
    NSAttributedString *attributedText = _textLayer.string;
    return attributedText.string;
}

- (void)setFont:(UIFont *)font {
    super.font = font;
    if (!font) return;
    [self addAttributesForTextLayer:@{NSFontAttributeName:font}];
}

- (void)setTextColor:(UIColor *)textColor {
    super.textColor = textColor;
    if (!textColor) return;
    [self addAttributesForTextLayer:@{NSForegroundColorAttributeName:textColor}];
}

- (void)setTextShadow:(NSShadow *)textShadow {
    _textShadow = textShadow;
    if (!textShadow) return;
    [self addAttributesForTextLayer:@{NSShadowAttributeName:textShadow}];
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
    _textLayer.string = attributedText;
}

- (nullable NSAttributedString *)attributedText {
    return _textLayer.string;
}

@end
