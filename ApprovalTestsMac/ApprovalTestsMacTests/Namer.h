//
// Created by Aaron Griffith on 10/21/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Namer : NSObject{
    NSString *baseName;
}

@property (nonatomic, retain) NSString *baseName;

- (NSString*)getClassNameFromClass:(int) depth;

- (NSString*)getMethodNameFromMethod:(int) depth;

- (NSString*)getDirectoryNameFromClass;

- (NSString*)getBasename:(int) depth;

- (NSArray*)parseCaller:(NSString* )nameSource;



@end