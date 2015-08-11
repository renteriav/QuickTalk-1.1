//
//  HomeViewController.m
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+Resize.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "commonunit.h"
#import "Overlay.h"
#import "ShareViewController.h"
#import "QTStyle.h"
#import "CircleView.h"
#import "RecordAudio.h"
#import "HTAutocompleteManager.h"
#import "HTAutocompleteTextField.h"
#import "CKCalendarView.h"




#define imagesize CGSizeMake(960, 960)
#define headerImage @"header.png"
#define profileImage @"profile.png"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE

 const unsigned char SpeechKitApplicationKey[] = {0x70, 0xf1, 0xac, 0xdb, 0x59, 0x3e, 0x5b, 0x3c, 0xe3, 0x9a, 0xc6, 0x3d, 0x3b, 0x30, 0x55, 0x6d, 0x83, 0xa0, 0x38, 0x80, 0x40, 0x36, 0x2b, 0x80, 0x97, 0x26, 0xeb, 0x88, 0x8f, 0x8b, 0x4e, 0xff, 0x7c, 0xfa, 0xda, 0xd5, 0x39, 0x35, 0x11, 0x1c, 0xcf, 0xd8, 0x59, 0x0a, 0x08, 0xae, 0x77, 0x8b, 0x4e, 0xb0, 0x0b, 0x8f, 0xe6, 0x37, 0x0f, 0x7d, 0x5d, 0xfa, 0x06, 0xec, 0x85, 0x54, 0xeb, 0x02};


@interface HomeViewController () <HTAutocompleteDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>//MFMailComposeViewControllerDelegate
{
    UIImagePickerController *imagePicker;
}
@property(nonatomic, weak) IBOutlet UITextView *txtview;
@property (weak, nonatomic) IBOutlet UITextField *amountView;
@property (weak, nonatomic) IBOutlet UITextField *methodView;
@property (weak, nonatomic) IBOutlet UITextField *categoryView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerDoneBtn;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *payeeView;
@property (weak, nonatomic) IBOutlet UITextField *dateView;
@property (nonatomic, strong) UIImage *sendimage;
@property(nonatomic,retain) IBOutlet UIView* vuMeter;
@property(nonatomic,retain) IBOutlet UIView* whitelineview;
@property(nonatomic,retain) IBOutlet Overlay* cameraOverlay;
@property(nonatomic,retain) IBOutlet RecordAudio* recordOverlay;
@property (weak, nonatomic) IBOutlet UIButton *submitbtn;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;
@property (weak, nonatomic) IBOutlet UIButton *micrphonebtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *lineOne;
@property (nonatomic, assign) bool firstTime;
@property (nonatomic) NSString *localtemp;
@property (nonatomic) NSMutableArray *allData;
@property (nonatomic) BOOL oldUploadsuccessful;
@property (nonatomic) dispatch_group_t group;
@property (weak, nonatomic) IBOutlet UIView *textboxContainer;
@property (nonatomic) NSString *descriptiontext;
@property (nonatomic) BOOL amountset;
@property (nonatomic) BOOL cateSet;
@property (nonatomic) BOOL compSet;
@property (nonatomic) BOOL methodSet;
@property (nonatomic) NSArray *companys;
@property (nonatomic) NSArray *paymentTypes;
@property (nonatomic) NSArray *categoryTypes;
@property (nonatomic) NSString *totalFilled;
@property (nonatomic) NSString *paymentMethodFilled;
@property (nonatomic) NSString *cardEndingFilled;
@property (nonatomic) NSString *cateFilled;
@property (nonatomic) NSString *companyToPFilled;
@property (nonatomic) NSString *dateFilled;
@property (nonatomic) BOOL Mileage;
@property (nonatomic) BOOL lockSubmit;
@property (nonatomic) BOOL Income;
@property (nonatomic) BOOL Transa;
@property (nonatomic) int typeTran;
@property (weak, nonatomic) IBOutlet UILabel *ampmlabel;
@property (nonatomic) CKCalendarView *calenderPicker;
@property (nonatomic) NSInteger prevrow;
@property (nonatomic) NSArray *dateValues;
@property (nonatomic) NSArray *dayValues;
@property (nonatomic) UIToolbar *calenderbar;



@end



@implementation HomeViewController
@synthesize voiceSearch;
@synthesize websiteButton;
@synthesize phoneButton;
@synthesize emailButton;
@synthesize website;
@synthesize phone;
@synthesize email;
@synthesize saveLocalContext;
@synthesize saveLocalModel;
@synthesize login;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _calenderPicker = [[CKCalendarView alloc] init];
    
    _calenderPicker.delegate = self;
    
   self.calenderbar = [[UIToolbar alloc] init];
   
    

    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cateDoneClicked:)]];
    [self.calenderbar setItems:items animated:NO];
   
   
    
    self.navigationController.navigationBarHidden = TRUE;
    QTStyle *style = [[QTStyle alloc]init];
    self.descriptiontext = @"";
    self.firstTime = true;
    //NSLog(@"initial dic%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
   // NSLog(self.login ? @"Yes" : @"No");
    
    //[self loadData];
    
    // NSLog(@"\n new dic%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    self.allData = [[NSMutableArray alloc] init];
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
   
    //self.categoryView = [[HTAutocompleteTextField alloc] init];
    NSArray *cards = [appdelegate getCards];
    NSArray *methodtypes = [appdelegate getIncomeMethods];
    if(self.login || cards.count == 0){
        
        [appdelegate saveCardInfo:@"Login"];

    }
    if(self.login || methodtypes.count == 0){
        [appdelegate setIncomeMethod:@" Card"];
        [appdelegate setIncomeMethod:@" Check"];
        [appdelegate setIncomeMethod:@" Cash"];
    }
    self.amountView.text = @"Description";
    self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.payeeView.autocompleteType = HTAutocompleteTypeComp;
    //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    //self.methodView.autocompleteType = HTAutocompleteTypeMethod;
    self.companyToPFilled = @"";
    self.totalFilled = @"";
    self.paymentMethodFilled = @"";
    self.dateFilled = @"";
    self.cateFilled = @"";
    self.cardEndingFilled = @"";
    self.dateView.text = @"";

    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"show_personal_info_form"]boolValue]){
        if([self checkprofile]){
            //navigate to personal profile screen
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"Updateuserinfo" sender:nil];
            [voiceSearch cancel];
            return;
            
        }
    }
    self.Mileage = NO;
    self.lockSubmit = NO;
    self.Transa = YES;
    self.Income = NO;
    self.txtview.delegate = self;
    self.payeeView.delegate = self;
    self.categoryView.delegate = self;
    self.methodView.delegate = self;
    self.amountView.delegate = self;
    self.typeTran = 1;
    
    [style greyBorder:(CALayer *) self.textboxContainer.layer];
    [style blueBackground:(CALayer *) self.view.layer];
    [style blueBackground:(CALayer *) self.submitbtn.layer];
    [style blueBackground:(CALayer *) self.sharebtn.layer];
    [style blueBackground:(CALayer *) self.websiteButton.layer];
    [style blueBackground:(CALayer *) self.phoneButton.layer];
    [style blueBackground:(CALayer *) self.emailButton.layer];
    [style transparentTextBox:(CALayer *) self.txtview.layer];
    [style transparentTextBox:(CALayer *) self.amountView.layer];
    [style transparentTextBox:(CALayer *) self.methodView.layer];
    [style transparentTextBox:(CALayer *) self.categoryView.layer];
    [style textBox:(CALayer *) self.payeeView.layer];
     [style transparentTextBox:(CALayer *) self.dateView.layer];
    self.amountset = FALSE;
    self.methodSet = FALSE;
    self.cateSet = FALSE;
    self.compSet = FALSE;
    self.amountView.text = @"Amount:";
    self.methodView.text = @"Type:";
    self.categoryView.text = @"Category:";
    self.payeeView.text = @"";
    self.txtview.text = @"Description";
    self.dateView.text = @"Date:";

    [self.logoButton setTitle:@"" forState:UIControlStateNormal];
    [self.logoButton setImage:nil forState:UIControlStateNormal];
    
    
    UIViewController *vc= [[UIViewController alloc] initWithNibName:@"Overlay" bundle:[NSBundle mainBundle]];
    self.cameraOverlay =  (Overlay *)vc.view;
    self.cameraOverlay.selectionView.delegate = self;
    [self.cameraOverlay.moneyOut setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [self.cameraOverlay.moneyIn addTarget:self action:@selector(selectedTranaction:) forControlEvents:UIControlEventTouchUpInside];
     [self.cameraOverlay.moneyOut addTarget:self action:@selector(selectedTranaction:) forControlEvents:UIControlEventTouchUpInside];
     [self.cameraOverlay.Mileage addTarget:self action:@selector(selectedTranaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraOverlay.btntake addTarget:self action:@selector(takeImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraOverlay.btncancel addTarget:self action:@selector(cancelImage:) forControlEvents:UIControlEventTouchUpInside];

    vc = nil;
    
    

    
    //[self.recordOverlay.cancelbtn addTarget:self action:@selector(cancelrecording) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[self.profileimageView.layer setCornerRadius:30.0];
    self.profileimageView.layer.cornerRadius = self.profileimageView.frame.size.width / 2;
    self.profileimageView.clipsToBounds = TRUE;
    
    [self.logoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

    
    /*
    http://dragonmobile.nuancemobiledeveloper.com/public/index.php
    username: kokx85
    pwd: kokx1985
    */
    [SpeechKit setupWithID:@"NMDPPRODUCTION_KC_Truby_Auto_Kept_20141113145805"
                      host:@"cta.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
    // Set earcons to play
//  SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"Voice Screen.mp4"];
    SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateScreen];
        CGRect rect = self.whitelineview.frame;
        rect.size.width = 0;
        //self.vuMeter = [[UIView alloc] initWithFrame:rect];
        //[self.view addSubview:self.vuMeter];
        //[self.vuMeter setBackgroundColor:[UIColor greenColor]];
        
        [self openCameraOrLibrary:UIImagePickerControllerSourceTypeCamera];
        //[self openCameraOrLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
    });

    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture = nil;
    [self checkforpastuploads];
       [SVProgressHUD dismiss];
    
    
    //self.paymentTypes = [appdelegate getCards];
    
    [self getpaymentMethods];
    [self getExpenseCategories];
    
    //self.categoryTypes = [NSArray arrayWithObjects:@"Mileage",@"Mileage",@"",@"Money In",@"Money In - I Don't Know", @"Money In - Earned Income",@"",@"Money Out",@"Money Out - I Don’t Know",@"Advertising/Marketing",@"Automotive",@"Bank/CC Fees",@"Charity/Medical/Misc. Tax Deductions",@"Cost Of Goods",@"Credit Card/Loan Payments",@"Dues/Subscriptions/Professional Fees",@"Insurance/Licenses/Permits",@"Meals/Travel/Entertainment",@"Rent/Utilities",@"Sub-Contractor",@"Supplies/Equipment",@"Telecommunications", nil];
    
    
    self.dateValues = @[@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@""],
  @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"],
  @[@"AM",@"PM"]];
    self.timePicker.dataSource = self;
    self.timePicker.delegate = self;
    self.dayValues = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
    self.dateView.delegate = self;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) dealloc
{
    self.vuMeter = nil;
    self.sendimage = nil;
    self.txtview = nil;
    self.recordButton = nil;
    self.profileimageView = nil;
    self.logoButton = nil;
    self.logoImageView = nil;
    self.lineTwo = nil;
    self.lineOne = nil;
}

#pragma get expense categories

- (void)getExpenseCategories{
    
    //NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@expense_categories",baseurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@", result);
    
    NSMutableArray *allKeys = [[result allKeys] mutableCopy];
    
    self.categoryTypes = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"%@", self.categoryTypes);
    
}
- (void)getpaymentMethods{
    
    //NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@bank_accounts",baseurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@", result);
    
    NSMutableArray *allKeys = [[result allKeys] mutableCopy];
    
    self.paymentTypes = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"%@", self.paymentTypes);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Gestures

// Set's transaction Type!


