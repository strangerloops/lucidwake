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
@property (strong, nonatomic) LWAlarm *alarm;
@property (strong, nonatomic) LWAlarm *alarmBackup;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UINavigationController *controller;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, assign) BOOL displayDelete;

- (IBAction)deleteAlarm:(id)sender;

@end
