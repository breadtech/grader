//
//  Criteria+methods.h
//  breadgrader
//
//  Created by Brian Kim on 5/10/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Criteria.h"

@class BGGradeInfo;

@interface Criteria (methods)

@property (readonly) BGGradeInfo *grade;

+ (NSSet *)setOfGradesForAssignmentsInCriteria:(Criteria *)criteria;

+ (Criteria *)insertCriteriaForCourse:(Course *)course withType:(NSString *)type andWeight:(NSNumber *)weight;

@end
