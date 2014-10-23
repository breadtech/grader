//
//  BGSupportViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/9/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAppDelegate.h"
#import "BGSupportViewController.h"
#import "BGSupportInfoLayout.h"

#import "Appirater.h"
#import "BIWebViewController.h"

@interface BGSupportViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation BGSupportViewController
@synthesize infoLayout = _infoLayout;
@synthesize shareableItem = _shareableItem;

- (BIInfoLayout *)infoLayout
{
    if (!_infoLayout)
    {
        _infoLayout = [BGSupportInfoLayout defaultLayout];
    }
    return _infoLayout;
}

- (BIShareableItem *)shareableItem
{
    if (!_shareableItem)
    {
        _shareableItem = [[BIShareableItem alloc] initWithTitle: @"breadgrader"];
        _shareableItem.shortDescription = @"breadgrader is an app that helps manage the grades in your classes. ";
        _shareableItem.description = @"Learn more at http://breadgrader.com/";
    }
    return _shareableItem;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)wantsToPickValueForCellAtIndexPath:(NSIndexPath *)ip
{
    if ([ip isEqual: [self.infoLayout indexPathForKey: SEND_FEEDBACK_KEY]])
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
            vc.subject = @"grader feedback";
            vc.toRecipients = @[@"feedback@grader.breadtech.com"];
            [vc setMessageBody: @"" isHTML: NO];
            
            vc.mailComposeDelegate = self;
            [self presentViewController: vc animated: YES completion: nil];
        } else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                            message: @"You can't seem to send mail right now..."
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: REQUEST_HELP_KEY]])
    {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
                vc.subject = @"grader support request";
                vc.toRecipients = @[@"support@grader.breadtech.com"];
                [vc setMessageBody: @"" isHTML: NO];
                
                vc.mailComposeDelegate = self;
                [self presentViewController: vc animated: YES completion: nil];
            } else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                                message: @"You can't seem to send mail right now..."
                                                               delegate: self
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: VISIT_FORUMS_KEY]])
    {
        [self performSegueWithIdentifier: @"webview segue" sender: ip];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: HELP_GUIDE_KEY]])
    {
        [self performSegueWithIdentifier: @"help segue" sender: nil];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: DONATE_KEY]])
    {
        
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: REVIEW_KEY]])
    {
        [Appirater rateApp];
    }
    else if ([ip isEqual: [self.infoLayout indexPathForKey: SHARE_KEY]])
    {
        NSArray *items = @[
                           self.shareableItem.shortDescription,
                           self.shareableItem.description
                           ];
        if ([UIActivityViewController class])
        {
            UIActivityViewController *activityvc = [[UIActivityViewController alloc] initWithActivityItems: items applicationActivities: nil];
            [self presentViewController: activityvc animated: YES completion: nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"webview segue"])
    {
        BIWebViewController *vc = segue.destinationViewController;;
        if ([sender isEqual: [self.infoLayout indexPathForKey: VISIT_FORUMS_KEY]])
        {
            vc.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/forums", breadgradersite]];
        }
        else if ([sender isEqual: [self.infoLayout indexPathForKey: SEND_FEEDBACK_KEY]])
        {
            
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupUI
{
    
    self.tl = self.backButton;
    self.tr = self.bl = self.br = self.noButton;
    
    [super setupUI];
}

@end
