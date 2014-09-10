//
//  Criteria+methods.m
//  breadgrader
//
//  Created by Brian Kim on 5/10/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Criteria+methods.h"
#import "Course+methods.h"
#import "Assignment+methods.h"

#import "BGGrader.h"
#import "BGGradeInfo.h"

@implementation Criteria (methods)

- (BGGradeInfo *)grade
{
    return [BGGrader average: [Criteria setOfGradesForAssignmentsInCriteria: self]];
}

+ (NSSet *)setOfGradesForAssignmentsInCriteria:(Criteria *)criteria
{
    NSMutableSet *set = [NSMutableSet setWithCapacity: criteria.assignments.count];
    for (Assignment *a in criteria.assignments)
    {
        [set addObject: a.grade];
    }
    return set;
}

+ (Criteria *)insertCriteriaForCourse:(Course *)course withType:(NSString *)type andWeight:(NSNumber *)weight
{
    Criteria *cr = [NSEntityDescription insertNewObjectForEntityForName: @"Criteria" inManagedObjectContext: course.managedObjectContext];
    cr.course = course;
    cr.type = type;
    cr.weight = weight;
    
    
    return cr;
}

@end
