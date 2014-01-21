//
//  LWAppDelegate.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAppDelegate.h"
#import "LWAlarmViewController.h"
#import "LWRecordingsViewController.h"
#import "LWAlarmStore.h"
#import "LWRecordingStore.h"

@implementation LWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LWAlarmViewController *alarmViewController = [[LWAlarmViewController alloc] init];
    LWRecordingsViewController *recordingsViewController = [[LWRecordingsViewController alloc] init];
        
    UINavigationController *alarmController = [[UINavigationController alloc] initWithRootViewController:alarmViewController];
    UINavigationController *recordingController = [[UINavigationController alloc] initWithRootViewController:recordingsViewController];
    
    UITabBarItem *tbi = [alarmController tabBarItem];
    [tbi setTitle:@"Alarms"];
    UITabBarItem *tbii = [recordingController tabBarItem];
    [tbii setTitle:@"Recordings"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:alarmController, recordingController, nil];
    [tabBarController setViewControllers:viewControllers];
    [self setTabControl:tabBarController];
    [[self window] setRootViewController:tabBarController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    BOOL success = [[LWAlarmStore sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"Saved the alarms.");
    } else
    {
        NSLog(@"Failed to save alarms.");
    }
    success = [[LWRecordingStore sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"Saved the recordings.");
    } else
    {
        NSLog(@"Failed to save recordings.");
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:nil];
    [[UIApplication sharedApplication] cancelLocalNotification:notification]; // this silences alarm post dismissal hopefully?
    [_tabControl setSelectedIndex:1];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
