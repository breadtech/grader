//
//  BGCriteriaInfoViewController.m
//  breadgrader
//
//  Created by Brian Kim on 6/4/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCriteriaInfoViewController.h"
#import "BGCriteriaTypePickerViewController.h"
#import "BGCriteriaInfoLayout.h"

#import "BGGradeInfo.h"
#import "Course+methods.h"
#import "Criteria+methods.h"

#import "BCDShareableItem.h"

@interface BGCriteriaInfoViewController () <BGCriteriaTypeTableViewControllerDelegate>


@end

@implementation BGCriteriaInfoViewController
@synthesize infoLayout = _infoLayout;
@synthesize shareableItem = _shareableItem;

#pragma mark - accesor methods

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGCriteriaInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (UITextField *)weightTextField
{
    BIInfoCell *weightCell = (BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kCriteriaWeightKey]];
    return weightCell.textField1;
}

- (UILabel *)typeLabel
{
    return [[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: kCriteriaTypeKey]] detailTextLabel];
}

- (NSString *)type
{
    if (!_type)
    {
        _type = self.criteria ? self.criteria.type : @"Choose a type";
    }
    return _type;
}

- (NSNumber *)weight
{
    if (!_weight)
    {
        _weight = self.criteria ? self.criteria.weight : @(20);
    }
    return _weight;
}


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

- (void)vc:(BGCriteriaTypePickerViewController *)vc didChooseType:(NSString *)type
{
    self.type = [NSString stringWithString: type];
    [self.navigationController popViewControllerAnimated: YES];
    
    [self updateUI];
}

- (void)confirmDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Delete" message: @"Are you sure you want to delete this item?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Delete", nil];
    [alert show];
}

- (void)deleteButtonPressed:(id)sender
{
    [self confirmDelete];
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.typeLabel.text isEqualToString: @"Choose a type"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Field" message: @"Criteria need a type" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self updateModel];
    
    NSDictionary *dict = @{ kCriteriaTypeKey : self.type,
                            kCriteriaWeightKey : self.weight };
    [self.delegate infoViewController: self didSaveWithInfo: dict];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)setupUI
{
    self.tl = self.cancelButton;
    self.tr = self.doneButton;
    self.bl = self.shareButton;
    self.br = self.deleteButton;
    
    self.title = @"Criteria Info";
    
    [super setupUI];
}

- (void)updateUI
{
    [self.typeLabel setText: self.type];
    self.weightTextField.text = self.weight.stringValue;
    
    [super updateUI];
}

- (void)updateModel
{
    self.type = self.typeLabel.text;
    self.weight = @(self.weightTextField.text.intValue);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self updateUI];
}

#pragma mark - uivc methods

- (void)pickCriteriaType
{
    self.weight = @(self.weightTextField.text.intValue);
    
    BGCriteriaTypePickerViewController *vc = [[BGCriteriaTypePickerViewController alloc] init];
    vc.delegate = self;
    
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - delete management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *s = [alertView buttonTitleAtIndex: buttonIndex];
    if ([s isEqualToString: @"Delete"]) [self trash];
}

- (void)trash
{
    [self.criteria.course removeCriterionObject: self.criteria];
    [self.criteria.managedObjectContext deleteObject: self.criteria];
    [self.criteria.managedObjectContext save: nil];
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - biinfovc methods

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if ([ip isEqual: [self.infoLayout indexPathForKey: kCriteriaTypeKey]])
    {
        [self pickCriteriaType];
    }
}

@end
