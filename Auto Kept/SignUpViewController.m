//
//  SignUpViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/27/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//
/*
 Done:
 Added touch input controls and declared text variables in header
 TODO: 
 Recover functionality navigation. controls
 */
#import "SignUpViewController.h"
#import "QTStyle.h"
#import "SVProgressHUD.h"
#import "AKDefault.h"

@interface SignUpViewController () <UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

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
    [style textBox:(CALayer *)self.firstNameField.layer];
    [style textBox:(CALayer *)self.lastNameField.layer];
    [style textBox:(CALayer *)self.phoneNumber.layer];
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.usernameField.delegate = self;
    self.phoneNumber.delegate = self;
    self.confirmPasswordField.delegate = self;
    self.passwordField.delegate = self;

    
    
    [self.phoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [self.usernameField setKeyboardType:UIKeyboardTypeEmailAddress];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture = nil;

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
    
    NSString *number = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(self.firstNameField.text.length == 0 || self.lastNameField.text.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter First and Last Names" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
        else if(self.phoneNumber.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your Phone Number" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }else if(self.phoneNumber.text.length < 14){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid Phone Number" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];}
        else if(self.usernameField.text.length == 0 || self.passwordField.text.length == 0 || self.confirmPasswordField.text.length == 0)
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
    }else
    {
     NSString *str = [NSString stringWithFormat:@"email=%@&password=%@&password_confirmation=%@&first=%@&last=%@&phone=%@",self.usernameField.text, self.passwordField.text, self.confirmPasswordField.text, self.firstNameField.text, self.lastNameField.text, number];
    
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@users/sign_up",baseurl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    data= nil;
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSLog(@"%@", response);
         if(error == nil)
         {
             NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSRange range = [string rangeOfString:@"{"];
             if(range.length > 0)
             {
                 NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"== success = %d ", [result[@"success"] intValue]);
                 NSLog(@"== message = %@ ", result[@"message"]);
                 if([result[@"success"] intValue] == 1)
                 {
                    [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"username"];
                     [[NSUserDefaults standardUserDefaults] setObject:result[@"guid"] forKey:@"user_guid"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     NSLog(@"%@", [result description]);
                     
                     
                     
                     
                     [self userPath];
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
             [SVProgressHUD dismiss];
         }
     }];
    }

    
}

- (void)userPath{
    NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@profile?guid=",baseurl]stringByAppendingString:strguid]];
    //NSLog(@"companyLogo:%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
     //AKDefault *defaults = [[AKDefault alloc]init];
    //[defaults setRedirectPageSettings:result];
    [[NSUserDefaults standardUserDefaults] setObject:result[@"id"] forKey:@"profile_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", result[@"id"]);
    
    if ([result[@"hide_permission_page"] boolValue]){
     [self performSegueWithIdentifier:@"signUpToTutorialSegue" sender:nil];
     [SVProgressHUD dismiss];

     

    }else{
        [self performSegueWithIdentifier:@"agreePage" sender:nil];
        [SVProgressHUD dismiss];
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == self.firstNameField){
        [textField resignFirstResponder];
        [self.lastNameField becomeFirstResponder];
    }else if(textField == self.lastNameField){
        [textField resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    }else if(textField == self.usernameField){
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
#pragma mark - UItextField Text

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == self.phoneNumber){
        int length = [self getLength:textField.text];
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}


#pragma mark - phonestuff
-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)mobileNumber.length;
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)mobileNumber.length;
    
    return length;
    
    
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
