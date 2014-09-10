//
//  BGSupportInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGSupportInfoLayout.h"

@implementation BGSupportInfoLayout

+ (BIInfoLayout *)defaultLayout
{
    BIInfoLayout *layout = [[BGSupportInfoLayout alloc] init];
    layout.layoutKeys = @[ @[ HELP_GUIDE_KEY, REQUEST_HELP_KEY ], @[ SEND_FEEDBACK_KEY, REVIEW_KEY, SHARE_KEY ]];
    layout.layoutDictionary =
    @{
        HELP_GUIDE_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                            andCellStyle: UITableViewCellStyleDefault],
        VISIT_FORUMS_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                              andCellStyle: UITableViewCellStyleDefault],
        REQUEST_HELP_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                              andCellStyle: UITableViewCellStyleDefault],
        SHARE_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                       andCellStyle: UITableViewCellStyleDefault],
        REVIEW_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                        andCellStyle: UITableViewCellStyleDefault],
        SEND_FEEDBACK_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker
                                               andCellStyle: UITableViewCellStyleDefault]
    };
    return layout;
}

@end
