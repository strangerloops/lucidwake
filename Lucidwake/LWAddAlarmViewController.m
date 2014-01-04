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

@interface LabelValueCell : UITableViewCell
@end
@implementation LabelValueCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
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
    [self setTable:[[UITableView alloc] initWithFrame:CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y, [[self view] frame].size.width, [[self view] frame].size.height / 2) style:UITableViewStylePlain]];
    [[self subwindow] addSubview:[self table]];
    [[self table] setDelegate:self];
    [[self table] setDataSource:self];

    //UINib *nib = [UINib nibWithNibName:@"LWAddAlarmTableCell" bundle:Nil];
    //[[self table] registerNib:nib forCellReuseIdentifier:@"LWAddAlarmTableCell"];
    
    [[self table] registerClass:[LabelValueCell class] forCellReuseIdentifier:@"LWAddAlarmTableCell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self table] reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LabelValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWAddAlarmTableCell"];
    NSArray *titles = [NSArray arrayWithObjects:@"Name", @"Sound", @"Repeat", @"Retrigger", nil];
    NSArray *values = [NSArray arrayWithObjects:[alarm name], @"Temp", @"Temp", @"Temp", nil];
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
    }
}

- (void)save:(id)sender
{
    [alarm setTime:[[self datePicker] date]];
    [[LWAlarmStore sharedStore] addAlarm:alarm];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    [[LWAlarmStore sharedStore] removeAlarm:alarm];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

@end
