//
//  LWAlarmViewController.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWAlarmViewController.h"
#import "LWAddAlarmViewController.h"

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

- (IBAction)addNewAlarm:(id)sender
{
    LWAddAlarmViewController *addController = [[LWAddAlarmViewController alloc] init]; // add 'for new' yes here
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:Nil];
}
         
@end
