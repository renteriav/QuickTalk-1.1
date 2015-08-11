//
//  SliderViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/27/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "SliderViewController.h"
#import "AKStyle.h"
#import "HomeViewController.h"
#import "Finished.h"
#import <AVFoundation/AVFoundation.h>

@interface SliderViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *tutScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutPageControl;
@property (nonatomic,retain) AVPlayer *player;
@property (nonatomic,retain) AVPlayerLayer *playerLayer;
@property (nonatomic,retain) AVAsset *asset;
@property (nonatomic,retain) AVPlayerItem *playerItem;
@property (nonatomic,retain) Finished *buttonover;

@end

@implementation SliderViewController

@synthesize guid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AKStyle *style = [[AKStyle alloc]init];
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [style whiteBorder:(CALayer *)self.finishBtn.layer];
    self.tutScrollView.delegate = self;
    
    UIViewController *vc= [[UIViewController alloc] initWithNibName:@"Finished" bundle:nil];
    self.buttonover = (Finished *)vc.view;
    NSString *test = [[NSBundle mainBundle] pathForResource:@"AppTutVid" ofType:@"mp4"];
    NSURL* videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AppTutVid" ofType:@"mp4"]];
    
    self.asset = [AVAsset assetWithURL:videoURL];
    self.playerItem =[[AVPlayerItem alloc]initWithAsset:self.asset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playerLayer =[AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setFrame:self.view.frame];
    
    [self.view.layer addSublayer:self.playerLayer];
    self.buttonover.frame = self.view.frame;
    [self.view addSubview:self.buttonover];
    [self.player seekToTime:kCMTimeZero];
    
   
  
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"])
    {
        self.guid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    }
    
    [self.buttonover.press addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}


- (void)start{
     [self.player play];
    NSString *time = [NSString stringWithFormat: @"%f",CMTimeGetSeconds([self.playerItem currentTime])];
    
    
    if ([time floatValue] >= 61.3){
        [self finishClcked:nil];
    }

    
}
    
   



- (IBAction)finishClcked:(id)sender {
    
    NSDictionary *dictionary = @{ @"profile":@{ @"hide_tutorial_page": @1} };
    
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
                 HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
                 homeView.login = YES;
                 [self.navigationController pushViewController:homeView animated:NO];

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
