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

@end
