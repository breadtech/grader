//
//  BGBackup.m
//  breadgrader
//
//  Created by Brian Kim on 8/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGBackup.h"

@implementation BGBackup

+ (BGBackup *)backupWithDate:(NSDate *)date andPath:(NSURL *)path
{
    BGBackup *ret = [[BGBackup alloc] init];
    ret.backupDate = date;
    ret.path = path;
    return ret;
}

@end
