//
//  BGAssignmentInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/8/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAssignmentInfoLayout.h"

@implementation BGAssignmentInfoLayout
+ (BIInfoLayout *)defaultLayout
{
    BGAssignmentInfoLayout *layout = [[BGAssignmentInfoLayout alloc] init];
    layout.layoutKeys = @[ kAssignmentNameKey, kAssignmentDueDateKey, kAssignmentGradeKey, kAssignmentNotesKey ];
    layout.layoutDictionary = @{
                                kAssignmentNameKey : [BIInfoLayout layoutInfoForType: InfoTypeFill
                                                                     andKeyboardInfo: [BIInfoLayout keyboardInfoWithPlaceholderText: @"a descriptive name"]],
                                kAssignmentDueDateKey : [BIInfoLayout layoutInfoForType: InfoTypePicker],
                                kAssignmentGradeKey : [BIInfoLayout layoutInfoForType: InfoTypeFill2 andKeyboardInfo: @[[BIInfoLayout keyboardInfoWithPlaceholderText: @"received" keyboardType: UIKeyboardTypeDecimalPad] , [BIInfoLayout keyboardInfoWithPlaceholderText: @"max" keyboardType: UIKeyboardTypeDecimalPad]]],
                                kAssignmentNotesKey : [BIInfoLayout layoutInfoForType: InfoTypeTextView
                                                                      andKeyboardInfo: [BIInfoLayout defaultKeyboardInfo]]
                                };
    return layout;
}
@end
