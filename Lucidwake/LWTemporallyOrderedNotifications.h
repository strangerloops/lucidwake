//
//  LWTemporallyOrderedNotifications.h
//  Lucidwake
//
//  Created by   on 1/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWAlarmNotification, LWAlarm;

@interface LWTemporallyOrderedNotifications : NSObject

{
    NSMutableArray *allNotifications;
}

+ (LWTemporallyOrderedNotifications *)sharedStore;
- (NSArray *)allNotifications;
- (void)addNotification:(LWAlarmNotification *)p;
- (void)removeNotification:(LWAlarmNotification *)p;
- (void)unscheduleNotificationsForAlarm:(LWAlarm *)p;
- (NSString *)archivePath;
- (BOOL)saveChanges;

@end
