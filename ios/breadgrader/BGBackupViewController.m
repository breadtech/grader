//
//  BGBackupViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/11/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGBackupViewController.h"
#import "UIBarButtonItem+borderlessButtons.h"

#import "BGBackupManager.h"
#import "BGBackup.h"

@interface BGBackupViewController () < UIActionSheetDelegate, BGBackupManagerDelegate>
{
    BOOL isLoggedIn;
}

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) UIBarButtonItem *dropboxButton;
@property (nonatomic, strong) UIBarButtonItem *restoreButton;

@property (nonatomic, strong) UIActionSheet *dropboxActionSheet;

@property (nonatomic, weak) BGBackupManager *backupManager;

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation BGBackupViewController

#pragma mark - accessor methods

- (BGBackupManager *)backupManager
{
    return [BGBackupManager sharedManager];
}

- (UIBarButtonItem *)dropboxButton
{
    if (!_dropboxButton)
    {
        _dropboxButton = [UIBarButtonItem barItemWithImage: [UIImage imageNamed: @"dropbox.icon.png"]
                                                    target: self
                                                    action: @selector( showDropboxMenu)];
    }
    return _dropboxButton;
}

- (UIActionSheet *)dropboxActionSheet
{
    if (!_dropboxActionSheet)
    {
        _dropboxActionSheet= [[UIActionSheet alloc] initWithTitle: @"Dropbox"
                                                         delegate: self
                                                cancelButtonTitle: @"Cancel"
                                           destructiveButtonTitle: @"Unlink"
                                                otherButtonTitles: @"Refresh", nil];
    }
    return _dropboxActionSheet;
}

- (NSDateFormatter *)formatter
{
    if (!_formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.timeStyle = NSDateFormatterShortStyle;
        _formatter.dateStyle = NSDateFormatterShortStyle;
    }
    return _formatter;
}

- (UIBarButtonItem *)refreshButton
{
    return [UIBarButtonItem barButtonItemWithUnicode: [UnicodeDictionary dictionary][@"refresh"]
                                              target: self action: @selector( getBackups)];
}

- (UIBarButtonItem *)busyButton
{
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [v startAnimating];
    return [[UIBarButtonItem alloc] initWithCustomView: v];
}

