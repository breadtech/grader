//
//  BGCourseSubjectTableViewController.h
//  breadgrader
//
//  Created by Brian Kim on 6/4/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIListViewController.h"

@class  BGCourseSubjectPickerViewController;

@protocol BGCourseSubjectTableViewControllerDelegate
- (void)vc:(BGCourseSubjectPickerViewController *)vc didChooseSubject:(NSString *)subject;
@end

@interface BGCourseSubjectPickerViewController : BITableViewController
@property (nonatomic, weak) id<BGCourseSubjectTableViewControllerDelegate> delegate;
@end
