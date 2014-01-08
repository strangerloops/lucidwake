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

- (void)playRecording:(id)sender
{
    if (![_player isPlaying])
    {
        [_player setDelegate:self];
        [_player play];
        [audioButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else
    {
        [_player pause];
        [audioButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    NSLog(@"%f", [_player duration]);
}

@end
