//
// Created by Aaron Griffith on 10/21/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "Namer.h"
#include <execinfo.h>


@implementation Namer {

}
@synthesize baseName;

- (NSArray*)parseCaller:(NSString* )nameSource{
    NSRange start = [nameSource rangeOfString:@"["];
    NSRange end = [nameSource rangeOfString:@"]"];
    NSInteger _length = end.location - start.location - 1;
    NSString *substring = [nameSource substringWithRange:NSMakeRange(start.location+1, _length)];
    NSArray *substringsArray = [substring componentsSeparatedByString: @" "];
    return substringsArray;
}


- (NSArray*)getCallerAt:(int)depth{
    void *addr[depth + 1];
    int nframes = backtrace(addr, (int)sizeof(addr)/sizeof(*addr));
    if (nframes > depth) {
        char **syms = backtrace_symbols(addr, nframes);
        NSString * source = [NSString stringWithFormat:@"%s", syms[depth]];
        free(syms);
        return [self parseCaller: source];
    }
    return nil;
}

- (NSString*)getClassNameFromClass:(int) depth{
    return [self getCallerAt:depth][0];
}

- (NSString*)getMethodNameFromMethod:(int) depth{
    return [self getCallerAt:depth][1];
}

- (NSString*)getDirectoryNameFromClass{
    return [[NSString stringWithFormat:@"%s", __FILE__] stringByDeletingLastPathComponent];
}


- (NSString*)getBasename:(int) depth{
    NSString *directoryName = [[NSString stringWithFormat:@"%s", __FILE__] stringByDeletingLastPathComponent];
    NSString *className = [self getClassNameFromClass:depth];
    NSString *methodName = [self getMethodNameFromMethod:depth];
    baseName = [NSString stringWithFormat:@"%@/%@.%@", directoryName, className,methodName];
    
    while([baseName hasSuffix:@":"])
    {
        baseName = [baseName substringToIndex:[baseName length] - 1];
    }
    return baseName;
}

@end