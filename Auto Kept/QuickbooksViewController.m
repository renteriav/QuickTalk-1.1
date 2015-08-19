//
//  QuickbooksViewController.m
//  QuickTalk
//
//  Created by Francisco Renteria on 8/4/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "QuickbooksViewController.h"
#import "LoginViewController.h"

@interface QuickbooksViewController ()<UIWebViewDelegate, LoginViewControllerDelegate>

@end

@implementation QuickbooksViewController

@synthesize QuickbooksWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@",baseurl, accessToken]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [QuickbooksWebView loadRequest:requestObj];
    QuickbooksWebView.delegate = self;
    [self QuickbooksWebView].scalesPageToFit = YES;
    
}

#pragma mark - OproDemoViewControllerDelegate;

////////////////////////////////////////////////////////////////////////
- (void)LoginViewControllerDidAuthenticate:(LoginViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self getCurrentUser];
}

- (void)viewDidLayoutSubviews {
    QuickbooksWebView.frame = self.view.bounds;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"inapp"]) {
        if ([request.URL.host isEqualToString:@"capture"]) {
                       
            [self performSegueWithIdentifier:@"AuthToTutorial" sender:nil];
            
        }
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
