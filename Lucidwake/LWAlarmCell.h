//
//  LWAlarmCell.h
//  Lucidwake
//
//  Created by   on 1/2/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAlarmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ampmLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *clearSnoozeButton;
@property (strong, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (assign) int index;

- (IBAction)clearSnooze:(id)sender;

@end
