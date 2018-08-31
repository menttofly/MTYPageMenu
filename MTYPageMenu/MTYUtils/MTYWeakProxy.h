//
//  MTYWeakProxy.h
//  MTYPageMenu <https://github.com/menttofly/MTYPageMenu>
//
//  Created by menttofly on 2018/7/17.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTYWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end
