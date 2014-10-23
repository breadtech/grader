//
//  NSManagedObject+bcString.h
//  breadgrader
//
//  Created by Brian Kim on 7/11/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (bcString)
- (NSString *)bcString;
- (NSString *)bcStringWithIndex:(int)i;
- (NSString *)bcStringWithIndex:(int)i indentationLevel:(int)i;

// - (id)initWithBcString:(NSString *)bcString inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