- (UIBarButtonItem *)restoreButton
{
    return self.bottomMiddleButton;
    /*
    if (!_restoreButton)
    {
        _restoreButton = [[UIBarButtonItem alloc] initWithTitle: @"Unlinked"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector( confirmRestoreBackup)];
    }
    return _restoreButton;
     */
}
#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.backupManager.isLinked)
    {
        return self.backupManager.backups.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"acell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)ip
{
    if (self.backupManager.isLinked)
    {
        BGBackup *backup = self.backupManager.backups[ip.row];
        
        self.formatter.timeStyle = NSDateFormatterNoStyle;
        self.formatter.dateStyle = NSDateFormatterShortStyle;
        cell.textLabel.text = [self.formatter stringFromDate: backup.backupDate];
        
        self.formatter.timeStyle = NSDateFormatterMediumStyle;
        self.formatter.dateStyle = NSDateFormatterNoStyle;
        cell.detailTextLabel.text = [self.formatter stringFromDate: backup.backupDate];
    }
    else
    {
        cell.textLabel.text = @"Link to Dropbox";
        cell.detailTextLabel.text = @"";
    }
}

#pragma mark - convenience methods

- (void)showDropboxMenu
{
    if (self.backupManager.isLinked)
    {
        self.dropboxActionSheet.title = [NSString stringWithFormat: @"Logged into Dropbox as: %@", self.backupManager.currentUsername];
        [self.dropboxActionSheet showInView: self.navigationController.toolbar];
    } else
    {
        [self.backupManager linkToViewController: self];
    }
}

- (void)updateUI
{
    [super updateUI];
    
    if (self.backupManager.isLinked)
    {
        self.addButton.enabled = YES;
    } else
    {
        self.addButton.enabled = NO;
        self.restoreButton.title = @"Unlinked";
    }
    self.deleteButton.enabled = NO;
}

- (void)setupUI
{
    self.title = @"course list backups";
    
    self.tl = self.backButton;
    self.tr = self.dropboxButton;
    self.bl = self.deleteButton;
    self.wantBottomMiddleButton = YES;
    self.br = self.addButton;
    
    [super setupUI];
}

- (void)setupModel
{
    [[BGBackupManager sharedManager] setDelegate: self];
    [self getBackups];
}

- (void)addButtonPressed:(id)sender
{
    self.restoreButton.title = @"Backing up...";
    self.addButton.enabled = NO;
    
    [self.backupManager addBackup];
}

- (void)getBackups
{
    if (self.backupManager.isLinked)
    {
        self.tl = [self busyButton];
        self.restoreButton.title = @"Fetching backups...";
        [self.backupManager fetchBackups];
    }
}

- (void)bottomMiddleButtonPessed:(id)sender
{
    [self confirmRestoreBackup];
}

- (void)confirmRestoreBackup
{
    
    if (self.backupManager.isLinked && [self.tableView indexPathForSelectedRow] && [self.restoreButton.title isEqual: @"Restore"])
    {
#pragma mark - ONLY FOR VERSION 0.9 RELEASE
        
        /*
        [[[UIAlertView alloc] initWithTitle: @"Under construction"
                                    message: @"Data restoration is our last feature to implement for breadgrader's 1.0 release. We apologize for the inconvenience..."
                                   delegate: nil
                          cancelButtonTitle: @"Wait for 1.0" otherButtonTitles: nil] show];
        return;
         */
#pragma mark - STOP BEING SO LAZY
        
        [[[UIAlertView alloc] initWithTitle: @"WARNING"
                                    message: @"Restoration will delete all grader data currently on this device. Are you sure you wish to continue?"
                                   delegate: self
         
                          cancelButtonTitle: @"Cancel" otherButtonTitles: @"Restore", nil] show];
    } else if (!self.backupManager.isLinked)
    {
        [self.backupManager linkToViewController: self];
    }
}

- (void)restore
{
    self.restoreButton.title = @"Restoring...";
    
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    [self.backupManager restoreWithBackupAtIndex: ip.row];
}

#pragma mark - delegate callbacks

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.dropboxActionSheet)
    {
        NSString *btitle = [actionSheet buttonTitleAtIndex: buttonIndex];
        if ([btitle isEqualToString: @"Unlink"])
        {
            [self.backupManager unlink];
            [self updateUI];
        } else if ([btitle isEqualToString: @"Refresh"])
        {
            [self getBackups];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString: @"Confirm Delete"])
    {
        if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Delete"])
        {
            if (!self.backupManager.isLinked || ![self.tableView indexPathForSelectedRow])
            {
                [[[UIAlertView alloc] initWithTitle: @"Nothing to Delete"
                                            message: @"Make sure you have selected a backup or that your account is linked"
                                           delegate: nil cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil, nil] show];
            } else
            {
                self.deleteButton.enabled = NO;
                self.restoreButton.title = @"Deleting backup...";
                
                NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
                [self.backupManager deleteBackupAtIndex: ip.row];
            }
        }
    } else if ([alertView.title isEqualToString: @"WARNING"])
    {
        BOOL go = [[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Restore"];
        if (go)
        {
            [self restore];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.backupManager.isLinked)
    {
        self.deleteButton.enabled = YES;
        self.restoreButton.title = @"Restore";
    }
    else
    {
        [self.backupManager linkToViewController: self];
    }
}

#pragma mark - DBRestClient delegate methods

- (void)backupManagerDidSucceedBackupFetch:(NSArray *)backups
{
    [self updateUI];
    
    self.tl = self.backButton;
    self.restoreButton.title = @"Select a backup";
}

- (void)backupManagerDidFailBackupFetch:(NSError *)error
{
    NSString *msg;
    if (error.code == -1009)
    {
        msg = @"You are currently not connected to the Internet";
    }
    else msg = error.description;
    [[[UIAlertView alloc] initWithTitle: @"Failed to communicate with Dropbox"
                                message: msg
                               delegate: nil cancelButtonTitle: @"OK"
                      otherButtonTitles: nil] show];
}

- (void)backupManagerDidSucceedToAddBackup
{
    self.restoreButton.title = @"Backup successful!";
    [self performSelector: @selector( getBackups) withObject: nil afterDelay: 1.0f];
}

- (void)backupManagerDidFailToAddBackup:(NSError *)error
{
    self.restoreButton.title = @"Error backing up";
    [self updateUI];
}

- (void)backupManagerDidSucceedToDeleteBackup
{
    self.restoreButton.title = @"Delete successful";
    
    [self performSelector: @selector( getBackups) withObject: nil afterDelay: 1.0f];
}

- (void)backupManagerDidFailToDeleteBackup:(NSError *)error
{
    self.restoreButton.title = @"Error deleting backup";
    [self updateUI];
}

- (void)backupManagerDidSucceedRestore
{
    
}

- (void)backupManagerDidFailRestore:(NSError *)error
{
    
}

- (void)backupManagerDidSucceedLink
{
    [self getBackups];
}

 @end
