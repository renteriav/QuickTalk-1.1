//
//  BackgroundGradient.m
//  Auto Kept
//
//  Created by Renteria Family on 4/26/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//
//  Edited by Nicholas Bellisario on 4/27/15
//

#import "QTStyle.h"

@implementation QTStyle

-(void) blueBackground:(CALayer*)layer{
    
    [layer setBackgroundColor:[[UIColor colorWithRed:0.00 green:0.38 blue:0.75 alpha:1.0] CGColor]];
    
}

-(CAGradientLayer*) blueGradient:(UIView*)view{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.118 green:0.341 blue:0.6 alpha:1] CGColor], (id)[[UIColor colorWithRed:0.169 green:0.702 blue:0.898 alpha:1] CGColor], (id)[[UIColor colorWithRed:0.161 green:0.537 blue:0.847 alpha:1] CGColor], nil];
    return gradient;
}
-(void) whiteBorder:(CALayer *)layer{
    [layer setBorderWidth:2.0];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [layer setBackgroundColor:[[UIColor colorWithRed:0.529 green:0.78 blue:0.871 alpha:.65] CGColor]];
    layer.cornerRadius = 10;
}

-(void) greyBorder:(CALayer *)layer{
    layer.cornerRadius = 10;
}

-(void) blueBorder:(CALayer*)layer{
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1] CGColor]];
    layer.cornerRadius = 10;
}

-(void) textBox:(CALayer*)layer{
    
    [layer setBackgroundColor:[[UIColor colorWithRed:0.529 green:0.78 blue:0.871 alpha:.7] CGColor]];
    layer.cornerRadius = 0;
     
}

-(void) transparentTextBox:(CALayer*)layer{
    
    [layer setBackgroundColor:[[UIColor colorWithRed:0.129 green:0.78 blue:0.871 alpha:0] CGColor]];
    layer.cornerRadius = 0;
    
}

@end
