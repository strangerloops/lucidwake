//
//  LWAddAlarmViewController.h
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWAlarm;

@interface LWAddAlarmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
}

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) LWAlarm *alarm;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *subwindow;
@property (nonatomic, copy) void (^dismissBlock) (void);
@property (weak, nonatomic) UINavigationController *controller;

@end