-(void)selectedTranaction:(id)sender{
    
    if(sender == self.cameraOverlay.moneyOut){
        self.typeTran = 1;
        NSLog(@"MoneyOut");
    }else if(sender == self.cameraOverlay.moneyIn){
        self.typeTran = 0;
           NSLog(@"MoneyIn");
    }else if(sender == self.cameraOverlay.Mileage){
        self.typeTran = 2;
           NSLog(@"Mileage");
    }

    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVieView{
    float val = lround(self.cameraOverlay.selectionView.contentOffset.x / (self.cameraOverlay.selectionView.contentSize.width / 3));
    NSLog(@"%f",val);
    self.typeTran = val;
}


-(void)handleTap:(id)sender
{
   
    if(![self.CategoryPicker isHidden]){
        [self.CategoryPicker setHidden:YES];
        [self.pickerDoneBtn setHidden:YES];
        [self cateDoneClicked:self.CategoryPicker];
        
        
    }
    
    if(![self.methodPicker isHidden]){
        [self.methodPicker setHidden:YES];
        [self.pickerDoneBtn setHidden:YES];
        
        
    }
    if(![self.timePicker isHidden]){
        [self.timePicker setHidden:YES];
        [self.pickerDoneBtn setHidden:YES];
    }
    if([self.view.subviews containsObject:self.calenderPicker]){
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];

    }
    if([self.methodView isFirstResponder]){
        [self.pickerDoneBtn setHidden:YES];
        [self cateDoneClicked:self.methodView];
    }
    if([self.payeeView isFirstResponder]){
      
        [self.pickerDoneBtn setHidden:YES];
        [self cateDoneClicked:self.payeeView];
    }
    if([self.amountView isFirstResponder]){
        
        [self.pickerDoneBtn setHidden:YES];
        [self cateDoneClicked:self.amountView];
    }

 [self.view endEditing:TRUE];
    if (transactionState == TS_RECORDING) {
        [self.voiceSearch cancel];
    }
}


#pragma mark - Other Functions

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if([self.methodView isFirstResponder]||[self.payeeView isFirstResponder]){
    [self.pickerDoneBtn setHidden:YES];
    }
}
- (BOOL)textFieldShouldReturn:(HTAutocompleteTextField *)textField{
     [textField resignFirstResponder];
  
        [self.pickerDoneBtn setHidden:YES];

    return YES;
}

/*
-(void) loadData
{
//   http://autokept.herokuapp.com/api/v1/brands/fetch?guid=sdfgdfhgdh
    
    NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSString *str = [NSString stringWithFormat:@"guid=%@",strguid];

//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@brands/fetch?%@",baseurl,str]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
//    [request setHTTPBody:data];
//    data= nil;

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             string = [string stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
             NSData *datawithoutnull = [string dataUsingEncoding:NSUTF8StringEncoding];
             
             NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:datawithoutnull options:NSJSONReadingMutableContainers error:nil];
             datawithoutnull = nil;
            // NSLog(@"the result is %@",result);
             if(result != nil &&[result[@"success"] intValue] == 1)
             {
                 
                 NSMutableDictionary *message = result[@"message"];
              //   NSLog(@"the second result is %@",message);
                 if([[NSUserDefaults standardUserDefaults] objectForKey:userData])
                 {
                     
                     NSString *strlastupdate = [[[NSUserDefaults standardUserDefaults] objectForKey:userData] objectForKey:@"updated_at"];
                     if([strlastupdate isEqualToString:message[@"updated_at"]])
                     {
                         
                         if(self.login){
                             NSLog(@"Logged In");
                             [self StoreAndDownloadData:message];
                             [self updateButtons];
                         }else{
                         NSLog(@"No Updates");
                         [self updateScreen];
                         [self updateButtons];
                         }
                     }
                     else
                     {
                         NSLog(@"Updates performed");
                         [self StoreAndDownloadData:message];
                         [self updateButtons];
                         
                     }
                 }
                 else
                 {
                     [self StoreAndDownloadData:message];
                     [self updateButtons];
                 }
             }
             else
             {
                 if(result[@"guid"] != nil && ![result[@"guid"]  isEqual: @""]){
                     [SVProgressHUD showErrorWithStatus:result[@"message"]];
                     //[voiceSearch cancel];
              }
                 else{
                     NSLog(@"no guid");
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_guid"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }

            }
         });
     }];

}*/

-(void) StoreAndDownloadData:(NSMutableDictionary *)dic
{
    
    //Remove full value from response
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate deleteCompanyInfo];
    
    //Save new set in user default
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:userData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"saved in defaults%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    
    
    //download logo Image and save it
    if(!([dic[@"image_header"] isEqualToString:@""]))
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dic[@"image_header"]]];
        
        [self.logoImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            //Save Image to local
            [commonunit SaveImageInApp:headerImage Image:image];
            [self updateScreen];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Error: %@",[error description]);
            [self updateScreen];
        }];
    }else{
        [commonunit SaveImageInApp:headerImage Image:nil];
        [self updateScreen];
    }
    
    
    //Download user Image and save it
    if(dic[@"image_avatar"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dic[@"image_avatar"]]];
        [self.profileimageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            //Save Image to local
            [commonunit SaveImageInApp:profileImage Image:image];
            [self updateScreen];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [self updateScreen];
        }];
    }
}


-(void) updateScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.lineOne.text = @"";
        //self.lineTwo.text = @"";
        
        [self.logoButton setTitle:@"" forState:UIControlStateNormal];

        self.profileimageView.image = [commonunit GetImageFromApp:profileImage];
        [self.logoButton setImage:[commonunit GetImageFromApp:headerImage] forState:UIControlStateNormal];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:userData];
        
        NSLog(@"update screen%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        
        if(dic)
        {
            if(dic[@"line_one"])
            {
                self.lineOne.text = dic[@"line_one"];
            }
            if(dic[@"line_two"])
            {
                self.lineTwo.text = dic[@"line_two"];
            }
            //set brand buttons info
            if(dic[@"brand_web_site"])
            {
                self.website = dic[@"brand_web_site"];
            }
            if(dic[@"brand_phone"])
            {
                self.phone = dic[@"brand_phone"];
            }
            if(dic[@"brand_email"])
            {
                self.email = dic[@"brand_email"];
            }
            if([commonunit GetImageFromApp:headerImage] == nil)
            {
                if(dic[@"company_name"] && [dic[@"company_name"] length] > 0)
                {
                    [self.logoButton setTitle:dic[@"company_name"] forState:UIControlStateNormal];
                }
            }
        }
    });
}



#pragma mark - Button Events


- (IBAction)websiteButtonClicked:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@",self.website];
        NSLog(@"web %@",self.website);
    NSURL *websiteURL =  [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:websiteURL];
}
- (IBAction)phoneButtonClicked:(id)sender {
    //usleep(1500000);
    @autoreleasepool {
         [self.voiceSearch cancel];
    }
    NSString *number = [NSString stringWithFormat:@"tel://%@",self.phone];
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:number]];
    usleep(2000000);
    exit(0);


    
}
- (IBAction)emailButtonClicked:(id)sender {
    NSString *url = [NSString stringWithFormat:@"mailto:%@",self.email];
    NSURL *emailAddress =  [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:emailAddress];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [self.txtview resignFirstResponder];
    [self.CategoryPicker setHidden:NO];
    [self.pickerDoneBtn setHidden:NO];
    
}

-(IBAction)SubmitClicked:(id)sender
{
    [self.view endEditing:TRUE];
    if(self.lockSubmit){
        UIAlertView *badDate = [[UIAlertView alloc] initWithTitle:@"Incorrect Date" message:@"Please Correct Your Date Entry Before Attempting to Submit \n ie: 12/23/2015 at 5:00 PM " delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
        [badDate show];
        return;
    }
    
    NSString *strdescription = [self.txtview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([strdescription length] == 0 || [strdescription isEqualToString:@"Description"])
    {
        [SVProgressHUD showErrorWithStatus:@"Please enter description"];
        return;
    }
//    else if(self.sendimage == nil)
//    {
//        [SVProgressHUD showErrorWithStatus:@"Please select image"];
//        return;
//    }
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];

    
    NSString *base64String = @"";
    if(self.sendimage != nil)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.sendimage, 1);
        base64String = [[imageData base64EncodedStringWithOptions:0] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    if (self.Transa){
    self.paymentMethodFilled = [[self.methodView.text componentsSeparatedByString:@":"] objectAtIndex:1];
    }
    if(self.Income){
    [appdele SaveSource:self.companyToPFilled];
    [appdele setIncomeMethod:self.paymentMethodFilled];
    }else if(self.Transa){
        [self cardSave];
    }
    NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSString *str;
    if(self.Mileage) {
        //&trip_time=3:30PM&trip_date=2015-07-01
        NSArray *date = [self.dateFilled componentsSeparatedByString:@"at"];
        NSString *day = [[date objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSString *day = @"2014-05-12";
        NSString *time =[[date objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"Date:%@", day);
        NSLog(@"Time:%@", time);
       str = [NSString stringWithFormat:@"guid=%@&description=%@&distance=%@&transaction_type=mileage&trip_date=%@&trip_time=%@&image=%@",strguid, self.txtview.text,self.totalFilled, day, time,base64String];
    }
    if(self.Transa){
    str = [NSString stringWithFormat:@"guid=%@&description=%@&amount=%@&payment_method=%@&transaction_type=%@&payee=%@&transaction_date=%@&image=%@",strguid, self.txtview.text,self.totalFilled, self.paymentMethodFilled, self.cateFilled, self.companyToPFilled, self.dateFilled,base64String];
    }
    if(self.Income){
            str = [NSString stringWithFormat:@"guid=%@&description=%@&amount=%@&payment_method=%@&transaction_type=%@&payee=%@&transaction_date=%@&image=%@",strguid, self.txtview.text,self.totalFilled, self.paymentMethodFilled,self.cateFilled, self.companyToPFilled, self.dateFilled,base64String];
    }
    
    self.localtemp = str;
    //    str = [self urlencode:str];
    
    //NSLog(str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@submit",baseurl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    data= nil;
    // upload message fail
    UIAlertView *uploadFailMessage = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We apologize, however we’re having trouble submitting this entry at the moment." delegate:self cancelButtonTitle:@"Try Again Now" otherButtonTitles:@"Save And Upload Later", nil];
    
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSRange range = [string rangeOfString:@"{"];
                 if(range.length > 0)
                 {
                     NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                     NSLog(@"%@",result);
                     if([result[@"success"] intValue] == 1)
                     {
                         self.sendimage = nil;
                         self.txtview.text = @"Description";
                         //[SVProgressHUD showErrorWithStatus:@"Upload Successful! Click your iPhone home button to close the app."];
                         [SVProgressHUD dismiss];
                         UIAlertView *lastcall = [[UIAlertView alloc] initWithTitle:@"Upload Successful!" message:@"Please sign in at www.autokept.com to view your reports." delegate:self cancelButtonTitle:@"Exit App" otherButtonTitles:@"Submit Another",nil ];
                         
                         lastcall.tag = 1;
                         self.localtemp = nil;
                         [lastcall show];
                     }
                     else
                     {
                         //[SVProgressHUD showErrorWithStatus:@"Upload not successful, please try again."];
                         uploadFailMessage.tag = 2;
                         [uploadFailMessage show];
                          [SVProgressHUD dismiss];
                     }
                 }
                 else
                 {
                     //[SVProgressHUD showErrorWithStatus:@"Upload not successful, please try again."];
                     uploadFailMessage.tag = 2;
                     [uploadFailMessage show];
                     [SVProgressHUD dismiss];
                 }
             }
             else
             {
                 uploadFailMessage.tag = 2;
                 [uploadFailMessage show];
                 [SVProgressHUD dismiss];
             }
         });
     }];
    
}

-(IBAction)MinuteBookClicked:(id)sender
{
    //[self performSegueWithIdentifier:@"sharemodel" sender:nil];
}

