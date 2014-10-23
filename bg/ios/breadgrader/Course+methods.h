//
//  Course+methods.h
//  breadgrader
//
//  Created by Brian Kim on 3/16/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Course.h"

@class BGGradeInfo;

@interface Course (methods)

@property (readonly) BGGradeInfo *grade;
@property (readonly) NSString *titleInfo;

+ (Course *)insertSampleCourseInManagedObjectContext:(NSManagedObjectContext *)moc;
+ (BGGradeInfo *)averageGradeOfCoursesInManagedObjectContext:(NSManagedObjectContext *)moc
                                             wantsActive:(BOOL)wantsActive;

@end
