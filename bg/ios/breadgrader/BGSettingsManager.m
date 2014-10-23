//
//  BASettingsManager.m
//  breadagenda
//
//  Created by Brian Kim on 2/26/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGSettingsManager.h"

#define DEFAULT_FONT @"OpenSans"
#define DEFAULT_THEME BGThemeApple
#define DEFAULT_GRADINGSYSTEM BGPreferredGradingSystemNumberOutOf100
#define DEFAULT_SCHOOL_TYPE @"High"

@interface BGSettingsManager()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation BGSettingsManager

#define firstLoadKey @"firstLoadKey"

#pragma mark - first time load handling

- (BOOL)isFirstLoad
{
    NSNumber *ret = [self.userDefaults objectForKey: firstLoadKey];
    if (ret)
    {
        return ret.boolValue;
    } else
    {
        [self resetSettings];
        return YES;
    }
}

- (void)resetSettings
{
    NSNumber *firstLoad = @(NO);
    NSArray *schoolTypes = @[ @"Middle School", @"High School", @"College" ];
    NSArray *courseSubjects = @[ @"Math", @"English", @"Science", @"History", @"Language", @"Programming" ];
    NSArray *criteriaTypes = @[ @"Test", @"Quiz", @"Homework", @"Participation", @"Essay", @"Project", @"Lab", @"Midterm", @"Final" ];
    
    [self.userDefaults setObject: firstLoad forKey: firstLoadKey];
    self.schoolTypes = schoolTypes;
    self.courseSubjects = courseSubjects;
    self.criteriaTypes = criteriaTypes;
}

#pragma mark - school type

- (NSArray *)schoolTypes
{
    return [self.userDefaults arrayForKey: kUserDefaultsSchoolTypesKey];
}

- (void)setSchoolTypes:(NSArray *)schoolTypes
{
    [self.userDefaults setObject: schoolTypes forKey: kUserDefaultsSchoolTypesKey];
    [self.userDefaults synchronize];
}

#pragma mark - school type layout

#pragma mark - course subjects

- (NSArray *)courseSubjects
{
    return [self.userDefaults arrayForKey: kUserDefaultsCourseSubjectsKey];
}

- (void)setCourseSubjects:(NSArray *)courseSubjects
{
    [self.userDefaults setObject: courseSubjects forKey: kUserDefaultsCourseSubjectsKey];
    [self.userDefaults synchronize];
}

#pragma mark - criteria types

- (NSArray *)criteriaTypes
{
    return [self.userDefaults arrayForKey: kUserDefaultsCriteriaTypesKey];
}

- (void)setCriteriaTypes:(NSDictionary *)criteriaTypes
{
    [self.userDefaults setObject: criteriaTypes forKey: kUserDefaultsCriteriaTypesKey];
    [self.userDefaults synchronize];
}

#pragma mark - singleton instantiation

static BGSettingsManager *sharedManager;

+ (BGSettingsManager *)sharedManager {
    if (sharedManager == nil) {
        sharedManager = [[super allocWithZone: NULL] init];
    }
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

@end
