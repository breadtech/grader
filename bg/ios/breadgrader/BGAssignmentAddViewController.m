//
//  BGAssignmentAddViewController.m
//  breadgrader
//
//  Created by Brian Kim on 10/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGAssignmentAddViewController.h"

@interface BGAssignmentAddViewController ()

@end

@implementation BGAssignmentAddViewController

- (void)setupUI
{
    [super setupUI];
    
    self.title = @"Add Assignment";
    self.tl = self.closeButton;
    self.bl = self.br = self.noButton;
}

@end
