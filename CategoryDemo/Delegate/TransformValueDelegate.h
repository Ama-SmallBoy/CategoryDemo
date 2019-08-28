//
//  TransformValueDelegate.h
//  CategoryDemo
//
//  Created by a on 2019/8/28.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TransformValueDelegate <NSObject>
//声明一个方法
-(void)fromSecondVControllerValue:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
