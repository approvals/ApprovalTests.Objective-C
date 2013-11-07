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
    XCTAssertEqualObjects(@"/Users/AaronGriffith/iOS Dev/ApprovalTestsMac/ApprovalTestsMacTests", [namer getDirectoryNameFromClass], @"This is the directory name");
}


- (void)testNamerGetBasename
{
    Namer *namer = [[Namer alloc] init];
    // self.assertTrue(n.get_basename().endswith("\\NamerTests.test_basename"), n.get_basename())
    NSString *basenameLast =[[namer getBasename] lastPathComponent];
    basenameLast =[namer getBasename];
    XCTAssertEqualObjects(basenameLast, @"/Users/AaronGriffith/iOS Dev/ApprovalTestsMac/ApprovalTestsMacTests/ApprovalTestsMacTests.testNamerGetBasename");
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
    //    def test_compare_same_files():
    //    approver = FileApprover()
    //    writer = StringWriter("a")
    //    writer.write_received_file("a.txt")
    //    shutil.copy("a.txt", "a_same.txt")
    //    approver.verify_files("a.txt", "a_same.txt", None)
    
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
    //    def test_compare_different_files(self):
    //    approver = FileApprover()
    //    reporter = TestingReporter()
    //    approver.verify_files("a.txt", "b.txt", reporter)
    //    self.assertTrue(reporter.called)
    
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
    //    namer = Namer()
    //    writer = StringWriter("b")
    //    reporter = TestingReporter()
    //    approver = FileApprover()
    //    approver.verify(namer, writer, reporter)
    //    self.assertTrue(reporter.called)
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
    //    def test_returns_error_when_files_are_different(self):
    //    namer = Namer()
    //    writer = StringWriter("b")
    //    reporter = TestingReporter()
    //    approver = FileApprover()
    //    error = approver.verify(namer, writer, reporter)
    //    self.assertEqual("Approval Mismatch", error)
    
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
    //def test_returns_none_when_files_are_same_files(self):
    //namer = Namer()
    //writer = StringWriter("b")
    //reporter = ReceivedFileLauncherReporter()
    //approver = FileApprover()
    //error = approver.verify(namer, writer, reporter)
    //self.assertEqual(None, error)
    
    FileApprover *fa = [[FileApprover alloc]init];
    Namer *namer = [[Namer alloc] init];
    StringWriter *sw = [[StringWriter alloc] init];
    
    //replace b.txt with namer name
     NSString *target = [NSString stringWithFormat:@"%@/%@", [namer getDirectoryNameFromClass] , [namer getClassNameFromClass]];
    [sw WriteReceivedFile:target:[namer getBasename] :@"b text content"];
    ReceivedFileLauncherReporter *reporter = [[ReceivedFileLauncherReporter alloc]init];
    NSString *error = [fa verify:namer :sw :reporter];
    XCTAssertEqualObjects(@"none", error);


}










@end

