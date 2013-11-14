//
// Created by Aaron Griffith on 10/21/13.
// Copyright (c) 2013 Aaron Griffith. All rights reserved.
//


#import "Namer.h"
#include <execinfo.h>


@implementation Namer {

}
@synthesize baseName;

- (NSString*)getClassNameFromClass{
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes);
        NSLog(@"%s: caller: %s", __func__, syms[1]);
        
        NSString * source = [NSString stringWithFormat:@"%s", syms[1]];
        free(syms);
        NSRange start = [source rangeOfString:@"["];
        NSRange end = [source rangeOfString:@"]"];
        NSInteger _length = end.location - start.location - 1;
        NSString *substring = [source substringWithRange:NSMakeRange(start.location+1, _length)];
        NSArray *substringsArray = [substring componentsSeparatedByString: @" "];
        return substringsArray[0];
    } else {
        NSLog(@"%s: *** Failed to generate backtrace.", __func__);
    }
    return @"suck it, Trebek!";
}

- (NSString*)getMethodNameFromMethod{
    
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes);
        NSLog(@"%s: caller: %s", __func__, syms[1]);
        
        NSString * source = [NSString stringWithFormat:@"%s", syms[1]];
        free(syms);
        NSRange start = [source rangeOfString:@"["];
        NSRange end = [source rangeOfString:@"]"];
        NSInteger _length = end.location - start.location - 1;
        NSString *substring = [source substringWithRange:NSMakeRange(start.location+1, _length)];
        NSArray *substringsArray = [substring componentsSeparatedByString: @" "];
        return substringsArray[1];
    } else {
        NSLog(@"%s: *** Failed to generate backtrace.", __func__);
    }
    return @"suck it, Trebek!";
}

- (NSString*)getDirectoryNameFromClass{
    return [[NSString stringWithFormat:@"%s", __FILE__] stringByDeletingLastPathComponent];
}


- (NSString*)getBasename{
    NSString *className;
    NSString *methodName;
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes);
        NSLog(@"%s: caller: %s", __func__, syms[1]);
        
        NSString * source = [NSString stringWithFormat:@"%s", syms[1]];
        NSLog(@"%s", syms[0]);
        NSLog(@"%s", syms[1]);
       // NSLog(@"%s", syms[2]);

        free(syms);
        NSRange start = [source rangeOfString:@"["];
        NSRange end = [source rangeOfString:@"]"];
        NSInteger _length = end.location - start.location - 1;
        NSString *substring = [source substringWithRange:NSMakeRange(start.location+1, _length)];
        NSArray *substringsArray = [substring componentsSeparatedByString: @" "];
        className = substringsArray[0];
        methodName = substringsArray[1];
    }
    baseName = [NSString stringWithFormat:@"%@/%@.%@", [[NSString stringWithFormat:@"%s", __FILE__] stringByDeletingLastPathComponent], className,methodName];
    while([baseName hasSuffix:@":"])
    {
        baseName = [baseName substringToIndex:[baseName length] - 1];
    }
    return baseName;
}

@end