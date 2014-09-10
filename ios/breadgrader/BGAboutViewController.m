//
//  BGAboutViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAboutViewController.h"
#import "BGAboutInfoLayout.h"
#import "BIWebViewController.h"

@interface BGAboutViewController ()

@end

@implementation BGAboutViewController
@synthesize infoLayout = _infoLayout;

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGAboutInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if (![ip isEqual: [self.infoLayout indexPathForKey: VERSION_KEY]])
        [self performSegueWithIdentifier: @"webview segue" sender: ip];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"webview segue"])
    {
        BIWebViewController *vc = segue.destinationViewController;
        if ([sender isEqual: [self.infoLayout indexPathForKey: LEGAL_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/legal", breadgradersite]];
        }
        else if ([sender isEqual: [self.infoLayout indexPathForKey: OPEN_SOURCE_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/licenses", breadgradersite]];
        }
        else if ([sender isEqual: [self.infoLayout indexPathForKey: PRIVACY_POLICY_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/privacy", breadgradersite]];
        } 
        else if ([sender isEqual: [self.infoLayout indexPathForKey: TERMS_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/terms", breadgradersite]];
        }
        else if ([sender isEqual: [self.infoLayout indexPathForKey: VERSION_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/version", breadgradersite]];
        }
        vc.title = self.infoLayout.layoutKeys[[sender row]];
    }
}

- (void)setupUI
{
    self.tl = self.backButton;
    self.tr = self.bl = self.br = self.noButton;
    
    BIInfoCell *versionCell = (BIInfoCell *)[self.tableView cellForRowAtIndexPath: [self.infoLayout indexPathForKey: VERSION_KEY]];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionCell.detailTextLabel.text = version;
    versionCell.accessoryType = UITableViewCellAccessoryNone;
    versionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [super setupUI];
}

@end
