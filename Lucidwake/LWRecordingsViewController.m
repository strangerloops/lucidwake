//
//  LWRecordingsViewController.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWRecordingsViewController.h"

@interface LWRecordingsViewController ()

@end

@implementation LWRecordingsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Recordings"];
    }
    return self;
}

@end
