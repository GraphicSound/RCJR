//
//  TEAppDelegate.m
//  TabbedExp
//
//  Created by yu_hao on 10/8/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "TEAppDelegate.h"

@implementation TEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UINavigationController *navigationBarController = self.window.rootViewController.navigationController;
//    UITabBarController *tabBarController = self.window.rootViewController.tabBarController;
//    UITabBar *tabBar = tabBarController.tabBar;
//    UINavigationBar *navigationBar = navigationBarController.navigationBar;
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    float currentVersion = 7.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        NSLog(@"Running in IOS_7");
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:236/256.0 green:162/256.0 blue:222/256.0 alpha:1.0]];
    } else
    {
        UIImage *navBackgroundImage = [UIImage imageNamed:@"navi_bg"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:246/256.0 green:182/256.0 blue:198/256.0 alpha:1.0]];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
