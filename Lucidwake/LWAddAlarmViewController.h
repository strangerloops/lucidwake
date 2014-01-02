//
//  LWAddAlarmViewController.h
//  Lucidwake
//
//  Created by   on 12/30/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAddAlarmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    
}

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *subwindow;

@end
