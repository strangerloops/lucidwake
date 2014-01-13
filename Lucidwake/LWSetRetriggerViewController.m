//
//  LWSetRetriggerViewController.m
//  Lucidwake
//
//  Created by   on 1/11/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWSetRetriggerViewController.h"
#import "LWAlarm.h"

@implementation LWSetRetriggerViewController

- (void)viewDidLoad
{
    [_quantityStepper addTarget:self action:@selector(updateLabels) forControlEvents:UIControlEventValueChanged];
    [_intervalStepper addTarget:self action:@selector(updateLabels) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_quantityStepper setValue:[_alarm retriggers]];
    [_intervalStepper setValue:[_alarm retriggerInterval]];
    [self updateLabels];
}

- (void)updateLabels
{
    [_quantityLabel setText:[NSString stringWithFormat:@"%d", (int)[_quantityStepper value]]];
    [_intervalLabel setText:[NSString stringWithFormat:@"%d", (int)[_intervalStepper value]]];
    [_alarm setRetriggers:[_quantityStepper value]];
    [_alarm setRetriggerInterval:[_intervalStepper value]];
}

@end
