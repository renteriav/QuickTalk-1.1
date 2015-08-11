//
//  CircleView.h
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/10/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *SkipBtn;



- (void)drawTouchCircle:(CGFloat *)value;
@end
