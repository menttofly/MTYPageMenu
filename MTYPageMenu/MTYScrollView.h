//
//  MTYScrollView.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/8/8.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTYGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@end

@interface MTYScrollView : UIScrollView

/// In some cases you may want to control gesture recognition yourself.
@property (nonatomic, weak) id<MTYGestureRecognizerDelegate> grDelegate;

@end
