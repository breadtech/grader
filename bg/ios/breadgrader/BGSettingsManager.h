//
//  BASettingsManager.h
//  breadagenda
//
//  Created by Brian Kim on 2/26/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSettingsManager : NSObject

@property (readonly) BOOL isFirstLoad;

@property (nonatomic) NSArray *schoolTypes;
// strings from schoolTypes are keys that point to arrays of arrays of keys to tableInfo (for BGCourseInfoVC)
@property (nonatomic) NSArray *termNames;
@property (nonatomic) NSArray *courseSubjects;
@property (nonatomic) NSArray *criteriaTypes;

@property (readonly) float scaleValue;

// backup
// reminders

// about
// support bread
// version

- (void)resetSettings;

+ (BGSettingsManager *)sharedManager;

@end
