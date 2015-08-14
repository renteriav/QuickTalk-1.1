//
//  HomeViewController.h
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

@interface HomeViewController : UIViewController<SpeechKitDelegate, SKRecognizerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
}
@property(readwrite) SKRecognizer* voiceSearch;
@property(nonatomic,weak) IBOutlet UIButton* recordButton;
@property(nonatomic,weak) IBOutlet UISegmentedControl* languageType;
@property(nonatomic,weak) IBOutlet UIImageView *profileimageView;
@property(nonatomic,weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic,retain) NSManagedObjectModel *saveLocalModel;
@property (nonatomic, nonatomic) NSManagedObjectContext *saveLocalContext;
@property (weak, nonatomic) IBOutlet UIPickerView *CategoryPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *methodPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *payeePicker;

@property (nonatomic,weak) IBOutlet UIButton* logoButton;

@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *email;

@property bool login;


@end
