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
    if (![player isPlaying])
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[[[LWRecordingStore sharedStore] allRecordings] objectAtIndex:_index] URLlocation] error:nil];
        [player setDelegate:self];
        [player play];
    } else
    {
        [player pause];
    }
}

@end
