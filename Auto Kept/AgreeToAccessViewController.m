//
//  AgreeToAccessViewController.m
//  Auto Kept
//
//  Created by Renteria Family on 4/27/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "AgreeToAccessViewController.h"
#import "AKStyle.h"
#import "SVProgressHUD.h"
@interface AgreeToAccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *permissionLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *declineBtn;
@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
@property (nonatomic) NSString *hide;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;


@end

@implementation AgreeToAccessViewController

@synthesize guid;
@synthesize companyName;
@synthesize profileId;

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    AKStyle *style = [[AKStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    [style whiteBorder:(CALayer *) self.acceptBtn.layer];
    [style whiteBorder:(CALayer *) self.declineBtn.layer];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"])
    {
        self.guid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    }

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"profile_id"])
    {
        self.profileId = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_id"];
    }

    [self fetchCompanyName];
    [self fetchCompanyLogo];
    NSString *accountant = @"your accountant";
    if (![self.companyName  isEqual: @""] & (self.companyName != nil) & ![self.companyName isEqual:[NSNull null]]) {
        accountant =  self.companyName;
    }
    
    self.permissionLabel.text = [NSString stringWithFormat:@"Do you agree to allow %@ to view your submissions?", accountant];

    
    // Do any additional setup after loading the view.
}
- (void)fetchCompanyLogo{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@brands/fetch?guid=",baseurl]stringByAppendingString:self.guid]];
    NSLog(@"companyLogo:%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if(error == nil)
    {
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *message = result[@"message"];
        NSLog(@"Logo = %@", message[@"image_header"]);
      
        if (message[@"image_header"] == [NSNull null]){
            [SVProgressHUD dismiss];
        }else{
            self.staticLabel.text = @"";
            NSURL *url = [NSURL URLWithString:message[@"image_header"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
        self.brandLogo.image = [[UIImage alloc] initWithData:data];
        [SVProgressHUD dismiss];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"We're sorry something went wrong!"];
        [SVProgressHUD dismiss];
    }
    
    
    
    


}
- (void)fetchCompanyName {
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@profile?guid=",baseurl] stringByAppendingString:self.guid]];
    NSLog(@"%@",url);
    
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
         if(error == nil)
         {
             NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             NSLog(@"Company = %@", result[@"company_name"]);
             self.staticLabel.text = result[@"company_name"];
             self.companyName = result[@"company_name"];
             self.hide = result[@"hide_tutorial_page"];
             NSLog(@"hide = %@", result[@"hide_tutorial_page"]);
            
             
            [SVProgressHUD dismiss];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"We're sorry something went wrong!"];
             [SVProgressHUD dismiss];
         }
    
    
    

    

}

- (IBAction)acceptClicked:(id)sender {
    
    
    
    NSDictionary *dictionary =@{ @"user":
                                @{ @"profile_attributes":
                                       
                                           @{ @"id": self.profileId, @"agree_to_access": @1, @"hide_permission_page": @1 }}};

    
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
                 
                 [self checkForAndPerformSegue];
                 [SVProgressHUD dismiss];
             }
             
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Something went wrong, Please try again."];
             }
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"Something went wrong, Please try again."];
         }
     }];

    
}
- (IBAction)declineClicked:(id)sender {
    
    NSDictionary *dictionary = @{ @"profile":@{ @"agree_to_access": @0, @"hide_permission_page": @1} };
    
    NSData *params = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@profiles/update?guid=",baseurl] stringByAppendingString:self.guid]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"PUT"];
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
                 
                 [self checkForAndPerformSegue];
                 [SVProgressHUD dismiss];
             }
             
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"Something went wrong, Please try again."];
             }
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"Something went wrong, Please try again."];
         }
     }];
    
}

- (void)checkForAndPerformSegue{
   
    SliderViewController *tutorialPage = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialPage"];
    [self.navigationController pushViewController:tutorialPage animated:YES];
    [SVProgressHUD dismiss];
    NSLog(@"Silder View Accessed");

    /*
    if([self.hide boolValue])
    {
        HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
        homeView.login = YES;
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
    */
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
