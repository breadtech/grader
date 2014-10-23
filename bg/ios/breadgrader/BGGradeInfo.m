//
//  BGGrade.m
//  breadgrader
//
//  Created by Brian Kim on 3/16/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGGradeInfo.h"

@interface BGGradeInfo()

@property (nonatomic, strong) NSNumber *grade;

@end

@implementation BGGradeInfo

- (id)initWithUngradedGrade:(float)max
{
    self = [super init];
    if (self)
    {
        self = [self initWithGrade: -1 outOf: max];
    }
    return self;
}

- (id)initWithGrade:(float)grade
{
    self = [super init];
    if (self)
    {
        self = [self initWithGrade: grade outOf: 100.0f];
    }
    return self;
}

- (id)initWithGrade:(float)received outOf:(float)max
{
    self = [super init];
    if (self)
    {
        self.received = received;
        self.max = max;
        [self updateGrade];
    }
    return self;
}

- (float)updateGrade
{
    if (self.received + 1 < 0.1)
    {
        self.grade = [NSNumber numberWithInt: -1];
        return -1;
    }
    float retval = self.received / self.max * 100;
    self.grade = [NSNumber numberWithFloat: retval];
    return retval;
}

- (void)setReceived:(float)received
{
    _received = received;
    [self updateGrade];
}

- (void)setMax:(float)max
{
    _max = max;
    [self updateGrade];
}

- (BOOL)isGraded
{
    return self.intValue != -1;
}

- (int)intValue
{
    return self.grade.intValue;
}

- (float)floatValue
{
    return self.grade.floatValue;
}

- (float)scaleValue
{
    if (self.isGraded) return (100 - self.floatValue)/3.5;
    else return 100.0f;
}

- (NSString *)stringValue
{
    NSString *ret;
    if (self.isGraded)
    {
        if (100.0f - self.floatValue < 0.001)
        {
            ret = @"100%";
        } else
            ret = [NSString stringWithFormat: @"%.2f%%", self.grade.floatValue];
    }
    else
        ret = @"NG";
    return ret;
    
}

+ (BGGradeInfo *)ungradedGrade
{
    return [BGGradeInfo gradeWithUngradedGrade: 100.0f];
}

+ (BGGradeInfo *)gradeWithUngradedGrade:(float)max
{
    return [[BGGradeInfo alloc] initWithUngradedGrade: max];
}

+ (BGGradeInfo *)gradeWithGrade:(float)received
{
    return [[BGGradeInfo alloc] initWithGrade: received];
}

+ (BGGradeInfo *)gradeWithGrade:(float)received outOf:(float)max
{
    return [[BGGradeInfo alloc] initWithGrade: received outOf: max];
}


@end
