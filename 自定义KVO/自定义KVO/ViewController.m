//
//  ViewController.m
//  自定义KVO
//
//  Created by 谭启龙 on 2019/6/25.
//  Copyright © 2019 谭启龙. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+XLKVO.h"
#import "Person.h"

@interface ViewController ()
@property (nonatomic,strong) Person * person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _person = [Person new];
    NSLog(@"%@",[_person class]);
    [_person xlAddObserver:self forKeypath:@"name"];
    
    _person.name = @"小明";
    NSLog(@"%@",[_person class]);
}


-(void)xlObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object {
    NSLog(@"监听的新名字%@",[object valueForKey:keyPath]);
}

@end
