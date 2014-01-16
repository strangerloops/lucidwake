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
    IBOutlet UIButton *audioButton;
}

@property (assign, nonatomic) int index;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) UIViewController *viewController;

- (IBAction)playRecording:(id)sender;
- (IBAction)shareRecording:(id)sender;

@end
