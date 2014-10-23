//
//  BGCourseInfoViewController.h
//  breadgrader
//
//  Created by Brian Kim on 3/29/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIInfoViewController.h"

@class Course;

@interface BGCourseInfoViewController : BIInfoViewController

@property (nonatomic, strong) Course *course;

@end
