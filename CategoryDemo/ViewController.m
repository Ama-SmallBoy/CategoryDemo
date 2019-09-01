//
//  ViewController.m
//  CategoryDemo
//
//  Created by a on 2019/8/26.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Infomation.h"
#import "FirstViewController+Extension.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "TransformValueDelegate.h"

#import "MObject.h"
#import "MObserver.h"

@interface ViewController ()<TransformValueDelegate,TransformValueSecondDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //TODO:你使用分类做了哪些事情？
    //1、声明私有方法
    //2、分解体积庞大的类文件
    //3、把Framework的私有化方法公开
    
    //TODO:分类的特点：
    //1、在运行时进行决议：在编写分类文件后，他并没有把分类当中对应添加的内容，附加到相应的宿主类上面，这时，宿主类还没有分类中，所对应的方法。而是在运行时，通过runtime把分类当中添加的内容，真实的添加到对应的宿主类上面。
    //2、可以为系统类添加分类而扩展不能为系统类添加扩展。
    
    //TODO:分类中可以添加哪些内容？
    //1、添加实例方法，类方法，添加协议，添加属性（只声明get\set方法，没有生成相应的实例变量）
    //2、可以通过关联对象，添加实例变量。
    
    //分类的加载调用栈：首先进行runtime初始化，也就是调用_objc_init-->map_2_images-->map_images_nolock-->_red_images（加载可执行文件，到内存中）-->remethodizeClass(逻辑代码处)。
    
    
    //TODO:分类有多个的时候，哪个分类中的同名方法会生效？？
    //最后编译的分类中的同名方法会最终生效。
    
    /*
     
     总结：
         分类添加的方法可以‘覆盖’原类方法
         同名的分类方法谁能生效取决于编译顺序 --> 最后编译的分类中的同名方法会最终生效。
         名字相同的分类会引起编译报错
     
     */
    
    /*
     TODO:category原理流程：
     remethodizeClass-->判别是哪一种分类（类方法、实例方法）-->尝试获取所有未完成整合的分类（unattachedCategoriesForClass）---->就将未完成整合的分类，拼接到宿主类上面（attachCategories）
     
     如何进行拼接的呢？？
     
     attachCategories-->判断是否有分类-->判别是哪一种分类（类方法、实例方法）--->创建一个分类的方法列表（method_list_t）-->对分类cats进行倒叙遍历，并添加到分类的方法列表中-->通过attachLists方法将分类的方法附加到宿主类的上面。
     
     具体实现：
     
     attachLists-->判断是否有分类-->更改原有宿主的方法总数-->根据新总数重新分配内存-->并通过内存移动（memmove）内存拷贝（memcpy）来完成分类附加到宿主类的任务，从而使宿主类具有分类的方法。
     
 
     */
    
    
    //TODO:怎样为分类添加成员变量？
    //可以使用关联对象的方法为其添加实例变量。
    
    //主要涉及到的方法：
    
    //获取关联：
    //objc_getAssociatedObject(id  _Nonnull object, const void * _Nonnull key);
    
    //设置关联：
//    policy:与关联引用相关的策略。
    
//    OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
//    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
//                                            *   The association is not made atomically. */
//    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
//                                            *   The association is not made atomically. */
//    OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
//                                            *   The association is made atomically. */
//    OBJC_ASSOCIATION_COPY = 01403
    
//    object:关联的源对象。
//    value要与对象关联的值。可以将其设置为nil,来移除关联性。
//    key 关联的key值：传递进去的是，在分类中的声明的方法或者选择器：@selector(text);
    
