//
//  BGSettingsInfoLayout.m
//  breadgrader
//
//  Created by Brian Kim on 7/8/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGSettingsInfoLayout.h"

@implementation BGSettingsInfoLayout


+ (BIInfoLayout *)defaultLayout
{
    BGSettingsInfoLayout *layout = [[BGSettingsInfoLayout alloc] init];
    layout.layoutKeys = @[ @[ COURSE_SUBJECTS_KEY, CRITERIA_TYPES_KEY],
                           @[ BACKUP_RESTORE_KEY],
                           @[ ABOUT_KEY, SUPPORT_KEY]];
    layout.layoutDictionary = @{
      COURSE_SUBJECTS_KEY: [BIInfoLayout layoutInfoForType: InfoTypePicker andCellStyle: UITableViewCellStyleDefault],
      CRITERIA_TYPES_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker andCellStyle: UITableViewCellStyleDefault],
      BACKUP_RESTORE_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker andCellStyle: UITableViewCellStyleDefault],
      ABOUT_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker andCellStyle: UITableViewCellStyleDefault],
      SUPPORT_KEY : [BIInfoLayout layoutInfoForType: InfoTypePicker andCellStyle: UITableViewCellStyleDefault],
      };
    return layout;
}

@end
