//
//  MTYAnimatedView.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/19.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Page menu's animated view.
 */
@interface MTYAnimatedView : UIView

@property (nonatomic) CGFloat progress;  ///< Animated view tranfer progress.
@property (nonatomic) NSInteger tranferRate;  ///< Transfer rate of update progress.
@property (nonatomic) BOOL springEffectEnabled;  ///< Whether enable awesome effect or not.
@property (nonatomic, copy) NSString *timingFunction;  ///< Time fuction of the animated part, default is kCAMediaTimingFunctionDefault.
@property (nonatomic, copy) NSString *contentsGravity;  ///< Content mode for track image view, default is 'kCAGravityResize'.

@property (nonatomic) UIColor *trackColor;  ///< Fill color of the track view.
@property (nonatomic) CGFloat trackCornerRadius;  ///< Corner radius of the track view.
@property (nullable, nonatomic) UIImage *trackImage;  ///< Animated image of the track view, this will cover 'trackColor' attribute.
@property (nullable, nonatomic, copy) NSArray<NSValue *> *keyFrames;  ///< Animated view key frames.

- (void)animatedWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
