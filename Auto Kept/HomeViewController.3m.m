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
#import "AKStyle.h"
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
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *methodView;
@property (weak, nonatomic) IBOutlet UITextField *catagoryView;
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
@property (nonatomic) NSString *descriptiontext;
@property (nonatomic) BOOL amountset;
@property (nonatomic) BOOL cataSet;
@property (nonatomic) BOOL compSet;
@property (nonatomic) BOOL methodSet;
@property (nonatomic) NSArray *companys;
@property (nonatomic) NSArray *paymentTypes;
@property (nonatomic) NSArray *catagoraytypes;
@property (nonatomic) NSString *totalFilled;
@property (nonatomic) NSString *paymentMethodFilled;
@property (nonatomic) NSString *cardEndingFilled;
@property (nonatomic) NSString *cataFilled;
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
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cataDoneClicked:)]];
    [self.calenderbar setItems:items animated:NO];
   
   
    
    self.navigationController.navigationBarHidden = TRUE;
    AKStyle *style = [[AKStyle alloc]init];
     CAGradientLayer *gradient = [style blueGradient:(UIView*)self.view];
    self.descriptiontext = @"";
    self.firstTime = true;
    NSLog(@"initial dic%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    NSLog(self.login ? @"Yes" : @"No");
    
    [self loadData];
    
     NSLog(@"\n new dic%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    self.allData = [[NSMutableArray alloc] init];
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
   
    //self.catagoryView = [[HTAutocompleteTextField alloc] init];
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
    self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.methodView.autocompleteType = HTAutocompleteTypeMethod;
    self.companyToPFilled = @"";
    self.totalFilled = @"";
    self.paymentMethodFilled = @"";
    self.dateFilled = @"";
    self.cataFilled = @"";
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
    self.catagoryView.delegate = self;
    self.methodView.delegate = self;
    self.amountView.delegate = self;
    self.typeTran = 1;
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    [style whiteBorder:(CALayer *) self.submitbtn.layer];
    [style whiteBorder:(CALayer *) self.sharebtn.layer];
    [style textBox:(CALayer *) self.websiteButton.layer];
    [style textBox:(CALayer *) self.phoneButton.layer];
    [style textBox:(CALayer *) self.emailButton.layer];
    [style textBox:(CALayer *) self.txtview.layer];
    [style textBox:(CALayer *) self.amountView.layer];
    [style textBox:(CALayer *) self.methodView.layer];
    [style textBox:(CALayer *) self.catagoryView.layer];
    [style textBox:(CALayer *) self.payeeView.layer];
     [style textBox:(CALayer *) self.dateView.layer];
    self.amountset = FALSE;
    self.methodSet = FALSE;
    self.cataSet = FALSE;
    self.compSet = FALSE;
    self.amountView.text = @"Description";
    self.methodView.text = @"";
    self.catagoryView.text = @"";
    self.payeeView.text = @"";
    self.txtview.text = @"";

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
    
    
    self.paymentTypes = [appdelegate getCards];
    self.catagoraytypes = [NSArray arrayWithObjects:@"Mileage",@"Mileage",@"",@"Money In",@"Money In - I Don't Know", @"Money In - Earned Income",@"",@"Money Out",@"Money Out - I Don’t Know",@"Advertising/Marketing",@"Automotive",@"Bank/CC Fees",@"Charity/Medical/Misc. Tax Deductions",@"Cost Of Goods",@"Credit Card/Loan Payments",@"Dues/Subscriptions/Professional Fees",@"Insurance/Licenses/Permits",@"Meals/Travel/Entertainment",@"Rent/Utilities",@"Sub-Contractor",@"Supplies/Equipment",@"Telecommunications", nil];
    
    
    self.dateValues = @[@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@""],
  @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"],
  @[@"AM",@"PM"]];
    self.timePicker.dataSource = self;
    self.timePicker.delegate = self;
    self.dayValues = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
    self.companys = [NSArray arrayWithObjects: @"2K Games",@"21st Century Fox",@"24 Hour Fitness",@"3M",@"4Licensing Corporation",@"a21 ",@"Aarons ",@"Abbott Laboratories",@"AbbVie",@"Abercrombie & Fitch",@"ABM Industries",@"ABS Capital Partners",@"ABX Air",@"AC Lens",@"Academi",@"Access Systems Americas ",@"ACCO Brands",@"Accuquote",@"Accuride Corporation",@"Ace Hardware",@"Acme Brick",@"Acme Fresh Market",@"Acsis ",@"ACN ",@"Activision",@"Activision Blizzard",@"Acuity Brands",@"Acuity Insurance",@"ADC Telecommunications",@"Adaptec",@"Adobe Systems",@"ADT Corp",@"ADTRAN",@"Advance Auto Parts",@"Advance Publications",@"Advanced Micro Devices",@"Advanced Processing & Imaging",@"Advent International",@"AECOM",@"Aerojet Rocketdyne",@"Aéropostale",@"AES Corporation",@"Aetna",@"Affiliated Computer Services",@"Aflac",@"AGCO",@"Agilent Technologies",@"AGL Resources",@"Agriprocessors",@"Air Products & Chemicals",@"Airgas",@"Air Tractor",@"Air Transport International",@"AirTran Holdings",@"Air Wisconsin",@"AK Steel Holding",@"Akamai Technologies",@"Alaska Air Group",@"Albemarle Corporation",@"Albertsons",@"Alcoa",@"Aleris",@"Alexander & Baldwin",@"Alexander Arms",@"Alexion Pharmaceuticals",@"Alienware",@"Alleghany Corporation",@"Allegheny Technologies",@"Allegis Group",@"Allen Organ Company",@"Allergan",@"Alliance Rubber Company",@"Alliant Energy",@"Alliant Techsystems",@"Allied Insurance",@"Allison Transmission",@"Allstate",@"Ally Financial",@"Aloha Air Cargo",@"Altec Lansing",@"Altera Corporation",@"Alton Steel",@"Altra Industrial Motion",@"Altria",@"Amazon",@"AMC Entertainment",@"Ameren",@"American Axle",@"American Apparel",@"American Broadcasting Company",@"American Eagle Outfitters",@"American Electric Power",@"American Family Insurance",@"American Financial Group",@"American Greetings",@"American Home Mortgage",@"American International Group",@"American Licorice Company",@"American Reprographics Company",@"American Sugar Refining ",@"Amerigroup",@"Ameriprise Financial",@"AmerisourceBergen",@"Ametek",@"Amgen",@"Amkor Technology",@"Ampex Corporation",@"Amphenol",@"AMR Corporation",@"American Airlines",@"AMSOIL ",@"Amtrak",@"Amway",@"Amys Kitchen",@"Anadarko Petroleum Corporation",@"Analog Devices",@"AnaSpec",@"Ancestrycom ",@"Anchor Bay Entertainment",@"Anchor Brewing Company",@"AND1",@"Andersen Corporation",@"Andronicos",@"Anixter",@"Ann Taylor",@"Annabelle Candy Company",@"Ansys",@"Antec",@"AOL",@"Aon plc",@"Apache Corporation",@"Apache Software Foundation",@"Apollo Global Management",@"Apollo Group",@"Applebees",@"Apple",@"Applico",@"Applied Biosystems",@"Applied Industrial Technologies",@"Applied Materials",@"Aramark",@"Arbitron",@"Arch Coal",@"Archer Daniels Midland",@"Arc Machines",@"Arctic Cat",@"Ariba",@"Arizona Beverage Company",@"Arizona Stock Exchange",@"Arkeia Software",@"Armstrong World Industries",@"Arrow Electronics",@"Arryx",@"ASARCO American Smelting And Refining Company",@"Asbury Automotive Group",@"A Schulman",@"Ashland ",@"Ashley Furniture Industries",@"AskMeNow",@"Aspen Skiing Company",@"Aspyr Media",@"Associated Wholesale Grocers",@"Assurant",@"Atlas Air",@"Atlas Van Lines",@"Atmel Corporation",@"Atmos Energy",@"AT Conference ",@"AT&T ",@"AT&T Mobility",@"Audiovox",@"Atari",@"Au Bon Pain",@"Authentic Brands Group",@"Autodesk",@"Autoliv",@"Automatic Data Processing",@"AutoNation",@"AutoOwners Insurance",@"AutoZone",@"Avaya",@"Avery Dennison",@"Avis Budget Group",@"Avnet",@"Avon Products",@"AVST",@"A&W Restaurants",@"Babcock & Wilcox",@"Bain & Company",@"Bain Capital",@"Baker Hughes",@"Bakers Square Restaurants",@"Baldor Electric Company",@"Ball Corporation",@"Ballistic Recovery Systems",@"Bally Technologies ",@"Bank of America",@"The Bank of New York Mellon Corporation",@"Barnes & Noble",@"Barrett Firearms Manufacturing",@"Bass Pro Shops",@"Bath & Body Works",@"Baxter International",@"BB&T Corporation",@"Bebo",@"B/E Aerospace",@"Bealls",@"Beam ",@"BearingPoint",@"Beazer Homes USA",@"Bechtel",@"Beckman Coulter",@"Becton Dickinson",@"Bed Bath & Beyond",@"Beechcraft",@"Beer Nuts ",@"Belk",@"Belkin",@"Bellwether Technology Corporation",@"Bemis Company ",@"Bemis Manufacturing Company",@"Benchmark Electronics",@"Ben Franklin",@"Benihana",@"Bennigans",@"W R Berkley",@"Berkshire Hathaway",@"Berry Plastics",@"Best Buy",@"Best Western International",@"BFG Technologies",@"Big 5 Sporting Goods",@"Big Boy Restaurants",@"Bigelow Tea Company",@"Big Lots",@"Biggby Coffee",@"BILO",@"Biogen Idec",@"BioRad Laboratories",@"Biomet",@"Birdwell",@"Bissell ",@"BJ Services Company",@"BJs Wholesale Club",@"Black Angus Steakhouse",@"BlackRock",@"Blackstone Group",@"Blistex ",@"Blockbuster",@"Bloomin Brands",@"BlueLinx",@"Blyth ",@"BMC Software",@"BNSF Railway",@"Bob Evans Restaurants",@"Boeing",@"Boise Cascade",@"Bollinger Shipyards",@"Booz Allen Hamilton",@"Borders Group",@"BorgWarner",@"Bosch Brewing Company",@"Bose Corporation",@"Boston Acoustics",@"Boston Beer Company",@"Boston Scientific",@"Bowlmor AMF",@"Boyd Gaming",@"Boyer Brothers",@"BP",@"Bradley Pharmaceuticals",@"Briggs & Stratton",@"BrightPoint",@"Brinker International",@"Brinks",@"BristolMyers Squibb",@"Broadcom",@"Brocade Communications Systems",@"Bronco Wine Company",@"Brookdale Senior Living",@"Brooks Brothers",@"BrownForman",@"Brown and Haley",@"Brown Shoe Company",@"Browning Arms Company",@"Bruker",@"Brunswick Corporation",@"Bucyrus International",@"BucketFeet",@"BunnOMatic Corporation",@"Burger King",@"Burlington Coat Factory",@"Burpee Seeds",@"Burton Snowboards",@"Bushmaster Firearms International",@"Cabelas",@"CA Technologies",@"Cablevision Systems",@"Cabot Corporation",@"Cabot Oil & Gas",@"CACI",@"Cadence Design Systems",@"California Pizza Kitchen",@"Calista Corporation",@"Callaway Golf Company",@"CalMaine",@"Calpine",@"CamelBak Products",@"Cameron International",@"Campbell Soup Company",@"Canvas",@"Cape Air",@"Capital Group Companies",@"Capital One",@"Cardinal Health",@"CareFusion",@"Carlson Companies",@"Carnival Corporation & plc",@"Carnival Cruise Lines",@"Cargill",@"Carlisle Companies",@"Carlyle Group",@"CarMax",@"Carpenter Technology Corporation",@"Carroll Shelby International",@"Carters ",@"Cartoon Network Studios",@"Casco Bay Lines",@"Caterpillar ",@"Cbeyond",@"CBS Corporation",@"CDI Corporation",@"CDW Corporation",@"Cedar Fair Entertainment Company",@"Celanese Corporation",@"Celgene",@"CenturyLink",@"Cerberus Capital Management",@"Ceridian",@"Cerner",@"CF Industries",@"CH2M Hill Companies",@"C H Robinson Worldwide",@"Charles Schwab Corporation",@"Charter",@"The Cheesecake Factory",@"ChemDry",@"Chesapeake Energy",@"Chevron Corporation",@"ChexSystems",@"Chicago Bridge & Iron Company",@"Chick-fil-A",@"Chipotle Mexican Grill",@"Chiquita Brands International",@"Choice Hotels International",@"Christian Moerlein Brewing Company",@"CHS ",@"Chubb Corporation",@"Chuck E Cheeses",@"Chugach Alaska Corporation",@"Church & Dwight",@"Chrysler",@"CiCis Pizza",@"CIGNA",@"Cinemark Theatres",@"Cintas Corporation",@"Cirrus Aircraft Corporation",@"Cisco Systems",@"Citigroup",@"CIT Group",@"Citrix Systems",@"CKE Restaurants",@"Hardees",@"Carls Jr",@"Clayton Dubilier & Rice",@"Clear Channel Communications",@"Clearwater Paper",@"Cliffs Natural Resources",@"The Clorox Company",@"CME Group",@"CNA Financial",@"CNET",@"CNO Financial Group",@"Coach",@"The CocaCola Company",@"Cogent Communications",@"Cognizant Technology Solutions",@"Cole Haan",@"ColgatePalmolive",@"Colt Defense",@"Colts Manufacturing Company",@"Columbia Pictures",@"Columbia Sportswear",@"Columbia Sussex",@"Comcast",@"Comerica",@"Commercial Metals Company",@"Comodo",@"Computer Sciences Corporation",@"Compuware",@"ConAgra Foods",@"Conair Corporation",@"ConocoPhillips",@"Consol Energy",@"Constellation Brands",@"Control Data Corporation",@"ConverDyn",@"Convergys",@"Converse",@"CoolTouch Monitors",@"Copelands",@"Cordell & Cordell",@"Corning ",@"Corrections Corporation of America",@"Corsair Memory",@"Costco",@"Cott Corporation",@"Coventry Health Care",@"Cox",@"Cracker Barrel",@"Craft Brew Alliance",@"Craigslist",@"Crane Carrier Company",@"Crane & Co ",@"Crane Company",@"Cray",@"Crazy Eddie",@"C R Bard ",@"Crowley Maritime",@"Crown Castle International",@"Crown Equipment Corporation",@"Crown Holdings",@"C&S Wholesale Grocers",@"CSX Corporation",@"Cubic Corporation",@"Culvers Franchising System ",@"Cumberland Farms",@"Cummins",@"CurtissWright",@"Curves International",@"CVS Caremark",@"Cypress Semiconductor",@"Daktronics",@"Dana Corporation",@"Danaher",@"Darden Restaurants",@"Dart Container Corporation",@"DaVita",@"Day & Zimmermann",@"Dayton Superior",@"DC Comics",@"DC Shoes",@"Dean Foods",@"Deere & Company",@"Del Monte Foods",@"Dell",@"Delphi",@"Delta Air Lines",@"Deluxe Corporation",@"Denbury Resources",@"Dennys",@"Dentsply",@"Devon Energy",@"DeVry ",@"DEX One",@"Diamond Foods",@"Diamond Offshore Drilling",@"Dicks Sporting Goods",@"DiC Entertainment",@"Diebold",@"DigiKey",@"Dillards",@"DineEquity",@"Dippin Dots",@"DirecTV",@"Discover Financial",@"Discovery Communications",@"Dish Network",@"The Walt Disney Company",@"DivX ",@"Djarum",@"Doculabs",@"Dogfish Head Brewery",@"Dole Food Company",@"Dollar General",@"Dollar Tree",@"Dominion Resources",@"Dominos Pizza",@"Domtar",@"Dover Corporation",@"Dow Chemical Company",@"Dow Jones & Company",@"D R Horton",@"Dr Pepper Snapple Group",@"Dresser Industries",@"DRS Technologies",@"DST Systems",@"DTE Energy",@"Duke Energy",@"Dun & Bradstreet",@"Dunkin Donuts",@"DuPont",@"Dura Automotive Systems",@"DynCorp",@"Dynegy",@"E*Trade Financial Corporation",@"Eastman Chemical Company",@"Eastman Kodak",@"Eaton Corporation",@"eBay",@"Ebonite International",@"EBSCO Industries",@"EchoStar",@"Ecolab",@"Eddie Bauer",@"Edward Jones",@"Edwards Lifesciences",@"E & J Gallo Winery",@"Egglands Best",@"El Paso Corp",@"Electronic Arts",@"Electronic Data Systems",@"Electronics for Imaging ",@"Eli Lilly and Company",@"Elizabeth Arden",@"El Pollo Loco",@"EMC Corporation",@"Emcor",@"Emerson Electric Company",@"Emerson Radio",@"Energizer Holdings",@"Enterasys Networks",@"Entergy",@"Enterprise Holdings",@"Enterprise Products",@"EOG Resources",@"Equifax",@"Equinix",@"Erickson AirCrane",@"Erie Insurance Group",@"Esselte",@"Estée Lauder Companies",@"Estes Industries",@"Estwing Manufacturing Company",@"Ethan Allen",@"Eureka",@"Evergreen International Airlines",@"Exelon",@"Exide Technologies",@"Expedia",@"Expeditors International",@"Express Scripts",@"Extron",@"ExxonMobil",@"F5 Networks",@"Fabrik ",@"Facebook",@"Fairchild Semiconductor",@"Family Dollar Stores",@"Fannie Mae",@"Far West Capital",@"Farmers Insurance Group",@"FatPipe networks",@"Faultless Starch/Bon Ami Company",@"FederalMogul Corporation",@"Federal Signal Corporation",@"FedEx",@"Fender Musical Instruments Corporation",@"Fenway Partners",@"FICO",@"Fidelity Investments",@"Firestone Tire and Rubber Company",@"First Hawaiian Bank",@"Firstsource",@"Fidelity National Information Services",@"Fiserv",@"Fisher Electronics",@"Fisker Automotive",@"Five Guys Enterprises",@"FLIR Systems",@"Flowers Foods",@"Flowserve",@"Fluor Corporation",@"FMC Technologies",@"Focus Brands",@"Foot Locker",@"Ford Motor Company",@"Forest Laboratories",@"Forrester Research",@"Fortune Brands Home & Security ",@"Forum Communications",@"Fossil ",@"Foster Farms",@"Fosters Freeze",@"Fox Entertainment Group",@"Franklin Templeton",@"Frasca International",@"Fred Meyer",@"Freddie Mac",@"Freedom Group",@"FreeportMcMoRan",@"Freescale Semiconductor",@"FreeWave Technologies",@"Fresh & Easy",@"Friedman Fleischer & Lowe",@"Frontier Airlines",@"Frontier Communications",@"Fruit of the Loom",@"Frys Electronics",@"GameStop",@"Gannett Company",@"Gap",@"Gardner Denver",@"Garmin",@"Gartner",@"Gateway ",@"Gatorade",@"GCI",@"GEICO",@"Gemini Sound Products",@"GenCorp",@"Genentech",@"Generac Power Systems",@"General Atomics",@"General Cable",@"General Dynamics",@"Bath Iron Works",@"General Dynamics Electric Boat",@"Gulfstream Aerospace",@"General Electric",@"GE Consumer & Industrial",@"General Mills",@"General Motors",@"Genesco ",@"Gentiva Health Services",@"Genuine Parts Company",@"Genworth Financial",@"GeorgiaPacific",@"Gerber Scientific",@"GHD Group",@"Giant Food",@"Gibson Guitar Corporation",@"Gilead Sciences",@"Gillette",@"Global Insight",@"GlobalFoundries",@"Go Daddy",@"Gojo Industries",@"Golden Corral",@"Goldman Sachs",@"Goodwill",@"Goodyear",@"Google",@"Gordon Food Service",@"Graco",@"Graham Holdings Company",@"Gray Line Worldwide",@"The Greenbrier Companies",@"Green Mountain Coffee Roasters",@"Ground Round",@"Group O",@"Groupon",@"Growmark",@"GTECH",@"Guardian Industries",@"H&R Block",@"Haas Automation",@"Hain Celestial Group",@"Hallmark Cards",@"Halliburton",@"HanesBrands",@"The Hanover Insurance Group",@"Harbor Freight Tools",@"Hard Rock Cafe",@"HarleyDavidson",@"Harman International Industries",@"Harris Corporation",@"Harsco Corporation",@"The Hartford Financial Services Group",@"Hartzell Propeller",@"Hasbro",@"Hastings Entertainment",@"Hawaiian Airlines",@"Haworth ",@"Hearst Corporation",@"HEB",@"Heaven Hill Distilleries ",@"Henry Repeating Arms",@"Henry Schein ",@"Herbalife",@"Herman Miller ",@"The Hershey Company",@"The Hertz Corporation",@"Hess Corporation",@"HewlettPackard",@"Hexcel Corporation",@"Hillerich & Bradsby Company",@"HiPoint Firearms",@"Hilton Worldwide",@"H J Heinz Company",@"HNI Corporation",@"Hobbico ",@"Hobby Lobby",@"Holley Performance Products",@"Hollister Clothing",@"Hologic ",@"Home City Ice",@"Home Depot",@"Home Shopping Network",@"Honeywell",@"Hormel Foods Corporation",@"Hornbeck Offshore Services",@"Hospital Corporation of America",@"Hostess Brands",@"Host Hotels & Resorts ",@"Hot Topic",@"Houchens Industries",@"Houghton Mifflin Harcourt Learning Technology",@"Houlihans",@"House of Deréon",@"H T Hackney Company",@"Hughes Communications",@"Human Kinetics",@"Humana",@"Hunt Petroleum",@"Huntington Ingalls Industries",@"Huntsman Corporation",@"Hyland Software",@"HyVee",@"IBM",@"Iconix Brand Group",@"Ideal Industries",@"Ilitch Holdings",@"Illinois Tool Works",@"Imation",@"Infinity Ward",@"Infor Global Solutions",@"Ingram Industries",@"Ingram Micro",@"InNOut Burger",@"Intel",@"Interactive Brokers",@"IntercontinentalExchange",@"Intercontinental Manufacturing Company",@"International Dairy Queen",@"International Flavors & Fragrances",@"International Game Technology",@"International Lease Finance Corporation",@"International Paper",@"Interplay Entertainment",@"Interpublic Group",@"Intersil Corporation",@"Interstate Batteries",@"Interstate Van Lines",@"Ingredion Incorporated",@"Intuit",@"Intuitive Surgical",@"Invacare Corporation",@"Invesco",@"Ion Media Networks",@"iRobot",@"Iron City Brewing Company",@"Iron Mountain Incorporated",@"ITT Corporation",@"ITT Technical Institute",@"IXYS Corporation",@"Jabil Circuit",@"Jack in the Box",@"Jacobs Engineering Group",@"Jamba Juice",@"Janus Capital Group",@"Jarden",@"J B Hunt Transport Services",@"J C Penney",@"J Crew Group",@"JDS Uniphase",@"The Jelly Belly Candy Company",@"JetBlue Airways",@"Jimmy Johns",@"JL Audio",@"JM Family Enterprises",@"The JM Smucker Company",@"JNInternational Medical Corporation",@"Jobing",@"Jockey International ",@"Jones Soda",@"Johnson & Johnson",@"Johnson Controls",@"Johnsonville Foods",@"John Wiley & Sons",@"Joseph A Bank Clothiers",@"Journal Communications",@"JPMorgan Chase",@"J R Simplot Company",@"Juniper Networks",@"Kahala Corporation",@"Kahr Arms",@"Kaiser Aluminum",@"Kaiser Permanente",@"Kalitta Air",@"Kaman Aerospace",@"Kampgrounds of America KOA",@"Kansas City Southern Railway",@"KB Home",@"KBR",@"KFC",@"KelTec CNC Industries",@"Kellogg Company",@"Kelly Services",@"KendallJackson",@"Kenexa",@"Kennametal",@"Kenworth",@"KerrMcGee",@"KeyBank",@"Kiewit Corporation",@"Kimball International",@"Kimber Manufacturing",@"KimberlyClark",@"Kinder Morgan",@"King Kullen Grocery Company",@"Kingston Technology",@"KLA Tencor",@"Klipsch Audio Technologies",@"Kohlberg Kravis Roberts KKR",@"Kmart",@"Knights Armament Company",@"Koch Industries",@"Kohler Company",@"Kohls",@"KPMG",@"Kraft Foods",@"Krispy Kreme",@"Kroger",@"KSwiss",@"Kurzweil Educational Systems",@"L Brands",@"L3 Communications",@"LabCorp",@"Lam Research",@"Land O Lakes",@"Laserfiche",@"Las Vegas Sands Corp",@"LaZBoy",@"LeapFrog Enterprises",@"Lear Corporation",@"Lee Enterprises",@"Legg Mason",@"Leggett & Platt",@"Lennar Corporation",@"Lennox International",@"Leonard Green & Partners",@"Les Schwab Tire Centers",@"Leucadia National",@"Levi Strauss & Co",@"Leviton Manufacturing Company",@"Lexmark",@"Liberty Global",@"Liberty Media",@"Liberty Mutual",@"Liberty Tax Service",@"Life Technologies",@"Li.ncoln Industries",@"Li.ncoln National Corporation",@"Line and Space",@"Linear Technology",@"LinkedIn",@"Little Caesars",@"Live Nation Entertainment",@"Liz Claiborne",@"LLBean",@"L&L Hawaiian Barbecue",@"Local Matters",@"Local Motion",@"Lockheed Martin",@"Lodge Manufacturing Company",@"Loews Corporation",@"Long John Silvers",@"Loral Space & Communications",@"Lorillard",@"LouisianaPacific",@"Loves Travel Stops & Country Stores",@"Lowes",@"L W Seecamp Company",@"LSI Corporation",@"LS Starrett Company",@"Lubys ",@"Lucas Oil",@"Lucasfilm",@"Lumencraft",@"MacAndrews & Forbes Holdings",@"Macys",@"Madison Dearborn Partners",@"Magellan Navigation",@"Magnavox",@"Magpul Industries",@"Maidenform Brands",@"The Manischewitz Company",@"Manpower ",@"Marantz",@"Marathon Oil",@"Marathon Petroleum",@"Marble Slab Creamery",@"Marie Callenders",@"Marlin Firearms",@"Marriott Corporation",@"Mars Incorporated",@"Marsh & McLennan Companies",@"Marshall Pottery",@"Martha Stewart Living Omnimedia",@"Martin Marietta Materials",@"Marvell Technology Group",@"Mary Kay",@"Masco Corporation",@"MasterCraft",@"Mattel",@"Mauna Loa Macadamia Nut Corporation",@"Maxim Integrated",@"Maxtor",@"The McClatchy Company",@"McAfee",@"McCormick & Company",@"McDonalds",@"MCI ",@"McIntosh Laboratory",@"McGrawHill",@"McIlhenny Company",@"McKee Foods Corporation",@"McKesson Corporation",@"McKinsey & Company",@"MD Helicopters",@"Mead Johnson",@"MeadWestvaco",@"Medimix International",@"Medtronic",@"Meijer",@"Meineke Car Care Centers",@"Menards",@"Mens Wearhouse",@"Mentor Graphics",@"Merck & Co",@"Mercury Insurance Group",@"Mercury Marine",@"Meredith Corporation",@"Meritor",@"Mesa Airlines",@"MetLife",@"MetroGoldwynMayer MGM",@"MettlerToledo",@"Michaels Stores ",@"Microchip Technology",@"Micron Technology",@"Microsoft",@"Midway Games",@"Midwest Communications",@"MIG ",@"Miller Brewing Company",@"Miro Technologies",@"Mohawk Industries",@"Molex ",@"Molycorp",@"Momentive",@"Mondelēz International",@"Monotype Imaging Holdings",@"Monsanto",@"Monster Beverage Corporation",@"Montana Resources",@"Moodys",@"Moog I.ncIncorporated",@"Monro Muffler Brake ",@"Morgan Stanley",@"Morningstar",@"The Mosaic Company",@"Motorola",@"Movado",@"Mozilla Foundation",@"MTX Audio",@"Murphy Oil Corporation",@"Musco Lighting",@"Mutual of Omaha",@"Mylan ",@"Myspace",@"Nabisco",@"NACCO Industries",@"Nalge Nunc International",@"NASDAQ OMX Group",@"Nathans Famous ",@"National Airlines",@"National Beverage",@"National Oilwell Varco",@"National Presto Industries",@"National Railway Equipment Company",@"Nationwide Mutual Insurance Company",@"Nautilus ",@"NBCUniversal",@"NCR Corporation",@"Necco",@"Neiman Marcus Group",@"NetApp",@"Netcordia",@"Netflix",@"Netgear",@"NetZero",@"New Balance",@"Neweggcom ",@"New Era Tickets",@"Newell Rubbermaid",@"Newfield Exploration",@"Newmont Mining Corporation",@"NewPage Corporation",@"News Corporation",@"New York Life Insurance Company",@"Nielsen",@"Nike ",@"NL Industries",@"Noble Energy",@"Nordstrom",@"Norfolk Southern Railway",@"Northrop Grumman",@"North Sails",@"Northwest Airlines",@"Norwegian Cruise Line",@"Novell",@"Novellus Systems",@"NRG Energy",@"Nuance Communications",@"Nucor",@"Numark Industries",@"Nvidia",@"NYSE Euronext",@"Oak Hill Capital Partners",@"Oaktree Capital Management",@"Oberto Sausage Company",@"Oberweis Dairy",@"Occidental Petroleum",@"Oceaneering International",@"Ocean Spray",@"OCZ Technology",@"Odwalla ",@"OF Mossberg & Sons",@"Office Depot",@"OfficeMax",@"Olan Mills",@"Old Dominion Freight Line",@"Olin Corporation",@"Olympic Steel",@"Omaha Steaks",@"Omni Air International",@"The Omni Group",@"Omnicare",@"Omnicom Group",@"ON Semiconductor",@"ONEOK",@"Onvia",@"Open Interface North America",@"OpenTable",@"Opower",@"OptiRTC",@"Oracle Corporation",@"Oracle Financial Services Software",@"Orbital Sciences Corporation",@"Oreck Corporation",@"OReilly Auto Parts",@"OReilly Media",@"Oshkosh Corporation",@"OSI Restaurant Partners",@"Overcast Media",@"Overstockcom ",@"Owens Corning",@"OwensIllinois",@"Pabst Brewing Company",@"PACCAR",@"Pacer International",@"Pacific Gas and Electric Company PG&E",@"Pacific Life Insurance Company",@"Packaging Corporation of America",@"Pall Corporation",@"Panda Energy International",@"Panda Express",@"Panera Bread",@"Papa Johns Pizza",@"Papa Murphys",@"Paramount Pictures",@"Park Seed Company",@"Parker Hannifin Corporation",@"Patterson Companies",@"Paxton Media Group",@"Paychex ",@"Payless ShoeSource",@"PC Power and Cooling",@"Peabody Energy",@"Pearsons Candy Company",@"Peavey Electronics Corporation",@"Peets Coffee",@"Pelican Products",@"Penn National Insurance",@"Penske Corporation",@"Pep Boys",@"PepsiCo",@"Perdue Farms",@"PerkinElmer",@"Perrigo",@"Perry Ellis International",@"Petco Animal Supplies",@"Peterbilt",@"PetMeds",@"PetSmart",@"Pfizer",@"Philip Morris",@"Phillips 66",@"Phillips Van HeusenPhilip Morris",@"Pier 1 Imports",@"Piggybackr",@"Pilgrims Pride",@"Pilot Travel Centers",@"Pinnacle Foods Group",@"Pinnacle Systems",@"Pioneer Natural Resources",@"Pioneer Railcorp",@"Piper Jaffray",@"Pitney Bowes",@"Pizza Hut",@"Plains All American Pipeline",@"Planet Hollywood",@"Plantronics",@"Plochmans",@"PMCSierra",@"PNY Technologies",@"Polaroid Corporation",@"Polaris Industries",@"Popeyes Louisiana Kitchen",@"PPG Industries",@"Praxair",@"Precision Castparts Corp",@"Prestige Brands",@"Priceline",@"PricewaterhouseCoopers",@"Primerica",@"Pri.ncipal Financial Group",@"Procter & Gamble",@"Progressive Corporation",@"Protective Life Corporation",@"Prudential Financial",@"PSSC Labs",@"Public Storage",@"Publishers Clearing House",@"Publix",@"Pulte Homes",@"QCR Holdings",@"Qpass",@"Qualcomm",@"Quanta Services",@"Quantrix",@"Quantum Corporation",@"Quest Diagnostics",@"Quest Software",@"QuikTrip Corporation",@"Qui.ncy Newspapers",@"QVC",@"Qwest",@"Quiznos",@"RaceTrac Petroleum",@"RadioShack",@"Ralcorp",@"Raleys Supermarkets",@"Ralph Lauren",@"Rand McNally",@"Ranger Boats",@"Raybestos",@"Raycom Media",@"Raymond James Financial",@"Raytheon",@"RCA",@"Realogy",@"Red Hat",@"Red Robin Gourmet Burgers",@"Red River Broadcasting",@"REI",@"RegalBeloit",@"Regal Entertainment Group",@"Regeneron Pharmaceuticals",@"Regions Financial Corporation",@"Regis Corporation",@"Reliance Steel & Aluminum Co",@"RE/MAX International",@"Renco Group",@"RentACenter",@"RentAWreck",@"Renys",@"Republic Services ",@"Respironics",@"Reyes Holdings",@"Reynolds American",@"Riceland Foods",@"Rite Aid",@"RJ Corman Railroad Group",@"Roark Capital Group",@"Robert Half International",@"Robinson Helicopter Company",@"Rockford Fosgate",@"Rockport Company",@"Rockstar ",@"Rockstar Games",@"RockTenn Company",@"Rockwell Automation",@"Rockwell Collins",@"Rodale ",@"Rollins ",@"Roper Industries",@"Rosetta Stone ",@"Ross Stores",@"Round Table Pizza",@"Roush Performance",@"Rovi Corporation",@"Rowan Companies",@"Royal Caribbean International",@"RPM International",@"RR Donnelley",@"Ruby Tuesday",@"Russell Investments",@"Russell Stover Candies",@"Ryder",@"Ryland Homes",@"S3 Graphics",@"Sabre Holdings",@"Safeco",@"Safeway ",@"SAIC",@"Salem Communications",@"Salesforcecom ",@"Saleen Automotive",@"SanDisk",@"Sara Lee Corporation",@"SauerDanfoss",@"Savage Arms Company",@"Save Mart Supermarkets",@"Sbarro",@"SC Johnson & Son",@"SCANA Corporation",@"Schlumberger",@"Schnitzer Steel Industries",@"Schoeps Ice Cream",@"Scholastic Corporation",@"Schneider National ",@"Schnucks",@"Schwan Food Company",@"Scottrade",@"The Scotts MiracleGro Company",@"Scripps Networks Interactive",@"Seaboard Corporation",@"Seagate Technology",@"Sealed Air Corporation",@"Sears",@"Seattles Best Coffee",@"Seneca Foods Corporation",@"Sequoia Capital",@"Sequoia Voting Systems",@"Service Corporation International",@"SERVPRO Industries",@"SFN Group",@"Shaklee Corporation",@"Shea Homes",@"Sheetz ",@"Shell",@"SherwinWilliams",@"Shirokiya",@"Shoneys",@"Shop n Save",@"Shure",@"Sierra Nevada Brewing Company",@"Sierra Nevada Corporation",@"SigmaAldrich",@"Silicon Graphics International",@"Silicon Image",@"Silver Lake Partners",@"Simon Property Group",@"Si.nclair Oil Corporation",@"Sirius XM Radio",@"SIRVA ",@"Six Flags",@"Sizzler",@"Skechers",@"SkyWest Airlines",@"Smart & Final",@"Smith & Wesson",@"SnapOn",@"SnydersLance ",@"Sociometric Solutions",@"Sonic Restaurants ",@"Sonic Solutions",@"Sony Pictures Entertainment",@"Sothebys",@"Southern Air",@"Southern California Edison",@"Southern Progress Corporation",@"Southern Wine & Spirits",@"Southwest Airlines",@"Soyo Group",@"Space Exploration Technologies Corporation",@"SpaceX",@"Spansion",@"Spanx",@"Specialized Bicycle Components ",@"Spectra Energy",@"Spectrum Brands",@"Speedway Motorsports",@"Spirit AeroSystems",@"Spirit Airlines",@"Springfield Armory ",@"Sprint Corporation",@"SPX Corporation",@"Standard Pacific Homes",@"Stanley Black & Decker",@"Staples ",@"Starbucks",@"Starwood Hotels & Resorts Worldwide",@"Starz",@"State Farm Insurance",@"State Street Corporation",@"Stater Bros Markets",@"Steak n Shake",@"Steelcase ",@"Steel Dynamics",@"Steinway & Sons",@"Stephens ",@"Stericycle",@"Sterling Ledet & Associates",@"Stewart & Stevenson",@"StewartWarner",@"Stew Leonards",@"STI International",@"Storage Technology Corporation",@"StrayerVoigt ",@"Stryker Corporation",@"Stuckeys",@"Sturm Ruger & Company",@"STX",@"Subway",@"Sun Capital Partners",@"SunMaid Growers of California",@"Sunny Delight Beverages",@"Sunoco",@"Sun Products",@"Sunsweet Growers Incorporated",@"SunTrust Banks ",@"Super One Foods",@"SuperValu",@"Sur La Table",@"Swayne Robinson and Company",@"SweetWater Brewing Company",@"Synopsys",@"Syntel",@"Symantec",@"Synovus Financial Corporation",@"Sysco Corporation",@"Taco Bell",@"TakeTwo Interactive",@"Talbots",@"Talend",@"Tanadgusix Corporation",@"Target Corporation",@"Taser International",@"TasteeFreez",@"Taunton Press",@"TD Ameritrade",@"Tektronix",@"Teledyne Technologies",@"Tellabs",@"TempurPedic",@"Tenet Healthcare",@"Teradata",@"Teradyne",@"Terex Corporation",@"Tesla Motors",@"Tesoro",@"Testor Corporation",@"Texas Instruments",@"Textron",@"Bell Helicopter",@"Cessna Aircraft",@"The Compleat Sculptor ",@"The Library Corporation",@"Thermo Fisher Scientific",@"Thor Industries",@"THQ",@"TIAACREF",@"Tiffany & Company",@"Time Warner",@"Timken Company",@"TiVo ",@"TJX Companies",@"Togos Eateries ",@"Toll Brothers",@"Torry Harris Business Solutions",@"Tony Romas",@"Tootsie Roll Industries",@"The Toro Company",@"Total System Services",@"Tower Automotive",@"Towers Perrin",@"Toys R Us",@"TPG Capital",@"TRAFFIK Advertising",@"TransDigm Group",@"T Rowe Price",@"The Travelers Companies",@"Trader Vics",@"Transamerica Corporation",@"Transammonia ",@"TreeRing",@"Trek Bicycle Corporation",@"Trijicon",@"Trimble Navigation",@"Trinity Industries",@"Tropicana Products",@"Trianz",@"Triumph Group",@"TRT Holdings",@"Trump Organization",@"TRW Automotive",@"Tuff Shed",@"Tullys Coffee",@"Tupperware Brands",@"Turtle Wax",@"Twitter",@"Tyr Sport ",@"Tyson Foods",@"Uber",@"UberOffices",@"Ubu Productions",@"UHaul",@"Ultimate Software",@"Under Armour",@"Underwriters Laboratories",@"Unified Grocers",@"Union Bank",@"Union Pacific Railroad",@"Unisys",@"United Airlines",@"United Country Real Estate",@"United Parcel Service",@"UPS",@"United Rentals",@"United States Enrichment Corporation",@"United Technologies Corporation",@"Carrier Corporation",@"Otis Elevator Company",@"Pratt & Whitney",@"Sikorsky Aircraft",@"UnitedHealth Group",@"Universal Forest Products",@"Universal Studios",@"Uno Chicago Grill",@"Unum Group",@"Upland Brewing Company",@"Upper Deck Company",@"Urban Outfitters",@"US Airways",@"USAA",@"USRobotics",@"US Foods",@"USG Corporation",@"US Bancorp",@"US Cellular",@"US Ordnance ",@"US Steel",@"US Venture Partners",@"UTStarcom",@"Uwajimaya",@"Vail Resorts ",@"Valero Energy Corporation",@"The Valspar Corporation",@"Valve Corporation",@"VantagePoint Capital Partners",@"Vantec",@"The Vanguard Group",@"Varian Medical Systems",@"Vaughan & Bushnell Manufacturing",@"VECO Corporation",@"Vectren",@"Venrock",@"Venus Swimwear",@"Verbatim Corporation",@"VeriFone Systems ",@"Verisign",@"Verisk Analytics",@"Verizon Communications",@"Verizon Wireless",@"Vertex Pharmaceuticals",@"VF Corporation",@"Lee",@"The North Face",@"Wrangler",@"Viacom",@"ViaSat",@"Victorias Secret",@"Victorious 22",@"ViewSonic",@"Vishay Intertechnology",@"Visteon Corporation",@"Vivitar",@"VIZ Media",@"Vizio",@"VMware",@"Vonage",@"Vornado Realty Trust",@"Vulcan Corporation",@"Vulcan Materials Company",@"VWR International",@"Wabash National",@"Wabtec Corporation",@"Waffle House",@"Wahl",@"Wakefern Food Corporation",@"Walgreens",@"Walmart",@"The Walt Disney Company",@"Warburg Pi.ncus",@"Warner Bros.",@"Washburn Guitars",@"Waste Management",@"Watco Companies",@"Waters Corporation",@"Watkins Incorporated",@"WatkinsJohnson Company",@"Watsco ",@"Wausau Paper",@"Wawa ",@"W C Bradley Co",@"WD40 Company",@"Wegmans Food Markets",@"The Weinstein Company",@"Weis Markets",@"Welchs",@"WellPoint",@"Wells Fargo",@"Wendys",@"Werner Enterprises",@"Westat",@"West Liberty Foods",@"Western Digital",@"Western Refining",@"Western Sugar Cooperative",@"Western Union",@"Westinghouse Digital",@"Weyerhaeuser",@"Whataburger",@"WheelingPittsburgh Steel",@"Whirlpool Corporation",@"White Castle",@"Whole Foods Market",@"Wienerschnitzel",@"Willett Distilling Company",@"William Blair & Company",@"Williams Companies",@"WilliamsonDickie Manufacturing Company",@"WilliamsSonoma",@"Wi.nCo Foods ",@"Windstream Communications",@"The Wine Group",@"WinnDixie",@"Winnebago Industries",@"Wizards of the Coast",@"W L Gore and Associates",@"GoreTex",@"Wolverine Worldwide",@"Woodward ",@"Woolrich ",@"World Airways",@"World Financial Group",@"World Fuel Services",@"World Wrestling Entertainment WWE",@"Worthington Industries",@"W R Grace and Company",@"W W Grainger",@"Wyndham Worldwide",@"Wynn Resorts",@"Xcel Energy",@"Xerox",@"Xilinx",@"XIM ",@"XPAC",@"XPLANE",@"XRite",@"Xylem ",@"Yahoo!",@"Yelp ",@"YRC Worldwide",@"Yum Brands",@"YumYum Donuts",@"Zale Corporation",@"Zapata Corporation",@"Zappos",@"Zaxbys",@"Zenith Electronics",@"Zilog",@"Zimmer Holdings",@"Zions Bancorp",@"Zippo Manufacturing Company",@"Zoetis ",@"Zoo York",@"Zoom Telephonics",@"Zune",@"Zynga",@"Zumiez",@"Zildjia", nil];
 
    
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
   
    if(![self.CatagoryPicker isHidden]){
        [self.CatagoryPicker setHidden:YES];
        [self.pickerDoneBtn setHidden:YES];
        [self cataDoneClicked:self.CatagoryPicker];
        
        
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
        [self cataDoneClicked:self.methodView];
    }
    if([self.payeeView isFirstResponder]){
      
        [self.pickerDoneBtn setHidden:YES];
        [self cataDoneClicked:self.payeeView];
    }
    if([self.amountView isFirstResponder]){
        
        [self.pickerDoneBtn setHidden:YES];
        [self cataDoneClicked:self.amountView];
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

}

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
    [self.CatagoryPicker setHidden:NO];
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
    str = [NSString stringWithFormat:@"guid=%@&description=%@&amount=%@&payment_method=%@&transaction_type=%@&payee=%@&transaction_date=%@&image=%@",strguid, self.txtview.text,self.totalFilled, self.paymentMethodFilled, self.cataFilled, self.companyToPFilled, self.dateFilled,base64String];
    }
    if(self.Income){
            str = [NSString stringWithFormat:@"guid=%@&description=%@&amount=%@&payment_method=%@&transaction_type=%@&payee=%@&transaction_date=%@&image=%@",strguid, self.txtview.text,self.totalFilled, self.paymentMethodFilled,self.cataFilled, self.companyToPFilled, self.dateFilled,base64String];
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
            self.cataSet = NO;
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Source: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.catagoryView.text = @"Catagory: ";
            self.descriptiontext = @"";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeSource;
            self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
            break;
        case 1:
            self.Transa = YES;
            self.Mileage = NO;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cataSet = NO;
            
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Payee: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.catagoryView.text = @"Catagory: ";
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
            self.cataSet = YES;
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            self.payeeView.text = @"";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Mileage: ";
            self.catagoryView.text = @"Catagory: Mileage";
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
            self.cataSet = NO;
            self.methodView.text = @"Method: ";
            self.payeeView.text = @"Source: ";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Amount: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.catagoryView.text = @"Catagory: ";
            self.payeeView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.payeeView.autocompleteType = HTAutocompleteTypeSource;
            self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
            break;
        case 1:
            self.Transa = YES;
            self.Mileage = NO;
            self.Income = NO;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cataSet = NO;
            self.catagoryView.text = @"Catagory: ";
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
            self.cataSet = YES;
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            self.payeeView.text = @"";
            self.dateView.text = @"Date: ";
            self.amountView.text = @"Mileage: ";
            self.txtview.text = @"Description";
            self.descriptiontext = @"";
            self.catagoryView.text = @"Catagory: Mileage";
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
            self.catagoryView.text = @"Catagory: Mileage";
            self.payeeView.text = @"";
            //[DateFormatter setDateFormat:@"yyyy-mm-dd 'at' hh:mm a"];
    
            self.payeeView.placeholder = @"";
            self.methodView.placeholder = @"";
            self.methodView.text = @"";
            
            self.txtview.text = self.descriptiontext;
}

