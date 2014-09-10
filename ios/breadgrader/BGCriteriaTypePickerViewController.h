//
//  BGCriteriaTypeTableViewController.h
//  breadgrader
//
//  Created by Brian Kim on 6/4/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  BGCriteriaTypePickerViewController;

@protocol BGCriteriaTypeTableViewControllerDelegate
- (void)vc:(BGCriteriaTypePickerViewController *)vc didChooseType:(NSString *)type;
@end

@interface BGCriteriaTypePickerViewController : BITableViewController
@property (nonatomic, weak) id<BGCriteriaTypeTableViewControllerDelegate> delegate;
@end
