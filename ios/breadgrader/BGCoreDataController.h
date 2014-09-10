//
//  BGCoreDataController.h
//  breadgrader
//
//  Created by Brian Kim on 11/21/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMModel.h"

@class BGModel;

@interface BGCoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)addModel:(BMModel *)model;
- (void)save;
// - (void)deleteChildModel:(BMModel *)model;
// - (void)saveToFilename:(NSURL *)path; // for now, nil can be safely passed to the path variable.
                                      // TODO: add code to choose the filename

+ (BGCoreDataController *)sharedController;

// if there are unsaved changes on the masterController
//   these methods will open up a UIAlertView asking if the user wants to save the current model
// + (BGCoreDataController *)loadModelFromFilename:(NSURL *)path;

@end
