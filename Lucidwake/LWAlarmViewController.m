//
//  LWAlarmViewController.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAlarmViewController.h"
#import "LWAddAlarmViewController.h"
#import "LWAlarmStore.h"
#import "LWAlarm.h"
#import "LWAlarmCell.h"

@implementation LWAlarmViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Alarms"];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewAlarm:)];
        [[self navigationItem] setRightBarButtonItem:addButton];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"LWAlarmCell" bundle:Nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"LWAlarmCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

- (IBAction)addNewAlarm:(id)sender
{
    LWAlarm *newAlarm = [[LWAlarm alloc] init];
    LWAddAlarmViewController *addController = [[LWAddAlarmViewController alloc] init]; // add 'for new' yes here
    [addController setAlarm:newAlarm];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [addController setController:navigationController];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:Nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[LWAlarmStore sharedStore] allAlarms] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWAlarm *p = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:[indexPath row]];
    LWAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWAlarmCell"];
    
    NSDate *displayDate = [[NSCalendar currentCalendar] dateFromComponents:[p hourMinutes]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    [[cell timeLabel] setText:[dateFormatter stringFromDate:displayDate]];
    [dateFormatter setDateFormat:@"a"];
    [[cell ampmLabel] setText:[dateFormatter stringFromDate:displayDate]];
    [[cell nameLabel] setText:[p name]];
    [cell setIndex:[indexPath row]];
    if (![p stale])
    {
        [p setStale:YES];
        [[cell statusSwitch] sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return cell;
}
         
@end
