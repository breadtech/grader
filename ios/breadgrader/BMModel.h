//
//  BMModel.h
//  breadgrader
//
//  Created by Brian Kim on 1/3/14.
//  Copyright (c) 2014 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMModel : NSObject

- (instancetype)initWithNSObject:(NSManagedObject *)obj;
- (instancetype)initWithManagedObject:(NSManagedObject *)managedObj;
- (instancetype)initWithJSONData:(NSData *)jsonData;

/** not yet implemented
 - (instancetype)initWithBcString:(NSString *)bcString;
**/

@property (nonatomic, readonly) Class modelClass;
@property (nonatomic, readonly) NSObject *obj;
@property (nonatomic, readonly) NSData *jsonData;
- (NSManagedObject *)managedObjWithEntityName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
