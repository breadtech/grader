//
//  BGCriteriaInfoViewController.h
//  breadgrader
//
//  Created by Brian Kim on 6/4/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BIInfoViewController.h"

@class Criteria;

@interface BGCriteriaInfoViewController : BIInfoViewController

@property (nonatomic, strong) Criteria *criteria;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *weight;

@end
