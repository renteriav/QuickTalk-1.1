//
//  PasswordRecoveryViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/27/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
#import "AKStyle.h"
@interface PasswordRecoveryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UITextField *infoTF;

@end

@implementation PasswordRecoveryViewController

@synthesize emailRecoverField;

- (void)viewDidLoad {
    AKStyle *style = [[AKStyle alloc]init];
    
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];

    
    [self.view.layer insertSublayer:gradient atIndex:0];
    [style whiteBorder:(CALayer *)self.submit.layer];
    [style blueBorder:(CALayer *)self.infoTF.layer];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SubmitClicked:(id)sender {
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
