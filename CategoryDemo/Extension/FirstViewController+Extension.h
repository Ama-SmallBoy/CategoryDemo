//
//  FirstViewController+Extension.h
//  CategoryDemo
//
//  Created by a on 2019/8/27.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "FirstViewController.h"

NS_ASSUME_NONNULL_BEGIN

//注意：扩展在使用的时候，在调用的类中倒入头文件，在源类中倒入头文件。

@interface FirstViewController (){
    //成员变量
    NSString * _name;
}
//属性
@property(nonatomic,strong)NSString * type;
//实例方法
-(void)changTextByImportText:(NSString *)textString;
//类方法：
+(void)changTextName:(NSString *)textName;
@end

NS_ASSUME_NONNULL_END
