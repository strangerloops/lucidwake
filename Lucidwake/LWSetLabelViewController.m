//
//  LWSetLabelViewController.m
//  Lucidwake
//
//  Created by   on 1/3/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWSetLabelViewController.h"

@implementation LWSetLabelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[self labelTextField] becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self controller] popToRootViewControllerAnimated:YES];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self alarm] setName:[[self labelTextField] text]];
}

@end
