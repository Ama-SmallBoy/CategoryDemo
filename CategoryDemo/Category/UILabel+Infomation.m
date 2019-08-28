

//
//  UILabel+Infomation.m
//  CategoryDemo
//
//  Created by a on 2019/8/27.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "UILabel+Infomation.h"
#import <objc/runtime.h>

static NSString *nameKey = @"nameKey"; //利用静态变量地址唯一不变的特性
@implementation UILabel (Infomation)

#pragma mark-----------第一种写法--------
-(NSString *)name{
    return objc_getAssociatedObject(self,&nameKey);
}

-(void)setName:(NSString*)name{
    objc_setAssociatedObject(self,&nameKey,name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark-----------第二种写法--------

//TODO:为什么不能添加实例变量呢?
//类的内存布局在编译时期就已经确定了，category是运行时才加载的,此时早已经确定了内存布局所以无法添加实例变量，如果添加实例变量就会破坏category的内部布局。

/*
 
 _cmd是什么？
 _cmd是指当前方法的一个SEL类型的指针，SEL可理解成方法选择器 - @selector(),就是取类成员方法的编号,他的行为基本可以等同C语言的中函数指针（函数地址）,只不过C语言中，可以把函数名直接赋给一个函数指针，而Object-C的类不能直接应用函数指针，这样只能做一个@selector语法来取,他的结果是SEL类型，用assgin修饰。
 
 该方法第二个参数的类型为const void * 表示是一个指针，该指针可以指向任意类型的值，但它指向的值必须是常量。刚好_cmd就是一个指针，指向的是当前方法的编号，是个常量，所以传_cmd没毛病。传_cmd的一个好处就是即保证唯一性又不需要声明参数。
 
 */




//-(NSString *)name{
//  return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setName:(NSString*)name{
//     objc_setAssociatedObject(self, @selector(name),name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}


@end
