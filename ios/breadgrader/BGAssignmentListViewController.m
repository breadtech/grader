//
//  BGAssignmentListViewController.m
//  breadgrader
//
//  Created by Brian Kim on 5/21/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAppDelegate.h"
#import "BGAssignmentListViewController.h"
#import "BGCriteriaInfoViewController.h"
#import "BGAssignmentInfoViewController.h"
#import "BGAssignmentAddViewController.h"

#import "Course+methods.h"
#import "Criteria+methods.h"
#import "Assignment+methods.h"
#import "BGGradeInfo.h"
#import "BGCoreDataController.h"

#import "BIListCell.h"

@interface BGAssignmentListViewController () <BIInfoViewControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSManagedObjectContext *moc;
@end

@implementation BGAssignmentListViewController
@synthesize shareableItem = _shareableItem;

#pragma mark - accesor methods

- (BIShareableItem *)shareableItem
{
    if (!_shareableItem)
    {
        _shareableItem = [[BIShareableItem alloc] initWithTitle: @"breadgrader"];
        _shareableItem.shortDescription = [NSString stringWithFormat: @"I got a %@ as my %@ grade in %@!", self.criteria.grade.stringValue, self.criteria.type, self.criteria.course.title];
        _shareableItem.description = [NSString stringWithFormat: @"Check out breadgrader at %@", breadgradersite];
    }
    return _shareableItem;
}

#pragma mark - convenience methods

- (void)addButtonPressed:(id)sender
{
    BGAssignmentAddViewController *vc = [[BGAssignmentAddViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}

- (void)infoButtonPressed:(id)sender
{
    BGCriteriaInfoViewController *vc = [[BGCriteriaInfoViewController alloc] init];
    vc.delegate = self;
    vc.criteria = self.criteria;
    
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)updateUI
{
    [super updateUI];
    
    self.bottomMiddleButton.title = [NSString stringWithFormat: @"%@ %@ average: %@", self.criteria.course.title, self.criteria.type, self.criteria.grade.stringValue];
}

- (void)setupUI
{
    self.tl = self.backButton;
    self.tr = self.infoButton;
    
    self.wantBottomMiddleButton = YES;
    self.bl = self.shareButton;
    self.br = self.addButton;
    
    self.title = self.criteria.type;
    
    [super setupUI];
}

#pragma mark - BIInfoViewController delegate

- (void)infoViewControllerDidCancel:(BIInfoViewController *)vc
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)infoViewController:(BIInfoViewController *)vc didSaveWithInfo:(NSDictionary *)info
{
    id obj;
    if ([vc isKindOfClass: [BGAssignmentAddViewController class]])
    {
        obj = [NSEntityDescription insertNewObjectForEntityForName: @"Assignment"
                                            inManagedObjectContext: self.moc];
        [obj setValue: self.criteria forKey: @"criteria"];
        
        int i = self.frc.fetchedObjects.count + 1;
        
        NSString *name = info[@"name"];
        if (!name.length)
        {
            info = [info mutableCopy];
            [(NSMutableDictionary *)info setObject: [NSString stringWithFormat: @"%@ %d", self.criteria.type, i]
                                          forKey: @"name"];
            [(NSMutableDictionary *)info setObject: @(i) forKey: @"index"];
        }
    }
    else if ([vc isKindOfClass: [BGAssignmentInfoViewController class]])
    {
        obj = [(BGAssignmentInfoViewController *)vc assignment];
    }
    else // from criteriainfo
    {
        obj = [(BGCriteriaInfoViewController *)vc criteria];
    }
    
    for (id key in info)
    {
        NSString *property = info[key];
        [obj setValue: property forKey: key];
    }
    
    [[BGCoreDataController sharedController] save];
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
    [self updateUI];
}

#pragma mark - BIListViewController methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showAssignmentInfoAtIndexPath: indexPath];
}

- (void)showAssignmentInfoAtIndexPath:(NSIndexPath *)ip
{
    BGAssignmentInfoViewController *vc = [[BGAssignmentInfoViewController alloc] init];
    Assignment *a = [self.frc objectAtIndexPath: ip];
    vc.delegate = self;
    vc.assignment = a;
    
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)cell:(BIListCell *)cell atIndexPath:(NSIndexPath *)ip
{
    Assignment *a = [self.frc objectAtIndexPath: ip];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@. %@", a.index, a.name];
    cell.detailTextLabel.text = a.grade.stringValue;
    cell.alert.scale = a.grade.scaleValue;
}

#pragma mark - Core Data fetch

- (NSFetchedResultsController *)frc
{
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Assignment"
                                              inManagedObjectContext: self.moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // set the predicate
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"criteria = %@", self.criteria];
    [fetchRequest setPredicate: pred];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
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

#pragma mark - uivc methods



@end
