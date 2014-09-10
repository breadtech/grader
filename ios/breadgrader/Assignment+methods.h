//
//  Assignment+methods.h
//  breadgrader
//
//  Created by Brian Kim on 5/10/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Assignment.h"

@class  BGGradeInfo;

@interface Assignment (methods)

@property (readonly) BGGradeInfo *grade;

+ (Assignment *)insertAssignmentForCriteria:(Criteria *)criteria;

@end
