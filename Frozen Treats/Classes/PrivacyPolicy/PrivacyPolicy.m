//
//  PrivacyPolicy.m
//  PetsPack
//
//  Created by AnaMac on 9/24/13.
//  Copyright (c) 2013 Newrosoft. All rights reserved.
//

#import "PrivacyPolicy.h"

@implementation PrivacyPolicy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"privacy" ofType:@"txt"];
    
    NSString  * htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"www.google.com"]];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
