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

- (LWAlarm *)createAlarm
{
    LWAlarm *p = [[LWAlarm alloc] init];
    [allAlarms addObject:p];
    return p;
}

- (void)removeAlarm:(LWAlarm *)p
{
    [allAlarms removeObjectIdenticalTo:p];
}

- (void)sortChronologically
{
    // sort array...
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:@"alarms.archive"];
}


@end
