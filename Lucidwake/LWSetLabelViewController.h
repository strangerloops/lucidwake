//
//  LWSetLabelViewController.h
//  Lucidwake
//
//  Created by   on 1/3/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWAlarm.h"

@interface LWSetLabelViewController : UIViewController <UITextFieldDelegate>

{
    
}

@property (weak, nonatomic) IBOutlet UITextField *labelTextField;
@property (weak, nonatomic) UINavigationController *controller;
@property (strong, nonatomic) LWAlarm *alarm;

@end
