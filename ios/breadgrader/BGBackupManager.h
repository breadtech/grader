//
//  BGBackupManager.h
//  breadgrader
//
//  Created by Brian Kim on 8/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGBackupManagerDelegate

- (void)backupManagerDidSucceedBackupFetch:(NSArray *)backups;
- (void)backupManagerDidFailBackupFetch:(NSError *)error;

- (void)backupManagerDidSucceedToAddBackup;
- (void)backupManagerDidFailToAddBackup:(NSError *)error;

- (void)backupManagerDidSucceedToDeleteBackup;
- (void)backupManagerDidFailToDeleteBackup:(NSError *)error;

- (void)backupManagerDidSucceedRestore;
- (void)backupManagerDidFailRestore:(NSError *)error;

- (void)backupManagerDidSucceedLink;

@end

@interface BGBackupManager : NSObject

@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSArray *backups;

@property (nonatomic) BOOL isLinked;

@property (nonatomic, weak) id<BGBackupManagerDelegate> delegate;

- (void)addBackup;
- (void)deleteBackupAtIndex:(int)i;
- (void)fetchBackups;
- (void)restoreWithBackupAtIndex:(int)i;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)linkToViewController:(UIViewController *)vc;
- (void)unlink;

+ (BGBackupManager *)sharedManager;

@end
