//
//  SignUpViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/27/15.
//  Copyright (c) 2015 AutoKept. All rights reserved.
//

#import "SignUpViewController.h"
#import "QTStyle.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AKDefault.h"
#import "OproAPIClient.h"

@interface SignUpViewController () <UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;
@property (nonatomic, assign) bool slideComp;
@end




@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    QTStyle *style = [[QTStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    self.slideComp = false;
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    [style whiteBorder:(CALayer *)self.signUpButton.layer];
    [style textBox:(CALayer *)self.usernameField.layer];
    [style textBox:(CALayer *)self.passwordField.layer];
    [style textBox:(CALayer *)self.confirmPasswordField.layer];
    
    self.usernameField.delegate = self;
    self.confirmPasswordField.delegate = self;
    self.passwordField.delegate = self;

    [self.usernameField setKeyboardType:UIKeyboardTypeEmailAddress];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture = nil;

}

- (IBAction)returnToRoot:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)Editstarted:(id)sender {
    [self slideup];
}


- (IBAction)passfinished:(id)sender{
    [self slideup];
    }

- (void)slideup{
    if(self.slideComp){
    CGPoint point = self.view.frame.origin;
    CGPoint scrollPoint = CGPointMake(0, point.y);
    [self.editScrollView setContentOffset:scrollPoint animated:YES];
        self.slideComp = false;
    }else{
        [self.editScrollView setContentOffset:CGPointMake(0, 120) animated:YES];
        self.slideComp = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpClicked:(id)sender {
    
    self.usernameField.text = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.passwordField.text = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.confirmPasswordField.text = [self.confirmPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(self.usernameField.text.length == 0 || self.passwordField.text.length == 0 || self.confirmPasswordField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter Email and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }  else if( ![self.passwordField.text isEqualToString:self.confirmPasswordField.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Mismatch" message:@"The password you have entered does not match the second please double check your password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    } else if ( self.passwordField.text.length < 4 || self.confirmPasswordField.text.length < 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password To Short" message:@"The password you have entered needs to be a minimum of 4 characters" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@users/sign_up",baseurl];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{ @"email": self.usernameField.text,
                                      @"password": self.passwordField.text,
                                      @"password_confirmation": self.confirmPasswordField.text
                                     };
        [SVProgressHUD show];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([responseObject[@"success"] intValue] == 1){
                [SVProgressHUD dismiss];
                NSLog(@"Success");
                
                NSString *username = [[self usernameField] text];
                NSString *password = [[self passwordField] text];
                [[OproAPIClient sharedClient] authenticateUsingOAuthWithUsername:username
                                                                        password:password
                                                                         success:^(NSString *accessToken, NSString *refreshToken, NSString *expiresIn) {
                                                                             NSLog(@"== Access Token: %@ Expires in: %@", accessToken, expiresIn);
                                                                             
                                                                             [[self delegate] LoginViewControllerDidAuthenticate:self];
                                                                             [self performSegueWithIdentifier:@"signUpToQbAuthorize" sender:self];
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
                

            }else{
               [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"Something went wrong!"];
        }];
    }
    
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == self.usernameField){
        [self.usernameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
        
    }else if(textField == self.passwordField){
        [self.passwordField resignFirstResponder];
        [self.confirmPasswordField becomeFirstResponder];
    }else if(textField == self.confirmPasswordField){
        [self.confirmPasswordField resignFirstResponder];
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)handleTap:(id)sender
{
    [self.view endEditing:TRUE];
}


@end
