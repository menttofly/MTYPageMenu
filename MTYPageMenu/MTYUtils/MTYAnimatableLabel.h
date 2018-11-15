//
//  MTYAnimatableLabel.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/25.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Implement a label which supports text-related properties to be animatable.
 */
@interface MTYAnimatableLabel : UILabel

@property (nonatomic) NSShadow *textShadow;  ///< Showdow for text.

@end
