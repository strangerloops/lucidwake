//
//  LWAlarmStore.h
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWAlarm;

@interface LWAlarmStore : NSObject

{
    NSMutableArray *allAlarms;
}

+ (LWAlarmStore *)sharedStore;
- (NSArray *)allAlarms;
- (LWAlarm *)createAlarm;
- (void)removeAlarm:(LWAlarm *)p;
- (void)sortChronologically;
- (NSString *)archivePath;
- (void)saveChanges;

@end
