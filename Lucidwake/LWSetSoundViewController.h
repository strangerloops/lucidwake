//
//  LWSetSoundViewController.h
//  Lucidwake
//
//  Created by   on 1/14/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LWAlarm;

@interface LWSetSoundViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

{
    AVAudioPlayer *player;
}

@property (strong, nonatomic) LWAlarm *alarm;
@property (strong, nonatomic) NSMutableArray *soundFiles;
@property (strong, nonatomic) NSIndexPath *checkedIndexPath;

@end
