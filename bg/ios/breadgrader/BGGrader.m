//
//  BGGrader.m
//  breadgrader
//
//  Created by Brian Kim on 10/24/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGGrader.h"

@interface BGGrader()
{
    
}

@property (nonatomic, strong) NSMutableSet *grades;

@end

@implementation BGGrader

- (instancetype)initWithGrade:(BGGradeInfo *)grade
{
    self = [super init];
    if (self)
    {
        self.grades = [@[grade] mutableCopy];
    }
    return self;
}

- (instancetype)initWithGradeSet:(NSSet *)grades
{
    self = [super init];
    if (self)
    {
        self.grades = [grades mutableCopy];
    }
    return self;
}

// gets the grade set of the grader's operands
- (NSSet *)getGradeSet
{
    return self.grades;
}

//
// grader operators
//

- (void)addGrade:(BGGradeInfo *)operand
{
    [self.grades addObject: operand];
}

- (void)addGrades:(NSSet *)grades
{
    [self.grades addObjectsFromArray:grades.allObjects];
}

- (double)sum
{
    double s = 0;
    for (BGGradeInfo *gr in self.grades)
    {
        s += gr.floatValue;
    }
    return s;
}

- (int)gradeCount
{
    return self.grades.count;
}

- (double)mean
{
    return [self sum] / (double)[self gradeCount];
}

- (double)standardDeviation
{
    double mean = [self mean];
    double stddev = 0;
    for (BGGradeInfo *grade in self.grades)
    {
        stddev += pow(grade.floatValue - mean, 2);
    }
    double n = [self gradeCount];
    return stddev/n;
}

- (double)variance
{
    return pow(self.standardDeviation,2);
}

+ (BGGradeInfo *)average:(NSSet *)grades
{
    float sum = 0;
    int n = 0;
    for (BGGradeInfo *grade in grades)
    {
        if (grade.isGraded)
        {
            sum += grade.floatValue;
            n++;
        }
    }
    BGGradeInfo *ret;
    if (!sum) ret = [BGGradeInfo gradeWithUngradedGrade: 100.0f];
    else ret = [BGGradeInfo gradeWithGrade: sum/n];
    return ret;
}

@end
