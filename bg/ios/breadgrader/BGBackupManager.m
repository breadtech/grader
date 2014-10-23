//
//  BGBackupManager.m
//  breadgrader
//
//  Created by Brian Kim on 8/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGBackupManager.h"
#import "BGBackup.h"
#import <DropboxSDK/DropboxSDK.h>
#import "BGCoreDataController.h"

#import "Course+methods.h"

#define backupPath @"/backup/"

@interface BGBackupManager() <DBNetworkRequestDelegate, DBSessionDelegate, DBRestClientDelegate>
{
    NSString *relinkUserId;
}
@property (nonatomic, strong) DBRestClient *restClient;
@end

@implementation BGBackupManager
@synthesize backups = _backups;
@synthesize restClient = _restClient;

- (NSString *)currentUsername
{
    if (!_currentUsername)
    {
        _currentUsername = @"Unknown";
    }
    return _currentUsername;
        
}

- (BOOL)isLinked
{
    return [[DBSession sharedSession] isLinked];
}

- (NSArray *)backups
{
    if (!_backups)
    {
        _backups = @[ [BGBackup backupWithDate: nil andPath: nil] ];
    }
    return _backups;
}

- (DBRestClient *)restClient {
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

#pragma mark - Public API

- (void)addBackup
{
    NSManagedObjectContext *moc = [[BGCoreDataController sharedController] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:nameSort]];
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest: fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching courses: %@", error);
    } else
    {
        NSString *doc = @"";
        for (int i = 0, n = fetchedObjects.count; i < n; i++)
        {
            Course *c = fetchedObjects[i];
            doc = [NSString stringWithFormat: @"%@%@", doc, [c bcStringWithIndex: i]];
        }
        
        NSDate *date = [NSDate date];
        NSString *fname = [NSString stringWithFormat: @"%d.bc", (int)date.timeIntervalSince1970];
        NSString *fullpath = [NSTemporaryDirectory() stringByAppendingPathComponent: fname];
        
        NSError *err;
        [doc writeToFile: fullpath atomically: YES encoding: NSStringEncodingConversionAllowLossy error: &err];
        
        [self.restClient uploadFile: fname toPath: backupPath withParentRev: nil fromPath: fullpath];
    }
}

- (void)deleteBackupAtIndex:(int)i
{
    BGBackup *fpath = self.backups[i];
    
    [self.restClient deletePath: fpath.path.absoluteString];
}

- (void)fetchBackups
{
    if ([[DBSession sharedSession] isLinked])
    {
        [self.restClient loadMetadata: backupPath];
    }
}

- (void)restoreWithBackupAtIndex:(int)i
{
    
}

- (BOOL)handleOpenURL:(NSURL *)url
{
	if ([[DBSession sharedSession] handleOpenURL:url]) {
        [self.delegate backupManagerDidSucceedLink];
        return YES;
    }
    return NO;
}

- (void)linkToViewController:(UIViewController *)vc
{
    [[DBSession sharedSession] linkFromController: vc];
}

- (void)unlink
{
    [[DBSession sharedSession] unlinkAll];
}

#pragma mark - Utility methods

- (void)restoreWithFile:(NSString *)fpath
{
    NSString *bcString = [[[NSFileManager defaultManager] contentsAtPath: fpath] description];
    NSLog( @"%@", bcString);
    
}


#pragma mark - DBRestClient delegate methods

- (void)restClient:(DBRestClient *)client loadedAccountInfo:(DBAccountInfo *)info
{
    self.currentUsername = info.displayName;
}

- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata
{
    [self.delegate backupManagerDidSucceedToAddBackup];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    [self.delegate backupManagerDidFailToAddBackup: error];
}

- (void)restClient:(DBRestClient *)client deletedPath:(NSString *)path
{
    [self.delegate backupManagerDidSucceedToDeleteBackup];
}

- (void)restClient:(DBRestClient *)client deletePathFailedWithError:(NSError *)error
{
    [self.delegate backupManagerDidFailToDeleteBackup: error];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    NSMutableArray *backups = [NSMutableArray new];
    
    for (DBMetadata *file in metadata.contents)
    {
        NSString *date_s = [[[file path] lastPathComponent] stringByDeletingPathExtension];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: date_s.floatValue];
        NSURL *path = [NSURL URLWithString: file.path];
        
        [backups addObject:[BGBackup backupWithDate: date andPath: path]];
    }
    
    self.backups = backups;
    [self.delegate backupManagerDidSucceedBackupFetch: backups];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    if (error.code == 404)
    {
        [self.restClient createFolder: @"/backup/"];
        return;
    }
    
    [self.delegate backupManagerDidFailBackupFetch: error];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    [self restoreWithFile: destPath];
}

#pragma mark - singleton instantiation

static BGBackupManager *sharedManager;

+ (BGBackupManager *)sharedManager {
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
        NSString* appKey = @"c982oe1fwm4ylz4";
        NSString* appSecret = @"bdt88ie3uujixto";
        NSString *root = kDBRootAppFolder;
        
        DBSession *session = [[DBSession alloc] initWithAppKey: appKey
                                                     appSecret: appSecret
                                                          root: root];
        session.delegate = self;
        [DBSession setSharedSession: session];
        
        [DBRequest setNetworkRequestDelegate: self];
        
        [self.restClient loadAccountInfo];
    }
    return self;
}

#pragma mark - DBSession delegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    relinkUserId = [userId copy];
	[[[UIAlertView alloc]
      initWithTitle:@"Dropbox Session Ended" message:@"Please relink" delegate: nil
      cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted
{
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}


@end
