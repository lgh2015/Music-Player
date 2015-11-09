//
//  AppDelegate.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//


//指定根视图->设置背景视图的模糊效果->想显示表视图的数据->封装musicmanager(处理数据,封装功能要全面,封装要彻底,封装的功能要明确)->对数据处理完毕后要赋值给model类,所以仍然需要接着封装model(注意对特殊数据的处理)->根据需求判断是否需要自定义cell

#import "AppDelegate.h"
#import "MusicListTableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.初始化window
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.将这个window显示出来
    [self.window makeKeyAndVisible];
    //3.创建音乐播放器列表控制器对象
    MusicListTableViewController *musicVC=[[MusicListTableViewController alloc]init];
    //4.创建一个导航控制器
    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:musicVC];
    //5.指定window的根视图
    self.window.rootViewController=navi;
    //6.设置导航控制器的样式为黑色样式
    [[UINavigationBar appearance]setBarStyle:UIBarStyleBlackTranslucent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
