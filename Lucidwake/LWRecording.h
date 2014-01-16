//
//  LWRecording.h
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWRecording : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSTimeInterval length;
@property (nonatomic, strong) NSURL *URLlocation;

@end
