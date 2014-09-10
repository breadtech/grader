//
//  BGCriteriaListViewController.h
//  breadgrader
//
//  Created by Brian Kim on 3/22/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIListViewController+CoreDataFetch.h"

@class Course;

@interface BGCriteriaListViewController : BIListViewController

@property (nonatomic, strong) Course *course;

@end
