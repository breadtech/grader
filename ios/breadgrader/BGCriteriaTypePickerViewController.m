//
//  BGCriteriaTypeTableViewController.m
//  breadgrader
//
//  Created by Brian Kim on 6/4/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCriteriaTypePickerViewController.h"

@interface BGCriteriaTypePickerViewController ()
@end

@implementation BGCriteriaTypePickerViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            return [[[BGSettingsManager sharedManager] criteriaTypes] count];
        case 1:
            return 1;
        default:
            break;
    }
    return 0;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == 0) CellIdentifier = @"typeCell";
    else CellIdentifier = @"addTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [[[BGSettingsManager sharedManager] criteriaTypes] objectAtIndex: indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self addCriteriaType];
    } else
    {
        NSMutableArray *subjects = [[[BGSettingsManager sharedManager] criteriaTypes] mutableCopy];
        [subjects removeObjectAtIndex: indexPath.row];
        [[BGSettingsManager sharedManager] setCriteriaTypes: subjects];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *subjects = [[[BGSettingsManager sharedManager] criteriaTypes] mutableCopy];
    
    NSString *old = subjects[ destinationIndexPath.row];
    subjects[ destinationIndexPath.row] = subjects[ sourceIndexPath.row];
    
    if (sourceIndexPath.row > destinationIndexPath.row)
    {
        for (int i = destinationIndexPath.row; i < sourceIndexPath.row; i++)
        {
            NSString *new = subjects[i+1];
            subjects[ i+1] = old;
            old = new;
        }
    } else
    {
        for (int i = destinationIndexPath.row; i > sourceIndexPath.row; i--)
        {
            NSString *new = subjects[i-1];
            subjects[ i-1] = old;
            old = new;
        }
    }
    [[BGSettingsManager sharedManager] setCriteriaTypes: subjects];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return NO;
    } else return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return UITableViewCellEditingStyleInsert;
    } else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *type = [[[BGSettingsManager sharedManager] criteriaTypes] objectAtIndex: indexPath.row];
        [self.delegate vc: self didChooseType: type];
    } else
    {
        [self addCriteriaType];
    }
}

#pragma mark - uivc methods

- (void)setupUI
{
    self.tl = self.backButton;
    // self.tr = self.menuButton;
    self.br = self.addButton;
    
    [super setupUI];
}

- (void)addButtonPressed:(id)sender
{
    [self addCriteriaType];
}

#pragma mark - More methods

- (void)addCriteriaType
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Type Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // Change keyboard type
    [[dialog textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeAlphabet];
    [[dialog textFieldAtIndex:0] setAutocapitalizationType: UITextAutocapitalizationTypeWords];
    [dialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *newSubject = [[alertView textFieldAtIndex:0] text];
        NSMutableArray *newArray = [[[BGSettingsManager sharedManager] criteriaTypes] mutableCopy];
        [newArray addObject: newSubject];
        
        [[BGSettingsManager sharedManager] setCriteriaTypes: newArray];
        [self.tableView reloadData];
    }
    [self.tableView deselectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] animated: YES];

}
@end
