//
// Created by Aaron Griffith on 10/28/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Reporter.h"


@interface TestingReporter : NSObject<Reporter>
{
    BOOL called;
}

@property (nonatomic, assign) BOOL called;

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path;

@end