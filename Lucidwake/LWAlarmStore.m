//
//  LWAlarmStore.m
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAlarmStore.h"
#import "LWAlarm.h"

@implementation LWAlarmStore

+ (LWAlarmStore *)sharedStore
{
    static LWAlarmStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        NSString *path = [self archivePath];
        allAlarms = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allAlarms)
        {
            allAlarms = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allAlarms
{
    return allAlarms;
}

- (void)addAlarm:(LWAlarm *)p
{
    if ([allAlarms count] == 0)
    {
        [allAlarms addObject:p];
    } else
    {
        BOOL added = false;
        for (int i = 0; i < [allAlarms count]; i++)
        {
            LWAlarm *q = [allAlarms objectAtIndex:i];
            if ([[p hourMinutes] hour] * 60 + [[p hourMinutes] minute] < [[q hourMinutes] hour] * 60 + [[q hourMinutes] minute])
            {
                [allAlarms insertObject:p atIndex:i];
                added = true;
                break;
            }
        }
        if (!added)
        {
            [allAlarms addObject:p];
        }
    }
}

- (void)removeAlarm:(LWAlarm *)p
{
    [allAlarms removeObjectIdenticalTo:p];
}


- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:@"alarms.archive"];
}


@end
