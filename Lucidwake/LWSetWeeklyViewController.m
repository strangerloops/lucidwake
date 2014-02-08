//
//  LWSetWeeklyViewController.m
//  Lucidwake
//
//  Created by   on 1/8/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWSetWeeklyViewController.h"
#import "LWAlarm.h"
#import "LWAlarmStore.h"

@implementation LWSetWeeklyViewController

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *text = [NSArray arrayWithObjects:@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    [[cell textLabel] setText:[text objectAtIndex:[indexPath row]]];
    
    if ([[[_alarm weekly] objectAtIndex:[indexPath row]] intValue] == 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [[[_alarm weekly] objectAtIndex:[indexPath row]] intValue];
    i += 1;
    i %= 2;
    [[_alarm weekly] replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithInt:i]];
    [tableView reloadData];
}

@end
