//
//  LWAddAlarmViewController.m
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAddAlarmViewController.h"
#import "LWAlarmStore.h"
#import "LWAlarm.h"
#import "LWSetLabelViewController.h"
#import "LWSetWeeklyViewController.h"
#import "LWSetRetriggerViewController.h"
#import "LWSetSoundViewController.h"

@interface LabelValueCell : UITableViewCell
@end

@implementation LabelValueCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LabelValueCell"];
    if (self)
    {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

@end

@implementation LWAddAlarmViewController

@synthesize alarm;

- (id)init
{
    self = [super init];
    if(self)
    {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self subwindow] setClipsToBounds:YES];
    [self setTable:[[UITableView alloc] initWithFrame:CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y, [[self view] frame].size.width, [[self view] frame].size.height / 2) style:UITableViewStylePlain]];
    [[self subwindow] addSubview:[self table]];
    [[self table] setDelegate:self];
    [[self table] setDataSource:self];
    [[self table] registerClass:[LabelValueCell class] forCellReuseIdentifier:@"LabelValueCell"];
    [_datePicker addTarget:self action:@selector(updateTime) forControlEvents:UIControlEventValueChanged];
    [self updateTime];
}

- (void)updateTime
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[_datePicker date]];
    [alarm setHourMinutes:components];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self table] reloadData];
    if (!_displayDelete)
    {
        [_deleteButton setHidden:true];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LabelValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelValueCell"];
    NSArray *titles = [NSArray arrayWithObjects:@"Name", @"Sound", @"Repeat", @"Retrigger", nil];
    NSArray *weekdays = [NSArray arrayWithObjects:@" Su", @" M", @" Tu", @" W", @" Th", @" F", @" Sa", nil];
    NSString *repeatLabel = [NSString stringWithFormat:@""];
    for (int i = 0; i < [[alarm weekly] count]; i++)
    {
        if ([[[alarm weekly] objectAtIndex:i] intValue] == 1)
        {
            repeatLabel = [repeatLabel stringByAppendingString:[weekdays objectAtIndex:i]];
        }
    }
    NSString *retriggerLabel = [NSString stringWithFormat:@"%d retriggers, %dm apart", [alarm retriggers], [alarm retriggerInterval]];
    NSArray *values = [NSArray arrayWithObjects:[alarm name], [alarm sound], repeatLabel, retriggerLabel, nil];
    [[cell textLabel] setText:[titles objectAtIndex:[indexPath row]]];
    [[cell detailTextLabel] setText:[values objectAtIndex:[indexPath row]]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        LWSetLabelViewController *labelController = [[LWSetLabelViewController alloc] init];
        [labelController setAlarm:alarm];
        [[labelController labelTextField] setText:[alarm name]];
        [labelController setController:[self controller]];
        [[self controller] pushViewController:labelController animated:YES];
    } else if ([indexPath row] == 1)
    {
        LWSetSoundViewController *soundController = [[LWSetSoundViewController alloc] init];
        [soundController setAlarm:alarm];
        [[self controller] pushViewController:soundController animated:YES];
    } else if ([indexPath row] == 2)
    {
        LWSetWeeklyViewController *weeklyController = [[LWSetWeeklyViewController alloc] init];
        [weeklyController setAlarm:alarm];
        [[self controller] pushViewController:weeklyController animated:YES];
    } else if ([indexPath row] == 3)
    {
        LWSetRetriggerViewController *retriggerController = [[LWSetRetriggerViewController alloc] init];
        [retriggerController setAlarm:alarm];
        [[self controller] pushViewController:retriggerController animated:YES];
    }
}

- (void)save:(id)sender
{
    [[LWAlarmStore sharedStore] removeAlarm:alarm];
    [[LWAlarmStore sharedStore] addAlarm:alarm];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    if (_alarmBackup)
    {
        [[LWAlarmStore sharedStore] removeAlarm:alarm];
        [[LWAlarmStore sharedStore] addAlarm:_alarmBackup];
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAlarm:(id)sender
{
    [[LWAlarmStore sharedStore] removeAlarm:alarm];
    alarm = nil;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
