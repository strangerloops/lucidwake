//
//  LWAlarmNotification.m
//  Lucidwake
//
//  Created by   on 2/1/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWAlarmNotification.h"
#import "LWAlarm.h"
#import "LWTemporallyOrderedNotifications.h"

@implementation LWAlarmNotification

- (void)reschedule
{
    NSLog(@"Before rescheduling: %d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
    if (!_snooze)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *rightNow = [NSDate date];
        NSDateComponents *weekdayComponents = [cal components:NSWeekdayCalendarUnit fromDate:rightNow];
        int todayWeekday = [weekdayComponents weekday];
        if ([[[_alarm weekly] objectAtIndex:(todayWeekday - 1)] intValue] == 1)
        {
            NSDateComponents *repeatComponent = [[NSDateComponents alloc] init];
            [repeatComponent setDay:7];
            NSDate *rescheduleDate = [cal dateByAddingComponents:repeatComponent toDate:rightNow options:0];
            LWAlarmNotification *an = [[LWAlarmNotification alloc] init];
            [an setFireDate:rescheduleDate];
            [an setAlarm:_alarm];
            [[LWTemporallyOrderedNotifications sharedStore] addNotification:an];
        }
        if ([_alarm retriggers] > 0 && [_alarm retriggerInterval] > 0)
        {
            for (int i = 0; i < [_alarm retriggers]; i++)
            {
                NSDateComponents *retriggerComponent = [[NSDateComponents alloc] init];
                [retriggerComponent setMinute:((i + 1) * [_alarm retriggerInterval])];
                NSDate *retriggerDate = [cal dateByAddingComponents:retriggerComponent toDate:rightNow options:0];
                LWAlarmNotification *rn = [[LWAlarmNotification alloc] init];
                [rn setFireDate:retriggerDate];
                [rn setAlarm:_alarm];
                [rn setSnooze:true];
                [[LWTemporallyOrderedNotifications sharedStore] addNotification:rn];
            }
        }
    }
    NSLog(@"After rescheduling: %d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_alarm forKey:@"alarm"];
    [aCoder encodeObject:_fireDate forKey:@"fireDate"];
    [aCoder encodeBool:_snooze forKey:@"snooze"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setAlarm:[aDecoder decodeObjectForKey:@"alarm"]];
        [self setFireDate:[aDecoder decodeObjectForKey:@"fireDate"]];
        [self setSnooze:[aDecoder decodeBoolForKey:@"snooze"]];
    }
    return self;
}

@end
