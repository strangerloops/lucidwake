//
//  LWAlarmCell.m
//  Lucidwake
//
//  Created by   on 1/2/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWAlarmCell.h"
#import "LWAlarm.h"
#import "LWAlarmStore.h"

@implementation LWAlarmCell

@synthesize statusSwitch;

- (IBAction)statusSwitch:(id)sender
{
    LWAlarm *alarm = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:_index];
    if ([statusSwitch isOn])
    {
        BOOL scheduled = false;
        
        for (int i = 0; i < [[alarm weekly] count]; i++)
        {
            NSNumber *n = [[alarm weekly] objectAtIndex:i];
            if ([n intValue] == 1)
            {
                NSDate *today = [NSDate date];
                NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today];
                NSInteger todayWeekday = [weekdayComponents weekday];
                
                NSInteger dayDifference = (i + 1) - todayWeekday;
                if (dayDifference < 1)
                {
                    dayDifference += 7;
                }
                NSDateComponents *repeatComponent = [[NSDateComponents alloc] init];
                [repeatComponent setDay:dayDifference];
                NSDate *repeatDate = [[NSCalendar currentCalendar] dateByAddingComponents:repeatComponent toDate:today options:0];
                UILocalNotification *l = [[UILocalNotification alloc] init];
                [l setFireDate:repeatDate];
                [l setAlertBody:[alarm name]];
                [l setRepeatInterval:NSWeekCalendarUnit];
                [[alarm notificationsArray] addObject:l];
                [[UIApplication sharedApplication] scheduleLocalNotification:l];
                NSLog(@"%@", repeatDate);
                scheduled = true;
            }
        }
        if (!scheduled)
        {
            UILocalNotification *l = [[UILocalNotification alloc] init];
            [l setFireDate:[alarm time]];
            [l setAlertBody:[alarm name]];
            [[alarm notificationsArray] addObject:l];
            [[UIApplication sharedApplication] scheduleLocalNotification:l];
        }
        for (UILocalNotification *u in [alarm notificationsArray])
        {
            if ([alarm retriggers] > 0)
            {
                for (int i = 0; i < [alarm retriggers]; i++)
                {
                    NSDateComponents *retriggerComponent = [[NSDateComponents alloc] init];
                    [retriggerComponent setMinute:([alarm retriggerInterval] * (i + 1))];
                    NSDate *retriggerDate = [[NSCalendar currentCalendar] dateByAddingComponents:retriggerComponent toDate:[u fireDate] options:0];
                    UILocalNotification *r = [[UILocalNotification alloc] init];
                    [r setFireDate:retriggerDate];
                    NSLog(@"%@", retriggerDate);
                    [r setAlertBody:[u alertBody]];
                    [[alarm retriggersArray] addObject:r];
                    [[UIApplication sharedApplication] scheduleLocalNotification:r];
                }
            }
        }
    } else
    {
        for (UILocalNotification *n in [alarm notificationsArray])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:n];
            [[alarm notificationsArray] removeObjectIdenticalTo:n];
        }
        for (UILocalNotification *n in [alarm retriggersArray])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:n];
            [[alarm retriggersArray] removeObjectIdenticalTo:n];
        }
    }
}

@end