- (IBAction)StartButtonAction: (id)sender
{
    //superSiri
    /*
    self.recordOverlay = [[RecordAudio alloc] initWithNibName:@"RecordAudio" bundle:nil];
    self.recordOverlay.view.frame = self.view.frame;
    [self.view addSubview: self.recordOverlay.view];
    [self.recordOverlay didMoveToParentViewController:self];
    
    [self.recordOverlay.cancelBtn addTarget:self action:@selector(cancelrecording:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordOverlay.cancel2btn addTarget:self action:@selector(cancelrecording:) forControlEvents:UIControlEventTouchUpInside];
    */
    
    [self.txtview resignFirstResponder];
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
        recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        
//        switch (self.languageType.selectedSegmentIndex) {
//            case 0:
//                langType = @"en_US";
//                break;
//            case 1:
//                langType = @"en_GB";
//                break;
//            case 2:
//                langType = @"fr_FR";
//                break;
//            case 3:
//                langType = @"de_DE";
//                break;
//            default:
//                langType = @"en_US";
//                break;
//        }

        langType = @"en_US";

        /* Nuance can also create a custom recognition type optimized for your application if neither search nor dictation are appropriate. */
        
//        NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        
        if (self.voiceSearch) self.voiceSearch = nil;
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
}

- (IBAction)logoutClick:(id)sender {

    
   /* 
    UIAlertView *lastcall = [[UIAlertView alloc] initWithTitle:@"Complete" message:@"Your Upload was successful and complete. Would you like to view your Transcations?" delegate:self cancelButtonTitle:@"Nope, I'm Done" otherButtonTitles:@"View Account",nil ];

    lastcall.tag = 1;
    [lastcall show];
    
    */

    usleep(1000000);
    @autoreleasepool {
        if (transactionState == TS_RECORDING){
            [self.voiceSearch cancel];
        }
    }
    [self.voiceSearch cancel];
    self.voiceSearch = nil;

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate deleteCompanyInfo];
    [appDelegate wipeCore];
    [appDelegate deleteCards];
    [appDelegate wipeSources];
    [appDelegate wipeMethodSources];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_guid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self.navigationController popToRootViewControllerAnimated:YES ];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
    if (buttonIndex == 0) {
        //Todo Close application
        NSLog(@"Close Application");
        exit(0);
    }else if(buttonIndex == 1){
                [self viewDidLoad];
    }else{
        //Todo open safari and load there database
        NSLog(@"Exit App and open Safari");
        // Temp web address for testing
        NSURL *accounturl = [NSURL URLWithString:@"http://autokept.herokuapp.com/users/sign_in"];
        [[UIApplication sharedApplication] openURL:accounturl];
    }   
    }
    if (alertView.tag == 2){
        if(buttonIndex ==0){
            NSLog(@"User chose to try again");
            [self SubmitClicked:nil];
        }else if(buttonIndex ==1){
            NSLog(@"User chose to Try Later");
            [self saveLocally];
            exit(0);
        }
    }
    if (alertView.tag ==3){
        if(buttonIndex ==0){
                //Cancel Button
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate wipeCore];
        }else if(buttonIndex == 1){
           //Retry Upload
            [self attemptUpload];
          
        }else{
            //Skip
        }
    }
}

-(IBAction)shareapp:(id)sender
{
    @autoreleasepool {
    
        if (transactionState == TS_RECORDING) {
            [self.voiceSearch cancel];
        }else{
            [self.voiceSearch cancel];
        }
        
        [self performSegueWithIdentifier:@"sharemodel" sender:nil];
        
    }
    
}

-(void) takeImage:(id)sender
{
    NSLog(@"Picha!!");
    [imagePicker takePicture];
    switch (self.typeTran){
        case 0:
            self.Transa = NO;
            self.Mileage = NO;
            self.Income = YES;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = NO;
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Source: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.categoryView.text = @"Category: ";
            self.descriptiontext = @"";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeSource;
            //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            //self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
            break;
        case 1:
            self.Transa = YES;
            self.Mileage = NO;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = NO;
            
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Payee: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.categoryView.text = @"Category: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeComp;
            break;
        case 2:
            self.Transa = NO;
            self.Mileage = YES;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = YES;
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            self.payeeView.text = @"";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Mileage: ";
            self.categoryView.text = @"Category: Mileage";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            break;
    }
}

-(void) cancelImage:(id)sender
{
    [imagePicker dismissViewControllerAnimated:TRUE completion:nil];
    imagePicker = nil;
     NSLog(@"No Picha!!");
    switch (self.typeTran){
        case 0:
            self.Transa = NO;
            self.Mileage = NO;
            self.Income = YES;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = NO;
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Source: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.categoryView.text = @"Category: ";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeSource;
            //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            //self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
            break;
        case 1:
            self.Transa = YES;
            self.Mileage = NO;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = NO;
            self.categoryView.text = @"Category: ";
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Payee: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeComp;
            
            break;
        case 2:
            self.Transa = NO;
            self.Mileage = YES;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = YES;
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            self.payeeView.text = @"";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Mileage: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.categoryView.text = @"Category: Mileage";
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self StartButtonAction:nil];
    });
}

#pragma mark -
#pragma mark VU Meter

- (void)setVUMeterWidth:(float)width {
    if (width < 0)
        width = 0;
    
    CGRect frame = self.vuMeter.frame;
    frame.size.width = width;//+10;
    self.vuMeter.frame = frame;
    
}

- (void)updateVUMeter {
    CGFloat width = (90+voiceSearch.audioLevel)*5/2;
    NSString *curval =[[NSNumber numberWithFloat:width] stringValue];
    NSLog(@"%@",curval);
    if(width>135){
        //Unlock for next update KEYWORD SuperSiri

     //[self.recordOverlay activate:&width];
    }
    [self setVUMeterWidth:width];
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.15];
}

#pragma mark -
#pragma mark UIImagePickerController
-(void) openCameraOrLibrary:(UIImagePickerControllerSourceType)type
{
    if([UIImagePickerController isSourceTypeAvailable:type])
    {
        
        self.cameraOverlay.frame = self.view.bounds;
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        [imagePicker setShowsCameraControls:NO];
        imagePicker.cameraOverlayView = self.cameraOverlay;
        [self presentViewController:imagePicker
                           animated:NO completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block  UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.sendimage = [image resizeImage:imagesize];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    picker = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self StartButtonAction:nil];
    });
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    picker = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self StartButtonAction:nil];
    });
}


//#pragma mark - MFMailComposeViewController delegate
//- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
#pragma mark PastUploads 
- (void)checkforpastuploads
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUInteger *size = (NSUInteger *)[appDelegate getCoresize];
    if(size > 0){
        UIAlertView *pastuploads = [[UIAlertView alloc] initWithTitle:@"Past Uploads" message:[NSString stringWithFormat:@"There are %lu document(s) would you like to upload them now?",(unsigned long)size] delegate:self cancelButtonTitle:@"Don't Ask Again" otherButtonTitles:@"Upload Now",@"Skip For Now", nil];
        pastuploads.tag = 3;
        [pastuploads show];
    }
}

- (void)attemptUpload{

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *oldFiles = [appDelegate oldSaves];
    self.oldUploadsuccessful = false;
        for (NSManagedObject *localSaves in oldFiles){
        [self retryUpload:localSaves];
    }


}

- (void)saveLocally{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveLocalFile:self.localtemp];
    
}


- (void)retryUpload:(NSManagedObject *)datatosend{
    
    NSString *temp = [datatosend valueForKey:@"savedData"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@submit",baseurl]];
    NSData *data = [[datatosend valueForKey:@"savedData"] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    data= nil;
    // upload message fail
    //UIAlertView *uploadFailMessage = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We apologize, however we’re having trouble submitting this entry at the moment." delegate:self cancelButtonTitle:@"Try Again Now" otherButtonTitles:@"Save And Upload Later", nil];

    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSRange range = [string rangeOfString:@"{"];
                 if(range.length > 0)
                 {
                     NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                     NSLog(@"%@",result);
                     if([result[@"success"] intValue] == 1)
                     {
                         //self.sendimage = nil;
                         //self.txtview.text = @"Description";
                         //[SVProgressHUD showErrorWithStatus:@"Upload Successful! Click your iPhone home button to close the app."];
                       
                        [SVProgressHUD showErrorWithStatus:@"Upload Successful!"];
                         [self deleteValueFromSave:datatosend];
                         self.localtemp = nil;
              
                     }
                     else
                     {
                         [SVProgressHUD showErrorWithStatus:@"Upload not successful, please try again."];
                         
                     }
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"Upload not successful, please try again."];
                     

                 }
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"No Connection"];

  
             }
             
         });
     }];
}


#pragma mark - SDK

