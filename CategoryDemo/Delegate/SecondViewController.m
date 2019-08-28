//
//  SecondViewController.m
//  CategoryDemo
//
//  Created by a on 2019/8/28.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "SecondViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)popControllerAction:(UIButton *)sender {
    
    if ([self.transformValueDelegate respondsToSelector:@selector(fromSecondVControllerValue:)]) {
        [self.transformValueDelegate fromSecondVControllerValue:@"快乐的小明"];
    }
    
    if ([self.transformValueSecondDelegate respondsToSelector:@selector(transformValueSecondValue:)]) {
        [self.transformValueSecondDelegate transformValueSecondValue:@"快乐的Y头"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
