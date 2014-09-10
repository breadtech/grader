//
//  BGAssignmentListViewController.h
//  breadgrader
//
//  Created by Brian Kim on 5/21/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIListViewController+CoreDataFetch.h"

@class Criteria;

@interface BGAssignmentListViewController : BIListViewController
@property (nonatomic, strong) Criteria *criteria;
@end
