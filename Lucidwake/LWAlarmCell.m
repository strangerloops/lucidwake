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

// probably scheduling / unscheduling notifications should be the alarm's method
// that way this disgusting code doesn't get repeated in the when the store has to unschedule alarms
// and like manually switching the switch ugh lol ugh

- (IBAction)statusSwitch:(id)sender
{
    LWAlarm *alarm = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:_index];
    if ([statusSwitch isOn])
    {
        BOOL scheduled = false;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSString *soundString = [[alarm sound] stringByAppendingString:@".m4r"];
        
        NSDate *thisInstant = [NSDate date];
        NSDateComponents *thisInstantComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:thisInstant];
        [thisInstantComponents setHour:[[alarm hourMinutes] hour]];
        [thisInstantComponents setMinute:[[alarm hourMinutes] minute]];
        NSDate *scheduledDate = [cal dateFromComponents:thisInstantComponents];
        
        // if scheduled date is earlier than this instant, add a day to scheduled date
        if ([scheduledDate compare:thisInstant] == NSOrderedAscending)
        {
            [thisInstantComponents setDay:[thisInstantComponents day] + 1];
            scheduledDate = [cal dateFromComponents:thisInstantComponents];
        }
        
        for (int i = 0; i < [[alarm weekly] count]; i++)
        {
            NSNumber *n = [[alarm weekly] objectAtIndex:i];
            if ([n intValue] == 1)
            {
                
                NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:scheduledDate];
                NSInteger scheduledWeekday = [weekdayComponents weekday];
                
                NSInteger dayDifference = (i + 1) - scheduledWeekday;
                if (dayDifference < 1)
                {
                    dayDifference += 7;
                }
                NSDateComponents *repeatComponent = [[NSDateComponents alloc] init];
                [repeatComponent setDay:dayDifference];
                NSDate *repeatDate = [[NSCalendar currentCalendar] dateByAddingComponents:repeatComponent toDate:scheduledDate options:0];
                UILocalNotification *l = [[UILocalNotification alloc] init];
                [l setFireDate:repeatDate];
                [l setAlertBody:[alarm name]];
                [l setRepeatInterval:NSWeekCalendarUnit];
                [l setSoundName:soundString];
                [[alarm notificationsArray] addObject:l];
                [[UIApplication sharedApplication] scheduleLocalNotification:l];
                scheduled = true;
            }
        }
        if (!scheduled)
        {
            UILocalNotification *l = [[UILocalNotification alloc] init];
            [l setFireDate:scheduledDate];
            [l setAlertBody:[alarm name]];
            [l setSoundName:soundString];
            [[alarm notificationsArray] addObject:l];
            [[UIApplication sharedApplication] scheduleLocalNotification:l];
        }
        for (int i = 0; i < [[alarm notificationsArray] count]; i++)
        {
            UILocalNotification *u = [[alarm notificationsArray] objectAtIndex:i];
            if ([alarm retriggers] > 0)
            {
                for (int i = 0; i < [alarm retriggers]; i++)
                {
                    NSDateComponents *retriggerComponent = [[NSDateComponents alloc] init];
                    [retriggerComponent setMinute:([alarm retriggerInterval] * (i + 1))];
                    NSDate *retriggerDate = [[NSCalendar currentCalendar] dateByAddingComponents:retriggerComponent toDate:[u fireDate] options:0];
                    UILocalNotification *r = [[UILocalNotification alloc] init];
                    [r setFireDate:retriggerDate];
                    [r setAlertBody:[u alertBody]];
                    [r setSoundName:soundString];
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

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if (state == UITableViewCellStateEditingMask)
    {
        [statusSwitch setHidden:YES];
        [self setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (state == UITableViewCellStateDefaultMask)
    {
        [statusSwitch setHidden:NO];
    }
}

@end
