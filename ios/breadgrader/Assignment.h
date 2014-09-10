//
//  Assignment.h
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Criteria;

@interface Assignment : NSManagedObject

@property (nonatomic, retain) NSNumber * didUpdate;
@property (nonatomic, retain) NSDate * due;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * max;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * received;
@property (nonatomic, retain) Criteria *criteria;

@end
