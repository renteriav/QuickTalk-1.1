//
//  Overlay.m
//  Auto Kept
//
//  Created by Kamal Mittal on 2/25/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "Overlay.h"

@implementation Overlay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)accessClicked:(id)sender {
    NSURL *accounturl = [NSURL URLWithString:@"http://autokept.herokuapp.com/users/sign_in"];
    [[UIApplication sharedApplication] openURL:accounturl];
}


- (IBAction)mInPressed:(id)sender {
    [self.moneyIn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.moneyOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Mileage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


}
- (IBAction)mOutPressed:(id)sender {
    [self.moneyIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.moneyOut setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.Mileage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}
- (IBAction)mileagePressed:(id)sender {
    [self.moneyIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.moneyOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Mileage setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
}



@end
