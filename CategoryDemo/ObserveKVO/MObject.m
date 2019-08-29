//
//  MObject.m
//  KVO_TEST
//
//  Created by yangyang38 on 2018/3/3.
//  Copyright © 2018年 yangyang. All rights reserved.
//

#import "MObject.h"

@implementation MObject

- (id)init
{
    self = [super init];
    if (self) {
        _value = 0;
    }
    return self;
}

- (void)increase
{
    //1、直接为成员变量赋值，不能触发KVO
    // _value += 1;
    
    //2、手动添加KVO才可以触发KVO
    [self willChangeValueForKey:@"value"];
    _value += 1;
    [self didChangeValueForKey:@"value"];
}
//如果想验证KVC是否触犯了该方法，则需要放开下面的注释。
//- (void)setValue:(int)value{
//    NSLog(@"====+++KVC触发了setter");
//}
@end
