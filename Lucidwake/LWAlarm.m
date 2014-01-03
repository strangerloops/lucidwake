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

- (NSString *)index
{
    return [NSString stringWithFormat:@"%d", [[[LWAlarmStore sharedStore] allAlarms] indexOfObject:self]];
}

@end
