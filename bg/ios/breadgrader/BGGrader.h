//
//  BGGrader.h
//  breadgrader
//
//  Created by Brian Kim on 10/24/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//
//  description:
//  - the operational object for BGGradeInfo objects
//  -

#import <Foundation/Foundation.h>
#import "BGGradeInfo.h"


@interface BGGrader : NSObject

//==================================================
// instance methods
//==================================================

//
// inits
//

//
// - initializes the grader with a starting grade
//
- (instancetype)initWithGrade:(BGGradeInfo *)grade;
- (instancetype)initWithGradeSet:(NSSet *)grades;

//
// convenience methods
//

- (NSSet *)getGradeSet;

//
// grader operators
//

// this method adds one grade to the gradeSet
- (void)addGrade:(BGGradeInfo *)operand;
- (void)addGrades:(NSSet *)grades;

- (double)sum;
- (int)gradeCount;
- (double)mean;

- (double)standardDeviation;
- (double)variance;


//==================================================
// class method
//==================================================

+ (BGGradeInfo *)average:(NSSet *)grades;

@end
