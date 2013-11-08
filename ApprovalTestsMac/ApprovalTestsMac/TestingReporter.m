//
// Created by Aaron Griffith on 10/28/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "TestingReporter.h"


@implementation TestingReporter {
  

}

@synthesize called;

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path{
    called = TRUE;
    return nil;
}


- (id<Reporter>)report {
    called = TRUE;
    return nil;

}

@end