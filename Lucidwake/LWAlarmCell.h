//
//  LWAlarmCell.h
//  Lucidwake
//
//  Created by   on 1/2/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAlarmCell : UITableViewCell

{
    IBOutlet UISwitch *statusSwitch;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ampmLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign) int index;

@end
