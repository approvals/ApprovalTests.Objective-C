//
// Created by Aaron Griffith on 10/29/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "KaleidoscopeReporter.h"


@implementation KaleidoscopeReporter {
    
}

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path{
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    received_path = [received_path stringByReplacingOccurrencesOfString:@":::" withString:@""];
    approved_path = [approved_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    received_path = [received_path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    NSString *diffProgram = [NSString stringWithFormat:@"/usr/local/bin/ksdiff %@ %@", received_path, approved_path];
    system([diffProgram UTF8String]);
    return nil;
}

- (id<Reporter>)report {
    return nil;
}

@end