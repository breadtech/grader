//
//  BGCourseInfoViewController.m
//  breadgrader
//
//  Created by Brian Kim on 3/29/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCourseInfoViewController.h"
#import "BGCourseSubjectPickerViewController.h"

#import "BGCourseInfoLayout.h"

#import "Course+methods.h"
#import "Criteria+methods.h"
#import "Assignment+methods.h"

@interface BGCourseInfoViewController () <UIAlertViewDelegate, BGCourseSubjectTableViewControllerDelegate> {}

@property (weak, nonatomic) UITextField *titleTextField;
@property (weak, nonatomic) UILabel *subjectLabel;

@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) NSString *subject;

@end

@implementation BGCourseInfoViewController
@synthesize infoLayout = _infoLayout;
@synthesize shareableItem = _shareableItem;

#pragma mark - accessor methods

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGCourseInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (UITextField *)titleTextField
{
    return [(BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kCourseTitleKey]] textField1];
}

- (UILabel *)subjectLabel
{
    return [[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kCourseSubjectKey]] detailTextLabel];
}

- (NSString *)courseTitle
{
    if (!_courseTitle)
    {
        _courseTitle = self.course.title;
    }
    return _courseTitle;
}

- (NSString *)subject
{
    if (!_subject)
    {
        _subject = self.course.subject;
    }
    return _subject;
}

#pragma mark - convenience methods

- (void)archiveButtonPressed:(id)sender
{
    [self confirmArchive];
}

- (void)deleteButtonPressed:(id)sender
{
    [self confirmDelete];
}

- (void)doneButtonPressed:(id)sender
{
    [self updateModel];
    if (!(self.courseTitle > 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Field" message: @"A course needs a title" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.subject isEqualToString: @"Choose a Subject"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Field" message: @"A course needs a subject" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSNumber *isActive = self.course.isActive;
    if (!isActive) isActive = @(YES);
    self.courseTitle = self.titleTextField.text;
    NSDictionary *dict = @{ kCourseIsActiveKey : isActive,
                            kCourseSubjectKey : self.subject,
                            kCourseTitleKey : self.courseTitle};

    [self.delegate infoViewController: self didSaveWithInfo: dict];
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)confirmArchive
{
    if (self.course.isActive.boolValue)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Archive" message: @"Are you sure you want to archive this course?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Archive", nil];
        [alert show];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Unarchive" message: @"Are you sure you want to unarchive this course?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Unarchive", nil];
        [alert show];
    }
}

- (void)confirmDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Delete" message: @"Are you sure you want to delete this item?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *s = [alertView buttonTitleAtIndex: buttonIndex];
    if ([s isEqualToString: @"Archive"] || [s isEqualToString: @"Unarchive"]) [self archive];
    if ([s isEqualToString: @"Delete"]) [self trash];
}

- (void)archive
{
    self.course.isActive = @(!self.course.isActive.boolValue);
    [self.course.managedObjectContext save: nil];
    
    NSString *title = self.course.title;
    NSString *status = self.course.isActive ? @"archived" : @"unarchived";
    [[[UIAlertView alloc] initWithTitle: @"Model Change"
                                message: [NSString stringWithFormat: @"Course \"%@\" has been successfully %@", title, status]
                               delegate: nil
                      cancelButtonTitle: @"OK"
                      otherButtonTitles: nil] show];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)trash
{
    NSString *title = self.course.title;
    for (Criteria *cr in self.course.criterion)
    {
        for (Assignment *a in cr.assignments)
        {
            [a.managedObjectContext deleteObject: a];
        }
        [cr.managedObjectContext deleteObject: cr];
    }
    [self.course.managedObjectContext deleteObject: self.course];
    [self.course.managedObjectContext save: nil];
    
    [[[UIAlertView alloc] initWithTitle: @"Model Change"
                                message: [NSString stringWithFormat: @"Course \"%@\" has been successfully deleted", title]
                              delegate: nil
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil] show];
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)setupUI
{
    self.tl = self.backButton;
    self.bl = self.archiveButton;
    self.br = self.deleteButton;
    
    self.title = @"Course Info";
    
    [super setupUI];
}

- (void)updateUI
{
    self.titleTextField.text = self.courseTitle;
    self.subjectLabel.text = [self.subject length] ? self.subject : @"Choose a Subject";

    [super updateUI];
}

- (void)updateModel
{
    self.courseTitle = self.titleTextField.text;
    self.subject = self.subjectLabel.text;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self updateUI];
}

#pragma mark - BIInfoVC methods

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if ([[self.infoLayout indexPathForKey: kCourseTitleKey] isEqual: ip])
    {
        [self.titleTextField becomeFirstResponder];
    } else if ([[self.infoLayout indexPathForKey: kCourseSubjectKey] isEqual: ip])
    {
        [self updateModel];
        [self pickSubject];
    }
}

#pragma mark - course subject selection delegate

- (void)pickSubject
{
    BGCourseSubjectPickerViewController *vc = [[BGCourseSubjectPickerViewController alloc] init];
    vc.delegate = self;
    
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)vc:(BGCourseSubjectPickerViewController *)vc didChooseSubject:(NSString *)subject
{
    self.subject = [subject copy];
    [self.navigationController popViewControllerAnimated: YES];
    
    [self updateUI];
}

@end
