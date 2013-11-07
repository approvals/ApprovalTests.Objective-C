//
// Created by Aaron Griffith on 10/24/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface StringWriter : NSObject
- (NSString *)GetReceivedFileName:(NSString *)fileName :(NSString *)basename;

- (NSString *)WriteReceivedFile:(NSString *)name :(NSString *)path :(NSString *)contents;

- (NSString *)GetApprovedFileName:(NSString *)fileName :(NSString *)basename;
@end