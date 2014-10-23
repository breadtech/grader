//
//  NSFileManager+fileSize.h
//  breadgrader
//
//  Created by Brian Kim on 8/27/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (fileSize)
- (unsigned long long)contentSizeOfDirectoryAtURL:(NSURL *)directoryURL;
@end
