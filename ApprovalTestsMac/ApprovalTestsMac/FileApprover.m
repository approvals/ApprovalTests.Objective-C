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
//    def verify_files(self, approved_file, received_file, reporter):
//    if self.are_files_the_same(approved_file, received_file):
//        os.remove(received_file)
//        return True
//        
//        reporter.report(approved_file, received_file)
//        return False
//
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
        NSLog (@"File contents do not match");
        [reporter report:approved_file :received_file];
        return false;
    }
}

- (NSString *)verify:(Namer *)namer :(StringWriter *)writer :(id<Reporter>)report
{

    
//    def verify(self, namer, writer, reporter):
//    base = namer.get_basename()
//    approved = writer.GetApprovedFileName(base)
//    received = writer.write_received_file(writer.GetReceivedFileName(base))
//    ok = self.verify_files(approved, received, reporter)
//    if not ok:
//        return "Approval Mismatch"
//        return None
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