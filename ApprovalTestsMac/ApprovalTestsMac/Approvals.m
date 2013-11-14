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

+ (void)verify:(NSString *)data{
    FileApprover *approver = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    ReceivedFileLauncherReporter *reporter = [[ReceivedFileLauncherReporter alloc]init];
    StringWriter *writer = [[StringWriter alloc] init];
    NSString *target = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , [namer getClassNameFromClass]];
    [writer WriteReceivedFile:target:[namer getBasename] :data];
    [approver verify:namer :writer :reporter];
}

@end