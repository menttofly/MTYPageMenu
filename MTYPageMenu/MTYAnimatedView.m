//
//  MTYAnimatedView.m
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/19.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYAnimatedView.h"
#import "UIView+MTYExtension.h"

@interface MTYAnimatedView ()

@property (nonatomic) CAKeyframeAnimation *pathAnimation;  ///< Animate path movement by CAKeyframeAnimation.
@property (nonatomic) CAShapeLayer *shapeLayer;  ///< Using CAShapeLayer to get better performance instead of drawRect.
@property (nonatomic) NSInteger index;  ///< Record the index that you selected.

@end

@implementation MTYAnimatedView

- (void)dealloc {
    MTYLog(@"MTYAnimatedView released!");
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
    self.userInteractionEnabled = NO;
    
    _shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_shapeLayer];;
}

- (void)_setNeedsDisplay {
    
    NSInteger index = (NSInteger)_progress;
    CGFloat rate = _progress - index;
    NSInteger nextIndex = index < _keyFrames.count - 1 ? index + 1 : index;
    
    /// Convert key frames to path.
    NSArray *keyFrames = @[_keyFrames[index], _keyFrames[nextIndex]];
    UIBezierPath *keyPath = [self _keyPathWithKeyFrames:keyFrames rate:rate];
    
    if (!_trackImage) {
        /// Draw and render layer by bezier path.
        _shapeLayer.path = keyPath.CGPath;
    } else {
        /// Layer using image as its contents.
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _shapeLayer.frame = keyPath.bounds;
        [CATransaction commit];
    }
}

- (UIBezierPath *)_keyPathWithKeyFrames:(NSArray<NSValue *> *)tuple rate:(CGFloat)rate{
    if (tuple.count != 2) return nil;
    
    /// Two key frame.
    CGRect frame = tuple.firstObject.CGRectValue;
    CGRect nextFrame = tuple.lastObject.CGRectValue;
    CGFloat x = frame.origin.x;
    CGFloat width = frame.size.width;
    CGFloat nextX = nextFrame.origin.x;
    CGFloat nextWidth = nextFrame.size.width;
    
    /// Animated part info.
    CGFloat atWidth = width + (nextWidth - width) * rate;
    CGFloat startX = x + (nextX - x) * rate;
    
    if (self.springEffectEnabled) {
        CGFloat midX = CGRectGetMidX(frame);
        CGFloat nextMidX = CGRectGetMidX(nextFrame);
        CGFloat distance = nextMidX - midX;
        CGFloat sRate = 0;
        /// Move less than or equal to half distance.
        if (rate <= 0.5) {
            sRate = rate * 2;
            startX = x + (midX - x) * sRate;
            atWidth = width + (distance - width) * sRate;
        } else {
            sRate = (rate - 0.5) * 2;
            startX = midX + (nextX - midX) * sRate;
            atWidth = distance - (distance - nextWidth) * sRate;
        }
    }
    UIBezierPath *keyPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, 0, atWidth, self.mty_height) cornerRadius:_trackCornerRadius];
    
    return keyPath;
}

#pragma mark - Setter & Getter

- (void)setProgress:(CGFloat)progress {
    
    /// Filter non-compliant case.
    if (!_keyFrames || !_keyFrames.count) return;
    if (progress < 0 || progress > _keyFrames.count - 1) return;
    _progress = progress;
    _index = progress;
    
    [self _setNeedsDisplay];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    _shapeLayer.fillColor = trackColor.CGColor;
}

- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    _shapeLayer.contents = (__bridge id)trackImage.CGImage;
    if (trackImage) {
         _shapeLayer.path = NULL;
    } else {
         _shapeLayer.frame = CGRectZero;
    }
}

- (void)setContentsGravity:(NSString *)contentsGravity {
    _contentsGravity = [contentsGravity copy];
    _shapeLayer.contentsGravity = contentsGravity;
}

- (NSInteger)tranferRate {
    return _tranferRate ?: 1;
}

- (CAKeyframeAnimation *)pathAnimation {
    if (!_pathAnimation) {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:_timingFunction];
        pathAnimation.duration = self.tranferRate / 60.f;
        pathAnimation.fillMode = kCAFillModeRemoved;
        pathAnimation.removedOnCompletion = YES;
        _pathAnimation = pathAnimation;
    }
    return _pathAnimation;
}

#pragma mark - Public

- (void)animatedWithIndex:(NSInteger)index {
    
    /// Final destination path.
    CGRect nextFrame = _keyFrames[index].CGRectValue;
    CGFloat nextX = nextFrame.origin.x;
    CGFloat nextWidth = nextFrame.size.width;
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(nextX, 0, nextWidth, self.mty_height) cornerRadius:_trackCornerRadius];

    if (_trackImage) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:self.tranferRate / 60.f];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:_timingFunction]];
        _shapeLayer.frame = toPath.bounds;
        [CATransaction commit];
    } else {
        CAKeyframeAnimation *pathAnimation = self.pathAnimation;
        /// Determine the appropriate path to animate.
        if (labs(index - _index) > 1 || !_springEffectEnabled) {
            pathAnimation.values = @[(__bridge id)_shapeLayer.path, (__bridge id)toPath.CGPath];
        } else {
            NSInteger start = index < _index ? index : _index;
            NSInteger end = index < _index ? _index :  index;
            NSArray<NSValue *> *keyFrames = @[_keyFrames[start], _keyFrames[end]];
            
            UIBezierPath *springPath = [self _keyPathWithKeyFrames:keyFrames rate:0.5];
            pathAnimation.values = @[(__bridge id)_shapeLayer.path, (__bridge id)springPath.CGPath , (__bridge id)toPath.CGPath];
        }
        [_shapeLayer addAnimation:pathAnimation forKey:nil];  /// Animation will copied by the render tree.
        // When Core Animation running, the origin layer will auto hidden until animation complete.
        _shapeLayer.path = toPath.CGPath;
    }
    _index = index;
}

@end
