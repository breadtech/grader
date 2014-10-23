//
//  BGCriteriaListViewController.m
//  breadgrader
//
//  Created by Brian Kim on 3/22/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAppDelegate.h"

#pragma mark - Controllers
#import "BGCourseInfoViewController.h"
#import "BGCriteriaListViewController.h"
#import "BGCriteriaInfoViewController.h"
#import "BGCriteriaAddViewController.h"
#import "BGAssignmentListViewController.h"

#pragma mark - Model
#import "Course+methods.h"
#import "Criteria+methods.h"
#import "BGGradeInfo.h"
#import "BGCoreDataController.h"

#pragma mark - View
#import "BIListCell.h"

@interface BGCriteriaListViewController () <BIInfoViewControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation BGCriteriaListViewController
@synthesize shareableItem = _shareableItem;

#pragma mark - accessor methods

- (BIShareableItem *)shareableItem
{
    if (!_shareableItem)
    {
        _shareableItem = [[BIShareableItem alloc] initWithTitle: @"breadgrader"];
        _shareableItem.shortDescription = [NSString stringWithFormat: @"I got a %@ in my %@ course!", self.course.grade.stringValue, self.course.title];
        _shareableItem.description = [NSString stringWithFormat: @"Check out breadgrader at %@", breadgradersite];
    }
    return _shareableItem;
}

#pragma mark - Core Data fetch

- (NSFetchedResultsController *)frc
{
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Criteria"
                                              inManagedObjectContext: self.moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // set the predicate
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"course = %@", self.course];
    [fetchRequest setPredicate: pred];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"weight" ascending:NO];
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

#pragma mark - BIInfoViewController delegate

- (void)infoViewController:(BIInfoViewController *)vc didSaveWithInfo:(NSDictionary *)info
{
    if ([vc isKindOfClass: [BGCriteriaAddViewController class]])
    {
        Criteria *cr = [NSEntityDescription insertNewObjectForEntityForName: @"Criteria" inManagedObjectContext: self.moc];
        cr.course = self.course;
        cr.type = info[kCriteriaTypeKey];
        cr.weight = info[kCriteriaWeightKey];
        
    }
    else if (vc.class == [BGCriteriaInfoViewController class])
    {
        Criteria *cr = [(BGCriteriaInfoViewController *)vc criteria];
        cr.type = info[kCriteriaTypeKey];
        cr.weight = info[kCriteriaWeightKey];
    }
    else
    {
        
        Course *course;
        
        if ([(BGCourseInfoViewController *)vc course])
        {
            course = [(BGCourseInfoViewController *)vc course];
        }
        
        course.isActive = info[kCourseIsActiveKey];
        course.subject = info[kCourseSubjectKey];
        course.title = info[kCourseTitleKey];
        
    }
    
    [[BGCoreDataController sharedController] save];
    [self dismissViewControllerAnimated: YES completion: nil];
    
    [self updateUI];
}

#pragma mark - BI methods

- (void)setupUI
{
    self.tl = self.backButton;
    self.tr = self.infoButton;
    self.wantBottomMiddleButton = YES;
    self.bl = self.shareButton;
    self.br = self.addButton;
    
    self.title = self.course.title;
    
    [super setupUI];
}

- (void)updateUI
{
    [super updateUI];
    if (self.frc.fetchedObjects.count)
    {
        self.bottomMiddleButton.title = [NSString stringWithFormat: @"%@ average: %@", self.course.title, self.course.grade.stringValue];
    }
    else
    {
        self.bottomMiddleButton.title = @"No criteria...";
        self.navigationController.toolbar.tintColor = [UIColor redColor];
    }
}

- (void)addButtonPressed:(id)sender
{
    BGCriteriaAddViewController *vc = [[BGCriteriaAddViewController alloc] init];
    vc.delegate = self;
    vc.title = @"Add Criteria";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    [self presentViewController: nav animated: YES completion: nil];
}

- (void)infoButtonPressed:(id)sender
{
    BGCourseInfoViewController *vc = [[BGCourseInfoViewController alloc] init];
    vc.course = self.course;
    vc.delegate = self;
    
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - BIListViewController methods

- (void)cell:(BIListCell *)cell atIndexPath:(NSIndexPath *)ip
{
    Criteria *c = [self.frc objectAtIndexPath: ip];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@ (%@%%)", c.type, c.weight];
    cell.detailTextLabel.text = c.grade.stringValue;
    cell.alert.scale = c.grade.scaleValue;
}

#pragma mark - UItableViewController methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showAssignmentListAtIndexPath: indexPath];
}

#pragma mark - UIViewController methods

- (void)showAssignmentListAtIndexPath:(NSIndexPath *)ip
{
    BGAssignmentListViewController *vc = [[BGAssignmentListViewController alloc] init];
    vc.criteria = [self.frc objectAtIndexPath: ip];
    
    vc.moc = self.moc;
    
    [self.navigationController pushViewController: vc
                                         animated: YES];
}


@end
