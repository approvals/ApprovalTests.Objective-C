//
// Created by Aaron Griffith on 10/29/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "P4MergeReporter.h"


@implementation P4MergeReporter {
    
}

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path{
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    received_path = [received_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    received_path = [received_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    //if bcomp has issues, try bcompare
    NSString *diffProgram = [NSString stringWithFormat:@" /Applications/p4merge.app/Contents/Resources/launchp4merge %@ %@", received_path, approved_path];
    system([diffProgram UTF8String]);
    return nil;
}

- (id<Reporter>)report {
    return nil;
}

@end