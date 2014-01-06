//
//  LWRecordingsViewController.h
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class LWRecording;

@interface LWRecordingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate>

{
    AVAudioRecorder *recorder;
}

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *subwindow;
@property (strong, nonatomic) LWRecording *recording;
@property (assign, nonatomic) BOOL recordingInProgress;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
