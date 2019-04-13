//
//  InjectionIIIHelper.m
//  SYLibDemo
//
//  Created by zhangshuangyi on 2019/4/13.
//  Copyright © 2019 ZHSY. All rights reserved.
//

#import "InjectionIIIHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation InjectionIIIHelper


/**
 InjectionIII 热部署会调用的一个方法，
 runtime给VC绑定上之后，每次部署完就重新viewDidLoad
 */
void injected (id self, SEL _cmd) {
    [self viewDidLoad];
}

+ (void)load
{
#if DEBUG
    //注册项目启动监听
    __block id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

        //更改bundlePath
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];

        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    //给UIViewController 注册injected 方法
    class_addMethod([UIViewController class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
    
#endif
}

@end