//    objc_setAssociatedObject(id  _Nonnull object, const void * _Nonnull key, id  _Nullable value, objc_AssociationPolicy policy);
    
    
    //移除关联：
    //objc_removeAssociatedObjects(id  _Nonnull object);
    
    
    //TODO:添加成员变量的位置具体的添加到了哪里？
    //关联对象的本质：
    //关联对象是由AssociationsManager管理并在AssociationsHashMap中存储。
    //所有对象的关联都在同一个全局容器中。
    
    
    /*
     TODO:怎样将一个值，关联到对象上面的
     
     数据结构：objcAssociation(policy,value)-->ObjectAssociationMap(key,objcAssociation)映射到-->(ObjectAssociationMap)----->实际上是放在AssociationsHashMap中的（通过当前被关联对象的指针值，来建立与ObjectAssociationMap的映射来实现将一个值关联到一个实例对象上面AssociationsHashMap实现的。
     
     
     具体的实现流程：
     
     首先根据策略值对value进行处理-->newValue
     
     通过AssociationsManager获取全局容器AssociationsHashMap-->根据对象的指针地址按位取反作为该对象在AssociationsHashMap存储的对象指针。
     
     newValue != nil -->获取ObjectAssociationsMap 如果说本次进行关联的时候，之前有其他对象进行关联过，那么获得就不为空，否则，为空。
     
         i != associations.end()(非第一次)-->根据对象关联的对象指针获取所关联的ObjectAssociationMap（对象关联的map）-->在对象关联的map中，根据我们d传递的key进行查找-->如果说查找到了将value更换成最新的，如果没有查到，就进行创建一个ObjcAssociation，将newValue，policy组成的数据封装成ObjcAssociation并与key映射到ObjectAssociationMap[(*refs)[key] = ObjcAssociation(policy, new_value);]
     
         i == associations.end()（第一次）-->创建一个ObjectAssociationMap-->将ObjectAssociationMap与disguised_object（对象指针）映射到AssociationsHashMap中（ObjectAssociationMap *refs = new ObjectAssociationMap;
         associations[disguised_object] = refs;）-->将newValue，policy组成的数据封装成ObjcAssociation并与key映射到ObjectAssociationMap[(*refs)[key] = ObjcAssociation(policy, new_value);]-->附加到相应的源对象上面。
     
      newValue == nil-->根据对象获取对象关联Map(ObjectAssociationMap)-->查找到了，就根据key从ObjectAssociationMap获取ObjcAssociation，获取到了，就进行了一个擦出的操作。
     
     */
    
    
    /*
     TODO:扩展：Extension
     
     一般使用扩展来做什么？？
     //添加私有属性,添加私有方法,声明私有成员,私有类方法
     
     特点：
     编译时决议
     只以声明的方式存在，多数情况下，寄生于宿主类的.m中.
     不能为系统类添加扩展。
     
     */

    //使用分类：
    [self useCategoryMethod];
    
    
    /*
     TODO:代理：Delegate
     
     //什么是代理？
     代理是一种软件设计模式
     iOS当中以@protocol形式表现出来
     传递方式是一对一。（通知一对多）
     
     TODO:代理的工作流程：
     协议、代理方、委托方：
     
     委托方，要求代理方需要实现的全部接口，定义在协议（属性、方法）当中；由代理方按照协议进行方法的实现；可能需要一个返回值，返回一个处理结果，给委托方（协议方法调用方）；委托方需要调用代理方遵从的协议中的方法；
     
     TODO:代理以及委托方是以怎样的关系存在的？？
     一般我们会在委托方当中，声明为weak以规避循环引用。
     代理方会强持有他的委托方，而此时，委托方需要有一个代理方的声明为弱引用（weak），这样就规避了循环引用。
     
     //当然代理也可以有第二种方式，就是不需要有单独的文件，而是直接在委托方的头文件中定义；
     
     */
    
    /*
     TODO:通知 Notification
     
     是使用观察者模式来实现的，用于跨层传递消息的机制。（网络层--数据层---业务逻辑层---UI层）
     传递方式一对多。
     
     TODO:如何实现通知机制？？
     
     在通知中心可能会维持一个Map表或者是字典：NotificationMap(key是notificationName Value:是通知列表（Observers_list包含通知接受的观察者（Observer）以及观察者调用的方法）)
     
     //过于简单不做Demo,演示。
     
     */
    
    
    /*
     TODO:观察者 KVO
     
     1、什么是KVO?
     KVO全称为Key-value observing 的缩写
     KVO的实现模式是观察者模式。
     Apple  运用了 isa混写（isa-swizzling）来实现了KVO
     
     2、isa-swizzling 是如何实现KVO的。 NSKVONotifying_A 是 A 的一个子类，之所以创建这样一个子类，就是为了重写父类的Setter方法，负责通知所有对象
     
     *==============================
     NSKVONotifying_A的setter方法的具体的实现
     -(void)setValue:(id)obj{
         [self willChangeValueForKey:@"keyPath"];
         [super setValue:obj];
         [self didChangeValueFroKey:@"keyPath"];
     }
     =============================*
     3、KVO的实现机制是什么？
     注册观察者（addObserverForPath:）--> 比如说：观察者观察对象A的成员变量或者属性 --> 系统会为我们动态生成一个NSKVONotifying_A的类 --> 又会将原来指向A的isa 指针 指向了 NSKVONotifying_A 类,现在创建 NSKVONotifying_A 类的时候，会重写A 的setter方法，在重写的setter方法中，会首先调用 [self willChangeValueForKey:@"keyPath"];接着调用父类的setter方法 [super setValue:obj];最后调用  [self didChangeValueFroKey:@"keyPath"];（如上代码）在调用最后的didChangeValueFroKey方法的时候，会出发观察者的observeValueForKeyPath方法，从而完成整个的观察者的工作流程。
     
     4、如何手动添加KVO？
     如下添加即可：
     [self willChangeValueForKey:@"value"];
     _value += 1;
     [self didChangeValueForKey:@"value"];
     
     以上我们所熟知的观察的模式KVO。接下来，我们来思考这样两个问题。
     **1. 使用KVC给变量赋值，会触发KVO吗？**
     答案是肯定的，因为在使用KVC赋值的时候，触发了对象的setter方法，在[Demo](https://github.com/Ama-SmallBoy/CategoryDemo.git)的有相应的印证代码。
     
     2. 直接给成员变量赋值，会触发KVO吗？
     答案：不能触发KVO的。从KVO的实现机制中，我们知道，系统为我们提供的KVO相当于在我们的setter 方法中插入了两行代码willChangeValueForKey：和 didChangeValueForKey：，那么我们是否也可以在成员变量赋值的时候，手动的添加这两行代码，来模拟系统的setter方法，来实现KVO呢，答案是肯定。这就是我们手动添加KVO的一个运用场景。具体实现，可参考[Demo](https://github.com/Ama-SmallBoy/CategoryDemo.git)中的事例代码。
     
     */
    [self showObserverDemo];
    
    /*
     TODO:KVC Key-value coding的s缩写.
     
     -(id)valueForKey:(NSString *)key;
     
     -(void)setValue:(id)value forKey:(NSString *)key;
     
     TODO:我们使用键值编码，是否会破坏面向对象的编程方法？会。如果我们知道了一个类的私有的成员变量，我们就可以使用键值编码进行更改与访问：类似这种：[obj setValue:@2 forKey:@"value"];
     
     TODO:valueForKey 的系统实现流程：首先：会判断通过Key访问的实例变量是否有相应的get方法，如果存在，就直接调用，然后结束。如果不存，就会判断实例变量是否存在，通过+(BOOL)accessInstanceVariablesDirectly判断实例变量是否存在,默认值为YES(key与成员变量相同或者相似都会返回YES)。如果不存，系统会调用当前实例的valueForUndefinedKey:方法，然后会抛出一个为定义Key 的异常，然后结束valueForKey的调用流程。
     
     TODO: 访问器方法是否存在的判断规则：getKey key isKey 都说get方法存在。
     
     实例变量说明：_key\_isKey\key\isKey 都可以说明key成员变量存在。
     
     setValue:forKey:的流程同valueForKey:基本相同。
     
     */
    
    /*属性关键字：
     
     读写权限
     引用计数
     原子性：atomic 保证s赋值和获取线程安全的，并不能保证其操作与访问的安全性。比如修饰的是数组：对数组进行赋值或者获取，可以保证线程安全的。对于数组的添加和删除，则不能保证线程安全。
     
     TODO:weak 和 assign 区别 ？？
     assign 特点：1、修饰数据类型 2、在修改对象时，引用计数不改变 3、会产生悬垂指针（在修饰的对象被释放掉后，其仍然指向该对象的内存地址。）（引起内存泄漏，野指针）
     
     weak 特点：1、不改变g被修饰对象的引用计数。 2、所指代的对象在被释放后，会自动置为nil.
     
     weak 指针在被废弃之后，为何会被置为nil呢。
     
     
     copy : 浅拷贝 拷贝的仅仅是指针，内存并没有发生改变，也就说，原指针和拷贝后的对象，都指向一个内存空间。而深拷贝：拷贝的不仅仅是指针，还拷贝了内存空间，也就是，这是两个内容完全相同的内存空间。
     
     浅拷贝：是对内存地址的复制，目标对象指针和源对象指针指向同一片内存空间。
     
     
     如何区别深拷贝&&浅拷贝：1、是否开辟了内存空间 2、是否会引起对象的引用计数的更改。
     
     
     
     可变对象的copy与mutableCopy 都是深拷贝，
     不可变对象的copy是浅拷贝，mutableCopy 是深拷贝。
     
     copy 方法返回的都是不可变对象。

     //浅拷贝（指针复制，不会创建一个新的对象）
     - (id)copyWithZone:(NSZone *)zone{
        return self;
     }
     
     
     //深拷贝(内容复制，会创建一个新的对象)
     //- (id)copyWithZone:(NSZone *)zone{
     //    //创建新的对象空间
     //    Model1 *model = [[Model1 allocWithZone:zone]init];
     //   //属性也进行深层拷贝
     //    model.name = [self.name mutableCopy];
     //    return model;
     //}
     
     
     MRC下如何重写retain修饰变量的setter方法？？
     @property(nonatomic,retain) id obj;
     
     -(void)setObj:(id)obj{
         if (_obj!=obj) {
         [_obj release];
         _obj = [obj retain];
         }
     }
     
     为什么要进行判断_obj != obj;???
     
     如果不进行判断？假设：_obj 与 obj 是同一个话，那么， [_obj release]; _obj 被释放，当我们在[obj retain];程序就会保存，Crash。

     
     */
    
    
}



