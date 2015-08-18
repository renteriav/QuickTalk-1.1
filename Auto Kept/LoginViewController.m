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
#import "OproAPIClient.h"
#import "SVProgressHUD.h"
#import "QTStyle.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>
#import "HTAutocompleteManager.h"
#import "HTAutocompleteTextField.h"

@interface LoginViewController () <UITextFieldDelegate,UIScrollViewDelegate>
- (void)authenticate;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextfield;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextfield;
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
        self.usernameTextfield.text = [[NSUserDefaults standardUserDefaults]
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
#pragma Set the styles using QTStyle Helper

    QTStyle *style = [[QTStyle alloc]init];
    
    // borders
    
    [style whiteBorder:(CALayer*)self.loginButton.layer];
    [style textBox:(CALayer*)self.usernameTextfield.layer];
    [style textBox:(CALayer*)self.passwordTextfield.layer];
    
    [self.usernameTextfield setKeyboardType:UIKeyboardTypeEmailAddress];
    self.passwordTextfield.secureTextEntry = YES;
    self.usernameTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    // Hide Navigation
    
    self.navigationController.navigationBarHidden = TRUE;
    
    // Do any additional setup after loading the view.
   
    if(TARGET_IPHONE_SIMULATOR)
    {
        
        self.usernameTextfield.text = @"";
        self.passwordTextfield.text = @"";


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
    self.usernameTextfield = nil;
    self.passwordTextfield = nil;
}


-(void)handleTap:(id)sender
{
    [self.view endEditing:TRUE];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.usernameTextfield){
        [textField resignFirstResponder];
        [self.passwordTextfield becomeFirstResponder];
    }else if(textField == self.passwordTextfield){
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
    [SVProgressHUD show];
    
    [self authenticate];
    
}

#pragma mark - Private

- (void)authenticate
{
    NSLog(@"== Authenticating username and password from server");
    
    NSString *username = [[self usernameTextfield] text];
    NSString *password = [[self passwordTextfield] text];
    
    [[OproAPIClient sharedClient] authenticateUsingOAuthWithUsername:username
                                                            password:password
                                                             success:^(NSString *accessToken, NSString *refreshToken, NSString *expiresIn) {
                                                                 NSLog(@"== Access Token: %@ Expires in: %@", accessToken, expiresIn);
                                                                 
                                                                 [[self delegate] LoginViewControllerDidAuthenticate:self];
                                                                 [self performSegueWithIdentifier:@"loginToQbAuthorize" sender:self];
                                                                 [SVProgressHUD dismiss];
                                                             } failure:^(NSError *error) {
                                                                 [SVProgressHUD dismiss];
                                                                 NSLog(@"== Auth failure: %@", [error localizedDescription]);
                                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Sorry"
                                                                                                                message: [error localizedDescription]
                                                                                                               delegate: self
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles: nil];
                                                                 
                                                                 [alert show];
                                                             }];
}

@end
