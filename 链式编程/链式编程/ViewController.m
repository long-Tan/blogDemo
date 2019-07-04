//
//  ViewController.m
//  链式编程
//
//  Created by 谭启龙 on 2019/7/3.
//  Copyright © 2019 谭启龙. All rights reserved.
//

#import "ViewController.h"


#define KVAR_VOID(name,...) void(^name)(__VA_ARGS__)

//name=block名字 obj返回值类型 ...表示任意参数
#define KVAR(name,obj,...) obj(^name)(__VA_ARGS__)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.personNameIs(@"小明");
//    [self sayHello:@"小明"];
//
////    self.myNameIs(@"小王").sayHello;
//
//    self.personNameIs1(@"小明");
//
    self.MyNameIs1(@"小明",@" 朋友");
    self.personNameIs2(@"小明");
//
//    self.name;
//    self.name = [NSObject new];

//    self.sayHello(@"小明").helloWolrd;
}


void sayHi(NSString * a1,NSString * a2) {
    NSLog(@"%@...%@",a1,a2);
}

//不带参数的形式
-(ViewController *(^)(NSString * name))sayHello{
    ViewController *(^block)(NSString* name)  = ^(NSString * name) {
        NSLog(@"Person的名字是%@",name);
        return self;
    };
    return block;
}

-(void)helloWolrd {
    NSLog(@"hello world");
}

//带参数的形式
-(void(^)(NSString * name))personNameIs{
    
    void(^block)(NSString* name)  = ^(NSString * name) {
        NSLog(@"Person的名字是%@",name);
    };
    return block;
}


//带返回值调用
-(ViewController *(^)(NSString * name))myNameIs {
    ViewController *(^block)(NSString * name) = ^(NSString * name) {
        NSLog(@"我的的名字是%@",name);
        return self;
    };
    return block;
}


//通过宏来实现参数传递===========
//不带返回值，仅仅是传递参数
-(KVAR_VOID(,NSString *))personNameIs1 {
    KVAR_VOID(block,NSString *) = ^(NSString * name) {
        NSLog(@"person的名字%@",name);
    };
    return block;
}

//待返回值的形式
-(KVAR(,ViewController *,NSString *,NSString *))MyNameIs1 {
    KVAR(block, ViewController *,NSString *,NSString *) = ^(NSString * name1,NSString * name2) {
        NSLog(@"我的名字是%@ %@",name1,name2);
        return self;
    };
    return block;
}

-(KVAR(,void,NSString *))personNameIs2 {
    KVAR(block,void,NSString *) = ^(NSString * name) {
        NSLog(@"Person的名字是%@",name);
    };
    return block;
}


@end
