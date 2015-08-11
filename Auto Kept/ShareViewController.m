//
//  ShareViewController.m
//  Auto Kept
//
//  Created by Kamal Mittal on 30/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import "ShareViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "commonunit.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AKStyle.h"


@interface ShareViewController () <MFMessageComposeViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UIButton *btnshare;
@property (nonatomic, strong) IBOutlet UITextField *txtnumber;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AKStyle *style = [[AKStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [style textBox:(CALayer *) self.txtnumber.layer];
    [style whiteBorder:(CALayer *) self.btnshare.layer];
    
    // Do any additional setup after loading the view.
    [self.txtnumber setKeyboardType:UIKeyboardTypePhonePad];
    self.txtnumber.delegate = self;
    
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
    self.txtnumber = nil;
    self.btnshare = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Buttons
-(IBAction)shareapp:(id)sender
{
    
    NSString *number = [self.txtnumber.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];

    if(number.length != 10 || ![commonunit IsOnlyNumber:number])
    {
        [SVProgressHUD showErrorWithStatus:@"Please enter 10 digits number only."];
        return;
    }
    
    //https://autokept.herokuapp.com/api/v1/share?guid=243423&phone=2342343234
    
    NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSString *str = [NSString stringWithFormat:@"guid=%@&phone=%@",strguid,number];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@share?%@",baseurl,str]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             string = [string stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
             NSData *datawithoutnull = [string dataUsingEncoding:NSUTF8StringEncoding];
             
             NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:datawithoutnull options:NSJSONReadingMutableContainers error:nil];
             datawithoutnull = nil;
             NSLog(@"%@",result);
             if(result != nil &&[result[@"success"] intValue] == 1)
             {
                 [SVProgressHUD showErrorWithStatus:@"Share successful! Your friend should get a text message very soon."];
                 [self backClicked:nil];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:result[@"message"]];
             }
         });
     }];
    
}



-(IBAction)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
-(void)handleTap:(id)sender
{
    [self.view endEditing:TRUE];
}


#pragma mark - MFMessageComposeViewController
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch(result) {
        case MessageComposeResultCancelled:
            // user canceled sms
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            // user sent sms
            //perhaps put an alert here and dismiss the view on one of the alerts buttons
            break;
        case MessageComposeResultFailed:
            // sms send failed
            //perhaps put an alert here and dismiss the view when the alert is canceled
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];

}


#pragma mark - UItextField Text

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
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
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self shareapp:self.btnshare];
    return TRUE;
}


#pragma mark - 
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
@end
