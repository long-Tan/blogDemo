//
//  NSObject+XLKVO.m
//  自定义KVO
//
//  Created by 谭启龙 on 2019/6/25.
//  Copyright © 2019 谭启龙. All rights reserved.
//

#import "NSObject+XLKVO.h"
#import <objc/message.h>


@implementation NSObject (XLKVO)

-(void)xlAddObserver:(id)obj forKeypath:(NSString *)keyPath {
    //1.注册一个中间类XLKVO_开头的子类 继承自当前类
    Class superClass = object_getClass(self);
    NSString * newClassName = [NSString stringWithFormat:@"XLKVO_%@",NSStringFromClass(superClass)];
    //判断下是否注册过
    Class newClass;
    if (!NSClassFromString(newClassName)) {
        //创建新类
        newClass = [self registerNewClass:superClass newClassName:newClassName];
        //改变 当前类的isa只向newClass 此时所有的函数执行都要经过子类newClass了
        object_setClass(self, newClass);
        
    
    }
    
    
    //关联对象 obj，以便在后面通知执行回调方法
    objc_setAssociatedObject(self, @"xlobserver", obj, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, @"keyPath", keyPath, OBJC_ASSOCIATION_RETAIN);
    
    
    //2.动态给newClass添加一个setter方法 实现方法重写完成监听回调
    //注：这里的所有的self都是只的新的类
    
    NSString * setterName = [self setterNameFromKeyPath:keyPath];
    if (![self hasSelector:NSSelectorFromString(setterName)]) {
        Method setterMethod = class_getInstanceMethod(superClass, NSSelectorFromString(setterName));
        const char * types = method_getTypeEncoding(setterMethod);
        class_addMethod(newClass, NSSelectorFromString(setterName), (IMP)xlKVOStter, types);
    }
    
}


//注册一个新的类
-(Class)registerNewClass:(Class)superClass newClassName:(NSString *)newClassName{
    //生成一个类继承自superClass
    Class newClass = objc_allocateClassPair(superClass, newClassName.UTF8String, 0);
    
    
    //重写对象的class方法,将KVO_XXX的class指向监听类的class，达到用户无感知的目的
    Method classMethod = class_getInstanceMethod(superClass, NSSelectorFromString(@"class"));
    const char * classTypes = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, NSSelectorFromString(@"class"), (IMP)KVOClass, classTypes);
    
    //注册
    objc_registerClassPair(newClass);
    return newClass;
}

//setter方法的IMP实现 前两个参数固定的写法 _cmd在Objective-C的方法中表示当前方法的selector
static void xlKVOStter(id self,SEL _cmd,id value) {
    //1.执行父类的方法
    //消息转发 直接去执行父类的
    //结构体 点的作用是结构体成员指定初始化
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    //取结构体地址 执行消息发送
    objc_msgSendSuper(&superStruct,_cmd,value);
    
    
    //2.调用observer通知属性即将改变
    id obj = objc_getAssociatedObject(self, @"xlobserver");
    NSString * keyPath = objc_getAssociatedObject(self, @"keyPath");
    [obj xlObserveValueForKeyPath:keyPath ofObject:self];
   
}

//拼接setter方法名
-(NSString *)setterNameFromKeyPath:(NSString *)name {
    NSString * firstName = [[name substringToIndex:1]uppercaseString];
    NSString * otherStr = [name substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@:",firstName,otherStr];
}

//判断是否存在该方法
-(BOOL)hasSelector:(SEL)selector {
    Class myclass = object_getClass(self);
    unsigned int methodCount = 0;
    //获取该类的方法列表,列表是一个结构体指针的数组
    Method * methodList = class_copyMethodList(myclass, &methodCount);
    
    for (int i = 0; i < methodCount; i++) {
        SEL sel = method_getName(methodList[i]);
        if (sel == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

static Class KVOClass (id self,SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

@end
