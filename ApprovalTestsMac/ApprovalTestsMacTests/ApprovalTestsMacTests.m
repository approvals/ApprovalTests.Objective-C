//
//  ApprovalTestsMacTests.m
//  ApprovalTestsMacTests
//
//  Created by Aaron Griffith on 10/21/13.
//  Copyright (c) 2013 Aaron Griffith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Namer.h"
#import "StringWriter.h"
#import "FileApprover.h"
#import "TestingReporter.h"
#import "ReceivedFileLauncherReporter.h"
#import "KaleidoscopeReporter.h"
#import "Approvals.h"

@interface ApprovalTestsMacTests : XCTestCase

@end

@implementation ApprovalTestsMacTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNamerGetClass
{
    Namer *namer = [[Namer alloc] init];
    XCTAssertEqualObjects(@"ApprovalTestsMacTests", [namer getClassNameFromClass:2], @"This is the class name");
}

- (void)testNamerGetMethod
{
    Namer *namer = [[Namer alloc] init];
    XCTAssertEqualObjects(@"testNamerGetMethod", [namer getMethodNameFromMethod:2], @"This is the method name");
}

- (void)testNamerGetDirectory
{
    Namer *namer = [[Namer alloc] init];
    NSString* filePath = [namer getDirectoryNameFromClass];
    NSString* lastTwoPath;
    
    NSArray* pathComponents = [filePath pathComponents];
    
    if ([pathComponents count] > 2) {
        NSArray* lastTwoArray = [pathComponents subarrayWithRange:NSMakeRange([pathComponents count]-2,2)];
        lastTwoPath = [NSString pathWithComponents:lastTwoArray];
    }
    XCTAssertEqualObjects(@"ApprovalTestsMac/ApprovalTestsMacTests", lastTwoPath, @"This is the directory name");
}

- (void)testNamerGetBasename
{
    Namer *namer = [[Namer alloc] init];
    NSString *basenameLast =[[namer getBasename:3] lastPathComponent];
    XCTAssertEqualObjects(basenameLast, @"ApprovalTestsMacTests.testNamerGetBasename");
}


- (void)testWritesFile
{
    NSString *contents = [NSString stringWithFormat:@"foo%i", arc4random() % 100];
    StringWriter *sw = [[StringWriter alloc] init];
    
    NSString *fileName = @".txt";
    NSString *currentFilePath = [NSString stringWithFormat:@"%s", __FILE__];
    NSString *baseName = [currentFilePath substringToIndex:[currentFilePath length]-2];
    [sw WriteReceivedFile:baseName :contents];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *homeDir = [currentFilePath stringByDeletingLastPathComponent];
    
    NSError *error;
    NSString *filePath = [homeDir stringByAppendingPathComponent:[NSString stringWithFormat:@"ApprovalTestsMacTests.received%@",fileName]];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    XCTAssertEqualObjects(contents, txtInFile, @"This is the received file name");
    
    if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    NSLog(@"Test Class location: %@",
          [fileMgr contentsOfDirectoryAtPath:homeDir error:&error]);

}

- (void)testWriterRecievedName
{
    StringWriter *sw = [[StringWriter alloc] init];
    NSString *fileName = [sw GetReceivedFileName:@"./stuff" :nil ];
    XCTAssertEqualObjects(fileName, @"./stuff.received.txt", @"This is the received file name");
}


- (void)testWriterApprovedName
{
    StringWriter *sw = [[StringWriter alloc] init];
    NSString *fileName = [sw GetApprovedFileName:@"./stuff" :nil ];
    XCTAssertEqualObjects(fileName, @"./stuff.approved.txt", @"This is the approved file name");
}


- (void)testWriterAlternativeExtension
{
    StringWriter *sw = [[StringWriter alloc] init];
    NSString *fileName = [sw GetApprovedFileName:@"./stuff" :@".html" ];
    XCTAssertEqualObjects(fileName, @"./stuff.approved.html", @"This is the approved file name with .html extension");
}

- (void)testFileApproverCompareSameFiles
{
    FileApprover *fa = [[FileApprover alloc]init];
    StringWriter *sw = [[StringWriter alloc] init];
    Namer *namer = [[Namer alloc] init];
    [sw WriteReceivedFile:[namer getDirectoryNameFromClass] :@"a text content"];
    NSString *target = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , @"a.txt"];
    NSString *destination = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , @"a_same.txt"];
    [[NSFileManager defaultManager] copyItemAtPath:target toPath: destination error:nil];
    XCTAssertTrue([fa verifyFiles:target: destination:nil], @"These are matching files");
}


- (void)testFileApproverCompareDifferentFiles
{
    FileApprover *fa = [[FileApprover alloc]init];
    StringWriter *sw = [[StringWriter alloc] init];
    TestingReporter *tr = [[TestingReporter alloc]init];
    Namer *namer = [[Namer alloc] init];
    [sw WriteReceivedFile:[namer getDirectoryNameFromClass] :@"a text content"];
    NSString *target = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , @"a.txt"];
    NSString *destination = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , @"a_same.txt"];
    [[NSFileManager defaultManager] copyItemAtPath:target toPath: destination error:nil];
    [fa verifyFiles:target: destination: [tr report]];
    XCTAssertTrue(tr.called, @"Reporter called");
}

- (void)testFileApproverFull
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    [sw WriteReceivedFile:[namer getDirectoryNameFromClass] :@"b text content"];
    TestingReporter *tr = [[TestingReporter alloc]init];
    [fa verify:namer :sw :tr];
    XCTAssertTrue(tr.called, @"Reporter called");
}

- (void)testReturnsErrorWhenFilesAreDifferent
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    [sw WriteReceivedFile:[namer getDirectoryNameFromClass] :@"b text content"];
    TestingReporter *tr = [[TestingReporter alloc]init];
    NSString *error = [fa verify:namer :sw :tr];
    XCTAssertEqualObjects(@"Approval Mismatch", error);
    
}
- (void)testReturnsNilWhenFilesAreSame
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    [sw WriteReceivedFile:[namer getBasename:3] :@"b text content"];
    ReceivedFileLauncherReporter *reporter = [[ReceivedFileLauncherReporter alloc]init];
    NSString *error = [fa verify:namer :sw :reporter];
    XCTAssertEqualObjects(@"none", error);
}

- (void)testKaleidoscopeReporter
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    [sw WriteReceivedFile:[namer getBasename:3] :@"kaleidoscope text content"];
    KaleidoscopeReporter *reporter = [[KaleidoscopeReporter alloc]init];
    NSString *error = [fa verify:namer :sw :reporter];
    XCTAssertEqualObjects(@"none", error);
}

- (void)testVerify{
    [Approvals verify:@"Hellowwwww World"];
}








@end

