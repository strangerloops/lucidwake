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
#import "LWAlarmNotification.h"

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
    [c setRetriggerInterval:[self retriggerInterval]];
    [c setRetriggers:[self retriggers]];
    return c;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_sound forKey:@"sound"];
    [aCoder encodeObject:_hourMinutes forKey:@"hourMinutes"];
    [aCoder encodeObject:_weekly forKey:@"weekly"];
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
        [self setRetriggerInterval:[aDecoder decodeIntForKey:@"retriggerInterval"]];
        [self setRetriggers:[aDecoder decodeIntForKey:@"retriggers"]];
    }
    return self;
}

- (void)scheduleNotifications
{
    NSLog(@"Before scheduling: %d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
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
            
            LWAlarmNotification *an = [[LWAlarmNotification alloc] init];
            [an setFireDate:repeatDate];
            [an setAlarm:self];
            [[LWTemporallyOrderedNotifications sharedStore] addNotification:an];
            scheduled = true;
        }
    }
    if (!scheduled)
    {
        LWAlarmNotification *an = [[LWAlarmNotification alloc] init];
        [an setFireDate:scheduledDate];
        [an setAlarm:self];
        [[LWTemporallyOrderedNotifications sharedStore] addNotification:an];
    }
    NSLog(@"After scheduling: %d", [[[LWTemporallyOrderedNotifications sharedStore] allNotifications] count]);
}

@end
