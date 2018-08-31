//
//  MTYXibViewController.m
//  MTYPageMenuDemo
//
//  Created by menttofly on 2018/8/30.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYXibViewController.h"
#import "MTYPageViewController.h"

@interface MTYXibViewController () <MTYPageMenuDataSource, MTYPageMenuDelegate>

@end

@implementation MTYXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MTYPageMenuOption *option = MTYPageMenuOption.new;
    option.widthEqualAdaptiveItem = YES;
    option.animatedHeight = 2;
    option.animatedColor = UIColor.orangeColor;
    option.itemMargin = 10;
    option.extraWidth = 10;
    self.menuOption = option;
    self.startIndex = 3;
    self.dataSource = self;
    self.delegate = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (CGRect)pageMenu:(MTYPageMenu *)pageMenu preferredFrameForContentView:(UIScrollView *)contentView {
    return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 74);
}

@end
