//
//  BGBackup.h
//  breadgrader
//
//  Created by Brian Kim on 8/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGBackup : NSObject

@property (nonatomic, strong) NSDate *backupDate;
@property (nonatomic, strong) NSURL *path;

+ (BGBackup *)backupWithDate:(NSDate *)date andPath:(NSURL *)path;

@end
