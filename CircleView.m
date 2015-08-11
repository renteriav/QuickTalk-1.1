//
//  CircleView.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/10/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "CircleView.h"
#import "PulsingHaloLayer.h"


@interface CircleView ()

@property (nonatomic) BOOL touched;

@property (nonatomic) CGPoint locationOfTouch;
@end
@implementation CircleView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.touched = YES;
    UITouch *touch = [touches anyObject];
    self.locationOfTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}

- (void)drawTouchCircle:(CGFloat *)value
{
   
    PulsingHaloLayer *halo = [PulsingHaloLayer layer];
    halo.repeatCount = 1;
    halo.position = self.center;
    [self.layer addSublayer:halo];
    halo.radius = *(value);
    
}


- (void)drawRect:(CGRect)rect
{
  }



@end
