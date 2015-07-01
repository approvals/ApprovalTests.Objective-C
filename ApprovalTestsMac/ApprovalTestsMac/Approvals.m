//
// Created by AaronGriffith on 11/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Approvals.h"
#import "Namer.h"
#import "ReceivedFileLauncherReporter.h"
#import "KaleidoscopeReporter.h"
#import "BeyondCompareReporter.h"
#import "StringWriter.h"
#import "FileApprover.h"

@implementation Approvals {
}

+ (void)verify:(NSString *)contents{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [defaults objectForKey:@"diffReporter"];
    
    FileApprover *approver = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    NSString* baseName = [namer getBasename:4];
    NSObject *reporter;
    reporter = [[ReceivedFileLauncherReporter alloc]init];
    if([firstName isEqualToString:@"KALEIDOSCOPE"])
    {
        reporter = [[KaleidoscopeReporter alloc]init];
    }
    if([firstName isEqualToString:@"BEYONDCOMPARE"])
    {
        reporter = [[BeyondCompareReporter alloc]init];
    }
    StringWriter *writer = [[StringWriter alloc] init];
    [writer WriteReceivedFile:baseName :contents];
    NSString *error = [approver verify:namer :writer :(id<Reporter>)reporter];
    if ([error isEqualToString:@"none"]) {
        return;
    }
    NSException *exception = [NSException exceptionWithName:@"error" reason:@"error reason" userInfo:nil];
    @throw exception;
}

@end