//
//  Reporter.h
//  XcodeApprovalTests
//
//  Created by Aaron Griffith on 10/28/13.
//  Copyright (c) 2013 Aaron Griffith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Reporter <NSObject>

- (id<Reporter>) report;

- (id<Reporter>)report:(NSString *)approved_path :(NSString *)received_path;

@end