-(void)IncomeRecord:(NSString *)values{
   // self.payeeView.userInteractionEnabled = YES;
    //self.catagoryView.userInteractionEnabled = NO;
       if (self.Mileage){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cataSet = NO;
    }
    self.Mileage = NO;
    if (self.Transa){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cataSet = NO;
    }
    self.Transa = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
[DateFormatter setDateFormat:@"MM/dd/yyyy"];

    if([values length] == 0){
        if([self.cataFilled  isEqual: @""]){
            NSString *cata = @"Money In - I Don't Know";
            self.catagoryView.text =[NSString stringWithFormat:@"Catagory: %@", cata];
            self.cataSet = TRUE;
            self.cataFilled = [cata capitalizedString];
            self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
            
        }
        
        return;
    }

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
        self.catagoryView.userInteractionEnabled = YES;
        dateset = true;
        
    }
    if ([[values lowercaseString] rangeOfString:@"yesterday"].location !=NSNotFound  && [values length] != 0){
        self.dateFilled = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]];
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.catagoryView.userInteractionEnabled = YES;
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
    

        if([[values lowercaseString] rangeOfString:@"earned income"].location !=NSNotFound || [[values lowercaseString] rangeOfString:@"earned"].location !=NSNotFound){
             self.catagoryView.text = @"Catagory: Money In - Earned Income";
             self.cataFilled = @"Money In - Earned Income";
            self.cataSet = YES;
        }else{
            if(!self.cataSet){
            self.catagoryView.text = @"Catagory: Money In - I Don't Know";
            self.cataFilled = @"Money In - I Don't Know";
            self.cataSet= YES;
            }else if([[self.catagoryView.text componentsSeparatedByString:@":"] count] == 1){
                self.catagoryView.text = @"Catagory: Money In - I Don't Know";
                self.cataFilled = @"Money In - I Don't Know";
                self.cataSet= YES;

            }
        }
    
    
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
    NSString *cata;
    NSString *companyToP;
    total = @"";
    paymentMethod = @"";
    cardEnding = @"";
    cata= @"";
    companyToP = @"";

    
    BOOL amex = false;
    BOOL cardFound = false;
    BOOL cardNumberFound = false;
    if (self.Mileage){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cataSet = NO;
    }
    self.Mileage = NO;
    if (self.Income){
        self.methodSet = NO;
        self.compSet = NO;
        self.amountset = NO;
        self.cataSet = NO;
    }
    self.Income = NO;
    
  
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
      NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    if([values length] == 0){
        if([self.cataFilled  isEqual: @""]){
            cata = @"Money Out - I Don't Know";
            self.catagoryView.text =[NSString stringWithFormat:@"Catagory: %@", cata];
            self.cataSet = TRUE;
            self.cataFilled = [cata capitalizedString];
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
        if (!self.cataSet){
            self.catagoryView.text = @"Catagory: ";
        }
      BOOL dateset = false;

    if ([[values lowercaseString] rangeOfString:@"today"].location !=NSNotFound && [values length] != 0){
   
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[NSDate date]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.catagoryView.userInteractionEnabled = YES;
        dateset = true;
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFilled = [DateFormatter stringFromDate:[NSDate date]];
        
    }
    if ([[values lowercaseString] rangeOfString:@"yesterday"].location !=NSNotFound && [values length] != 0){
        
      
        self.dateView.text = [NSString stringWithFormat:@"Date: %@",[DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
        self.lockSubmit = NO;
        self.payeeView.userInteractionEnabled = YES;
        self.catagoryView.userInteractionEnabled = YES;
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
            NSArray *transactionCatagorys =  [NSArray arrayWithObjects:@"Money Out",@"Advertising/Marketing",@"Automotive",@"Bank/CC Fees",@"Charity/Medical/Misc. Tax Deductions",@"Cost Of Goods",@"Credit Card/Loan Payments",@"Dues/Subscriptions/Professional Fees",@"Insurance/Licenses/Permits",@"Meals/Travel/Entertainment",@"Rent/Utilities",@"Sub-Contractor",@"Supplies/Equipment",@"Telecommunications",nil];
            
            bool catagoryFound = false;
            
            if([[values lowercaseString] rangeOfString:@"tax deductions"].location !=NSNotFound){
                cata = @"Charity/Medical/Misc. Tax Deductions";
                self.cataSet = FALSE;
                catagoryFound = true;
                
            }else if([[values lowercaseString] rangeOfString:@"subcontractor"].location !=NSNotFound){
                cata = @"Sub-Contractor";
                self.cataSet = FALSE;
                catagoryFound = true;
            }else if([[values lowercaseString] rangeOfString:@"credit card fees"].location !=NSNotFound){
                cata = @"Bank/CC Fees";
                self.cataSet = FALSE;
                catagoryFound = true;
            }else{
            for (NSString *catagories in transactionCatagorys){
                if([catagories rangeOfString:@"/"].location != NSNotFound){
                    NSArray *temp = [catagories componentsSeparatedByString:@"/"];
                    for(NSString *temp2 in temp){
                    if([[values lowercaseString] rangeOfString:[temp2 lowercaseString]].location != NSNotFound){
                        cata = catagories;
                        self.cataSet = FALSE;
                        NSLog(@"%@",cata);
                        catagoryFound = true;
                    }
                        }
                    
                }else{
                   if([[values lowercaseString] rangeOfString:[catagories lowercaseString]].location != NSNotFound){
                       if([[catagories lowercaseString] rangeOfString:@"money out"].location !=NSNotFound){
                           cata = @"Money Out - I Don't Know";
                           self.cataSet = FALSE;
                           NSLog(@"%@",cata);
                           catagoryFound = true;
                       }else{
                           cata = catagories;
                           self.cataSet = FALSE;
                           NSLog(@"%@",cata);
                           catagoryFound = true;
                       }
          
                }
                }
            }
                NSArray *randomstuff = [self.catagoryView.text componentsSeparatedByString:@": "];
            if(!catagoryFound && self.cataFilled == @""){
                cata = @"Money Out - I Don't Know";
                self.cataSet = FALSE;
                NSLog(@"%@",cata);
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
        //NSString *values = [NSString stringWithFormat:@"Amount: %@ \nPayment Method: %@ %@ \nCatagory: %@ \nPayee: %@ \n\nDescription:%@", total,[paymentMethod capitalizedString],cardEnding,[cata capitalizedString],companyToP,self.descriptiontext ];
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
    
    if (!self.cataSet){
        self.catagoryView.text =[NSString stringWithFormat:@"Catagory: %@", cata];
        self.cataSet = TRUE;
        self.cataFilled = [cata capitalizedString];
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
        [self.CatagoryPicker setHidden:YES];
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
    [self.CatagoryPicker setHidden:YES];
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
                // [self.catagoryView becomeFirstResponder];
                return;
            }
            if ([[card lowercaseString] rangeOfString:@"american"].length > 5){
                if (cNSize == 5){
                    card = [NSString stringWithFormat:@"American Express %@" , cardnumber];
                    //saved = [appDelegate saveCardInfo:card];
                    NSLog(@"Method: %@",card);
                   // NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                    self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                    //   [self.catagoryView becomeFirstResponder];
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
                    //   [self.catagoryView becomeFirstResponder];
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
                //   [self.catagoryView becomeFirstResponder];
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
            // [self.catagoryView becomeFirstResponder];
            return;
        }
        if ([[card lowercaseString] rangeOfString:@"american"].length > 5){
            if (cNSize == 5){
                card = [NSString stringWithFormat:@"American Express %@" , cardnumber];
                saved = [appDelegate saveCardInfo:card];
                NSLog(@"Method: %@",card);
                NSLog(saved ? @"Yes, Saved" : @"No, Not Saved");
                self.methodView.text = [NSString stringWithFormat:@"Method: %@", [card capitalizedString]];
                //   [self.catagoryView becomeFirstResponder];
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
                //   [self.catagoryView becomeFirstResponder];
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
            //   [self.catagoryView becomeFirstResponder];
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
    if (!self.cataSet){
        
        self.cataSet = TRUE;
        self.catagoryView.text = @"Catagory: Money Out - I Don't Know";
        self.cataFilled =@"Money Out - I Don't Know";
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
        if (!self.cataSet){
            self.catagoryView.text = @"Catagory: Mileage";
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
        if (!self.cataSet){
            self.catagoryView.text = @"Catagory: Money In - I Don't Know";
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
    if(textField == self.catagoryView){
        [self.methodView resignFirstResponder];
        [self.payeeView resignFirstResponder];
        [self.amountView resignFirstResponder];
        [self.txtview resignFirstResponder];
        [self.amountView resignFirstResponder];
        if(!([[self.catagoryView.text componentsSeparatedByString:@":"] count] == 1)){
            for (int i=0;i<[self.catagoraytypes count]; i++) {
                NSLog(@"%@",[[self.catagoryView.text componentsSeparatedByString:@":"] objectAtIndex:1] );
                if([[[self.catagoryView.text componentsSeparatedByString:@":"] objectAtIndex:1] rangeOfString:[self.catagoraytypes objectAtIndex:i]].location != NSNotFound){
                    [self.CatagoryPicker selectRow:i inComponent:0 animated:NO];
                }
            }

        }
        [self.CatagoryPicker setHidden:NO];
        [self.pickerDoneBtn setHidden:NO];
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
        
    return NO;
    }else if(textField == self.amountView){
        [self.CatagoryPicker setHidden:YES];
        return YES;

    }else{
        [self.CatagoryPicker setHidden:YES];
        [self.pickerDoneBtn setHidden:NO];
        [self.calenderPicker removeFromSuperview];
        [self.calenderbar removeFromSuperview];
        return YES;
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView == self.CatagoryPicker){
        return 1;
    }else{
        return 3;
    }

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == self.CatagoryPicker){
       return 21;
    }
    if(pickerView == self.timePicker){
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
    return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == self.CatagoryPicker){
    return [self.catagoraytypes objectAtIndex:row];
    }
    if(pickerView == self.timePicker){
        return self.dateValues[component][row];
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
         if(pickerView == self.CatagoryPicker){
    switch (row) {
        case 0:
            [pickerView selectRow:1 inComponent:component animated:YES];
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:1]];
            self.prevrow = 1;
            
            [self.CatagoryPicker reloadComponent:0];
            break;
        case 1:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            self.cataFilled = [self.catagoraytypes objectAtIndex:row];

            self.prevrow = row;
            break;
        case 2:
            if (self.prevrow == 1){
                [pickerView selectRow:4 inComponent:component animated:YES];
                self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:4]];
                self.prevrow = 4;
            }else{
                [pickerView selectRow:1 inComponent:component animated:YES];
                self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:1]];
                self.prevrow = 1;
            }
            break;
        case 3:
              [pickerView selectRow:4 inComponent:component animated:YES];
             self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:4]];
               self.prevrow = 4;
            break;
        case 4:
             self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            self.prevrow = row;
            break;
        case 5:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 6:
            if(self.prevrow <= 4){
                [pickerView selectRow:8 inComponent:component animated:YES];
                self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:8]];
                self.prevrow = 8;
            }else{
                [pickerView selectRow:5 inComponent:component animated:YES];
                self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:5]];
                self.prevrow = 4;
            }
            break;
        case 7:
            [pickerView selectRow:8 inComponent:component animated:YES];
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:8]];
            self.prevrow = row;
            break;
        case 8:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 9:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 10:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 11:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 12:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 13:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 14:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 15:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 16:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 17:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 18:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 19:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 20:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        case 21:
            self.catagoryView.text = [NSString stringWithFormat:@"Catagory: %@" , [self.catagoraytypes objectAtIndex:row]];
            break;
        
         

    }
    }
    if (pickerView == self.timePicker){
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
    if(pickerView == self.CatagoryPicker){
    UILabel* tView = (UILabel*)view;
    if (!tView){
        if(row == 0 || row == 3 || row == 7){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:28]];
        [tView setTextColor:[UIColor whiteColor]];
        [tView setTextAlignment:UITextAlignmentCenter];
        tView.numberOfLines=1;
        }else{
            tView = [[UILabel alloc] init];
            [tView setFont:[UIFont fontWithName:@"Arial" size:18]];
            [tView setTextColor:[UIColor whiteColor]];
            [tView setTextAlignment:UITextAlignmentCenter];
            tView.numberOfLines=2;
            
        }
    }
    
    // Fill the label text here
    tView.text = [self.catagoraytypes objectAtIndex:row];
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
    if (pickerView == self.CatagoryPicker){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self.catagoraytypes objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:titleFont}];
        return attString;
    }else{
    
    }
    
    if (pickerView == self.timePicker){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.dateValues[component][row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    return nil;
    
    
}


- (IBAction)cataDoneClicked:(id)sender {
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

    [self.CatagoryPicker setHidden:YES];
    [self.pickerDoneBtn setHidden:YES];
    if (![self.timePicker isHidden]){
    [self.timePicker setHidden:YES];
        return;
    }
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];

   
    if (![self.catagoryView.text isEqualToString:@""]){
    NSString *catagorySelected =[[self.catagoryView.text componentsSeparatedByString:@":"] objectAtIndex:1];
        self.cataFilled = catagorySelected;

    if ([catagorySelected isEqualToString:@" Mileage"]){
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
        self.cataSet = YES;
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
    }else if ([catagorySelected rangeOfString:@"Money In"].location !=NSNotFound){
        if(self.Income){
            return;
        }
        if([[[catagorySelected componentsSeparatedByString:@" - "] objectAtIndex:1] rangeOfString:@"Earned Income"].location !=NSNotFound){
            _calenderPicker = [[CKCalendarView alloc] init];
            
            _calenderPicker.delegate = self;
            self.Mileage = false;
            self.Transa = false;
            self.Income = true;
            self.methodSet = NO;
            self.compSet = NO;
            self.amountset = NO;
            self.cataSet = YES;
            self.cataFilled =@"Money In - Earned Income";
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
            self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
            self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
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
        self.cataSet = YES;

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
        self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        self.methodView.autocompleteType = HTAutocompleteTypeRecieve;
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
        self.cataSet = YES;
        
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
        self.methodView.autocompleteDataSource = [HTAutocompleteManager sharedManager];
        self.methodView.autocompleteType = HTAutocompleteTypeMethod;
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
