//
//  FirstViewController.m
//  CategoryDemo
//
//  Created by a on 2019/8/27.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewController+Extension.h"
@interface FirstViewController ()
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _name = @"时间点";
}
-(void)changTextByImportText:(NSString *)textString{
    NSLog(@"=====%@",textString);
}
- (IBAction)getNameAction:(UIButton *)sender {
    NSLog(@"=====我是实例变量:%@",_name);
}

+(void)changTextName:(NSString *)textName{
    NSLog(@"========%@",textName);
}

@end
