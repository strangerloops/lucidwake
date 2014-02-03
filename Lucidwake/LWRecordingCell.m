//
//  LWRecordingCell.m
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWRecordingCell.h"
#import "LWRecordingStore.h"
#import "LWRecording.h"

@implementation LWRecordingCell

//- (id)init
//{
//    self = [super init];
//    if (self)
//    {
//        [_nameField setDelegate:self];
//    }
//    return self;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"text field delegate method called");
    LWRecording *recording = [[[LWRecordingStore sharedStore] allRecordings] objectAtIndex:_index];
    [textField resignFirstResponder];
    [recording setName:[textField text]];
    return NO;
}

- (void)playRecording:(id)sender
{
    if (![_player isPlaying])
    {
        [_slider setMaximumValue:[_player duration]];
        [_slider setValue:[_player currentTime]];
        [_slider addTarget:self action:@selector(updatePlayer) forControlEvents:UIControlEventValueChanged];
        [_slider setHidden:NO];
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
        [_player setDelegate:self];
        [_player play];
        [audioButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else
    {
        [_player pause];
        if (_timer)
        {
            [_timer invalidate];
            _timer = nil;
        }
        [audioButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)updateSlider
{
    [_slider setValue:[_player currentTime]];
}

- (void)updatePlayer
{
    [_player stop];
    [_player setCurrentTime:[_slider value]];
    [_player play];
}

- (void)shareRecording:(id)sender
{
    NSArray *objectToShare = [NSArray arrayWithObject: [_player url]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    [[self viewController] presentViewController:activityController animated:YES completion:nil];
}

@end
