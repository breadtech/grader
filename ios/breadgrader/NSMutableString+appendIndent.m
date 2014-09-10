//
//  NSMutableString+appendIndent.m
//  breadgrader
//
//  Created by Brian Kim on 7/11/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "NSMutableString+appendIndent.h"

@implementation NSMutableString (appendIndent)

- (NSMutableString *)appendIndent:(int)i
{
    for (int j = 0; j < i; j++)
    {
        [self appendString: @"\t"];
    }
    return self;
}

@end
