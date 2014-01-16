//
//  LWRecording.m
//  Lucidwake
//
//  Created by   on 1/5/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "LWRecording.h"

@implementation LWRecording

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeInt:_length forKey:@"length"];
    [aCoder encodeObject:_URLlocation forKey:@"URLlocation"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setDate:[aDecoder decodeObjectForKey:@"date"]];
        [self setLength:[aDecoder decodeIntForKey:@"length"]];
        [self setURLlocation:[aDecoder decodeObjectForKey:@"URLlocation"]];
    }
    return self;
}

@end
