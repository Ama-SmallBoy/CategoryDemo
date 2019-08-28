//
//  SecondViewController.h
//  CategoryDemo
//
//  Created by a on 2019/8/28.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransformValueDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TransformValueSecondDelegate <NSObject>
-(void)transformValueSecondValue:(NSString *)value;
@end
@interface SecondViewController : UIViewController
@property(nonatomic,weak) id<TransformValueDelegate>transformValueDelegate;
@property(nonatomic,weak) id<TransformValueSecondDelegate>transformValueSecondDelegate;
@end

NS_ASSUME_NONNULL_END
