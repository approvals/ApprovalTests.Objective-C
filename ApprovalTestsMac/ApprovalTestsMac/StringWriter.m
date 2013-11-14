//
// Created by Aaron Griffith on 10/24/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "StringWriter.h"


@implementation StringWriter {

}

- (NSString *)GetReceivedFileName:(NSString *)fileName :(NSString *)basename {
    if (basename.length==0) {
        basename = @".txt";
    }
    return [NSString stringWithFormat:@"%@.received%@", fileName, basename];
}

- (NSString *)WriteReceivedFile:(NSString *)name :(NSString *)path :(NSString *)contents{
//    if([path hasSuffix:@":"])
//    {
//        path = [path substringToIndex:[path length] - 1];
//    }
    NSString *filePath = [path stringByAppendingPathComponent:nil];
    
    filePath = [self GetReceivedFileName:path :nil];
    [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return filePath;
}

- (NSString *)GetApprovedFileName:(NSString *)fileName :(NSString *)basename {
    if (basename.length==0) {
        basename = @".txt";
    }
    return [NSString stringWithFormat:@"%@.approved%@", fileName, basename];
}





@end