//
//  BackgroundGradient.h
//  Auto Kept
//
//  Created by Renteria Family on 4/26/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>

@interface AKStyle : NSObject

-(CAGradientLayer*) blueGradient:(UIView*)view;

-(void) blueBorder:(CALayer*)layer;
-(void) whiteBorder:(CALayer*)layer;
-(void) greyBorder:(CALayer*)layer;
-(void) textBox:(CALayer*)layer;


@end
