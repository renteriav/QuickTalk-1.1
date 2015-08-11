//
//  RecordAudio.h
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/12/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordAudio : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancel2btn;


- (void) activate:(CGFloat *)value;
- (void) switchto:(NSString *)totalamount:(NSString *)paymentMethod;
@end
