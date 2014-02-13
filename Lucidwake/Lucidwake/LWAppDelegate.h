//
//  LWAppDelegate.h
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LWAppDelegate : UIResponder <UIApplicationDelegate>

{
    NSTimer *silenceTimer;
    NSTimer *alarmTimer;
    BOOL shouldPresentMicrophone;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabControl;

@end
