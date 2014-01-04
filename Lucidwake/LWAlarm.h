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

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL state;
@property (nonatomic, copy) NSString *sound;
@property (nonatomic, strong) NSArray *repeat;

@end
