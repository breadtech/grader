//
//  Assignment+methods.m
//  breadgrader
//
//  Created by Brian Kim on 5/10/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Assignment+methods.h"
#import "Criteria.h"
#import "BGGradeInfo.h"

@implementation Assignment (methods)

- (BGGradeInfo *)grade
{
    BGGradeInfo *g;
        if (self.received.intValue == -1)
        {
            g = [BGGradeInfo gradeWithUngradedGrade: 100.0f];
        } else
        {
            g = [BGGradeInfo gradeWithGrade: self.received.floatValue outOf: self.max.floatValue];
        }
    return g;
}

+ (Assignment *)insertAssignmentForCriteria:(Criteria *)criteria
{
    Assignment *a = [NSEntityDescription insertNewObjectForEntityForName: @"Assignment"
                                                  inManagedObjectContext: criteria.managedObjectContext];
    a.criteria = criteria;
    a.didUpdate = [NSNumber numberWithBool: YES];
    a.index = [NSNumber numberWithInt: criteria.assignments.count];
    a.name = [NSString stringWithFormat: @"%@ %i", criteria.type, a.index.intValue];
    a.due = [NSDate date];
    a.received = @(-1);
    a.max = @(-1);
    
    return a;
}

@end
