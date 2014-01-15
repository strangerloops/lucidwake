//
//  LWAlarm.m
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAlarm.h"
#import "LWAlarmStore.h"

@implementation LWAlarm

- (id)init
{
    self = [super init];
    [self setName:@"Alarm"];
    [self setSound:@"Default"];
    [self setWeekly:[[NSMutableArray alloc] init]];
    for (int i = 0; i < 7; i++)
    {
        [_weekly addObject:[NSNumber numberWithInt:0]];
    }
    [self setNotificationsArray:[[NSMutableArray alloc] init]];
    [self setRetriggersArray:[[NSMutableArray alloc] init]];
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

@end
