//
//  BGCourseListViewController.h
//  breadgrader
//
//  Created by Brian Kim on 3/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIListViewController.h"

#import "BIListViewController+CoreDataFetch.h"

@class  BGGradeInfo;

@interface BGCourseListViewController : BIListViewController

@property (nonatomic) BOOL wantsActive;

@property (nonatomic, strong) BGGradeInfo *average;

@end
