//
//  BGCourseListViewController.m
//  breadgrader
//
//  Created by Brian Kim on 3/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCourseListViewController.h"

#pragma mark - Controller headers

// top-left
#import "BGHelpViewController.h"

// top-right
#import "BGSettingsViewController.h"

// bottom-right
#import "BGCourseAddViewController.h"

// on table-cell click
#import "BGCriteriaListViewController.h"

// on table-cell info button click
#import "BGCourseInfoViewController.h"

#pragma mark - Model headers

#import "BGGradeInfo.h"
#import "Course+methods.h"
#import "BGCoreDataController.h"

#pragma mark - View headers

#import "BIListCell.h"

@interface BGCourseListViewController () <BIInfoViewControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation BGCourseListViewController

#pragma mark - Core Data fetch

- (NSFetchedResultsController *)frc
{
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"Course"];
    
    // set the predicate
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"isActive = %@",
                         @(self.wantsActive)];
    [fetchRequest setPredicate: pred];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:self.moc
            sectionNameKeyPath:nil cacheName:nil];
    _frc.delegate = self;
    
	NSError *error = nil;
	if (![_frc performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _frc;
}

#pragma mark - accessor methods

- (NSManagedObjectContext *)moc
{
    return [[BGCoreDataController sharedController] managedObjectContext];
}

- (BGGradeInfo *)average
{
    if (!_average)
    {
        _average = [Course averageGradeOfCoursesInManagedObjectContext: self.moc wantsActive: self.wantsActive];
        if (!_average.isGraded) _average = [BGGradeInfo gradeWithUngradedGrade: 100.0f];
    }
    return _average;
}


#pragma mark - BIList methods

- (void)cell:(BIListCell *)cell atIndexPath:(NSIndexPath *)ip
{
    Course *c = [self.frc objectAtIndexPath: ip];
    cell.textLabel.text = c.title;
    cell.detailTextLabel.text = c.grade.stringValue;
    cell.alert.scale = c.grade.scaleValue;
}

#pragma mark - BI methods

- (void)helpButtonPressed:(id)sender
{
    [self openHelp];
}

- (void)settingsButtonPressed:(id)sender
{
    [self openSettings];
}

- (void)addButtonPressed:(id)sender
{
    [self addCourse];
}

- (void)addCourse
{
    BGCourseAddViewController*vc = [[BGCourseAddViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}


- (void)openHelp
{
    BGHelpViewController *vc = [[BGHelpViewController alloc] init];
    [self presentViewController: [[UINavigationController alloc] initWithRootViewController: vc]
                       animated: YES completion: nil];
}

- (void)openSettings
{
    BGSettingsViewController *vc = [[BGSettingsViewController alloc] init];
    
    [self presentViewController: [[UINavigationController alloc] initWithRootViewController: vc]
                       animated: YES
                     completion: nil];
}

- (void)archiveButtonPressed:(id)sender
{
    BGCourseListViewController *vc = [[BGCourseListViewController alloc] init];
    vc.wantsActive = NO;
    vc.moc = self.moc;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}

- (void)updateAverage
{
    self.average = [Course averageGradeOfCoursesInManagedObjectContext: [[BGCoreDataController sharedController] managedObjectContext]
                                                           wantsActive: self.wantsActive];
}

- (void)updateUI
{
    [super updateUI];
    
    [self updateAverage];
    
    if (self.wantsActive)
    {
        self.title = @"breadgrader";
        self.bottomMiddleButton.title = [NSString stringWithFormat: @"grader average: %@", self.average.stringValue];
    } else
    {
        self.title = @"breadarchive";
        self.bottomMiddleButton.title = [NSString stringWithFormat: @"archive average: %@", self.average.stringValue];
    }
}

- (void)setupUI
{
    [super setupUI];
    
    self.tl = self.helpButton;
    self.tr = self.settingsButton;
    
    // nil out the previous average...
    self.average = nil;
    self.wantBottomMiddleButton = YES;
    
    self.bl = self.wantsActive ? self.archiveButton : self.closeButton;
    self.br = self.wantsActive ? self.addButton : self.noButton;
    
    [self firstLoadCheck];
    
}

- (void)firstLoadCheck
{
    if ([[BGSettingsManager sharedManager] isFirstLoad])
    {
        [Course insertSampleCourseInManagedObjectContext: self.moc];
    }
    [self updateUI];
}

#pragma mark - BIInfoViewController delegate methods

- (void)infoViewController:(BIInfoViewController *)vc didSaveWithInfo:(NSDictionary *)info
{
    Course *course;
    
    BOOL wantsAdd = [vc isKindOfClass: [BGCourseAddViewController class]];
    
    if (wantsAdd)
    {
        course = [NSEntityDescription insertNewObjectForEntityForName: @"Course" inManagedObjectContext: self.moc];
    }
    else
    {
        course = [(BGCourseInfoViewController *)vc course];
    }

    course.isActive = info[kCourseIsActiveKey];
    course.subject = info[kCourseSubjectKey];
    course.title = info[kCourseTitleKey];

    if (wantsAdd)
    {
        BMModel *model = [[BMModel alloc] initWithManagedObject: course];
        [[BGCoreDataController sharedController] addModel: model];
    }
    [[BGCoreDataController sharedController] save];
    [self dismissViewControllerAnimated: YES completion: nil];
    
    [self updateUI];
}

#pragma mark - UITableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openCriteriaListAtIndexPath: indexPath];
}

- (void)openCriteriaListAtIndexPath:(NSIndexPath *)ip
{
    BGCriteriaListViewController *vc = [[BGCriteriaListViewController alloc] init];
    vc.course = [self.frc objectAtIndexPath: ip];
    vc.moc = self.moc;
    
    [self.navigationController pushViewController: vc animated: YES];
}

@end
