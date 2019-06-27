//
//  NSObject+XLKVO.h
//  自定义KVO
//
//  Created by 谭启龙 on 2019/6/25.
//  Copyright © 2019 谭启龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XLKVO)

//监听
-(void)xlAddObserver:(id)obj forKeypath:(NSString *)keyPath;

//回调
-(void)xlObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object;

@end

NS_ASSUME_NONNULL_END
