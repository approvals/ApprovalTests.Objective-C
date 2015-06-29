//
// Created by Aaron Griffith on 10/24/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface StringWriter : NSObject
- (NSString *)GetReceivedFileName:(NSString *)baseName :(NSString *)extension;

- (NSString *)WriteReceivedFile:(NSString *)baseName :(NSString *)contents;

- (NSString *)GetApprovedFileName:(NSString *)baseName :(NSString *)extension;
@end