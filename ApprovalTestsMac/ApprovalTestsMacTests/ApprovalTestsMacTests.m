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

@interface ApprovalTestsMacTests : XCTestCase

@end

@implementation ApprovalTestsMacTests

- (void)setUp
{
    [super setUp];
    //EXC_BAD_ACCESS (code=EXC_l386_GPFLT)
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testNamerGetClass
{
    Namer *namer = [[Namer alloc] init];
    XCTAssertEqualObjects(@"ApprovalTestsMacTests", [namer getClassNameFromClass], @"This is the class name");
}



- (void)testNamerGetMethod
{
    Namer *namer = [[Namer alloc] init];
    XCTAssertEqualObjects(@"testNamerGetMethod", [namer getMethodNameFromMethod], @"This is the method name");
}

- (void)testNamerGetDirectory
{
    Namer *namer = [[Namer alloc] init];
    //NSLog([namer getDirectoryNameFromClass]);
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
    // self.assertTrue(n.get_basename().endswith("\\NamerTests.test_basename"), n.get_basename())
    NSString *basenameLast =[[namer getBasename] lastPathComponent];
    basenameLast =[namer getBasename];
   // NSString* filePath = basenameLast
    NSString* lastThreePath;
    
    NSArray* pathComponents = [basenameLast pathComponents];
    
    if ([pathComponents count] > 3) {
        NSArray* lastTwoArray = [pathComponents subarrayWithRange:NSMakeRange([pathComponents count]-3,3)];
        lastThreePath = [NSString pathWithComponents:lastTwoArray];
    }
    XCTAssertEqualObjects(lastThreePath, @"ApprovalTestsMac/ApprovalTestsMacTests/ApprovalTestsMacTests.testNamerGetBasename");


}


- (void)testWritesFile
{
    NSString *contents = [NSString stringWithFormat:@"foo%i", arc4random() % 100];
    StringWriter *sw = [[StringWriter alloc] init];
    NSString *fileName = @".stuff.txt";
   // NSString *newString = [[NSString stringWithFormat:@"%s", __FILE__] substringToIndex:[[NSString stringWithFormat:@"%s", __FILE__] length]-1];
    [sw WriteReceivedFile:fileName :[[NSString stringWithFormat:@"%s", __FILE__] substringToIndex:[[NSString stringWithFormat:@"%s", __FILE__] length]-2] :contents];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *homeDir = [[NSString stringWithFormat:@"%s", __FILE__] stringByDeletingLastPathComponent];
    
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
    [sw WriteReceivedFile:@"a.txt" :[namer getDirectoryNameFromClass] :@"a text content"];
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
    [sw WriteReceivedFile:@"a.txt" :[namer getDirectoryNameFromClass] :@"a text content"];
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
    [sw WriteReceivedFile:@"b.txt" :[namer getDirectoryNameFromClass] :@"b text content"];
    TestingReporter *tr = [[TestingReporter alloc]init];
    [fa verify:namer :sw :tr];
    XCTAssertTrue(tr.called, @"Reporter called");
    
}

- (void)testReturnsErrorWhenFilesAreDifferent
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    [sw WriteReceivedFile:@"b.txt" :[namer getDirectoryNameFromClass] :@"b text content"];
    TestingReporter *tr = [[TestingReporter alloc]init];
    NSString *error = [fa verify:namer :sw :tr];
    XCTAssertEqualObjects(@"Approval Mismatch", error);
    
}
- (void)testReturnsNilWhenFilesAreSame
{
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    NSString *target = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , [namer getClassNameFromClass]];
    [sw WriteReceivedFile:target:[namer getBasename] :@"b text content"];
    ReceivedFileLauncherReporter *reporter = [[ReceivedFileLauncherReporter alloc]init];
    NSString *error = [fa verify:namer :sw :reporter];
    XCTAssertEqualObjects(@"none", error);


}










@end

