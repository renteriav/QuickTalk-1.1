//
//  Overlay.h
//  Auto Kept
//
//  Created by Kamal Mittal on 2/25/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Overlay : UIView
@property (nonatomic, weak) IBOutlet UIButton *btntake;
@property (nonatomic, weak) IBOutlet UIButton *btncancel;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionView;
@property (weak, nonatomic) IBOutlet UIButton *moneyIn;
@property (weak, nonatomic) IBOutlet UIButton *moneyOut;
@property (weak, nonatomic) IBOutlet UIButton *Mileage;

@end
