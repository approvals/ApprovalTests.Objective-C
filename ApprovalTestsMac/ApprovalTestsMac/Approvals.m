//
// Created by AaronGriffith on 11/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Approvals.h"
#import "Namer.h"
#import "ReceivedFileLauncherReporter.h"
#import "StringWriter.h"
#import "FileApprover.h"


@implementation Approvals {
}

+ (void)verify:(NSString *)contents{
    
    FileApprover *approver = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    NSString* baseName = [namer getBasename:4];
    ReceivedFileLauncherReporter *reporter = [[ReceivedFileLauncherReporter alloc]init];
    StringWriter *writer = [[StringWriter alloc] init];
    [writer WriteReceivedFile:baseName :contents];
    [approver verify:namer :writer :reporter];
}

@end