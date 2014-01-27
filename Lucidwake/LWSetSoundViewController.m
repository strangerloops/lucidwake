//
//  LWSetSoundViewController.m
//  Lucidwake
//
//  Created by   on 1/14/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWSetSoundViewController.h"
#import "LWAlarm.h"

@implementation LWSetSoundViewController

- (id)init
{
    self = [super init];
    if (self)
    {
    _soundFiles = [[NSMutableArray alloc] initWithObjects:@"Apex", @"Beacon", @"Bulletin", @"By The Seaside", @"Chimes", @"Circuit", @"Constellation", @"Cosmic", @"Crystals", @"Hillside", @"Illuminate", @"Night Owl", @"Opening", @"Playtime", @"Presto", @"Radar", @"Radiate", @"Ripples", @"Sencha", @"Signal", @"Silk", @"Slow Rise", @"Stargaze", @"Summit", @"Twinkle", @"Uplift", @"Waves", nil];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_soundFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    [[cell textLabel] setText:[_soundFiles objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [player stop];
    if ([indexPath compare:_checkedIndexPath] != NSOrderedSame)
    {
        UITableViewCell *toUncheck = [tableView cellForRowAtIndexPath:_checkedIndexPath];
        [toUncheck setAccessoryType:UITableViewCellAccessoryNone];
        UITableViewCell *check = [tableView cellForRowAtIndexPath:indexPath];
        [check setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self setCheckedIndexPath:indexPath];
        [_alarm setSound:[_soundFiles objectAtIndex:[indexPath row]]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:[_soundFiles objectAtIndex:[indexPath row]] ofType:@".m4r"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:Nil];
    [player play];
}

@end
