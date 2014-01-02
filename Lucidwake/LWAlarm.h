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
    NSDate *time;
    NSString *label;
    BOOL state;
    NSString *sound;
    NSArray *repeat;
}

@end
