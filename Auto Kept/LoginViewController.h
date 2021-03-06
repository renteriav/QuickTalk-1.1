//
//  LoginViewController.h
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AKDefault.h"
#import "HomeViewController.h"
#import "TutorialViewController.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
- (void)LoginViewControllerDidAuthenticate:(LoginViewController *)viewController;
@end

@interface LoginViewController : UIViewController  <UITextFieldDelegate>

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;


@end
