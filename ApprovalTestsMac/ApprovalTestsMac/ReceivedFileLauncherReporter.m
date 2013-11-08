//
// Created by Aaron Griffith on 10/29/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "ReceivedFileLauncherReporter.h"


@implementation ReceivedFileLauncherReporter {

}

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path{
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    received_path = [received_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    received_path = [received_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    NSString *openDiffString = [NSString stringWithFormat:@"opendiff %@ %@", received_path, approved_path];
    system([openDiffString UTF8String]);    
    return nil;
}

- (id<Reporter>)report {
    return nil;    
}

@end