//
//  LWAppDelegate.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "LWAppDelegate.h"
#import "LWAlarmViewController.h"
#import "LWRecordingsViewController.h"
#import "LWTemporallyOrderedNotifications.h"
#import "LWAlarmStore.h"
#import "LWAlarm.h"
#import "LWAlarmNotification.h"
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
    [tbi setImage:[UIImage imageNamed:@"alarm.png"]];
    UITabBarItem *tbii = [recordingController tabBarItem];
    [tbii setTitle:@"Recordings"];
    [tbii setImage:[UIImage imageNamed:@"z.png"]];
    
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
    success = [[LWTemporallyOrderedNotifications sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"Saved temporal ordering.");
    }
    else
    {
        NSLog(@"Failed to save temporal ordering.");
    }
    if ([[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count] > 0)
    {
        UIApplication *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier bgTask = 0;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
        }];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"silence" ofType:@".wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
        [player setNumberOfLoops:-1];
        silenceTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(playSilence) userInfo:nil repeats:YES];
        NSDate *rightNow = [NSDate date];
        NSTimeInterval timerInterval = [[[[[LWTemporallyOrderedNotifications sharedStore] allNotifications] objectAtIndex:0] fireDate] timeIntervalSinceDate:rightNow];
        alarmTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(triggerAlarm) userInfo:nil repeats:NO];
        [player prepareToPlay];
        [player play];
        [player stop];
    }
}

- (void)playSilence
{
    NSLog(@"playSilence method called");
//    [player stop];
//    [player setCurrentTime:0];
//    [player prepareToPlay];
//    [player play];
    [player prepareToPlay];
    [player play];
    [player stop];
}

- (void)triggerAlarm
{
    [self performSelectorOnMainThread:@selector(playAlarm) withObject:Nil waitUntilDone:YES];
}

- (void)playAlarm
{
    NSLog(@"playAlarm method called");
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    LWAlarmNotification *alarmNotification = [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] objectAtIndex:0];
    [silenceTimer invalidate];
    silenceTimer = nil;
    [player stop];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:[[alarmNotification alarm] sound] ofType:@".m4r"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    [player setNumberOfLoops:-1];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [player play];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setAlertBody:[[alarmNotification alarm] name]];
    [localNotification setFireDate:[NSDate date]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    shouldPresentMicrophone = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startRecording" object:nil];
    [alarmNotification reschedule];
    [[LWTemporallyOrderedNotifications sharedStore] removeNotification:alarmNotification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [player stop];
    [alarmTimer invalidate];
    alarmTimer = nil;
    if (shouldPresentMicrophone)
    {
        [_tabControl setSelectedIndex:1];
        shouldPresentMicrophone = false;
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
