//
//  Course+methods.m
//  breadgrader
//
//  Created by Brian Kim on 3/16/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "Course+methods.h"
#import "Criteria+methods.h"
#import "Assignment+methods.h"

#import "BGGradeInfo.h"

@implementation Course (methods)

#pragma mark - Public API

- (BGGradeInfo *)grade
{
    float received = 0, max = 0;
    for (Criteria *cr in self.criterion)
    {
        if (cr.grade.isGraded)
        {
            received += cr.grade.received * cr.weight.floatValue;
            max += cr.grade.max * cr.weight.floatValue;
        }
    }
    if (received == 0) received = -1;
    return [BGGradeInfo gradeWithGrade: received outOf: max];
}

- (NSString *)titleInfo
{
    return [NSString stringWithFormat: @"%@: %@", self.subject, self.title];
}

+ (BGGradeInfo *)averageGradeOfCoursesInManagedObjectContext:(NSManagedObjectContext *)moc
                                             wantsActive:(BOOL)wantsActive
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Course"
                inManagedObjectContext:moc];
    request.entity = entity;
    
    // set the predicate
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"isActive = %@",
                         @(wantsActive)];
    request.predicate = pred;

    NSError *err;
    NSArray *a = [moc executeFetchRequest: request error: &err];
    
    if (a)
    {
        float recieved = 0, max = 0;
        for (Course *c in a)
        {
            BGGradeInfo *grade = c.grade;
            if (grade.isGraded)
            {
                recieved += grade.received;
                max += grade.max;
            }
        }
        
        BGGradeInfo *ret;
        if (recieved < 0.01)
        {
            ret = [BGGradeInfo gradeWithUngradedGrade: 100.0f];
        } else
        {
            ret = [BGGradeInfo gradeWithGrade: recieved outOf: max];
        }
        return ret;
    } else
    {
        // handle error
        return nil;
    }
}

/*
- (BGGrade *)getAverage
{
    float received = 0;
    float max = 0;
    for (Criteria *criteria in self.criterion)
    {
        if (criteria.received.intValue != -1)
        {
            received += criteria.received.floatValue * criteria.weight.floatValue;
            max += criteria.max.floatValue * criteria.weight.floatValue;
        }
    }
    if (max < 0.1)
    {
        return [BGGrade gradeWithUngradedGrade: 100];
    }
    
    self.received = [NSNumber numberWithFloat: received];
    self.max = [NSNumber numberWithFloat: max];
    return [BGGrade gradeWithGrade: received outOf: max];
}
 */

+ (Course *)insertSampleCourseInManagedObjectContext:(NSManagedObjectContext *)moc
{
    Course *c = [NSEntityDescription insertNewObjectForEntityForName: @"Course" inManagedObjectContext: moc];
    
    c.title = @"Freshman C";
    c.subject = @"Programming";
    c.isActive = [NSNumber numberWithBool: YES];
    
    for (int i = 0; i < 5; i++) {
        Criteria *cr;
        switch (i) {
            case 0:
            {
                cr = [Criteria insertCriteriaForCourse: c withType: @"Project" andWeight: @(20)];
                break;
            }
            case 1:
            {
                cr = [Criteria insertCriteriaForCourse: c withType: @"Test" andWeight: @(40)];
                break;
            }
            case 2:
            {
                cr = [Criteria insertCriteriaForCourse: c withType: @"Quiz" andWeight: @(10)];
                break;
            }
            case 3:
            {
                cr = [Criteria insertCriteriaForCourse: c withType: @"Homework" andWeight: @(10)];
                break;
            }
            default:
            {
                cr = [Criteria insertCriteriaForCourse: c withType: @"Final" andWeight: @(20)];
                break;
            }
        }
        // generate a first assignment
        int n = arc4random() % 12 + 1;
        for (int i = 0; i < n; i++)
        {
            Assignment *a = [Assignment insertAssignmentForCriteria: cr];
            a.due = [NSDate date];
            a.notes = @"assignment description";
            int received = arc4random() % 30 + 70;
            a.received = [NSNumber numberWithInt: received];
            a.max = [NSNumber numberWithInt: 100];
            a.didUpdate = [NSNumber numberWithBool: YES];
            
            [cr addAssignmentsObject: a];
        }
        [c addCriterionObject: cr];
    }
    
    NSError *err;
    if (![moc save: &err]) return nil;
    
    return c;
}
@end
