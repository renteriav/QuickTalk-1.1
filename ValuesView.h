//
//  ValuesView.h
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/12/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuesView : UIView
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *method;
@property (weak, nonatomic) IBOutlet UIButton *contBtn;

@end
