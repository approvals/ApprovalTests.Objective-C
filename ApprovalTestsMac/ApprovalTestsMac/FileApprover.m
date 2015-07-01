//
// Created by Aaron Griffith on 10/25/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "FileApprover.h"
#import "Namer.h"
#import "StringWriter.h"
#import "TestingReporter.h"


@implementation FileApprover {

}


- (bool)verifyFiles:(NSString *)approved_file :(NSString *)received_file :(id<Reporter>)reporter {
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    NSLog(@"%@", approved_file);
        NSLog(@"%@", received_file);
    
    if (![filemgr fileExistsAtPath:approved_file]){
        [filemgr createFileAtPath:approved_file contents:nil attributes:nil];
    }
    if ([filemgr contentsEqualAtPath: approved_file andPath: received_file] == YES)
    {
        NSLog (@"File contents match");
        return true;
    }
    else
    {
        return [self removeWhiteSpaceAndCompare:approved_file received_file:received_file reporter:reporter];
    }
}

- (bool)removeWhiteSpaceAndCompare:(NSString *)approved_file received_file:(NSString *)received_file reporter:(id)reporter {
    NSString *txtInApprovedFile = [[NSString alloc] initWithContentsOfFile:approved_file encoding:NSUTF8StringEncoding error:nil];
    txtInApprovedFile = [txtInApprovedFile stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *txtInReceivedFile = [[NSString alloc] initWithContentsOfFile:received_file encoding:NSUTF8StringEncoding error:nil];
    txtInReceivedFile = [txtInReceivedFile stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([txtInApprovedFile isEqualToString:txtInReceivedFile]) {
        NSLog (@"File contents match");
        return true;
    }
    NSLog (@"File contents do not match");
    [reporter report:approved_file :received_file];
    return false;
}

- (NSString *)verify:(Namer *)namer :(StringWriter *)writer :(id<Reporter>)report
{
    NSString *base = namer.baseName;
    NSString *approved = [writer GetApprovedFileName:base :nil];
    NSString *received = [writer GetReceivedFileName:base :nil];
    BOOL okCheck = [self verifyFiles:approved :received :report];
    if (!okCheck) {
        return @"Approval Mismatch";
    }
    else{
        return @"none";
    }
}


@end