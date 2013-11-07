//
// Created by Aaron Griffith on 10/25/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Reporter.h"
#import "TestingReporter.h"
#import "StringWriter.h"
#import "Namer.h"


@interface FileApprover : NSObject
- (bool)verifyFiles:(NSString *)approved_file :(NSString *)received_file :(id<Reporter>)reporter;

- (NSString *)verify:(Namer *)namer :(StringWriter *)writer :(id<Reporter>)report;
@end