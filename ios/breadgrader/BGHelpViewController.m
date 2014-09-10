//
//  BGHelpViewController.m
//  breadgrader
//
//  Created by Brian Kim on 7/26/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "BGHelpViewController.h"

@interface BGHelpViewController ()

@end

@implementation BGHelpViewController

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
    [super setupUI];
    self.tl = self.closeButton;
    [self updateUI];
}

- (void)viewDidLoad
{
    self.url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/help", breadgradersite]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
