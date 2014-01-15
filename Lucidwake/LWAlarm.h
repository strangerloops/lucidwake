//
//  LWAlarm.h
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAlarm : NSObject

{

}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sound;
@property (nonatomic, strong) NSDateComponents *hourMinutes;
@property (nonatomic, strong) NSMutableArray *weekly;
@property (nonatomic, strong) NSMutableArray *notificationsArray;
@property (nonatomic, strong) NSMutableArray *retriggersArray;
@property (nonatomic, assign) int retriggerInterval;
@property (nonatomic, assign) int retriggers;
@property (nonatomic, assign) BOOL stale;

- (LWAlarm *)clone;

@end
