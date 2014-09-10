//
//  BGSettingsViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/8/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGSettingsViewController.h"
#import "BGSettingsInfoLayout.h"

#import "BGSettingsManager.h"
#import "BGBackupViewController.h"

#import "BGCourseSubjectPickerViewController.h"
#import "BGCriteriaTypePickerViewController.h"
#import "BGBackupViewController.h"
#import "BGAboutViewController.h"
#import "BGSupportViewController.h"

@interface BGSettingsViewController()
@property (nonatomic, weak) BGSettingsManager *settingsManager;
@end

@implementation BGSettingsViewController
@synthesize infoLayout = _infoLayout;

- (BGSettingsManager *)settingsManager
{
    return [BGSettingsManager sharedManager];
}

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGSettingsInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (void)toCourseSubjects
{
    BGCourseSubjectPickerViewController *vc = [[BGCourseSubjectPickerViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)toCriteriaTypes
{
    BGCriteriaTypePickerViewController *vc = [[BGCriteriaTypePickerViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)toBackup
{
    BGBackupViewController *vc = [[BGBackupViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)toAbout
{
    BGAboutViewController *vc = [[BGAboutViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)toSupport
{
    BGSupportViewController *vc = [[BGSupportViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - biinfovc methods

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if ([ip isEqual: [self.infoLayout indexPathForKey: COURSE_SUBJECTS_KEY]])
    {
        [self toCourseSubjects];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: CRITERIA_TYPES_KEY]])
    {
        [self toCriteriaTypes];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: BACKUP_RESTORE_KEY]])
    {
        [self toBackup];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: ABOUT_KEY]])
    {
        [self toAbout];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: SUPPORT_KEY]])
    {
        [self toSupport];
    }
}

#pragma mark - bi methods

- (void)setupUI
{
    [super setupUI];
    
    self.tl = self.noButton;
    self.tr = self.closeButton;
    
    self.title = @"Settings";
    [self updateUI];
}

@end
