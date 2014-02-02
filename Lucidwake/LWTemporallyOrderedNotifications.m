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
    [allNotifications removeObjectIdenticalTo:p];
}

- (void)unscheduleNotificationsForAlarm:(LWAlarm *)p
{
    for (int i = 0; i < [allNotifications count]; i++)
    {
        LWAlarmNotification *an = [allNotifications objectAtIndex:i];
        if (![an alarm] || [an alarm] == p)
        {
            [self removeNotification:an];
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
