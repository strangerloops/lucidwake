//
//  LWTemporallyOrderedNotifications.h
//  Lucidwake
//
//  Created by   on 1/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWTemporallyOrderedNotifications : NSObject

{
    NSMutableArray *allNotifications;
}

+ (LWTemporallyOrderedNotifications *)sharedStore;
- (NSArray *)allNotifications;
- (void)addNotification:(UILocalNotification *)p;
- (void)removeNotification:(UILocalNotification *)p;
- (NSString *)archivePath;
- (BOOL)saveChanges;

@end
