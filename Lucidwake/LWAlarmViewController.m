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
#import "LWTemporallyOrderedNotifications.h"
#import "LWAlarmNotification.h"

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
        [[self tableView] setAllowsSelection:NO];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] setAllowsSelectionDuringEditing:editing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *clr = [UIColor colorWithRed:.875 green:.88 blue:.91 alpha:1];
    [[self view] setBackgroundColor:clr];
    UINib *nib = [UINib nibWithNibName:@"LWAlarmCell" bundle:Nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"LWAlarmCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
    [self setEditing:NO animated:NO];
}

- (IBAction)addNewAlarm:(id)sender
{
    [self setEditing:NO animated:YES];
    LWAlarm *newAlarm = [[LWAlarm alloc] init];
    LWAddAlarmViewController *addController = [[LWAddAlarmViewController alloc] init];
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
    [dateFormatter setDateFormat:@"h:mm"];
    [[cell timeLabel] setText:[dateFormatter stringFromDate:displayDate]];
    [dateFormatter setDateFormat:@"a"];
    [[cell ampmLabel] setText:[dateFormatter stringFromDate:displayDate]];
    NSString *nameLabelText = [NSString stringWithFormat:[p name]];
    NSArray *weekdays = [NSArray arrayWithObjects:@" Su", @" M", @" Tu", @" W", @" Th", @" F", @" Sa", nil];
    NSString *repeatLabel = [NSString stringWithFormat:@""];
    for (int i = 0; i < [[p weekly] count]; i++)
    {
        if ([[[p weekly] objectAtIndex:i] intValue] == 1)
        {
            repeatLabel = [repeatLabel stringByAppendingString:[weekdays objectAtIndex:i]];
        }
    }
    nameLabelText = [nameLabelText stringByAppendingString:repeatLabel];
    [[cell nameLabel] setText:nameLabelText];
    [cell setIndex:[indexPath row]];
    [[cell statusSwitch] setHidden:NO];
    
    BOOL hasNotification = false;
    BOOL hasSnooze = false;
    
    for (LWAlarmNotification *an in [[LWTemporallyOrderedNotifications sharedStore] allNotifications])
    {
        if ([an alarm] == p)
        {
            hasNotification = true;
            if ([an snooze])
            {
                hasSnooze = true;
                break;
            }
        }
    }
    if (hasNotification)
    {
        [[cell statusSwitch] setOn:YES];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            [cell setAlpha:1.0];
        } completion:nil];
    }
    else
    {
        [[cell statusSwitch] setOn:NO];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            [cell setAlpha:0.5];
        } completion:nil];
    }
    if (hasSnooze)
    {
        [[cell clearSnoozeButton] setHidden:NO];
    }
    else
    {
        [[cell clearSnoozeButton] setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        LWAlarmStore *as = [LWAlarmStore sharedStore];
        NSArray *alarms = [as allAlarms];
        LWAlarm *p = [alarms objectAtIndex:[indexPath row]];
        [as removeAlarm:p];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWAddAlarmViewController *editController = [[LWAddAlarmViewController alloc] init];
    LWAlarm *a = [[[LWAlarmStore sharedStore] allAlarms] objectAtIndex:[indexPath row]];
    [editController setAlarm:a];
    [editController setAlarmBackup:[a clone]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
    [editController setDisplayDelete:YES];
    [editController setController:navigationController];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:Nil];
}
    
@end
