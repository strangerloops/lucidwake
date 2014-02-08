//
//  LWTemporallyOrderedNotifications.m
//  Lucidwake
//
//  Created by   on 1/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWTemporallyOrderedNotifications.h"
#import "LWAlarmNotification.h"
#import "LWAlarm.h"

@implementation LWTemporallyOrderedNotifications

+ (LWTemporallyOrderedNotifications *)sharedStore
{
    static LWTemporallyOrderedNotifications *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        NSString *path = [self archivePath];
        allNotifications = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!allNotifications)
        {
            allNotifications = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allNotifications
{
    return allNotifications;
}

- (void)addNotification:(LWAlarmNotification *)p
{
    if ([allNotifications count] == 0)
    {
        [allNotifications addObject:p];
    }
    else
    {
        BOOL added = false;
        for (int i = 0; i < [allNotifications count]; i++)
        {
            LWAlarmNotification *q = [allNotifications objectAtIndex:i];
            if ([[p fireDate] compare:[q fireDate]] == NSOrderedAscending)
            {
                [allNotifications insertObject:p atIndex:i];
                added = true;
                break;
            }
        }
        if (!added)
        {
            [allNotifications addObject:p];
        }
    }
}

- (void)removeNotification:(LWAlarmNotification *)p
{
    NSLog(@"Temporally ordered array removeNotification method called, %lu before removing", (unsigned long)[allNotifications count]);
    [allNotifications removeObjectIdenticalTo:p];
    NSLog(@"%lu after removing", (unsigned long)[allNotifications count]);
}

- (void)unscheduleNotificationsForAlarm:(LWAlarm *)p
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (LWAlarmNotification *an in allNotifications)
    {
        if (![an alarm] || [an alarm] == p)
        {
            [toDelete addObject:an];
        }
    }
    for (LWAlarmNotification *an in toDelete)
    {
        [self removeNotification:an];
    }
}

- (void)relocateNotificationsFromAlarm:(LWAlarm *)p toAlarm:(LWAlarm *)q
{
    for (LWAlarmNotification *an in allNotifications)
    {
        if ([an alarm] == p)
        {
            [an setAlarm:q];
        }
    }
}

- (NSString *)archivePath
{
    NSString *localPath = @"Documents/notifications.archive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    return fullPath;
}

- (BOOL)saveChanges
{
    NSString *path = [self archivePath];
    return [NSKeyedArchiver archiveRootObject:allNotifications toFile:path];
}

@end
