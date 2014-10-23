//
//  BGAboutInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAboutInfoLayout.h"

@implementation BGAboutInfoLayout

+ (BIInfoLayout *)defaultLayout
{
    BGAboutInfoLayout *layout = [[BGAboutInfoLayout alloc] init];
    layout.layoutKeys = @[
        LEGAL_KEY, OPEN_SOURCE_KEY, PRIVACY_POLICY_KEY, TERMS_KEY, VERSION_KEY
                        ];
    NSMutableDictionary *versionDict = [[BIInfoLayout layoutInfoForType: InfoTypePicker
                                                          andCellStyle: UITableViewCellStyleValue1] mutableCopy];
    
    layout.layoutDictionary = @{
                                LEGAL_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                                                      andCellStyle: UITableViewCellStyleDefault],
                                OPEN_SOURCE_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                                                             andCellStyle: UITableViewCellStyleDefault],
                                PRIVACY_POLICY_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                                                       andCellStyle: UITableViewCellStyleDefault],
                                TERMS_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                                                         andCellStyle: UITableViewCellStyleDefault],
                                VERSION_KEY : versionDict
                                };
    return layout;
}

@end
