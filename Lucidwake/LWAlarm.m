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
    [self setWeekly:[[NSMutableArray alloc] init]];
    for (int i = 0; i < 7; i++)
    {
        [_weekly addObject:[NSNumber numberWithInt:0]];
    }
    return self;
}

@end
