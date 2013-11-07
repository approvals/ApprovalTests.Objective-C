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
   // openDiffString = [openDiffString stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];

    //NSString *turd = [openDiffString UTF8String];
 //   NSString *path = [openDiffString
                  //    stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  //  NSString *stringFromUTFString = [[NSString alloc] initWithUTF8String:[openDiffString UTF8String]];
   // NSString *someString = [NSString stringWithUTF8String:openDiffString.UTF8String];
    system([openDiffString UTF8String]);
    
    //system("opendiff /Users/AaronGriffith/Documents/doc1.rtf /Users/AaronGriffith/Documents/doc2.rtf"	);
    return nil;
}

- (id<Reporter>)report {
    return nil;    
}

@end