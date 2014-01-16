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
    [aCoder encodeBool:_stale forKey:@"stale"];
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
        [self setStale:[aDecoder decodeBoolForKey:@"stale"]];
    }
    return self;
}

@end
