//
//  MTYMenuItem.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYMenuItem.h"
#import "MTYWeakProxy.h"

static inline BOOL isEqual(CGFloat a, CGFloat b) {
    return fabs(a-b) < 0.000001;
}

@interface MTYMenuItem () {
    CGFloat _nRed, _nGreen, _nBlue, _nAlpha;   /// Trichromatic of the normal state.
    CGFloat _sRed, _sGreen, _sBlue, _sAlpha;   /// Trichromatic of the selected state.
}

@property (nonatomic) CGFloat sign;  ///< Represent select or deselect.
@property (nonatomic) CGFloat gap;  ///< The distance to tranfer to target state.
@property (nonatomic) CGFloat step;  ///< Represents the distance of action for each frame.
@property (nonatomic) CADisplayLink *displayLink;

@end

@implementation MTYMenuItem

- (void)dealloc {
    [self _stopAnimation];
}

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

#pragma mark - Private

- (void)_setup {
    self.userInteractionEnabled = YES;
    self.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)_startAnimation {
    if (!_displayLink) {
        MTYWeakProxy *weakProxy = [MTYWeakProxy proxyWithTarget:self];
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(updateProgress:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        displayLink.frameInterval = 1;
        self.displayLink = displayLink;
    }
    _displayLink.paused = NO;
}

- (void)_stopAnimation {
    [_displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - Action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(didSelectedMenuItem:)]) {
        [_delegate didSelectedMenuItem:self];
    }
}

- (void)updateProgress:(CADisplayLink *)displayLink {
    _gap -= _step;
    if (_gap >= 0) {
        self.progress += _sign * _step;
    } else {
        [self _stopAnimation];
        /// Progress crossing boundary, so we reset it.
        if (!isEqual(_progress, 0) &&  !isEqual(_progress, 1)) {
            self.progress = _sign > 0 ? 1.0 : 0.0;
        }
    }
}

#pragma mark - Setter & Getter

- (void)setProgress:(CGFloat)progress {
    if (progress < 0.0 || progress > 1.0) return;
    
    _progress = progress;
    CGFloat red = _nRed + (_sRed - _nRed) * progress;
    CGFloat green = _nGreen + (_sGreen - _nGreen) * progress;
    CGFloat blue = _nBlue + (_sBlue - _nBlue) * progress;
    CGFloat alpha = _nAlpha + (_sAlpha - _nAlpha) * progress;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    [CATransaction commit];
    
    /// Alter the font of UILabel has poor effect, however CATextLayer which base on CoreText kit has excellent result.
    CGFloat titleSize = _titleFont.pointSize;
    CGFloat selectedTitleSize = _selectedTitleFont.pointSize;
    
    /// If normal font same as selected font, then no need to process.
    if (titleSize == selectedTitleSize && [_titleFont.fontName isEqualToString:_selectedTitleFont.fontName]) {
        return;
    }
    if (titleSize != selectedTitleSize && selectedTitleSize > 0) {
        CGFloat rate = titleSize / selectedTitleSize;
        CGFloat scale = rate + (1 - rate) * progress;
        /// Disable implicit animation, and more precise than use transform to implement font animation.
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (isEqual(progress, 0)) {
            self.font = _titleFont;
        } else if (isEqual(progress, 1)) {
            self.font = _selectedTitleFont;
        } else {
            /// !!!: Returns a font matching the '_titleFont' descriptor.
            self.font = [UIFont fontWithDescriptor:_titleFont.fontDescriptor size:selectedTitleSize * scale];
        }
        [CATransaction commit];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [_titleColor getRed:&_nRed green:&_nGreen blue:&_nBlue alpha:&_nAlpha];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    [_selectedTitleColor getRed:&_sRed green:&_sGreen blue:&_sBlue alpha:&_sAlpha];
}

- (NSInteger)tranferRate {
    return _tranferRate ?: 1;
}

#pragma mark - Public

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (animated) {
        _sign = selected ? 1.0 : -1.0;
        _gap = selected ? (1.0 - _progress) : _progress;
        _step = _gap / self.tranferRate;
        [self _startAnimation];
    } else {
        _progress = selected ? 1.0 : 0.0;
        self.font = selected ? _selectedTitleFont : _titleFont;
        self.textColor = selected ? _selectedTitleColor : _titleColor;
    }
}

@end
