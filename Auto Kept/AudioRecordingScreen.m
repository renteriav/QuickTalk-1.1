//
//  AudioRecordingScreen.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/10/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "AudioRecordingScreen.h"

@interface AudioRecordingScreen ()

@end

@implementation AudioRecordingScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Create a view with a corner radius as the circle
    UIView* circle = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    [circle setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:circle];
    
    [UIView animateWithDuration:5 animations:^{
        
        // Animate it to double the size
        const CGFloat scale = 2;
        [circle setTransform:CGAffineTransformMakeScale(scale, scale)];
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
