//
//  LWRecordingStore.h
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWRecording;

@interface LWRecordingStore : NSObject

{
    NSMutableArray *allRecordings;
}

+ (LWRecordingStore *)sharedStore;
- (NSArray *)allRecordings;
- (NSString *)archivePath;
- (void)addRecording:(LWRecording *)r;
- (void)removeRecording:(LWRecording *)r;
- (BOOL)saveChanges;

@end
