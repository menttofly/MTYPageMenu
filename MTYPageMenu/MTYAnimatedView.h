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

@property (nonatomic) UIColor *animatedColor;  ///< Color of the animated part.
@property (nonatomic) CGFloat animatedCornerRadius;  ///< Corner radius of the animated part.
@property (nullable, nonatomic, copy) NSArray<NSValue *> *keyFrames;  ///< Animated view key frames.

- (void)animatedWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
