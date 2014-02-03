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
#import "LWAlarmNotification.h"
#import "LWTemporallyOrderedNotifications.h"

@implementation LWAlarmCell

@synthesize statusSwitch;

- (IBAction)statusSwitch:(id)sender
{
    LWAlarm *alarm = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:_index];
    if ([statusSwitch isOn])
    {
        [alarm scheduleNotifications];
    }
    else
    {
        [[LWTemporallyOrderedNotifications sharedStore] unscheduleNotificationsForAlarm:alarm];
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

- (IBAction)clearSnooze:(id)sender
{
    LWAlarm *p = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:_index];
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (LWAlarmNotification *an in [[LWTemporallyOrderedNotifications sharedStore] allNotifications])
    {
        if (([an alarm] == p || ![an alarm]) && [an snooze])
        {
            [toDelete addObject:an];
        }
    }
    for (LWAlarmNotification *an in toDelete)
    {
        [[LWTemporallyOrderedNotifications sharedStore] removeNotification:an];
    }
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseOut animations:^{
        [_clearSnoozeButton setAlpha:0.0];
    }
    completion:^(BOOL finished){
        [_clearSnoozeButton setHidden:true];
    }];
    
    BOOL hasNotification = false;
    for (LWAlarmNotification *an in [[LWTemporallyOrderedNotifications sharedStore] allNotifications])
    {
        if ([an alarm] == p)
        {
            hasNotification = true;
            break;
        }
    }
    if (!hasNotification)
    {
        [statusSwitch setOn:false animated:true];
    }
}

@end
