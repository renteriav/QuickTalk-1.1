//
//  QuickbooksViewController.m
//  QuickTalk
//
//  Created by Francisco Renteria on 8/4/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "QuickbooksViewController.h"

@interface QuickbooksViewController ()<UIWebViewDelegate>

@end

@implementation QuickbooksViewController

@synthesize QuickbooksWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = @"https://still-beyond-6524.herokuapp.com/quickbooks";
    //NSString *fullURL = @"http://localhost:3000/quickbooks";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [QuickbooksWebView loadRequest:requestObj];
    QuickbooksWebView.delegate = self;
    [self QuickbooksWebView].scalesPageToFit = YES;
    
}

- (void)viewDidLayoutSubviews {
    QuickbooksWebView.frame = self.view.bounds;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"inapp"]) {
        if ([request.URL.host isEqualToString:@"capture"]) {
            NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
            NSURL *url = [NSURL URLWithString:currentURL];
            NSString *query = url.query;
            
            NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
            NSArray *urlComponents = [query componentsSeparatedByString:@"&"];
            
            for (NSString *keyValuePair in urlComponents)
            {
                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
                NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
                
                [queryStringDictionary setObject:value forKey:key];
                
            }
            NSString *realm_id =[queryStringDictionary objectForKey:@"realm_id"];
            NSString *secret =[queryStringDictionary objectForKey:@"secret"];
            NSString *token =[queryStringDictionary objectForKey:@"token"];
            
            NSLog(@"realm_id = %@", realm_id);
            NSLog(@"secret = %@", secret);
            NSLog(@"token = %@", token);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:realm_id forKey:@"realm_id"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
