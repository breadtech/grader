//
//  BGAssignmentInfoViewController.h
//  breadgrader
//
//  Created by Brian Kim on 6/5/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIInfoViewController.h"

@class Assignment;

@interface BGAssignmentInfoViewController : BIInfoViewController
@property (nonatomic, strong) Assignment *assignment;
@end
