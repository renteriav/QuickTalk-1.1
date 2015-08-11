//
//  RecordAudio.m
//  Auto Kept
//
//  Created by Nicholas Bellisario on 6/12/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "RecordAudio.h"
#import "CircleView.h"
#import "ValuesView.h"
@interface RecordAudio ()

@property (nonatomic) CircleView *daview;
@property (nonatomic) ValuesView *valview;
@end

@implementation RecordAudio

@synthesize cancelBtn;
@synthesize cancel2btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSArray  *nib = [[NSArray alloc] initWithObjects:[[NSBundle mainBundle] loadNibNamed:@"CircleView" owner:self options:nil],[[NSBundle mainBundle] loadNibNamed:@"ValuesView" owner:self options:nil], nil];
    
    self.daview = [[nib objectAtIndex:0] objectAtIndex:0];
    self.valview = [[nib objectAtIndex:1] objectAtIndex:0];
    self.view = self.daview;
    cancelBtn = self.daview.SkipBtn;
    cancel2btn = self.valview.contBtn;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) activate:(CGFloat *)value{
    [self.daview drawTouchCircle:value];
}

- (void) switchto:(NSString *)totalamount: (NSString *)paymentMethod{
    if(totalamount == nil){
        self.valview.amount.text = @"Amount: N/A ";
    }else{
        self.valview.amount.text = [NSString stringWithFormat:@"Amount: %@",totalamount];
    }
    if(paymentMethod == nil){
        self.valview.method.text = @"Payment Method: N/A";
    }else{
    self.valview.method.text = [NSString stringWithFormat:@"Payment Method: %@", [paymentMethod capitalizedString]];
    }
    self.view = self.valview;
    
    
    
}


@end
