//
//  Course.h
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSManagedObject+bcString.h"

@class Criteria;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSSet *criterion;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addCriterionObject:(Criteria *)value;
- (void)removeCriterionObject:(Criteria *)value;
- (void)addCriterion:(NSSet *)values;
- (void)removeCriterion:(NSSet *)values;

@end
