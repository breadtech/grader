//
//  BGSupportWebViewViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/10/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation UIWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSURLRequest *request = [NSURLRequest requestWithURL: self.url];
    [self.webView loadRequest: request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
