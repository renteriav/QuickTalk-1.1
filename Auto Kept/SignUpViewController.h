//
//  SignUpViewController.h
//  Auto Kept
//
//  Created by Nicholas Bellisario on 4/27/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class SignUpViewController;

@protocol SignUpViewControllerDelegate <NSObject>
- (void)LoginViewControllerDidAuthenticate:(SignUpViewController *)viewController;
@end

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *RegistrationView;
@property (nonatomic, weak) id <SignUpViewControllerDelegate> delegate;

@end
