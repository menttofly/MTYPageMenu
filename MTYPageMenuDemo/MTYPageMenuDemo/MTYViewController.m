//
//  MTYViewController.m
//  MTYPageMenuDemo
//
//  Created by menttofly on 2018/7/17.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYViewController.h"
#import "MTYPageViewController.h"

@interface MTYViewController () <MTYPageMenuDataSource, MTYPageMenuDelegate>

@end

@implementation MTYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    MTYPageMenuOption *option = MTYPageMenuOption.new;
    option.widthEqualAdaptiveItem = YES;
    option.trackImage = [UIImage imageNamed:@"track_background"];
    //    option.showAnimatedView = NO;
    //    option.showMenuView = NO;
    option.trackCornerRadius = 35.f / 2;
    option.animatedBottomSpace = 4.5;
    option.animatedHeight = 35;
    option.itemMargin = 10;
    option.extraWidth = 25;
    self.menuOption = option;
    self.startIndex = 3;
    self.dataSource = self;
    self.delegate = self;
    
    /// Trigger by code.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self selectPageAtIndex:0];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.menuOption.extraWidth = 30;
        self.menuOption.trackImage = nil;
        self.menuOption.trackColor = UIColor.orangeColor;
        [self resetOption:self.menuOption];
        self.startIndex = 2;
        [self reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSString *)map:(NSInteger)index {
    if (index == 0) {
        return @"DarkGray";
    } else if (index == 1) {
        return @"LightGray";
    } else if (index == 2) {
        return @"Gray";
    } else if (index == 3) {
        return @"Red";
    } else if (index == 4) {
        return @"Blue";
    } else if (index == 5) {
        return @"Cyan";
    } else if (index == 6) {
        return @"Yellow";
    } else if (index == 7) {
        return @"Magenta";
    } else if (index == 8) {
        return @"Orange";
    } else if (index == 9) {
        return @"Purple";
    } else {
        return @"Brown";
    }
}

#pragma mark - MTYPageMenuDataSource

- (NSInteger)numberOfPagesInPageMenu:(MTYPageMenu *)pageMenu {
    return 11;
}

- (NSString *)pageMenu:(MTYPageMenu *)pageMenu titleForIndex:(NSInteger)index {
    return [self map:index];
}

- (UIViewController *)pageMenu:(MTYPageMenu *)pageMenu pageForIndex:(NSInteger)index {
    MTYPageViewController *vc = [[MTYPageViewController alloc] init];
    vc.index = index;
    return vc;
}

- (CGRect)pageMenu:(MTYPageMenu *)pageMenu preferredFrameForMenuView:(MTYMenuView *)menuView {
    return CGRectMake(0, 20, self.view.frame.size.width, 44);
}

#pragma mark - MTYPageMenuDelegate

- (void)pageMenu:(MTYPageMenu *)pageMenu didDisplayPage:(__kindof UIViewController *)page atIndex:(NSInteger)index {
    
}

@end
