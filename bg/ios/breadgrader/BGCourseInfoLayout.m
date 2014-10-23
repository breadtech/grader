//
//  BGCourseInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/7/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCourseInfoLayout.h"

@implementation BGCourseInfoLayout
@synthesize layoutKeys = _layoutKeys;
@synthesize layoutDictionary = _layoutDictionary;

- (NSArray *)layoutKeys
{
    if (!_layoutKeys)
    {
       _layoutKeys = @[ kCourseTitleKey, kCourseSubjectKey];
    }
    return _layoutKeys;
}

- (NSDictionary *)layoutDictionary
{
    if (!_layoutDictionary)
    {
        _layoutDictionary = @{
        kCourseTitleKey : [BIInfoLayout layoutInfoForType: InfoTypeFill
                                   andKeyboardInfo:
                [BIInfoLayout keyboardInfoWithPlaceholderText: @"Course Title"
                                                 keyboardType: UIKeyboardTypeDefault
                                       autocapitalizationType: UITextAutocapitalizationTypeWords
                 autocorrectionType: UITextAutocorrectionTypeNo]],
        kCourseSubjectKey : [BIInfoLayout layoutInfoForType: InfoTypePicker]
                              };
    }
    return _layoutDictionary;
}

+ (BIInfoLayout *)defaultLayout
{
    BGCourseInfoLayout *layout = [[BGCourseInfoLayout alloc] init];
    return layout;
}

@end
