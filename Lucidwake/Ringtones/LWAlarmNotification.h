//
//  LWAlarmNotification.h
//  Lucidwake
//
//  Created by   on 2/1/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWAlarm;

@interface LWAlarmNotification : NSObject <NSCoding>

@property (strong, nonatomic) LWAlarm *alarm;
@property (strong, nonatomic) NSDate *fireDate;
@property (nonatomic, assign) BOOL snooze;

- (void)reschedule;

@end
