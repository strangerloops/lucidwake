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

- (IBAction)statusSwitch:(id)sender
{
    LWAlarm *alarm = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:_index];
    if ([statusSwitch isOn])
    {
        UILocalNotification *n = [[UILocalNotification alloc] init];
        [n setFireDate:[alarm time]];
        [n setAlertBody:[alarm name]];
        [[UIApplication sharedApplication] scheduleLocalNotification:n];
        NSLog(@"Setting alarm for %@ at %@", [alarm name], [alarm time]);
        [alarm setNotification:n];
    } else
    {
        [alarm setNotification:nil];
    }
}

@end
