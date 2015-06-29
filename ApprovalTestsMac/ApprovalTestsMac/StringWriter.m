//
// Created by Aaron Griffith on 10/24/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "StringWriter.h"


@implementation StringWriter {

}

- (NSString *)GetReceivedFileName:(NSString *)baseName :(NSString *)extension {
    if (extension.length==0) {
        extension = @".txt";
    }
    return [NSString stringWithFormat:@"%@.received%@", baseName, extension];
}


- (NSString *)WriteReceivedFile:(NSString *)baseName :(NSString *)contents{
    NSString *filePath = [self GetReceivedFileName:baseName :@""];
    [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return filePath;
}

- (NSString *)GetApprovedFileName:(NSString *)baseName :(NSString *)extension {
    if (extension.length==0) {
        extension = @".txt";
    }
    return [NSString stringWithFormat:@"%@.approved%@", baseName, extension];
}





@end