#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    [self.recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    //[self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    [self.recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
    
    
}
- (void)recordType:(NSString *)values{

    if(self.Mileage){
        [self MileageTracker:values];
        NSLog(@"Mileage Record");
        return;
    }else if(self.Income){
        [self IncomeRecord:values];
        NSLog(@"Income Record");
        return;
    }else if(self.Transa){
        NSLog(@"Default Transaction");
        [self Transaction:values];
        return;
    }


}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    
    NSLog(@"Got results.");
   // NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
     BOOL added = false;
    NSString *rebuiltString = @"";
    
    if (numOfResults > 0)
    {
       
        NSArray *stringofValues = [[results firstResult] componentsSeparatedByString:@" "];
        for(int i = 0; i < [stringofValues count]; i++){
            if ([[stringofValues objectAtIndex:i] isEqualToString:@"end"]){
                if([[stringofValues objectAtIndex:(i+1)] rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound && [[stringofValues objectAtIndex:(i-1)] rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound ){
                    float totalamount = [[[stringofValues objectAtIndex:(i+1)] stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue] + [[[stringofValues objectAtIndex:(i-1)]stringByReplacingOccurrencesOfString:@"$" withString:@"" ] floatValue];
                    NSString *replacement = [NSString stringWithFormat:@"%@ %@ %@", [stringofValues objectAtIndex:(i-1)], [stringofValues objectAtIndex:(i)],[stringofValues objectAtIndex:(i+1)]];
                    if (self.Mileage){
                    rebuiltString = [[results firstResult] stringByReplacingOccurrencesOfString:replacement withString:[NSString stringWithFormat:[NSString stringWithFormat:@"%.1f", totalamount]]];
                    }else{
                    rebuiltString = [[results firstResult] stringByReplacingOccurrencesOfString:replacement withString:[NSString stringWithFormat:[NSString stringWithFormat:@"$%.2f", totalamount]]];
                    }
                    added = true;
                    
                }
                
            }
            
        }
            if ([self.txtview.text isEqualToString:@"Description"]){
                self.txtview.text = @"";
            }
        NSString *newText = @"";
        if(added){
            newText = rebuiltString;
        }else{
           newText = [results firstResult];
        }
            
            NSString *oldText = self.descriptiontext;
                       if([[newText substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"I "]){
                  self.descriptiontext = [NSString stringWithFormat:@"%@ %@",oldText,newText];
            }else{
          newText = [newText stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[newText substringToIndex:1] lowercaseString]];
             self.descriptiontext = [NSString stringWithFormat:@"%@ %@",oldText,newText];
            }
        
        //comment auto submission.
        //[self SubmitClicked:nil];
    }

    if (added){
        [self recordType:rebuiltString];
    }else{
    [self recordType:[results firstResult]];
    }
    

    
    
}
- (void)MileageTracker:(NSString *)values{
    self.amountset = true;
    if([values length] == 0){
        return;
    }
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    NSString *mileage = @"";
    [DateFormatter setDateFormat:@"MM/dd/yyyy 'at' hh:mm a"];
          //  NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            NSArray *stringofValues = [values componentsSeparatedByString:@" "];
    for(int i = 0; i < [stringofValues count]; i++){
        if([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:@"miles"]){
        NSString *amount = [[[stringofValues objectAtIndex:i-1] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
        float value = [amount floatValue];
        amount = [NSString stringWithFormat:@"%.1f", value];
        if (value > .001){
            mileage = amount;
            self.totalFilled = mileage;
            self.amountset = false;
        }
        }
    }
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    BOOL timeset = false;
    BOOL dateset = false;
    if ([[values lowercaseString] rangeOfString:@"today"].location !=NSNotFound){
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy"];
        NSString *yearString = [formater stringFromDate:[NSDate date]];
        [components setYear:[yearString integerValue]];
        
        [formater setDateFormat:@"MM"];
        NSString *monString = [formater stringFromDate:[NSDate date]];
        [components setMonth:[monString integerValue]];
        
        [formater setDateFormat:@"dd"];
        NSString *dayString = [formater stringFromDate:[NSDate date]];
        [components setDay:[dayString integerValue]];
        
        dateset = true;
        
    }
    if ([[values lowercaseString] rangeOfString:@"yesterday"].location !=NSNotFound){
        
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy"];
        NSString *yearString = [formater stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];
        [components setYear:[yearString integerValue]];
        
        [formater setDateFormat:@"MM"];
        NSString *monString = [formater stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];
        [components setMonth:[monString integerValue]];
        
        [formater setDateFormat:@"dd"];
        NSString *dayString = [formater stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];
        [components setDay:[dayString integerValue]];
        dateset = true;
        
    }

    if(!dateset){
    for (int b = 0;b<[self.dayValues count];b++){
        NSString *monthString = [self.dayValues objectAtIndex:b];
        for(int i = 0;i<[stringofValues count];i++){
            if ([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:[monthString lowercaseString]]){
                [components setMonth:b+1];
                if (i+1 < [stringofValues count]){
                    [components setDay:[[stringofValues objectAtIndex:i+1] integerValue]];
                }
                if (i+2 < [stringofValues count]){
                   
                    if ([[stringofValues objectAtIndex:i+2] rangeOfCharacterFromSet:notDigits].location == NSNotFound && [[stringofValues objectAtIndex:i+2] length]== 4 ){
                        [components setYear:[[stringofValues objectAtIndex:i+2] integerValue]];
                    }else{
                        NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                        [yearformat setDateFormat:@"yyyy"];
                        NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                        [components setYear:[yearString integerValue]];
                    }
                }else{
                    NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                    [yearformat setDateFormat:@"yyyy"];
                    NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                    [components setYear:[yearString integerValue]];
                }
                
                dateset = true;
                
            }
        }
        
    }
    }
    

        
    

    for(int i = 0;i<[stringofValues count];i++){
        if([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:@"am"]){
             if ([[stringofValues objectAtIndex:i-1] rangeOfString:@":"].location !=NSNotFound) {
                  NSArray *time = [[stringofValues objectAtIndex:i-1 ] componentsSeparatedByString:@":"];
                 [components setHour:[[time objectAtIndex:0] integerValue]];
                 [components setMinute:[[time objectAtIndex:1] integerValue]];
                 timeset = true;
                 break;
             }else{
                   [components setHour:[[stringofValues objectAtIndex:i-1] integerValue]];
                  timeset = true;
                 
             }
        }else if([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:@"pm"]){
            if ([[stringofValues objectAtIndex:i-1] rangeOfString:@":"].location !=NSNotFound) {
                NSArray *time = [[stringofValues objectAtIndex:i-1 ] componentsSeparatedByString:@":"];
                [components setHour:[[time objectAtIndex:0] integerValue] + 12];
                [components setMinute:[[time objectAtIndex:1] integerValue]];
                timeset = true;
            }else{
                [components setHour:[[stringofValues objectAtIndex:i-1] integerValue] +12];
                timeset = true;
            }
            
            
        }else if ([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:@"at"]){
            if (i+1 < [stringofValues count]){
                if([[stringofValues objectAtIndex:i+1] rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound){
                    if ([[stringofValues objectAtIndex:i+1] rangeOfString:@":"].location !=NSNotFound) {
                        NSArray *time = [[stringofValues objectAtIndex:i+1 ] componentsSeparatedByString:@":"];
                        if(i+2 < [stringofValues count]){
                            if ([[stringofValues objectAtIndex:i+2] isEqualToString:@"PM"]){
                                [components setHour:[[time objectAtIndex:0] integerValue] + 12];
                                [components setMinute:[[time objectAtIndex:1] integerValue]];
                            }else{
                                [components setHour:[[time objectAtIndex:0] integerValue]];
                                [components setMinute:[[time objectAtIndex:1] integerValue]];
                            }
                        }else{
                        [components setHour:[[time objectAtIndex:0] integerValue]];
                        [components setMinute:[[time objectAtIndex:1] integerValue]];
                        }
                    }else{
                        if(i+2 < [stringofValues count]){
                            if ([[stringofValues objectAtIndex:i+2] isEqualToString:@"PM"]){
                                [components setHour:[[stringofValues objectAtIndex:i+1] integerValue] + 12];
                            }else{
                                 [components setHour:[[stringofValues objectAtIndex:i+1] integerValue]];
                            }
                        }else{
                        [components setHour:[[stringofValues objectAtIndex:i+1] integerValue] + 12 ];
                        }
                    }
                  
                }
                timeset = true;
                NSLog(@"%@",[stringofValues objectAtIndex:i+1]);
            }
        }
    }

    if (!dateset && !timeset && [self.dateFilled isEqualToString:@""] ){
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
         self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
    }else if(!dateset && timeset){
    
        NSString *tempdate = [self.dateView.text stringByReplacingOccurrencesOfString:@"Date: " withString:@""];
        NSArray *temparray = [[[tempdate componentsSeparatedByString:@" at "] objectAtIndex:0] componentsSeparatedByString:@"/"];
        if ([temparray count] == 1){
            
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy"];
            NSString *yearString = [formater stringFromDate:[NSDate date]];
            [components setYear:[yearString integerValue]];
            
            [formater setDateFormat:@"MM"];
            NSString *monString = [formater stringFromDate:[NSDate date]];
            [components setMonth:[monString integerValue]];
            
            [formater setDateFormat:@"dd"];
            NSString *dayString = [formater stringFromDate:[NSDate date]];
            [components setDay:[dayString integerValue]];
            
        }else{
        NSString *yearString = [temparray objectAtIndex:2];
        [components setYear:[yearString integerValue]];
        

        NSString *monString = [temparray objectAtIndex:0];
        [components setMonth:[monString integerValue]];
        

        NSString *dayString = [temparray objectAtIndex:1];;
        [components setDay:[dayString integerValue]];
        }
        
        NSDate *date = [calendar dateFromComponents:components];
        

        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
        self.dateFilled = [DateFormatter stringFromDate:date];
    }else if(dateset && !timeset){
        NSString *tempdate = [self.dateView.text stringByReplacingOccurrencesOfString:@"Date: " withString:@""];
        if([tempdate length] == 0){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh"];
            [components setHour:[[formatter stringFromDate:[NSDate date]] integerValue]];
            
            [formatter setDateFormat:@"mm"];
            [components setMinute:[[formatter stringFromDate:[NSDate date]] integerValue]];
            
        }else{
        NSArray *temparray = [[[tempdate componentsSeparatedByString:@" at "] objectAtIndex:1] componentsSeparatedByString:@":"];
        
        if([[temparray objectAtIndex:1] rangeOfString:@"AM"].location != NSNotFound){
            
            [components setMinute:[[[temparray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" AM" withString:@""] integerValue]];
            [components setHour:[[temparray objectAtIndex:0] integerValue]];
        }else{
            
            [components setMinute:[[[temparray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" PM" withString:@""] integerValue]];
            [components setHour:[[temparray objectAtIndex:0] integerValue]+12];

        }
        }
        
        NSDate *date = [calendar dateFromComponents:components];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
        self.dateFilled = [DateFormatter stringFromDate:date];

    }else if(dateset && timeset){
        NSDate *date = [calendar dateFromComponents:components];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
        self.dateFilled = [DateFormatter stringFromDate:date];
    }

    
    if(!self.amountset){
            self.amountView.text = [NSString stringWithFormat:@"Mileage: %@ Miles",mileage];
        [self amountedit:self];
        self.amountset = true;
    }
            self.categoryView.text = @"Category: Mileage";
            self.payeeView.text = @"";
            //[DateFormatter setDateFormat:@"yyyy-mm-dd 'at' hh:mm a"];
    
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            
            self.txtview.text = self.descriptiontext;
}

-(void)IncomeRecord:(NSString *)values{
   // self.payeeView.userInteractionEnabled = YES;
    //self.categoryView.userInteractionEnabled = NO;
       if (self.Mileage){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = NO;
    }
    self.Mileage = NO;
    if (self.Transa){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = NO;
    }
    self.Transa = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
[DateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    /*

    if([values length] == 0){
        if([self.cateFilled  isEqual: @""]){
            NSString *cate = @"Money In - I Don't Know";
            self.categoryView.text =[NSString stringWithFormat:@"Category: %@", cate];
            self.cateSet = TRUE;
            self.cateFilled = [cate capitalizedString];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
            
        }
        
        return;
    }*/

      NSArray *stringofValues = [values componentsSeparatedByString:@" "];
      NSString *total = @"";
      NSString *method = @"";
     AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    NSArray *defaultsPayments = [appdele getIncomeMethods];
   
    for (int i = 0; i < [stringofValues count]; i++){
        NSString *temp = [stringofValues objectAtIndex:i];
        if ([temp rangeOfString:@"$"].location != NSNotFound ){
            NSLog(@"%@", temp);
            total = [temp lowercaseString];
            self.amountset = FALSE;
        }
        for (NSString *types in defaultsPayments)
        if ([[temp lowercaseString] rangeOfString:[types lowercaseString]].location !=NSNotFound){
            method = types;
            self.methodSet = FALSE;
            
        }
    }
    
    bool sourceFound = false;
    for (NSString *sourceName in [appdele LoadSource]){
        if (!sourceFound){
            NSUInteger lengthOfComp = [sourceName length];
            lengthOfComp = lengthOfComp - (lengthOfComp/3.5);
            // NSString *temp = [[comp lowercaseString] substringWithRange:NSMakeRange(0, lengthOfComp)];
            if([[values lowercaseString] rangeOfString:[sourceName lowercaseString]].length > lengthOfComp){
                //NSLog(@"my range is %@", NSStringFromRange([[values lowercaseString] rangeOfString:temp] ));
                NSLog(@"%@",sourceName);
                self.payeeView.text = [NSString stringWithFormat:@"Source: %@",sourceName];
                self.companyToPFilled = sourceName;
                self.compSet = TRUE;
                sourceFound = true;
            }
        }
        
    }
    if(!sourceFound){
        for (int i = 0; i < [stringofValues count]; i++){
            NSString *word = [stringofValues objectAtIndex:i];
            if ([[word lowercaseString] isEqualToString:@"from" ] || [[word lowercaseString] isEqualToString:@"by"]){
                if ((i+1) < [stringofValues count]){
                    self.payeeView.text = [NSString stringWithFormat:@"Source: %@",[stringofValues objectAtIndex:(i+1)]];
                     self.companyToPFilled = [stringofValues objectAtIndex:(i+1)];
                    self.compSet = TRUE;
                    sourceFound = true;
                }
            }
        }
    }
    
    

   
    BOOL dateset = false;
    if ([[values lowercaseString] rangeOfString:@"today"].location !=NSNotFound  && [values length] != 0){
        
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.categoryView.userInteractionEnabled = YES;
        dateset = true;
        
    }
    if ([[values lowercaseString] rangeOfString:@"yesterday"].location !=NSNotFound  && [values length] != 0){
        self.dateFilled = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.categoryView.userInteractionEnabled = YES;
        dateset = true;
        
    }
    if(!dateset){
    for (int b = 0;b<[self.dayValues count];b++){
        NSString *monthString = [self.dayValues objectAtIndex:b];
        for(int i = 0;i<[stringofValues count];i++){
            if ([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:[monthString lowercaseString]]){
                [components setMonth:b+1];
                if (i+1 < [stringofValues count]){
                    [components setDay:[[stringofValues objectAtIndex:i+1] integerValue]];
                }
                if (i+2 < [stringofValues count]){
                    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                    if ([[stringofValues objectAtIndex:i+2] rangeOfCharacterFromSet:notDigits].location == NSNotFound && [[stringofValues objectAtIndex:i+2] length]== 4 ){
                        [components setYear:[[stringofValues objectAtIndex:i+2] integerValue]];
                    }else{
                        NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                        [yearformat setDateFormat:@"yyyy"];
                        NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                        [components setYear:[yearString integerValue]];
                    }
                }else{
                    NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                    [yearformat setDateFormat:@"yyyy"];
                    NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                    [components setYear:[yearString integerValue]];
                }
                NSDate *date = [calendar dateFromComponents:components];
                self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
                [DateFormatter setDateFormat:@"yyyy-MM-dd"];
                self.dateFilled = [DateFormatter stringFromDate:date];
                dateset = true;
            }
        }
        
    }
    }
    
        /*
        if([[values lowercaseString] rangeOfString:@"earned income"].location !=NSNotFound || [[values lowercaseString] rangeOfString:@"earned"].location !=NSNotFound){
             self.categoryView.text = @"Category: Money In - Earned Income";
             self.cateFilled = @"Money In - Earned Income";
            self.cateSet = YES;
        }else{
            if(!self.cateSet){
            self.categoryView.text = @"Category: Money In - I Don't Know";
            self.cateFilled = @"Money In - I Don't Know";
            self.cateSet= YES;
            }else if([[self.categoryView.text componentsSeparatedByString:@":"] count] == 1){
                self.categoryView.text = @"Category: Money In - I Don't Know";
                self.cateFilled = @"Money In - I Don't Know";
                self.cateSet= YES;

            }
        }*/
    
    
    if (!dateset && [self.dateFilled isEqualToString:@""]){
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        
    }
    
    if(!self.amountset){
        self.amountView.text = [NSString stringWithFormat:@"Amount: %@",[[total stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@"" ]] ;
        [self amountedit:self];
        self.totalFilled = [[total stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        self.amountset = true;
    }
    if (!self.compSet){
        self.payeeView.text = @"Source: ";
        
    }
    if (!self.methodSet){
        
        self.methodView.text =[NSString stringWithFormat:@"Method: %@",[method capitalizedString]];
        self.paymentMethodFilled = [method capitalizedString];
        self.methodSet = TRUE;
    }

    self.txtview.text = self.descriptiontext;
    
}


-(void)Transaction:(NSString *)values{


    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.payeeView.autocompleteType = HTAutocompleteTypeComp;
  
    NSString *total;
    NSString *paymentMethod;
    NSString *cardEnding;
    NSString *cate;
    NSString *companyToP;
    total = @"";
    paymentMethod = @"";
    cardEnding = @"";
    cate= @"";
    companyToP = @"";

    
    BOOL amex = false;
    BOOL cardFound = false;
    BOOL cardNumberFound = false;
    if (self.Mileage){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = NO;
    }
    self.Mileage = NO;
    if (self.Income){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = NO;
    }
    self.Income = NO;
    
  
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
      NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    if([values length] == 0){
        if([self.cateFilled  isEqual: @""]){
            cate = @"Money Out - I Don't Know";
            self.categoryView.text =[NSString stringWithFormat:@"Category: %@", cate];
            self.cateSet = TRUE;
            self.cateFilled = [cate capitalizedString];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
            
        }
        
        return;
    }
    NSArray *stringofValues = [values componentsSeparatedByString:@" "];

    BOOL valid;
    
        if (!self.amountset){
            self.amountView.text = @"Amount: ";
        }
        if (!self.methodSet){
            self.methodView.text = @"Method: ";
        }
        if (!self.compSet){
            self.payeeView.text = @"Payee: ";
        }
        if (!self.cateSet){
            self.categoryView.text = @"Category: ";
        }
      BOOL dateset = false;

    if ([[values lowercaseString] rangeOfString:@"today"].location !=NSNotFound && [values length] != 0){
   
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.categoryView.userInteractionEnabled = YES;
        dateset = true;
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        
    }
    if ([[values lowercaseString] rangeOfString:@"yesterday"].location !=NSNotFound && [values length] != 0){
        
      
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.categoryView.userInteractionEnabled = YES;
        dateset = true;
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];

    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];

    if(!dateset){
    for (int b = 0;b<[self.dayValues count];b++){
        NSString *monthString = [self.dayValues objectAtIndex:b];
        for(int i = 0;i<[stringofValues count];i++){
            if ([[[stringofValues objectAtIndex:i] lowercaseString] isEqualToString:[monthString lowercaseString]]){
                              [components setMonth:b+1];
                if (i+1 < [stringofValues count]){
                 [components setDay:[[stringofValues objectAtIndex:i+1] integerValue]];
                }
                if (i+2 < [stringofValues count]){
                    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                    if ([[stringofValues objectAtIndex:i+2] rangeOfCharacterFromSet:notDigits].location == NSNotFound && [[stringofValues objectAtIndex:i+2] length]== 4 ){
                        [components setYear:[[stringofValues objectAtIndex:i+2] integerValue]];
                    }else{
                        NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                        [yearformat setDateFormat:@"yyyy"];
                        NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                        [components setYear:[yearString integerValue]];
                    }
                }else{
                    NSDateFormatter *yearformat = [[NSDateFormatter alloc] init];
                    [yearformat setDateFormat:@"yyyy"];
                    NSString *yearString = [yearformat stringFromDate:[NSDate date]];
                    [components setYear:[yearString integerValue]];
                }
                NSDate *date = [calendar dateFromComponents:components];
                self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
                [DateFormatter setDateFormat:@"yyyy-MM-dd"];
                self.dateFilled = [DateFormatter stringFromDate:date];
                dateset = YES;
                
                }
            }
        
    }
}
    if (!dateset) {
        if ([self.dateFilled isEqualToString:@""]){
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        }

    }
        self.amountset = true;
        for (int i = 0; i < [stringofValues count]; i++){
            NSString *temp = [stringofValues objectAtIndex:i];
            if ([temp rangeOfString:@"$"].location != NSNotFound ){
                NSLog(@"%@", temp);
                total = [temp lowercaseString];
                self.amountset = FALSE;
            }
            for (NSString *types in self.paymentTypes){
                if (!cardFound){
                    if([[types lowercaseString] rangeOfString:[temp lowercaseString]].length > 3){
                        NSLog (@"%@", temp);
                        if( [[temp lowercaseString] isEqualToString:@"amex"]){
                            goto amexjump;
                        }
                        if((i+1) < [stringofValues count]){
                            if ([[[stringofValues objectAtIndex:i+1] lowercaseString] isEqualToString:@"express"]){
                            amexjump:
                                amex = true;
                                paymentMethod = @"American Express";
                                cardEnding = @"";
                                cardFound = true;
                                self.methodSet = FALSE;
                                break;
                            }
                        }
                        
                        paymentMethod = types;
                        self.methodSet = FALSE;
                        cardEnding = @"";
                        cardFound = true;
                        break;
                    }
                    
                }
            }
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:temp];
            valid = [alphaNums isSupersetOfSet:inStringSet];
            if(valid){
                if((temp.length == 4 && !amex)  || (temp.length == 5 && amex)){
                    cardEnding = temp;
                    cardNumberFound = true;
                }
                
            }
            NSArray *transactionCategorys =  [NSArray arrayWithObjects:@"Money Out",@"Advertising/Marketing",@"Automotive",@"Bank/CC Fees",@"Charity/Medical/Misc. Tax Deductions",@"Cost Of Goods",@"Credit Card/Loan Payments",@"Dues/Subscriptions/Professional Fees",@"Insurance/Licenses/Permits",@"Meals/Travel/Entertainment",@"Rent/Utilities",@"Sub-Contractor",@"Supplies/Equipment",@"Telecommunications",nil];
            
            bool categoryFound = false;
            
            if([[values lowercaseString] rangeOfString:@"tax deductions"].location !=NSNotFound){
                cate = @"Charity/Medical/Misc. Tax Deductions";
                self.cateSet = FALSE;
                categoryFound = true;
                
            }else if([[values lowercaseString] rangeOfString:@"subcontractor"].location !=NSNotFound){
                cate = @"Sub-Contractor";
                self.cateSet = FALSE;
                categoryFound = true;
            }else if([[values lowercaseString] rangeOfString:@"credit card fees"].location !=NSNotFound){
                cate = @"Bank/CC Fees";
                self.cateSet = FALSE;
                categoryFound = true;
            }else{
            for (NSString *categories in transactionCategorys){
                if([categories rangeOfString:@"/"].location != NSNotFound){
                    NSArray *temp = [categories componentsSeparatedByString:@"/"];
                    for(NSString *temp2 in temp){
                    if([[values lowercaseString] rangeOfString:[temp2 lowercaseString]].location != NSNotFound){
                        cate = categories;
                        self.cateSet = FALSE;
                        NSLog(@"%@",cate);
                        categoryFound = true;
                    }
                        }
                    
                }else{
                   if([[values lowercaseString] rangeOfString:[categories lowercaseString]].location != NSNotFound){
                       if([[categories lowercaseString] rangeOfString:@"money out"].location !=NSNotFound){
                           cate = @"Money Out - I Don't Know";
                           self.cateSet = FALSE;
                           NSLog(@"%@",cate);
                           categoryFound = true;
                       }else{
                           cate = categories;
                           self.cateSet = FALSE;
                           NSLog(@"%@",cate);
                           categoryFound = true;
                       }
          
                }
                }
            }
                NSArray *randomstuff = [self.categoryView.text componentsSeparatedByString:@": "];
            if(!categoryFound && self.cateFilled == @""){
                cate = @"Money Out - I Don't Know";
                self.cateSet = FALSE;
                //NSLog(@"%@",cate);
            }
            }
            
    
            
            // Trial of new search Algorthm
                  bool compfound = false;
             for (NSString *sourceName in self.companys){
                 if (!compfound){
                     NSArray *companyNameBreakDown = [sourceName componentsSeparatedByString:@" "];
                     
                     NSUInteger companyNameSize = [companyNameBreakDown count];
                     if([[values lowercaseString] rangeOfString:[[companyNameBreakDown objectAtIndex:0] lowercaseString]].location != NSNotFound){
                         
                         NSUInteger locationofString = [[values lowercaseString] rangeOfString:[[companyNameBreakDown objectAtIndex:0] lowercaseString]].location;
                         NSUInteger stringsize = [values length];
                         NSString *choppedString = [values substringWithRange:NSMakeRange(locationofString, stringsize-locationofString)];
                        
                         NSArray *potentialCompanyBreakDown = [choppedString componentsSeparatedByString:@" "];

                         if([[potentialCompanyBreakDown objectAtIndex:0] length] == [[companyNameBreakDown objectAtIndex:0] length]){
                             if(companyNameSize >= 3 && [potentialCompanyBreakDown count] >= 3){
                                     if([[[potentialCompanyBreakDown objectAtIndex:1] lowercaseString] isEqualToString:[[companyNameBreakDown objectAtIndex:1] lowercaseString]] ){
                                         if([[[potentialCompanyBreakDown objectAtIndex:2] lowercaseString] isEqualToString:[[companyNameBreakDown objectAtIndex:2] lowercaseString]] ){
                                             companyToP = sourceName;
                                             self.compSet = FALSE;
                                             compfound = true;
                                             break;
                                         }
                                     }
                                 
                             }
                             
                             
                             
                             if(companyNameSize >= 2 && [potentialCompanyBreakDown count] >= 2){
                             if([[[potentialCompanyBreakDown objectAtIndex:1] lowercaseString] isEqualToString:[[companyNameBreakDown objectAtIndex:1] lowercaseString]] ){
                                 companyToP = sourceName;
                                 self.compSet = FALSE;
                                 compfound = true;
                                 break;
                                 
                             }
                             }else{
                                 companyToP = sourceName;
                                 self.compSet = FALSE;
                                 compfound = true;
                                 break;
                                 
                             }
                         }
                         
                 }
                 }
             }
            
            /*
            
            bool compfound = false;
            for (NSString *sourceName in self.companys){
                if (!compfound){
                NSUInteger lengthOfComp = [sourceName length];
                lengthOfComp = lengthOfComp - (lengthOfComp/3.5);
               // NSString *temp = [[comp lowercaseString] substringWithRange:NSMakeRange(0, lengthOfComp)];
                if([[values lowercaseString] rangeOfString:[sourceName lowercaseString]].length > lengthOfComp){
                    NSLog(@"my range is %@", NSStringFromRange([[values lowercaseString] rangeOfString:temp] ));
                    NSLog(@"%@",sourceName);
                    companyToP = sourceName;
                    self.compSet = FALSE;
                    compfound = true;
                }
                }
                
            }
             */
        }
        NSString *card = @"";
        BOOL savedCard = NO;
        
        if(![paymentMethod isEqualToString:@""] && ![cardEnding isEqualToString:@""]){
            if((amex && cardEnding.length == 5) || (cardEnding.length == 4 && !amex)){
                if(!amex){
                    if([paymentMethod rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound){
                        NSArray *clean = [paymentMethod componentsSeparatedByString:@" "];
                        paymentMethod = [clean objectAtIndex:0];
                    }
                }
                card = [NSString stringWithFormat:@"%@ %@", [paymentMethod capitalizedString], cardEnding];
                savedCard = [appDelegate saveCardInfo:card];
                if (savedCard){
                    self.methodSet = FALSE;
                }
                
            }
        }else{
            NSArray *cards = [appDelegate getCards];
            for (NSString *value in cards){
                if([[value lowercaseString] rangeOfString:[paymentMethod lowercaseString]].location != NSNotFound){
                    card = value;
                    self.methodSet = FALSE;
                }
            }
        }
        //NSString *values = [NSString stringWithFormat:@"Amount: %@ \nPayment Method: %@ %@ \nCategory: %@ \nPayee: %@ \n\nDescription:%@", total,[paymentMethod capitalizedString],cardEnding,[cate capitalizedString],companyToP,self.descriptiontext ];
        if (!self.amountset){
            NSString *amount = [[[total stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
            if(![amount isEqualToString:@""]){
            float value = [amount floatValue];
            total = [NSString stringWithFormat:@"%.2f", value];
            self.amountView.text  = [NSString stringWithFormat:@"Amount: $%@", total];
            [self amountedit:self];
            self.amountset = TRUE;
            self.totalFilled = total;
            }
            
        }
        if (!self.methodSet){
            if([card isEqualToString:@""]){
                if (cardFound && cardNumberFound){
                    
                    self.methodView.text = [NSString stringWithFormat:@"Method: %@ %@",[paymentMethod capitalizedString], [cardEnding stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    self.paymentMethodFilled = [NSString stringWithFormat:@"%@ %@",[paymentMethod capitalizedString], [cardEnding stringByReplacingOccurrencesOfString:@" " withString:@""]];
                }else if(cardFound){
                    self.methodView.text = [NSString stringWithFormat:@"Method: %@",[paymentMethod capitalizedString]];
                    self.paymentMethodFilled = [paymentMethod capitalizedString];
                }
            }else{
                self.methodView.text = [NSString stringWithFormat:@"Method: %@", card];
                self.paymentMethodFilled = card;
            }
        }
        self.methodSet = TRUE;
    
    if (!self.cateSet){
        self.categoryView.text =[NSString stringWithFormat:@"Category: %@", cate];
        self.cateSet = TRUE;
        self.cateFilled = [cate capitalizedString];
    }
    if (!self.compSet){
        self.payeeView.text = [NSString stringWithFormat:@"Payee: %@", companyToP];
        self.compSet = TRUE;
        self.companyToPFilled = companyToP;
    }
    
    
    self.txtview.text = self.descriptiontext;

}

// textfield stuff


- (IBAction)amountedit:(id)sender {
    NSArray *componentsString = [self.amountView.text componentsSeparatedByString:@": "];
    if(componentsString.count == 1){
        return;
    }
    if([[componentsString objectAtIndex:1] isEqualToString:@""]){
        [self.CategoryPicker setHidden:YES];
        if([self.methodView isFirstResponder]){
        [self.pickerDoneBtn setHidden:YES];
        }
        [self.amountView resignFirstResponder];
    }else{
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *amount = [[[[componentsString objectAtIndex:1] stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"," withString:@""];
    float value = [amount floatValue];

  
    if(self.Mileage){
        //  amount = [NSString stringWithFormat:@"%.1f", value];
       
         self.amountView.text = [NSString stringWithFormat:@"Mileage: %.1f Miles", value];
        self.totalFilled = [NSString stringWithFormat:@"$%.1f", value];

    }else{
     //   amount = [NSString stringWithFormat:@"%.2f", value];
    self.amountView.text = [NSString stringWithFormat:@"Amount: $%.2f", value];
        self.totalFilled = [NSString stringWithFormat:@"$%.2f", value];
    }
    [self.CategoryPicker setHidden:YES];
        if(!([self.methodView isFirstResponder]||[self.payeeView isFirstResponder])){
    [self.pickerDoneBtn setHidden:YES];
        }
    [self.amountView resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if(textField == self.methodView){
         NSString *methodtext = @"Method:";
        
        if (range.location > methodtext.length)
        {
            return YES;
           //  NSLog(@"I'm Method Edit YES");
        }else{
           // NSLog(@"I'm Method Edit NO");
            return NO;

        }
        
    }
    if(textField == self.payeeView){
        
        NSString *payee = @"Payee:";
        if (range.location > payee.length)
        {
            return YES;
        }else{

            return NO;
            
        }
    }
    if(textField == self.amountView){
        if(self.Mileage){
            NSString *amountText = @"Mileage:";
            if (range.location > amountText.length)
            {
                return YES;
            }else{
                
                return NO;
                
            }

        }else{
            NSString *amountText = @"Amount:";
            if (range.location > amountText.length)
            {

                return YES;
            }else{
                
                return NO;
                
            }
        }
    }
    if(textField == self.dateView){
        
        if(!self.Mileage){
        NSString *dateText = @"Date:";
        NSArray *dateTextFormat = [self.dateView.text componentsSeparatedByString:@":"];
        NSString *currenttextDate = [dateTextFormat objectAtIndex:1];
        currenttextDate = [self formatDate:currenttextDate];
        NSUInteger length = currenttextDate.length;
        if (range.location > dateText.length){
            NSLog(@"Range:%lu",range.length);
            NSLog(@"Length:%lu",length);
            NSLog(@"Replacement:%@",string);
            if (range.length == 0){
                switch (length) {
                    case 0:
                        if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"]){
                            
                        }else{
                            return NO;
                        }
                        break;
                    case 1:
                        if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"] ||  [string isEqualToString:@"2"]){
                            
                        }else{
                            return NO;
                        }
                        break;
                    case 2:
                        if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"] ||  [string isEqualToString:@"2"] || [string isEqualToString:@"3"]){
                            
                        }else{
                            return NO;
                        }
                        break;
                    case 4:
                        if ([string isEqualToString:@"2"]){
                            
                        }else{
                            return NO;
                        }
                        break;
                    case 5:
                        if ([string isEqualToString:@"0"]){
                            
                        }else{
                            return NO;
                        }
                        break;
                    case 6:
                        if ([string isEqualToString:@"0"]|| [string isEqualToString:@"1"]){
                            
                        }else{
                            return NO;
                        }
                        break;

                    default:
                        break;
                }
            }
            
            if(length == 8)
            {
                if(range.length == 0)
                    return NO;
            }
            
            if(length == 2)
            {
                NSString *num = [self formatDate:currenttextDate];
                textField.text = [NSString stringWithFormat:@"Date: %@/",num];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"Date: %@",[num substringToIndex:2]];
            }
            else if(length == 4)
            {
                NSString *num = [self formatDate:currenttextDate];
                //NSLog(@"%@",[num  substringToIndex:3]);
                //NSLog(@"%@",[num substringFromIndex:3]);
                textField.text = [NSString stringWithFormat:@"Date: %@/%@/",[num  substringToIndex:2],[num substringFromIndex:2]];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"Date: %@/%@",[num substringToIndex:2],[num substringFromIndex:2]];
            }else if(length == 8){

            }
            
            return YES;
        }else{
            
            
            return NO;
        }
        }else{
            NSString *dateText = @"Date:";
            NSArray *dateTextFormat = [self.dateView.text componentsSeparatedByString:@":"];
            NSString *currenttextDate = [dateTextFormat objectAtIndex:1];
            currenttextDate = [self formatDate:currenttextDate];
            NSUInteger length = currenttextDate.length;
            if (range.location > dateText.length){
                NSLog(@"Range:%lu",range.length);
                NSLog(@"Length:%lu",length);
                NSLog(@"Replacement:%@",string);
                if (range.length == 0){
                    switch (length) {
                        case 0:
                            if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                        case 1:
                            if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"] ||  [string isEqualToString:@"2"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                        case 2:
                            if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"] ||  [string isEqualToString:@"2"] || [string isEqualToString:@"3"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                        case 4:
                            if ([string isEqualToString:@"2"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                        case 5:
                            if ([string isEqualToString:@"0"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                        case 6:
                            if ([string isEqualToString:@"0"]|| [string isEqualToString:@"1"]){
                                
                            }else{
                                return NO;
                            }
                            break;
                            
                        default:
                            break;
                    }
                }
                
                if(length == 13)
                {
                    if(range.length == 0)
                        return NO;
                }
                
                if(length == 2)
                {
                    NSString *num = [self formatDate:currenttextDate];
                    textField.text = [NSString stringWithFormat:@"Date: %@/",num];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"Date: %@",[num substringToIndex:2]];
                }
                else if(length == 4)
                {
                    NSString *num = [self formatDate:currenttextDate];
                    //NSLog(@"%@",[num  substringToIndex:3]);
                    //NSLog(@"%@",[num substringFromIndex:3]);
                    textField.text = [NSString stringWithFormat:@"Date: %@/%@/",[num  substringToIndex:2],[num substringFromIndex:2]];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"Date: %@/%@",[num substringToIndex:2],[num substringFromIndex:2]];
                }else if(length == 8){
                    NSString *num = [self formatDate:currenttextDate];
                        NSLog(@"Substring 2:%@",[num substringFromIndex:2]);
                        NSLog(@"Substring 4:%@",[num substringFromIndex:4]);
                        NSLog(@"Substring 6:%@",[num substringFromIndex:6]);
                        NSLog(@"Substring 1:%@",[num substringFromIndex:1]);
                        NSLog(@"Substring 3:%@",[num substringFromIndex:3]);

                    
                    //NSLog(@"%@",[num  substringToIndex:3]);
                    //NSLog(@"%@",[num substringFromIndex:3]);
                    textField.text = [NSString stringWithFormat:@"Date: %@/%@/%@ at ",[num  substringToIndex:2],[num substringFromIndex:2],[num substringFromIndex:4]];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"Date: %@/%@/%@",[num substringToIndex:2],[num substringFromIndex:2],[num substringWithRange:NSMakeRange(4,7)]];
                }
                
                return YES;

        }
        
        }
    }

    
    return YES;
    
}
-(NSString*)formatDate:(NSString*)dateToChange
{
    
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@"/" withString:@""];
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@"at" withString:@""];
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@"t" withString:@""];
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@"a" withString:@""];
    dateToChange = [dateToChange stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", dateToChange);
    
    int length = (int)dateToChange.length;
    if(length > 10)
    {
        dateToChange = [dateToChange substringFromIndex: length-10];
        NSLog(@"%@", dateToChange);
        
    }
    
    
    return dateToChange;
}

-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"/" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@":" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"at" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int length = (int)mobileNumber.length;
    
    return length;
    
}

//Date has completed finished being edited
- (IBAction)endofDateEdit:(id)sender{

}



- (IBAction)editEndforMethod:(id)sender {
    HTAutocompleteTextField *textfield = (HTAutocompleteTextField *)sender;

    
    if (textfield == self.payeeView){
    NSArray *componentsString = [self.payeeView.text componentsSeparatedByString:@":"];
    NSString *payee = [componentsString objectAtIndex:1];
        if (self.Transa){
    self.payeeView.text = [NSString stringWithFormat:@"Payee:%@", [payee capitalizedString]];
        self.companyToPFilled = [payee capitalizedString];
        }
        if (self.Income){
            self.payeeView.text = [NSString stringWithFormat:@"Source:%@", [payee capitalizedString]];
            if(![payee isEqualToString:@""]){
                self.compSet = true;
            }
            self.companyToPFilled = [payee capitalizedString];
        }
        [textfield resignFirstResponder];
 
     }
    
    if (textfield == self.methodView){
        if (self.Income){
            NSArray *componentsString = [self.methodView.text componentsSeparatedByString:@":"];
            NSString *incomeMethod = [componentsString objectAtIndex:1];
            self.paymentMethodFilled = [incomeMethod capitalizedString];
            self.methodView.text  = [NSString stringWithFormat:@"Method:%@" ,[incomeMethod capitalizedString]];
            
        }
        if (self.Transa){
            //BOOL saved = NO;
           // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSString *cleanup = self.methodView.text;
            NSArray *componentsString = [cleanup componentsSeparatedByString:@":"];
            NSString *card = [componentsString objectAtIndex:1];
            NSRange range = NSMakeRange(0,1);
            if([card characterAtIndex:0] == ' '){
                card = [card stringByReplacingCharactersInRange:range withString:@""];
            }            
            NSString *cardnumber = [[card componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
            NSLog(@"card number:%@", cardnumber);
            int cNSize = (int)[cardnumber length];
            card = [card stringByReplacingOccurrencesOfString:cardnumber withString:@""];
            // card = [card stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([card isEqualToString:@""]){
                // [self.categoryView becomeFirstResponder];
                return;
            }
            if ([[card lowercaseString] rangeOfString:@"american"].length > 5){
                if (cNSize == 5){
                    card = [NSString stringWithFormat:@"American Express %@" , cardnumber];
                    //saved = [appDelegate saveCardInfo:card];
                    NSLog(@"Method: %@",card);
                   // NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                    self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                    //   [self.categoryView becomeFirstResponder];
                    return;
                }
            }
            if(cNSize == 4 ){
                card = [[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([[card lowercaseString] isEqualToString:@"visa"] || [[card lowercaseString] isEqualToString:@"mastercard"]|| [[card lowercaseString] isEqualToString:@"discover"]){
                    card = [NSString stringWithFormat:@"%@ %@", [card capitalizedString], cardnumber];
                    //saved = [appDelegate saveCardInfo:card];
                    NSLog(@"Method: %@",card);
                   // NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                    self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                    //   [self.categoryView becomeFirstResponder];
                    return;
                }
            }
            
            if(cNSize == 0 && !([[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]  rangeOfString:@"visa"].length > 3 || [[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:@"mastercard"].length > 7 || [[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:@"discover"].length > 7)){
                card = [NSString stringWithFormat:@"%@",card];
                //saved = [appDelegate saveCardInfo:card];
                NSLog(@"Method: %@",card);
                //NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                // [textfield resignFirstResponder];
                //   [self.categoryView becomeFirstResponder];
                return;
            }
            
            NSLog(@"%@" , [NSString stringWithFormat:@"%lu",(unsigned long)[cardnumber length]]);
            NSLog(@"Method: %@",card);
           // NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
        }else{
            
            NSLog(@"Mileage, No save");
        }

    }
  
}
#pragma Save Core Data
// Saves Payment Method into core data for later use

- (void)cardSave{
    
    if (!self.Mileage){
        BOOL saved = NO;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString *cleanup = self.methodView.text;
        NSArray *componentsString = [cleanup componentsSeparatedByString:@":"];
        NSString *card = [componentsString objectAtIndex:1];
        NSString *cardnumber = [[card componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSLog(@"card number:%@", cardnumber);
        int cNSize = (int)[cardnumber length];
        card = [card stringByReplacingOccurrencesOfString:cardnumber withString:@""];
        // card = [card stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([card isEqualToString:@""]){
            // [self.categoryView becomeFirstResponder];
            return;
        }
        if ([[card lowercaseString] rangeOfString:@"american"].length > 5){
            if (cNSize == 5){
                card = [NSString stringWithFormat:@"American Express %@" , cardnumber];
                saved = [appDelegate saveCardInfo:card];
                NSLog(@"Method: %@",card);
                NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                //   [self.categoryView becomeFirstResponder];
                return;
            }
        }
        if(cNSize == 4 ){
            card = [[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([[card lowercaseString] isEqualToString:@"visa"] || [[card lowercaseString] isEqualToString:@"mastercard"]|| [[card lowercaseString] isEqualToString:@"discover"]){
                card = [NSString stringWithFormat:@"%@ %@", [card capitalizedString], cardnumber];
                saved = [appDelegate saveCardInfo:card];
                NSLog(@"Method: %@",card);
                NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                //   [self.categoryView becomeFirstResponder];
                return;
            }
        }
        
        if(cNSize == 0 && !([[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]  rangeOfString:@"visa"].length > 3 || [[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:@"mastercard"].length > 7 || [[[card lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:@"discover"].length > 7) ){
            card = [NSString stringWithFormat:@"%@",card];
            saved = [appDelegate saveCardInfo:card];
            NSLog(@"Method: %@",card);
            NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
            self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
           // [textfield resignFirstResponder];
            //   [self.categoryView becomeFirstResponder];
            return;
        }
        
        NSLog(@"%@" , [NSString stringWithFormat:@"%lu",(unsigned long)[cardnumber length]]);
        NSLog(@"Method: %@",card);
        NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
    }else{
        
        NSLog(@"Mileage, No save");
    }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    if (self.Transa){
    if (!self.amountset){
        self.amountView.text = @"Amount: ";
    }
    if (!self.methodSet){
        self.methodView.text = @"Method: ";
    }
    if (!self.compSet){
        self.payeeView.text = @"Payee: ";
    }
    if (!self.cateSet){
        
        self.cateSet = TRUE;
        self.categoryView.text = @"Category: Money Out - I Don't Know";
        self.cateFilled =@"Money Out - I Don't Know";
    }
    if ([self.txtview.text isEqualToString:@""]){
    self.txtview.text = @"Description";
    }
    if ([self.dateView.text isEqualToString:@"Date: "]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
    }
        self.methodView.userInteractionEnabled = YES;
        self.payeeView.userInteractionEnabled = YES;
    }else if(self.Mileage){
        if (!self.amountset){
            self.amountView.text = @"Mileage: ";
        }
        if (!self.methodSet){
            self.methodView.text = @"";
        }
        if (!self.compSet){
            self.payeeView.text = @"";
        }
        if (!self.cateSet){
            self.categoryView.text = @"Category: Mileage";
        }
        if ([self.txtview.text isEqualToString:@""]){
            self.txtview.text = @"Description";
        }
        if ([self.dateView.text isEqualToString:@"Date: "]){
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"MM/dd/yyyy 'at' hh:mm a"];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        }
        self.methodView.userInteractionEnabled = NO;
        self.payeeView.userInteractionEnabled = NO;
    }else if(self.Income){
        
        if (!self.amountset){
            self.amountView.text = @"Amount: ";
        }
        if (!self.methodSet){
            self.methodView.text = @"Method: ";
        }
        if (!self.compSet){
            self.payeeView.text = @"Source: ";
        }
        if (!self.cateSet){
            self.categoryView.text = @"Category: Money In - I Don't Know";
        }
        if ([self.txtview.text isEqualToString:@""]){
            self.txtview.text = @"Description";
        }
        if ([self.dateView.text isEqualToString:@"Date: "]){
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"MM/dd/yyyy"];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        }
        self.methodView.userInteractionEnabled = YES;
        self.payeeView.userInteractionEnabled = YES;
    }
    //NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];

    if(error.code != 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    NSLog(@"%@", suggestion);
//    if (suggestion) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
//                                                        message:suggestion
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
//
//    }
    voiceSearch = nil;
    [self setVUMeterWidth:0.];
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([str isEqualToString:@"Description"])
    {
        textView.text = @"";
    }
    [self.pickerDoneBtn setHidden:YES];
    [self.timePicker setHidden:YES];
    
    if (transactionState == TS_RECORDING) {
        //[self.voiceSearch stopRecording];
        [self.voiceSearch cancel];

    }
    [self.voiceSearch cancel];
    if (isiPhone5)
    {}else{
        
    }
    

    return TRUE;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([str isEqualToString:@""])
    {
        self.descriptiontext = @"";
        textView.text = @"Description";
    }else{
        self.descriptiontext = self.txtview.text;
    }
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)deleteValueFromSave:(NSManagedObject *)objecttodelete{
    
     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate deleteOldCore:objecttodelete];
    
}

- (BOOL)checkprofile{
    
     NSString *strguid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_guid"];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@profile?guid=",baseurl]stringByAppendingString:strguid]];
    //NSLog(@"companyLogo:%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [SVProgressHUD show];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
     NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([result[@"show_personal_info_form"] boolValue]){
        return true;
    }else{
        return false;
    }
}

- (void)cancelrecording:(id)sender{
    //Unlock for next update KEYWORD SuperSiri
    //[self.recordOverlay willMoveToParentViewController:nil];
    //[self.recordOverlay.view removeFromSuperview];
    //[self.recordOverlay removeFromParentViewController];
    
    @autoreleasepool {
        if (transactionState == TS_RECORDING) {
            [self.voiceSearch cancel];
        }
    }
}

#pragma mark updateview

-(void)updateButtons{
     NSDictionary *initialDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:userData];
    
    self.lineOne.text = initialDictionary[@"line_one"];
    self.lineTwo.text = initialDictionary[@"line_two"];
    if(initialDictionary[@"brand_web_site"])
    {
        if([initialDictionary[@"brand_web_site"]  isEqual: @""])
        {
            self.websiteButton.enabled = FALSE;
            self.websiteButton.alpha = 0.6;
        }else{
            self.website = initialDictionary[@"brand_web_site"];
        }
    }
    if(initialDictionary[@"brand_phone"])
    {
        if([initialDictionary[@"brand_phone"]  isEqual: @""])
        {
            self.phoneButton.enabled = FALSE;
            self.phoneButton.alpha = 0.6;
        }else{
            self.phone = initialDictionary[@"brand_phone"];
        }
    }
    if(initialDictionary[@"brand_email"])
    {
        if([initialDictionary[@"brand_email"]  isEqual: @""])
        {
            self.emailButton.enabled = FALSE;
            self.emailButton.alpha = 0.6;
        }else{
            self.email = initialDictionary[@"brand_email"];
        }
    }
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [voiceSearch cancel];
    if(textField == self.categoryView){
        [self.methodView resignFirstResponder];
        [self.payeeView resignFirstResponder];
        [self.amountView resignFirstResponder];
        [self.txtview resignFirstResponder];
        [self.amountView resignFirstResponder];
        if(!([[self.categoryView.text componentsSeparatedByString:@":"] count] == 1)){
            for (int i=0;i<[self.categoryTypes count]; i++) {
                NSLog(@"%@",[[self.categoryView.text componentsSeparatedByString:@":"] objectAtIndex:1] );
                if([[[self.categoryView.text componentsSeparatedByString:@":"] objectAtIndex:1] rangeOfString:[self.categoryTypes objectAtIndex:i]].location != NSNotFound){
                    [self.CategoryPicker selectRow:i inComponent:0 animated:NO];
                }
            }

        }
        [self.CategoryPicker setHidden:NO];
        [self.pickerDoneBtn setHidden:NO];
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
        
    return NO;
    }else if(textField == self.methodView){
        [self.categoryView resignFirstResponder];
        [self.payeeView resignFirstResponder];
        [self.amountView resignFirstResponder];
        [self.txtview resignFirstResponder];
        [self.amountView resignFirstResponder];
        if(!([[self.methodView.text componentsSeparatedByString:@":"] count] == 1)){
            for (int i=0;i<[self.paymentTypes count]; i++) {
                NSLog(@"%@",[[self.methodView.text componentsSeparatedByString:@":"] objectAtIndex:1] );
                if([[[self.methodView.text componentsSeparatedByString:@":"] objectAtIndex:1] rangeOfString:[self.paymentTypes objectAtIndex:i]].location != NSNotFound){
                    [self.methodPicker selectRow:i inComponent:0 animated:NO];
                }
            }
            
        }
        [self.methodPicker setHidden:NO];
        [self.pickerDoneBtn setHidden:NO];
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
        
        return NO;
    }else if(textField == self.amountView){
        [self.CategoryPicker setHidden:YES];
        return YES;

    }else{
        [self.CategoryPicker setHidden:YES];
        [self.pickerDoneBtn setHidden:NO];
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
        return YES;
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView == self.CategoryPicker || pickerView == self.methodPicker){
        return 1;
    }else{
        return 3;
    }

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == self.CategoryPicker){
       return [self.categoryTypes count];
    }
    else if(pickerView == self.timePicker){
        switch (component) {
            case 0:
                return 12;
                break;
            case 1:
                return 60;
                break;
            case 2:
                return 2;
                break;
        }
    }
    else if(pickerView == self.methodPicker){
        return [self.paymentTypes count];
    }
    return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == self.CategoryPicker){
    return [self.categoryTypes objectAtIndex:row];
    }
    else if(pickerView == self.timePicker){
        return self.dateValues[component][row];
    }
    else if(pickerView == self.methodPicker){
        return [self.paymentTypes objectAtIndex:row];
    }
    return @"";

}
- (IBAction)changeAMPM:(id)sender {
    if(self.Mileage){
        NSString *currentTime = [[self.dateView.text componentsSeparatedByString:@"at"] objectAtIndex:2];
        if([currentTime rangeOfString:@"AM"].location !=NSNotFound){
            currentTime = [currentTime stringByReplacingOccurrencesOfString:@"AM" withString:@""];
            currentTime = [currentTime stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *temptime = [currentTime componentsSeparatedByString:@":"];
            [self.timePicker selectRow:[[temptime objectAtIndex:0] integerValue]-1 inComponent:0 animated:NO];
            [self.timePicker selectRow:[[temptime objectAtIndex:1] integerValue] inComponent:1 animated:NO];
            [self.timePicker selectRow:0 inComponent:2 animated:NO];
            
        }else{
            currentTime = [currentTime stringByReplacingOccurrencesOfString:@"PM" withString:@""];
            currentTime = [currentTime stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *temptime = [currentTime componentsSeparatedByString:@":"];
            [self.timePicker selectRow:[[temptime objectAtIndex:0] integerValue]-1 inComponent:0 animated:NO];
            [self.timePicker selectRow:[[temptime objectAtIndex:1] integerValue] inComponent:1 animated:NO];
            [self.timePicker selectRow:1 inComponent:2 animated:NO];
        }
     [voiceSearch cancel];
    [self.timePicker setHidden:NO];
    [self.pickerDoneBtn setHidden:NO];
    [self.calenderPicker removeFromSuperview];
    [self.calenderbar removeFromSuperview];
        if([self.amountView isFirstResponder]){
            [self.amountView resignFirstResponder];
             [self.pickerDoneBtn setHidden:NO];
        }
        if([self.txtview isFirstResponder]){
            [self.txtview resignFirstResponder];
        }
   
    }else{
       
        [self datebegin:sender];
        
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    //NSLog(@"Selected Row %d", row);
    if(pickerView == self.CategoryPicker){
        self.categoryView.text = [NSString stringWithFormat:@"Category: %@", [self.categoryTypes objectAtIndex:row]];

    }
    else if(pickerView == self.methodPicker){
        self.methodView.text = [NSString stringWithFormat:@"Type: %@", [self.paymentTypes objectAtIndex:row]];
        
    }
                                       
    else if (pickerView == self.timePicker){
        switch (component) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                switch (row) {
                    case 0:
                            self.dateView.text = [self.dateView.text stringByReplacingOccurrencesOfString:@"PM" withString:@"AM"];
                            self.dateView.text = [self.dateView.text stringByReplacingOccurrencesOfString:@"AM" withString:@"AM"];
                        break;
                    case 1:
                            self.dateView.text = [self.dateView.text stringByReplacingOccurrencesOfString:@"PM" withString:@"PM"];
                            self.dateView.text = [self.dateView.text stringByReplacingOccurrencesOfString:@"AM" withString:@"PM"];
                        break;
                }

                break;
            default:
                break;
        }
        
        NSString *currentDate = [[self.dateView.text componentsSeparatedByString:@" at "] objectAtIndex:0];
        NSLog(@"%@",[[self.dateView.text componentsSeparatedByString:@" at "] objectAtIndex:1]);
        currentDate = [[[currentDate componentsSeparatedByString:@":"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@ at %@:%@ %@", currentDate,self.dateValues[0][[self.timePicker selectedRowInComponent:0]], self.dateValues[1][[self.timePicker selectedRowInComponent:1]], self.dateValues[2][[self.timePicker selectedRowInComponent:2]]];
        NSLog(@"%@",[[self.dateView.text componentsSeparatedByString:@" at "] objectAtIndex:1]);
        self.dateFilled = [NSString stringWithFormat:@"%@ at %@", currentDate,[[self.dateView.text componentsSeparatedByString:@" at "] objectAtIndex:1]];
        
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(pickerView == self.CategoryPicker){
    UILabel* tView = (UILabel*)view;
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Arial" size:18]];
        [tView setTextColor:[UIColor blackColor]];
        [tView setTextAlignment:UITextAlignmentCenter];

        tView.text = [self.categoryTypes objectAtIndex:row];
    return tView;
    }else if(pickerView == self.methodPicker){
        UILabel* tView = (UILabel*)view;
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Arial" size:18]];
        [tView setTextColor:[UIColor blackColor]];
        [tView setTextAlignment:UITextAlignmentCenter];
        
        tView.text = [self.paymentTypes objectAtIndex:row];
        return tView;
    }else{
        UILabel* tView = (UILabel*)view;
        if (!tView){
                tView = [[UILabel alloc] init];
                [tView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:24]];
                [tView setTextColor:[UIColor whiteColor]];
                [tView setTextAlignment:UITextAlignmentCenter];
                tView.numberOfLines=1;
            
            tView.text = self.dateValues[component][row];
            

    }

        return tView;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont * titleFont = [UIFont fontWithName:@"Helvetica" size:32];
    if (pickerView == self.CategoryPicker){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self.categoryTypes objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:titleFont}];
        return attString;
    }else{
    
    }
    
    if (pickerView == self.timePicker){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.dateValues[component][row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    return nil;
    
    
}


- (IBAction)cateDoneClicked:(id)sender {
    if([self.view.subviews containsObject:self.calenderPicker]){
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
    }
    if([self.amountView isFirstResponder]){
        [self.amountView resignFirstResponder];
        [self.pickerDoneBtn setHidden:YES];

         [self amountedit:self];
        return;
    }else if([self.methodView isFirstResponder]){
        [self.methodView resignFirstResponder];
        [self.pickerDoneBtn setHidden:YES];

        return;
    }else if([self.payeeView isFirstResponder]){
        [self.payeeView resignFirstResponder];
        [self.pickerDoneBtn setHidden:YES];

        return;
    }

    [self.CategoryPicker setHidden:YES];
    [self.pickerDoneBtn setHidden:YES];
    if (![self.timePicker isHidden]){
    [self.timePicker setHidden:YES];
        return;
    }
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];

   
    if (![self.categoryView.text isEqualToString:@""]){
    NSString *categorySelected =[[self.categoryView.text componentsSeparatedByString:@":"] objectAtIndex:1];
        self.cateFilled = categorySelected;

    if ([categorySelected isEqualToString:@" Mileage"]){
        if(self.Mileage){
            return;
        }
        _calenderPicker = [[CKCalendarView alloc] init];
        
        _calenderPicker.delegate = self;
        self.Mileage = true;
        self.Transa = false;
        self.Income = false;
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = YES;
        self.payeeView.placeholder = @"";
        self.methodView.placeholder = @"";
        self.methodView.text = @"";
        self.payeeView.text = @"";
         self.dateView.text = @"Date: ";
         self.amountView.text = @"Mileage: ";
        self.txtview.text = @"Description";
        self.descriptiontext = @"";
        [DateFormatter setDateFormat:@"MM/dd/yyyy 'at' hh:mm a"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        self.methodView.userInteractionEnabled = NO;
        self.payeeView.userInteractionEnabled = NO;
    }else if ([categorySelected rangeOfString:@"Money In"].location !=NSNotFound){
        if(self.Income){
            return;
        }
        if([[[categorySelected componentsSeparatedByString:@" - "] objectAtIndex:1] rangeOfString:@"Earned Income"].location !=NSNotFound){
            _calenderPicker = [[CKCalendarView alloc] init];
            
            _calenderPicker.delegate = self;
            self.Mileage = false;
            self.Transa = false;
            self.Income = true;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cateSet = YES;
            self.cateFilled =@"Money In - Earned Income";
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Source: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            [DateFormatter setDateFormat:@"MM/dd/yyyy"];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeSource;
            //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            //self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
            self.methodView.userInteractionEnabled = YES;
            self.payeeView.userInteractionEnabled = YES;

        }
       
        _calenderPicker = [[CKCalendarView alloc] init];
        
        _calenderPicker.delegate = self;
        self.Mileage = false;
        self.Transa = false;
        self.Income = true;
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = YES;

        self.methodView.text = @"Method: ";
        self.payeeView.text = @"Source: ";
        self.amountView.text = @"Amount: ";
        self.txtview.text = @"Description";
          self.descriptiontext = @"";
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        self.payeeView.autocompleteType = HTAutocompleteTypeSource;
        //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        //self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
        self.methodView.userInteractionEnabled = YES;
        self.payeeView.userInteractionEnabled = YES;
        
    }else{
        if(self.Transa){
            return;
        }
        _calenderPicker = [[CKCalendarView alloc] init];
        
        _calenderPicker.delegate = self;
        self.Mileage = false;
        self.Transa = true;
        self.Income = false;
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cateSet = YES;
        
        self.methodView.text = @"Method: ";
        self.payeeView.text = @"Payee: ";
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        self.amountView.text = @"Amount: ";
        self.txtview.text = @"Description";
        self.descriptiontext = @"";
        self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        self.payeeView.autocompleteType = HTAutocompleteTypeComp;
        //self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        //self.methodView.autocompleteType = HTAutocompleteTypeMethod;
        self.methodView.userInteractionEnabled = YES;
        self.payeeView.userInteractionEnabled = YES;
    }
    
}
}

 

- (void)datefieldUpdate:(UIDatePicker *)sender{

    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM/dd/yyyy 'at' hh:mm a"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:sender.date]];
    }



- (IBAction)amounteditbegin:(id)sender {
    [self.pickerDoneBtn setHidden:NO];
    [self.calenderPicker removeFromSuperview];
    [self.timePicker setHidden:YES];
    [self.calenderbar removeFromSuperview];
    if(self.Mileage){
        self.amountView.text = [self.amountView.text stringByReplacingOccurrencesOfString:@" Miles" withString:@""];
    }

    
}
- (IBAction)datebegin:(id)sender {
    self.calenderbar.frame = CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.size.width, 44);
    [self.view addSubview:self.calenderbar];
    [self.calenderPicker setFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
      [voiceSearch cancel];
 [self.view addSubview: _calenderPicker];
     [self.pickerDoneBtn setHidden:YES];
      [self.timePicker setHidden:YES];
    if ([self.amountView isFirstResponder]){
    [self.amountView resignFirstResponder];
    }else if([self.methodView isFirstResponder]){
    [self.methodView resignFirstResponder];
    }else if([self.payeeView isFirstResponder]){
        [self.payeeView resignFirstResponder];
    }
    if([self.txtview isFirstResponder]){
        [self.txtview resignFirstResponder];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    // don't let people select dates in previous/next month
    return [calendar dateIsInCurrentMonth:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if(self.Mileage){
        NSArray *savetime = [self.dateView.text componentsSeparatedByString:@"at"];
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@ at%@",[DateFormatter stringFromDate:date], [savetime objectAtIndex:2]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:date];
          [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];

        
    }
    
    if(self.Transa || self.Income){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:date]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:date];
          [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];

        
    }

}
- (void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date;{
    return;
    
}






@end
