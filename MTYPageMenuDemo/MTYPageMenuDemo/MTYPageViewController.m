//
//  MTYPageViewController.m
//  MTYPageMenuDemo
//
//  Created by qiushibaike on 2018/8/15.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "MTYPageViewController.h"

@interface MTYPageViewController ()

@end

@implementation MTYPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [self map:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@:viewWillAppear", [self map:NO]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@:viewDidAppear", [self map:NO]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@:viewWillDisappear", [self map:NO]);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@:viewDidDisappear", [self map:NO]);
}

- (id)map:(BOOL)setBackgroundColor {
    switch (self.index) {
        case 0:
            return setBackgroundColor ? UIColor.darkGrayColor : @"DarkGray";
            break;
        case 1:
            return setBackgroundColor ? UIColor.lightGrayColor : @"LightGray";
            break;
        case 2:
            return setBackgroundColor ? UIColor.grayColor : @"Gray";
            break;
        case 3:
            return setBackgroundColor ? UIColor.redColor : @"Red";
            break;
        case 4:
            return setBackgroundColor ? UIColor.blueColor : @"Blue";
            break;
        case 5:
            return setBackgroundColor ? UIColor.cyanColor : @"Cyan";
            break;
        case 6:
            return setBackgroundColor ? UIColor.yellowColor : @"Yellow";
            break;
        case 7:
            return setBackgroundColor ? UIColor.magentaColor : @"Magenta";
            break;
        case 8:
            return setBackgroundColor ? UIColor.orangeColor : @"Orange";
            break;
        case 9:
            return setBackgroundColor ? UIColor.purpleColor : @"Purple";
            break;
        default:
            return setBackgroundColor ? UIColor.brownColor : @"Brown";
            break;
    }
}

@end
