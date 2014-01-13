//
//  LWSetRetriggerViewController.h
//  Lucidwake
//
//  Created by   on 1/11/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWAlarm;

@interface LWSetRetriggerViewController : UIViewController



@property (strong, nonatomic) LWAlarm *alarm;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@property (strong, nonatomic) IBOutlet UIStepper *intervalStepper;

- (void)updateLabels;

@end
