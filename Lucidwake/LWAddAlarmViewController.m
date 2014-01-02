//
//  LWAddAlarmViewController.m
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAddAlarmViewController.h"

@implementation LWAddAlarmViewController

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
    [self setItems:[NSArray arrayWithObjects:@"item1", @"item2", @"item3", nil]];
    [[self table] setDelegate:self];
    [[self table] setDataSource:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [[cell textLabel] setText:[[self items] objectAtIndex:[indexPath row]]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self items] count];
}

@end
