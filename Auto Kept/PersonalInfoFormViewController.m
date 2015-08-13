//
//  PersonalInfoFormViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/28/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "PersonalInfoFormViewController.h"
#import "SVProgressHUD.h"
#import "QTStyle.h"

@interface PersonalInfoFormViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailField;
@property (weak, nonatomic) IBOutlet UITextField *firstField;
@property (weak, nonatomic) IBOutlet UITextField *lastField;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *confirmScroll;


@end

@implementation PersonalInfoFormViewController

@synthesize profileId;
@synthesize guid;

- (void)viewDidLoad {
    [super viewDidLoad];

    QTStyle *style = [[QTStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [style textBox:(CALayer *) self.emailField.layer];
    [style textBox:(CALayer *) self.passwordField.layer];
    [style textBox:(CALayer *) self.confirmEmailField.layer];
    [style textBox:(CALayer *) self.firstField.layer];
    [style textBox:(CALayer *) self.lastField.layer];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.confirmEmailField.delegate = self;
    self.firstField.delegate = self;
    self.lastField.delegate = self;
    
 
    [style whiteBorder:(CALayer *) self.updateBtn.layer];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture = nil;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"])
    {
        self.guid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"profile_id"])
    {
        self.profileId = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_id"];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleTap:(id)sender
{
    [self.view endEditing:TRUE];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == self.emailField){
        [textField resignFirstResponder];
        [self.confirmEmailField becomeFirstResponder];
    }else if(textField == self.confirmEmailField){
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }else if(textField == self.firstField){
        [textField resignFirstResponder];
        [self.lastField becomeFirstResponder];
        
    }else if(textField == self.lastField){
        [textField resignFirstResponder];
        [self.emailField becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)EmailEditstarted:(id)sender {
    [self.confirmScroll setContentOffset:CGPointMake(0, 120) animated:YES];
    
}
- (IBAction)Confirmpassfinished:(id)sender{
    CGPoint point = self.view.frame.origin;
    CGPoint scrollPoint = CGPointMake(0, point.y);
    [self.confirmScroll setContentOffset:scrollPoint animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)UpdateClicked:(id)sender {
    
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirmEmail = [self.confirmEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *first= [self.firstField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *last = [self.lastField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(email.length == 0 || password.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter email and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    
    else if( ![email isEqualToString:confirmEmail])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email mismatch" message:@"The email you have entered does not match the second please double check your email" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }else if(first.length == 0 || last.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter first and last names" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        NSDictionary *dictionary = @{ @"user":@{ @"email": email, @"password": password, @"password_confirmation": password,
                     @"profile_attributes":
                           @{ @"id": self.profileId, @"first": first, @"last": last, @"show_personal_info_form": @0 }}};
        
        NSData *params = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@user/update?guid=",baseurl] stringByAppendingString:self.guid]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"PATCH"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:params];
        
        NSLog(@"%@", params);
        params= nil;
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
                     NSLog(@"%@", result);
                     
                     if([result[@"success"] intValue] == 1)
                     {
                         [self performSegueWithIdentifier:@"AccessViewSegue" sender:nil];
                         [SVProgressHUD dismiss];
                     }
                     else{
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

@end
