//
//  BGCriteriaInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/7/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGCriteriaInfoLayout.h"

@implementation BGCriteriaInfoLayout

+ (BIInfoLayout *)defaultLayout
{
    BGCriteriaInfoLayout *layout = [[BGCriteriaInfoLayout alloc] init];
    layout.layoutKeys = @[ kCriteriaTypeKey, kCriteriaWeightKey ];
    layout.layoutDictionary = @{
        kCriteriaTypeKey : [BIInfoLayout layoutInfoForType: InfoTypePicker],
        kCriteriaWeightKey : [BIInfoLayout layoutInfoForType: InfoTypeFill
                                             andKeyboardInfo:
                              [BIInfoLayout keyboardInfoWithPlaceholderText: @"weight of grade" keyboardType: UIKeyboardTypeNumberPad]]};
    return layout;
}

@end