//展示观察者模式：
-(void)showObserverDemo{
    
    MObject *obj = [[MObject alloc] init];
    MObserver *observer = [[MObserver alloc] init];
    
  
    //调用kvo方法监听obj的value属性的变化
    [obj addObserver:observer forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:NULL];
    
    //通过setter方法修改value
    obj.value = 1;
    
    // 1 通过kvc设置value能否生效？如果可以，原因是什么？？
    [obj setValue:@2 forKey:@"value"];//由于KVC调用了Obj的setter方法，所以也能触发。如何印证，可以重写obj的setter 方法。
    
    // 2. 通过成员变量直接赋值value能否生效?不能触发KVO,需要手动添加才可以。
    [obj increase];

}

//使用分类：
-(void)useCategoryMethod{
    UILabel * testlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    testlabel.name = @"我的名字";
    testlabel.text = testlabel.name;
    NSLog(@"======%@",testlabel.name);
    testlabel.center = self.view.center;
    [self.view addSubview:testlabel];
}

- (IBAction)pushFirstVC:(UIButton *)sender {
    
    //使用扩展：
    FirstViewController * firstVC = [[FirstViewController alloc]init];
    [self.navigationController pushViewController:firstVC animated:YES];

    firstVC.type = @"静态label";
    NSLog(@"=====%@",firstVC.type);
    [firstVC changTextByImportText:@"我的类型是静态label"];
    [FirstViewController changTextName:@"小不点"];
   
}

//代理
- (IBAction)pushSecondVCAction:(UIButton *)sender {
    //使用扩展：
    SecondViewController * secondViewController = [[SecondViewController alloc]init];
    
    //设置为代理
    secondViewController.transformValueDelegate = self;
    
    secondViewController.transformValueSecondDelegate = self;
    
    [self.navigationController pushViewController:secondViewController animated:YES];
}

#pragma mark-----------delegate 实现代理中的方法-----

-(void)fromSecondVControllerValue:(NSString *)value{
    NSLog(@"====第一种方式===我是协议代理方====从委托方回传的值:%@",value);
}

-(void)transformValueSecondValue:(NSString *)value{
    NSLog(@"====第二种方式===我是协议代理方====从委托方回传的值:%@",value);
}

@end
