//
//  BGGrade.h
//  breadgrader
//
//  Created by Brian Kim on 3/16/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGGradeInfo : NSObject

@property (nonatomic) float received;
@property (nonatomic) float max;
@property (readonly) BOOL isGraded;

- (id)initWithUngradedGrade:(float)max;
- (id)initWithGrade:(float)received outOf:(float)max;
- (id)initWithGrade:(float)grade;

- (int)intValue;
- (float)floatValue;
- (float)scaleValue;
- (NSString *)stringValue;

+ (BGGradeInfo *)ungradedGrade;
+ (BGGradeInfo *)gradeWithUngradedGrade:(float)max;
+ (BGGradeInfo *)gradeWithGrade:(float)received;
+ (BGGradeInfo *)gradeWithGrade:(float)received outOf:(float)max;


@end
