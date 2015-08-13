//
//  WelcomeViewController.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 5/1/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "WelcomeViewController.h"
#import "QTStyle.h"
#import "HomeViewController.h"


@interface WelcomeViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *onBoardView;
@property (weak, nonatomic) IBOutlet UIButton *logIn;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"])
    {
        
        HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
        [self.navigationController pushViewController:homeView animated:NO];
    }
    // Do any additional setup after loading the view.
    
    
    QTStyle *style = [[QTStyle alloc]init];
    CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    
    
    self.onBoardView.pagingEnabled = YES;
    self.onBoardView.showsHorizontalScrollIndicator = NO;
   // NSString *platform = platform;
    //[self platformString]);
    
    self.onBoardView.delegate = self;
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [style whiteBorder:(CALayer *)self.logIn.layer];
    [style whiteBorder:(CALayer *)self.signUp.layer];
    self.signUp.layer.borderWidth = 0;
    self.signUp.backgroundColor = [UIColor clearColor];
    self.logIn.layer.borderWidth = 1;
    
    UIView *tutView1 = [[[NSBundle mainBundle] loadNibNamed:@"welcomeSlide1" owner:self options:nil] objectAtIndex:0];
    UIView *tutView2 = [[[NSBundle mainBundle] loadNibNamed:@"welcomeSlide2" owner:self options:nil] objectAtIndex:0];
    UIView *tutView3 = [[[NSBundle mainBundle] loadNibNamed:@"welcomeSlide3" owner:self options:nil] objectAtIndex:0];
    UIView *tutView4 = [[[NSBundle mainBundle] loadNibNamed:@"welcomeSlide4" owner:self options:nil] objectAtIndex:0];
    UIView *tutView5 = [[[NSBundle mainBundle] loadNibNamed:@"welcomeSlide5" owner:self options:nil] objectAtIndex:0];

    
    self.onBoardView.contentSize = CGSizeMake(self.view.frame.size.width*5, self.onBoardView.frame.size.height);
    
    self.onBoardView.directionalLockEnabled = YES;
    
    
    CGRect frame;
    tutView1.frame = tutView2.frame;
    
    //update frame 2
    frame = tutView2.frame;
    frame.origin.x = self.view.frame.size.width;
    tutView2.frame = frame;
    
    // update frame 3
    frame = tutView3.frame;
    frame.origin.x = self.view.frame.size.width*2;
    tutView3.frame = frame;
    
    // update frame 4
    frame = tutView4.frame;
    frame.origin.x = self.view.frame.size.width*3;
    tutView4.frame = frame;
    
    //update frame 5
    frame = tutView5.frame;
    frame.origin.x = self.view.frame.size.width*4;
    tutView5.frame = frame;
    
    [self.onBoardView addSubview:tutView1];
    [self.onBoardView addSubview:tutView2];
    [self.onBoardView addSubview:tutView3];
    [self.onBoardView addSubview:tutView4];
    [self.onBoardView addSubview:tutView5];
 
    
}

- (IBAction)changePage:(id)sender {
    CGFloat x = self.pageControl.currentPage * self.onBoardView.frame.size.width;
    [self.onBoardView setContentOffset:CGPointMake(x, 0) animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVieView{
   self.pageControl.currentPage = lround(self.onBoardView.contentOffset.x / (self.onBoardView.contentSize.width / self.pageControl.numberOfPages));

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
