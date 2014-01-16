//
//  LWRecordingStore.m
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWRecordingStore.h"
#import "LWRecording.h"

@implementation LWRecordingStore

+ (LWRecordingStore *)sharedStore
{
    static LWRecordingStore *sharedStore = nil;
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
        allRecordings = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!allRecordings)
        {
            allRecordings = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allRecordings
{
    return allRecordings;
}

- (void)addRecording:(LWRecording *)r
{
    if ([allRecordings count] == 0)
    {
        [allRecordings addObject:r];
    } else
    {
        BOOL added = false;
        for (int i = 0; i < [allRecordings count]; i++)
        {
            if ([[r date] compare:[[allRecordings objectAtIndex:i] date]] == NSOrderedDescending)
            {
                [allRecordings insertObject:r atIndex:i];
                added = true;
                break;
            }
        }
        if (!added)
        {
            [allRecordings addObject:r];
        }
    }
}

- (void)removeRecording:(LWRecording *)r
{
    [allRecordings removeObjectIdenticalTo:r];
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:@"recordings.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self archivePath];
    return [NSKeyedArchiver archiveRootObject:allRecordings toFile:path];
}

@end
