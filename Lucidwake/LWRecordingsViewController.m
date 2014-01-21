//
//  LWRecordingsViewController.m
//  Lucidwake
//
//  Created by   on 12/25/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "LWRecordingsViewController.h"
#import "LWRecording.h"
#import "LWRecordingStore.h"
#import "LWRecordingCell.h"

@implementation LWRecordingsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Recordings"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"notification" object:nil];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_table setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        LWRecordingStore *rs = [LWRecordingStore sharedStore];
        NSArray *recordings = [rs allRecordings];
        LWRecording *p = [recordings objectAtIndex:[indexPath row]];
        [rs removeRecording:p];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    UIColor *clr = [UIColor colorWithRed:.875 green:.88 blue:.91 alpha:1];
    [[self view] setBackgroundColor:clr];
    
    [_doneButton setHidden:YES];
    [_doneButton setEnabled:NO];
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y, [[self view] frame].size.width, [[self view] frame].size.height / 2) style:UITableViewStylePlain];
    [self setTable:tv];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [_subwindow addSubview:_table];
    UINib *nib = [UINib nibWithNibName:@"LWRecordingCell" bundle:Nil];
    [_table registerNib:nib forCellReuseIdentifier:@"LWRecordingCell"];
    [_table setAllowsSelection:NO];
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self setOpenedFromAlarm:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_openedFromAlarm)
    {
        [_recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self setOpenedFromAlarm:NO];
    }
}

- (IBAction)recordPauseTapped:(id)sender
{
    if (!_recordingInProgress)
    {
        CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        NSString *precursor = (__bridge NSString *)newUniqueIDString;
        NSString *uniqueURL = [precursor stringByAppendingString:@".m4a"];
        NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], uniqueURL, nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:Nil];
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        LWRecording *x = [[LWRecording alloc] init];
        [self setRecording:x];
        [_recording setURLlocation:outputFileURL];
        [session setActive:YES error:nil];
        [self setRecordingInProgress:YES];
        [_doneButton setEnabled:YES];
        [_doneButton setHidden:NO];
    }
    if (![recorder isRecording])
    {
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        }
        [self updateLabel];
        [_durationLabel setHidden:NO];
        [recorder record];
        [_recordButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else
    {
        [recorder pause];
        if (_timer)
        {
            [_timer invalidate];
            _timer = nil;
        }
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
}

- (void)updateLabel
{
    NSInteger ti = (NSInteger)[recorder currentTime];
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    [_durationLabel setText:[NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds]];
}

- (IBAction)doneTapped:(id)sender
{
    [recorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    [_durationLabel setHidden:YES];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [_doneButton setEnabled:NO];
    [_doneButton setHidden:YES];
    [_recording setDate:[NSDate date]];
    AVAudioPlayer *durationSource = [[AVAudioPlayer alloc] initWithContentsOfURL:[_recording URLlocation] error:nil];
    [_recording setLength:[durationSource duration]];
    [self setRecordingInProgress:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Dream Recording" message:@"Enter a name for this recording." delegate:self cancelButtonTitle:@"Discard" otherButtonTitles:@"OK", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"Dream Recording %d", (int)[[[LWRecordingStore sharedStore] allRecordings] count] + 1]];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self setRecording:nil];
    } else
    {
        [_recording setName:[[alertView textFieldAtIndex:0] text]];
        [[LWRecordingStore sharedStore] addRecording:_recording];
        [self setRecording:nil];
        [_table reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[LWRecordingStore sharedStore] allRecordings] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWRecording *r = [[[LWRecordingStore sharedStore] allRecordings] objectAtIndex:[indexPath row]];
    LWRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWRecordingCell"];
    [cell setPlayer:[[AVAudioPlayer alloc] initWithContentsOfURL:[r URLlocation] error:Nil]];
    [cell setIndex:[indexPath row]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yy"];
    [[cell nameLabel] setText:[r name]];
    [[cell dateLabel] setText:[df stringFromDate:[r date]]];
    [cell setViewController:self];
    int ti = (int)[r length];
    int seconds = ti % 60;
    int minutes = (ti / 60) % 60;
    int hours = ti / 3600;
    [[cell durationLabel] setText:[NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds]];
    return cell;
}

@end
