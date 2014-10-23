//
//  NSFileManager+fileSize.m
//  breadgrader
//
//  Created by Brian Kim on 8/27/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "NSFileManager+fileSize.h"

@implementation NSFileManager (fileSize)

- (unsigned long long)contentSizeOfDirectoryAtURL:(NSURL *)directoryURL
{
    unsigned long long contentSize = 0;
    NSDirectoryEnumerator *enumerator = [self enumeratorAtURL: directoryURL
                                   includingPropertiesForKeys: @[NSURLFileSizeKey]
                                                      options: NSDirectoryEnumerationSkipsHiddenFiles
                                                 errorHandler: NULL];
    NSNumber *val;
    for (NSURL *url in enumerator)
    {
        if ([url getResourceValue: &val forKey: NSURLFileSizeKey error: NULL])
        {
            contentSize += val.unsignedLongLongValue;
        }
    }
    return contentSize;
}

@end
