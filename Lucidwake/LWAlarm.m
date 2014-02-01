//
//  LWAlarm.m
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAlarm.h"
#import "LWAlarmStore.h"
#import "LWTemporallyOrderedNotifications.h"

@implementation LWAlarm

- (id)init
{
    self = [super init];
    [self setName:@"Alarm"];
    [self setSound:@"Uplift"];
    [self setWeekly:[[NSMutableArray alloc] init]];
    for (int i = 0; i < 7; i++)
    {
        [_weekly addObject:[NSNumber numberWithInt:0]];
    }
    [self setNotificationsArray:[[NSMutableArray alloc] init]];
    [self setRetriggersArray:[[NSMutableArray alloc] init]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"cleanArrays" object:nil];
    return self;
}

- (LWAlarm *)clone // this is disgusting
{
    LWAlarm *c = [[LWAlarm alloc] init];
    [c setName:[NSString stringWithFormat:[self name]]];
    [c setSound:[NSString stringWithFormat:[self sound]]];
    NSDateComponents *d = [[NSDateComponents alloc] init];
    [d setMinute:[[self hourMinutes] minute]];
    [d setHour:[[self hourMinutes] hour]];
    [c setHourMinutes:d];
    NSMutableArray *w = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[self weekly] count]; i++)
    {
        NSNumber *n = [NSNumber numberWithInt:[[[self weekly] objectAtIndex:i] intValue]];
        [w addObject:n];
    }
    [c setNotificationsArray:[[NSMutableArray alloc] init]];
    [c setRetriggersArray:[[NSMutableArray alloc] init]];
    [c setRetriggerInterval:[self retriggerInterval]];
    [c setRetriggers:[self retriggers]];
    return c;
}

- (void)receivedNotification:(NSNotification *)notification
{
    NSLog(@"%d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
    UILocalNotification *ln = [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] objectAtIndex:0];
    [_notificationsArray removeObjectIdenticalTo:ln];
    [_retriggersArray removeObjectIdenticalTo:ln];
    [[LWTemporallyOrderedNotifications sharedStore] removeNotification:ln];
    NSLog(@"%d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
    ln = nil;
    NSLog(@"LWAlarm's notification center method called.");
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_sound forKey:@"sound"];
    [aCoder encodeObject:_hourMinutes forKey:@"hourMinutes"];
    [aCoder encodeObject:_weekly forKey:@"weekly"];
    [aCoder encodeObject:_notificationsArray forKey:@"notificationsArray"];
    [aCoder encodeObject:_retriggersArray forKey:@"retriggersArray"];
    [aCoder encodeInt:_retriggerInterval forKey:@"retriggerInterval"];
    [aCoder encodeInt:_retriggers forKey:@"retriggers"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setSound:[aDecoder decodeObjectForKey:@"sound"]];
        [self setHourMinutes:[aDecoder decodeObjectForKey:@"hourMinutes"]];
        [self setWeekly:[aDecoder decodeObjectForKey:@"weekly"]];
        [self setNotificationsArray:[aDecoder decodeObjectForKey:@"notificationsArray"]];
        [self setRetriggersArray:[aDecoder decodeObjectForKey:@"retriggersArray"]];
        [self setRetriggerInterval:[aDecoder decodeIntForKey:@"retriggerInterval"]];
        [self setRetriggers:[aDecoder decodeIntForKey:@"retriggers"]];
    }
    return self;
}

- (void)scheduleNotifications
{
    BOOL scheduled = false;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *thisInstant = [NSDate date];
    NSDateComponents *thisInstantComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:thisInstant];
    [thisInstantComponents setHour:[_hourMinutes hour]];
    [thisInstantComponents setMinute:[_hourMinutes minute]];
    NSDate *scheduledDate = [cal dateFromComponents:thisInstantComponents];
    if ([scheduledDate compare:thisInstant] == NSOrderedAscending)
    {
        [thisInstantComponents setDay:[thisInstantComponents day] + 1];
        scheduledDate = [cal dateFromComponents:thisInstantComponents];
    }    
    for (int i = 0; i < [_weekly count]; i++)
    {
        NSNumber *n = [_weekly objectAtIndex:i];
        if ([n intValue] == 1)
        {
            NSDateComponents *weekdayComponents = [cal components:NSWeekdayCalendarUnit fromDate:scheduledDate];
            NSInteger scheduledWeekday = [weekdayComponents weekday];
            NSInteger dayDifference = (i + 1)  - scheduledWeekday;
            if (dayDifference < 1)
            {
                dayDifference += 7;
            }
            NSDateComponents *repeatComponent = [[NSDateComponents alloc] init];
            [repeatComponent setDay:dayDifference];
            NSDate *repeatDate = [cal dateByAddingComponents:repeatComponent toDate:scheduledDate options:0];
            UILocalNotification *ln = [[UILocalNotification alloc] init];
            [ln setFireDate:repeatDate];
            [ln setAlertBody:_name];
            [ln setRepeatInterval:NSWeekCalendarUnit];
            [ln setSoundName:_sound];
            [_notificationsArray addObject:ln];
            [[LWTemporallyOrderedNotifications sharedStore] addNotification:ln];
            [[UIApplication sharedApplication] scheduleLocalNotification:ln];
            NSLog(@"Scheduled notification for %@", [ln fireDate]);
            scheduled = true;
        }
    }
    if (!scheduled)
    {
        UILocalNotification *ln = [[UILocalNotification alloc] init];
        [ln setFireDate:scheduledDate];
        [ln setAlertBody:_name];
        [ln setSoundName:_sound];
        [_notificationsArray addObject:ln];
        [[LWTemporallyOrderedNotifications sharedStore] addNotification:ln];
        [[UIApplication sharedApplication] scheduleLocalNotification:ln];
        NSLog(@"Scheduled notification for %@", [ln fireDate]);
    }
    for (int i = 0; i < [_notificationsArray count]; i++)
    {
        UILocalNotification *ln = [_notificationsArray objectAtIndex:i];
        if (_retriggers > 0)
        {
            for (int j = 0; j < _retriggers; j++)
            {
                NSDateComponents *retriggerComponent = [[NSDateComponents alloc] init];
                [retriggerComponent setMinute:(_retriggerInterval * (j + 1))];
                NSDate *retriggerDate = [cal dateByAddingComponents:retriggerComponent toDate:[ln fireDate] options:0];
                UILocalNotification *r = [[UILocalNotification alloc] init];
                [r setFireDate:retriggerDate];
                [r setAlertBody:[ln alertBody]];
                [r setSoundName:_sound];
                [_retriggersArray addObject:r];
                [[LWTemporallyOrderedNotifications sharedStore] addNotification:ln];
                [[UIApplication sharedApplication] scheduleLocalNotification:r];
                NSLog(@"Scheduled notification for %@", [r fireDate]);
            }
        }
    }
}

- (void)unscheduleNotifications
{
    while ([_notificationsArray count] > 0)
    {
        UILocalNotification *ln = [_notificationsArray objectAtIndex:0];
        [_notificationsArray removeObjectAtIndex:0];
        [[LWTemporallyOrderedNotifications sharedStore] removeNotification:ln];
    }
    while ([_retriggersArray count] > 0)
    {
        UILocalNotification *ln = [_retriggersArray objectAtIndex:0];
        [_retriggersArray removeObjectAtIndex:0];
        [[LWTemporallyOrderedNotifications sharedStore] removeNotification:ln];
    }
}

@end
