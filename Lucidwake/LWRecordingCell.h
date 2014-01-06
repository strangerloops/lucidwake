//
//  LWRecordingCell.h
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LWRecordingCell : UITableViewCell <AVAudioPlayerDelegate>

{
    AVAudioPlayer *player;
    IBOutlet UIButton *audioButton;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (assign, nonatomic) int index;

- (IBAction)playRecording:(id)sender;

@end
