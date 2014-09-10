//
//  BGCourseAddViewController.m
//  breadgrader
//
//  Created by Brian Kim on 10/19/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGCourseAddViewController.h"
#import "BGCourseSubjectPickerViewController.h"

@interface BGCourseAddViewController ()

@end

@implementation BGCourseAddViewController

- (void)setupUI
{
    [super setupUI];
    
    self.bl = self.br = self.noButton;
    self.tl = self.closeButton;
    
    self.title = @"Add Course";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    CGFloat height = self.view.frame.size.height/2.0;
    CGRect frame = CGRectMake( 0, height, self.view.frame.size.width, height);
    
    BGCourseSubjectPickerViewController *picker = [[BGCourseSubjectPickerViewController alloc] init];
    
    [self addChildViewController: picker];
    picker.view.frame = frame;
    [self.view addSubview: picker.view];
    [picker didMoveToParentViewController: self];
     */
}

@end
