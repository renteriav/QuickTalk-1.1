//
//  LoginViewController.m
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//
// Edited by Nicholas Bellisario on 04/27/15
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "AKStyle.h"
#import <QuartzCore/QuartzCore.h>
#import "AgreeToAccessViewController.h"
#import <sys/utsname.h>
#import "HTAutocompleteManager.h"
#import "HTAutocompleteTextField.h"

@interface LoginViewController () <UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UITextField *txtemail;
@property (nonatomic, weak) IBOutlet UITextField *txtpasswd;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *RecoverButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ourScroll;
@property (nonatomic, assign) bool didSlide;
@property (nonatomic, assign) bool oldPhone;
@property bool login;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.didSlide = false;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"])
    {
        
        HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
        homeView.login = NO;
        [self.navigationController pushViewController:homeView animated:NO];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"])
    {
        self.txtemail.text = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"username"];
    }

    NSString *deviceType;
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //NSLog([NSString stringWithFormat:@"%@",deviceType]);
    if ([deviceType isEqualToString:@"iPhone4,1"] || TARGET_IPHONE_SIMULATOR){
        self.oldPhone = true;
    }else{
    self.oldPhone = false;
    }
#pragma Set the styles using AKStyle Helper
    
    
    // gradient background
    AKStyle *style = [[AKStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // borders
    
    [style whiteBorder:(CALayer*)self.loginButton.layer];
    [style textBox:(CALayer*)self.txtemail.layer];
    [style textBox:(CALayer*)self.txtpasswd.layer];
    
    [self.txtemail setKeyboardType:UIKeyboardTypeEmailAddress];
    self.txtpasswd.secureTextEntry = YES;
    self.txtemail.delegate = self;
    self.txtpasswd.delegate = self;
    // Hide Navigation
    
    self.navigationController.navigationBarHidden = TRUE;
    
    // Do any additional setup after loading the view.
   
    if(TARGET_IPHONE_SIMULATOR)
    {
        
        self.txtemail.text = @"";
        self.txtpasswd.text = @"";


    }
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture = nil;
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    self.txtemail = nil;
    self.txtpasswd = nil;
}


-(void)handleTap:(id)sender
{
    [self.view endEditing:TRUE];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.txtemail){
        [textField resignFirstResponder];
        [self.txtpasswd becomeFirstResponder];
    }else if(textField == self.txtpasswd){
        [textField resignFirstResponder];
        [self SignInClicked:self];
        
    }
    
    return YES;
}

-(void)viewSlide{
    if (self.oldPhone) {
    if(self.didSlide){
        [self.ourScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        self.didSlide = false;
    }else{
        [self.ourScroll setContentOffset:CGPointMake(0, 80) animated:YES];
        self.didSlide = true;
    }
    }

}

#pragma mark - Button Events

- (IBAction)RecoverPasswordClicked:(id)sender {
    //Open Safari to Recover password link
    //Testing URL CHANGE BEFORE PUSH TO UPDATE!
    NSURL *recoverURL =  [NSURL URLWithString:@"http://autokept.herokuapp.com/users/password/new"];
    [[UIApplication sharedApplication] openURL:recoverURL];
    
}
- (IBAction)Usernamefieldedit:(id)sender {
    [self viewSlide];
}
- (IBAction)UsernameFieldendEdit:(id)sender {
    [self viewSlide];
}
- (IBAction)PasswordFieldEdit:(id)sender {
    [self viewSlide];
}
- (IBAction)PasswordFieldEditEnded:(id)sender {
    [self viewSlide];
}

- (IBAction)SignUpClicked:(id)sender {
    //  not used yet

}


-(IBAction) SignInClicked:(id)sender
{
    
    self.txtemail.text = [self.txtemail.text lowercaseString];
    self.txtemail.text = [self.txtemail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.txtpasswd.text = [self.txtpasswd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if(self.txtemail.text.length == 0 || self.txtpasswd.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter Email and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }


    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@",self.txtemail.text,self.txtpasswd.text];

    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@users/log_in",baseurl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    data= nil;
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if(error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            if(range.length > 0)
            {
                NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"== success = %d ", [result[@"success"] intValue]);
                if([result[@"success"] intValue] == 1)
                {   
                    [[NSUserDefaults standardUserDefaults] setObject:self.txtemail.text forKey:@"username"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:result[@"guid"] forKey:@"user_guid"];
                    
                   //functions to get the api to show the right page
                    
                    NSLog(@"%@",[result description]);
                    AKDefault *defaults = [[AKDefault alloc]init];
                    
                    [defaults setRedirectPageSettings:result];
                    [defaults getRedirectPageSettings];
                    
                    
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    //Debuging only
                    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
                    
                    //Now we use the methods from AKDefult class to perform segues

                    if (defaults.showPersonalInfoForm == 1) {
                        [self performSegueWithIdentifier:@"SeguetoPersonalInfo" sender:nil];
                        [SVProgressHUD dismiss];
                    }
                    else if (defaults.hidePermissionPage == 1)
                    {
                        if(defaults.hideTutorialPage == 1)
                         {
                         
                             HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
                             self.login = YES;
                             homeView.login = self.login;
                             [self.navigationController pushViewController:homeView animated:YES];
                             
                             [SVProgressHUD dismiss];
                             NSLog(@"Home page view accessed");
                         }
                         else{
                             SliderViewController *tutorialPage = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialPage"];
                             [self.navigationController pushViewController:tutorialPage animated:YES];
                             [SVProgressHUD dismiss];
                             NSLog(@"Silder View Accessed");
                         }
                    }
                    else
                    {
                        AgreeToAccessViewController *accessPage = [self.storyboard instantiateViewControllerWithIdentifier:@"accessPage"];
                    [self.navigationController pushViewController:accessPage animated:YES];
                    [SVProgressHUD dismiss];
                        
                    }
                }

                else
                {
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"Something went wrong!"];
            }
           
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"We can't connect to the server. Please try later."];
            NSLog(@"Nothing Done");
        }
    }];
  
}

@end
