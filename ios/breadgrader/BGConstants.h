//
//  Constants.h
//  breadagenda
//
//  Created by Brian Kim on 12/29/12.
//  Copyright (c) 2012 bread. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const breadgradersite;

FOUNDATION_EXPORT NSString *const kAssignmentCriteriaKey;
FOUNDATION_EXPORT NSString *const kAssignmentDidUpdateKey;
FOUNDATION_EXPORT NSString *const kAssignmentGradeKey;
FOUNDATION_EXPORT NSString *const kAssignmentIndexKey;
FOUNDATION_EXPORT NSString *const kAssignmentNameKey;
FOUNDATION_EXPORT NSString *const kAssignmentDueDateKey;
FOUNDATION_EXPORT NSString *const kAssignmentReceivedGradeKey;
FOUNDATION_EXPORT NSString *const kAssignmentMaxGradeKey;
FOUNDATION_EXPORT NSString *const kAssignmentNotesKey;

FOUNDATION_EXPORT NSString *const kCriteriaCourseKey;
FOUNDATION_EXPORT NSString *const kCriteriaTypeKey;
FOUNDATION_EXPORT NSString *const kCriteriaWeightKey;
FOUNDATION_EXPORT NSString *const kCriteriaAssignmentsKey;

FOUNDATION_EXPORT NSString *const kCourseIsActiveKey;
FOUNDATION_EXPORT NSString *const kCourseSubjectKey;
FOUNDATION_EXPORT NSString *const kCourseTitleKey;
FOUNDATION_EXPORT NSString *const kCourseCriterionKey;

#define GRADE_TO_SCALE(x) (x < 65 ? 10 : 10 - (100-x)/3.5)

FOUNDATION_EXPORT NSString *const kUserDefaultsSchoolTypesKey;       // 0
FOUNDATION_EXPORT NSString *const kUserDefaultsSchoolTypeLayoutsKey; // 0
FOUNDATION_EXPORT NSString *const kUserDefaultsTermNamesKey;         // 0
FOUNDATION_EXPORT NSString *const kUserDefaultsCourseSubjectsKey;    // 1
FOUNDATION_EXPORT NSString *const kUserDefaultsCriteriaTypesKey;     // 1

FOUNDATION_EXPORT NSString *const kUserDefaultsPreferredGradingSystemKey; // 0
FOUNDATION_EXPORT NSString *const kUserDefaultsGradingSystemArrayKey;     // 0

FOUNDATION_EXPORT NSString *const kUserDefaultsFontKey;     // 0
FOUNDATION_EXPORT NSString *const kUserDefaultsThemeKey;    // 0

typedef enum
{
    BGReminderFrequencyNever = 0x00,
    BGReminderFrequencyNightBefore = 0x01,
    BGReminderFrequencyNotTooMuch = 0x02,
    BGReminderFrequencyAlot = 0x03
} BGReminderFrequency;

typedef enum
{
    BGPreferredGradingSystemCode = 0x00,
    BGPreferredGradingSystemNumberOutOf100 = 0x01,
    BGPreferredGradingSystemNumberOutOf4 = 0x02
} BGPreferredGradingSystem;

typedef enum
{
    BGThemeBread,
    BGThemeApple,
    BGThemeMetro
} BGTheme;