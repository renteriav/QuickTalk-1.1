//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteManager.h"
#import "AppDelegate.h"
static HTAutocompleteManager *sharedManager;

@implementation HTAutocompleteManager

+ (HTAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[HTAutocompleteManager alloc] init]; });
	return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == HTAutocompleteTypeEmail)
    {
        static dispatch_once_t onceToken;
        static NSArray *autocompleteArray;
        dispatch_once(&onceToken, ^
                      {
                          autocompleteArray = @[  @"gmail.com",
                                                  @"yahoo.com",
                                                  @"hotmail.com",
                                                  @"aol.com",
                                                  @"comcast.net",
                                                  @"me.com",
                                                  @"msn.com",
                                                  @"live.com",
                                                  @"sbcglobal.net",
                                                  @"ymail.com",
                                                  @"att.net",
                                                  @"mac.com",
                                                  @"cox.net",
                                                  @"verizon.net",
                                                  @"hotmail.co.uk",
                                                  @"bellsouth.net",
                                                  @"rocketmail.com",
                                                  @"aim.com",
                                                  @"yahoo.co.uk",
                                                  @"earthlink.net",
                                                  @"charter.net",
                                                  @"optonline.net",
                                                  @"shaw.ca",
                                                  @"yahoo.ca",
                                                  @"googlemail.com",
                                                  @"mail.com",
                                                  @"qq.com",
                                                  @"btinternet.com",
                                                  @"mail.ru",
                                                  @"live.co.uk",
                                                  @"naver.com",
                                                  @"rogers.com",
                                                  @"juno.com",
                                                  @"yahoo.com.tw",
                                                  @"live.ca",
                                                  @"walla.com",
                                                  @"163.com",
                                                  @"roadrunner.com",
                                                  @"telus.net",
                                                  @"embarqmail.com",
                                                  @"hotmail.fr",
                                                  @"pacbell.net",
                                                  @"sky.com",
                                                  @"sympatico.ca",
                                                  @"cfl.rr.com",
                                                  @"tampabay.rr.com",
                                                  @"q.com",
                                                  @"yahoo.co.in",
                                                  @"yahoo.fr",
                                                  @"hotmail.ca",
                                                  @"windstream.net",
                                                  @"hotmail.it",
                                                  @"web.de",
                                                  @"asu.edu",
                                                  @"gmx.de",
                                                  @"gmx.com",
                                                  @"insightbb.com",
                                                  @"netscape.net",
                                                  @"icloud.com",
                                                  @"frontier.com",
                                                  @"126.com",
                                                  @"hanmail.net",
                                                  @"suddenlink.net",
                                                  @"netzero.net",
                                                  @"mindspring.com",
                                                  @"ail.com",
                                                  @"windowslive.com",
                                                  @"netzero.com",
                                                  @"yahoo.com.hk",
                                                  @"yandex.ru",
                                                  @"mchsi.com",
                                                  @"cableone.net",
                                                  @"yahoo.com.cn",
                                                  @"yahoo.es",
                                                  @"yahoo.com.br",
                                                  @"cornell.edu",
                                                  @"ucla.edu",
                                                  @"us.army.mil",
                                                  @"excite.com",
                                                  @"ntlworld.com",
                                                  @"usc.edu",
                                                  @"nate.com",
                                                  @"outlook.com",
                                                  @"nc.rr.com",
                                                  @"prodigy.net",
                                                  @"wi.rr.com",
                                                  @"videotron.ca",
                                                  @"yahoo.it",
                                                  @"yahoo.com.au",
                                                  @"umich.edu",
                                                  @"ameritech.net",
                                                  @"libero.it",
                                                  @"yahoo.de",
                                                  @"rochester.rr.com",
                                                  @"cs.com",
                                                  @"frontiernet.net",
                                                  @"swbell.net",
                                                  @"msu.edu",
                                                  @"ptd.net",
                                                  @"proxymail.facebook.com",
                                                  @"hotmail.es",
                                                  @"austin.rr.com",
                                                  @"nyu.edu",
                                                  @"sina.com",
                                                  @"centurytel.net",
                                                  @"usa.net",
                                                  @"nycap.rr.com",
                                                  @"uci.edu",
                                                  @"hotmail.de",
                                                  @"yahoo.com.sg",
                                                  @"email.arizona.edu",
                                                  @"yahoo.com.mx",
                                                  @"ufl.edu",
                                                  @"bigpond.com",
                                                  @"unlv.nevada.edu",
                                                  @"yahoo.cn",
                                                  @"ca.rr.com",
                                                  @"google.com",
                                                  @"yahoo.co.id",
                                                  @"inbox.com",
                                                  @"fuse.net",
                                                  @"hawaii.rr.com",
                                                  @"talktalk.net",
                                                  @"gmx.net",
                                                  @"walla.co.il",
                                                  @"ucdavis.edu",
                                                  @"carolina.rr.com",
                                                  @"comcast.com",
                                                  @"live.fr",
                                                  @"blueyonder.co.uk",
                                                  @"live.cn",
                                                  @"cogeco.ca",
                                                  @"abv.bg",
                                                  @"tds.net",
                                                  @"centurylink.net",
                                                  @"yahoo.com.vn",
                                                  @"uol.com.br",
                                                  @"osu.edu",
                                                  @"san.rr.com",
                                                  @"rcn.com",
                                                  @"umn.edu",
                                                  @"live.nl",
                                                  @"live.com.au",
                                                  @"tx.rr.com",
                                                  @"eircom.net",
                                                  @"sasktel.net",
                                                  @"post.harvard.edu",
                                                  @"snet.net",
                                                  @"wowway.com",
                                                  @"live.it",
                                                  @"hoteltonight.com",
                                                  @"att.com",
                                                  @"vt.edu",
                                                  @"rambler.ru",
                                                  @"temple.edu",
                                                  @"cinci.rr.com"];
                      });
        
        // Check that text field contains an @
        NSRange atSignRange = [prefix rangeOfString:@"@"];
        if (atSignRange.location == NSNotFound)
        {
            return @"";
        }
        
        // Stop autocomplete if user types dot after domain
        NSString *domainAndTLD = [prefix substringFromIndex:atSignRange.location];
        NSRange rangeOfDot = [domainAndTLD rangeOfString:@"."];
        if (rangeOfDot.location != NSNotFound)
        {
            return @"";
        }
        
        // Check that there aren't two @-signs
        NSArray *textComponents = [prefix componentsSeparatedByString:@"@"];
        if ([textComponents count] > 2)
        {
            return @"";
        }
        
        if ([textComponents count] > 1)
        {
            // If no domain is entered, use the first domain in the list
            if ([(NSString *)textComponents[1] length] == 0)
            {
                return [autocompleteArray objectAtIndex:0];
            }
            
            NSString *textAfterAtSign = textComponents[1];
            
            NSString *stringToLookFor;
            if (ignoreCase)
            {
                stringToLookFor = [textAfterAtSign lowercaseString];
            }
            else
            {
                stringToLookFor = textAfterAtSign;
            }
            
            for (NSString *stringFromReference in autocompleteArray)
            {
                NSString *stringToCompare;
                if (ignoreCase)
                {
                    stringToCompare = [stringFromReference lowercaseString];
                }
                else
                {
                    stringToCompare = stringFromReference;
                }
                
                if ([stringToCompare hasPrefix:stringToLookFor])
                {
                    return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
                }
                
            }
        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeColor)
    {
        static dispatch_once_t colorOnceToken;
        static NSArray *colorAutocompleteArray;
        dispatch_once(&colorOnceToken, ^
        {
            colorAutocompleteArray = @[ @"Alfred",
                                        @"Beth",
                                        @"Carlos",
                                        @"Daniel",
                                        @"Ethan",
                                        @"Fred",
                                        @"George",
                                        @"Helen",
                                        @"Inis",
                                        @"Jennifer",
                                        @"Kylie",
                                        @"Liam",
                                        @"Melissa",
                                        @"Noah",
                                        @"Omar",
                                        @"Penelope",
                                        @"Quan",
                                        @"Rachel",
                                        @"Seth",
                                        @"Timothy",
                                        @"Ulga",
                                        @"Vanessa",
                                        @"William",
                                        @"Xao",
                                        @"Yilton",
                                        @"Zander"];
        });

        NSString *stringToLookFor;
		NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in colorAutocompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }else if (textField.autocompleteType == HTAutocompleteTypeComp){
        static dispatch_once_t compOnceToken;
        static NSArray *companys;
        dispatch_once(&compOnceToken, ^
        {
            companys = @[@"2K Games",@"21st Century Fox",@"24 Hour Fitness",@"3M",@"4Licensing Corporation",@"a21 Inc",@"Aarons Inc",@"Abbott Laboratories",@"AbbVie",@"Abercrombie & Fitch",@"ABM Industries",@"ABS Capital Partners",@"ABX Air",@"AC Lens",@"Academi",@"Access Systems Americas Inc",@"ACCO Brands",@"Accuquote",@"Accuride Corporation",@"Ace Hardware",@"Acme Brick",@"Acme Fresh Market",@"Acsis Inc",@"ACN Inc",@"Activision",@"Activision Blizzard",@"Acuity Brands",@"Acuity Insurance",@"ADC Telecommunications",@"Adaptec",@"Adobe Systems",@"ADT Corp",@"ADTRAN",@"Advance Auto Parts",@"Advance Publications",@"Advanced Micro Devices",@"Advanced Processing & Imaging",@"Advent International",@"AECOM",@"Aerojet Rocketdyne",@"Aéropostale",@"AES Corporation",@"Aetna",@"Affiliated Computer Services",@"Aflac",@"AGCO",@"Agilent Technologies",@"AGL Resources",@"Agriprocessors",@"Air Products & Chemicals",@"Airgas",@"Air Tractor",@"Air Transport International",@"AirTran Holdings",@"Air Wisconsin",@"AK Steel Holding",@"Akamai Technologies",@"Alaska Air Group",@"Albemarle Corporation",@"Albertsons LLC",@"Alcoa",@"Aleris",@"Alexander & Baldwin",@"Alexander Arms",@"Alexion Pharmaceuticals",@"Alienware",@"Alleghany Corporation",@"Allegheny Technologies",@"Allegis Group",@"Allen Organ Company",@"Allergan",@"Alliance Rubber Company",@"Alliant Energy",@"Alliant Techsystems",@"Allied Insurance",@"Allison Transmission",@"Allstate",@"Ally Financial",@"Aloha Air Cargo",@"Altec Lansing",@"Altera Corporation",@"Alton Steel",@"Altra Industrial Motion",@"Altria",@"Amazon",@"AMC Entertainment",@"Ameren",@"American Axle",@"American Apparel",@"American Broadcasting Company",@"American Eagle Outfitters",@"American Electric Power",@"American Express",@"American Family Insurance",@"American Financial Group",@"American Greetings",@"American Home Mortgage",@"American International Group",@"American Licorice Company",@"American Reprographics Company",@"American Sugar Refining Inc",@"Amerigroup",@"Ameriprise Financial",@"AmerisourceBergen",@"Ametek",@"Amgen",@"Amkor Technology",@"Ampex Corporation",@"Amphenol",@"AMR Corporation",@"American Airlines",@"AMSOIL Inc",@"Amtrak",@"Amway",@"Amys Kitchen",@"Anadarko Petroleum Corporation",@"Analog Devices",@"AnaSpec",@"Ancestrycom Inc",@"Anchor Bay Entertainment",@"Anchor Brewing Company",@"AND1",@"Andersen Corporation",@"Andronicos",@"Anixter",@"Ann Taylor",@"Annabelle Candy Company",@"Ansys",@"Antec",@"AOL",@"Aon plc",@"A O Smith Corporation",@"Apache Corporation",@"Apache Software Foundation",@"Apollo Global Management",@"Apollo Group",@"Applebees",@"Apple Inc",@"Applico",@"Applied Biosystems",@"Applied Industrial Technologies",@"Applied Materials",@"Aramark",@"Arbitron",@"Arch Coal",@"Archer Daniels Midland",@"Arc Machines",@"Arctic Cat",@"Ariba",@"Arizona Beverage Company",@"Arizona Stock Exchange",@"Arkeia Software",@"Armstrong World Industries",@"Arrow Electronics",@"Arryx",@"ASARCO American Smelting And Refining Company",@"Asbury Automotive Group",@"A Schulman",@"Ashland Inc",@"Ashley Furniture Industries",@"AskMeNow",@"Aspen Skiing Company",@"Aspyr Media",@"Associated Wholesale Grocers",@"Assurant",@"Atlas Air",@"Atlas Van Lines",@"Atmel Corporation",@"Atmos Energy",@"AT Conference Inc",@"AT&T Inc",@"AT&T Mobility",@"Audiovox",@"Atari",@"Au Bon Pain",@"Authentic Brands Group",@"Autodesk",@"Autoliv",@"Automatic Data Processing",@"AutoNation",@"AutoOwners Insurance",@"AutoZone",@"Avaya",@"Avery Dennison",@"Avis Budget Group",@"Avnet",@"Avon Products",@"AVST",@"A&W Restaurants",@"Babcock & Wilcox",@"Bain & Company",@"Bain Capital",@"Baker Hughes",@"Bakers Square Restaurants",@"Baldor Electric Company",@"Ball Corporation",@"Ballistic Recovery Systems",@"Bally Technologies Inc",@"Bank of America",@"The Bank of New York Mellon Corporation",@"Barnes & Noble",@"Barrett Firearms Manufacturing",@"Bass Pro Shops",@"Bath & Body Works",@"Baxter International",@"BB&T Corporation",@"Bebo",@"B/E Aerospace",@"Bealls",@"Beam Inc",@"BearingPoint",@"Beazer Homes USA",@"Bechtel",@"Beckman Coulter",@"Becton Dickinson",@"Bed Bath & Beyond",@"Beechcraft",@"Beer Nuts Inc",@"Belk",@"Belkin",@"Bellwether Technology Corporation",@"Bemis Company Inc",@"Bemis Manufacturing Company",@"Benchmark Electronics",@"Ben Franklin",@"Benihana",@"Bennigans",@"W R Berkley",@"Berkshire Hathaway",@"Berry Plastics",@"Best Buy",@"Best Western International",@"BFG Technologies",@"Big 5 Sporting Goods",@"Big Boy Restaurants",@"Bigelow Tea Company",@"Big Lots",@"Biggby Coffee",@"BILO",@"Biogen Idec",@"BioRad Laboratories",@"Biomet",@"Birdwell",@"Bissell Inc",@"BJ Services Company",@"BJs Wholesale Club",@"Black Angus Steakhouse",@"BlackRock",@"Blackstone Group",@"Blistex Inc",@"Blockbuster",@"Bloomin Brands",@"BlueLinx",@"Blyth Inc",@"BMC Software",@"BNSF Railway",@"Bob Evans Restaurants",@"Boeing",@"Boise Cascade",@"Bollinger Shipyards",@"Booz Allen Hamilton",@"Borders Group",@"BorgWarner",@"Bosch Brewing Company",@"Bose Corporation",@"Boston Acoustics",@"Boston Beer Company",@"Boston Scientific",@"Bowlmor AMF",@"Boyd Gaming",@"Boyer Brothers",@"BP",@"Bradley Pharmaceuticals",@"Briggs & Stratton",@"BrightPoint",@"Brinker International",@"Brinks",@"BristolMyers Squibb",@"Broadcom",@"Brocade Communications Systems",@"Bronco Wine Company",@"Brookdale Senior Living",@"Brooks Brothers",@"BrownForman",@"Brown and Haley",@"Brown Shoe Company",@"Browning Arms Company",@"Bruker",@"Brunswick Corporation",@"Bucyrus International",@"BucketFeet",@"BunnOMatic Corporation",@"Burger King",@"Burlington Coat Factory",@"Burpee Seeds",@"Burton Snowboards",@"Bushmaster Firearms International",@"Cabelas",@"CA Technologies",@"Cablevision Systems",@"Cabot Corporation",@"Cabot Oil & Gas",@"CACI",@"Cadence Design Systems",@"California Pizza Kitchen",@"Calista Corporation",@"Callaway Golf Company",@"CalMaine",@"Calpine",@"CamelBak Products",@"Cameron International",@"Campbell Soup Company",@"Canvas",@"Cape Air",@"Capital Group Companies",@"Capital One",@"Cardinal Health",@"CareFusion",@"Carlson Companies",@"Carnival Corporation & plc",@"Carnival Cruise Lines",@"Cargill",@"Carlisle Companies",@"Carlyle Group",@"CarMax",@"Carpenter Technology Corporation",@"Carroll Shelby International",@"Carters Inc",@"Cartoon Network Studios",@"Casco Bay Lines",@"Caterpillar Inc",@"Cbeyond",@"CBS Corporation",@"CDI Corporation",@"CDW Corporation",@"Cedar Fair Entertainment Company",@"Celanese Corporation",@"Celgene",@"CenturyLink",@"Cerberus Capital Management",@"Ceridian",@"Cerner",@"CF Industries",@"CH2M Hill Companies",@"C H Robinson Worldwide",@"Charles Schwab Corporation",@"Charter",@"The Cheesecake Factory",@"ChemDry",@"Chesapeake Energy",@"Chevron Corporation",@"ChexSystems",@"Chicago Bridge & Iron Company",@"ChickfilA",@"Chipotle Mexican Grill",@"Chiquita Brands International",@"Choice Hotels International",@"Christian Moerlein Brewing Company",@"CHS Inc",@"Chubb Corporation",@"Chuck E Cheeses",@"Chugach Alaska Corporation",@"Church & Dwight",@"Chrysler",@"CiCis Pizza",@"CIGNA",@"Cinemark Theatres",@"Cintas Corporation",@"Cirrus Aircraft Corporation",@"Cisco Systems",@"Citigroup",@"CIT Group",@"Citrix Systems",@"CKE Restaurants",@"Hardees",@"Carls Jr",@"Clayton Dubilier & Rice",@"Clear Channel Communications",@"Clearwater Paper",@"Cliffs Natural Resources",@"The Clorox Company",@"CME Group",@"CNA Financial",@"CNET",@"CNO Financial Group",@"Coach",@"The CocaCola Company",@"Cogent Communications",@"Cognizant Technology Solutions",@"Cole Haan",@"ColgatePalmolive",@"Colt Defense",@"Colts Manufacturing Company",@"Columbia Pictures",@"Columbia Sportswear",@"Columbia Sussex",@"Comcast",@"Comerica",@"Commercial Metals Company",@"Comodo",@"Computer Sciences Corporation",@"Compuware",@"ConAgra Foods",@"Conair Corporation",@"ConocoPhillips",@"Consol Energy",@"Constellation Brands",@"Control Data Corporation",@"ConverDyn",@"Convergys",@"Converse",@"CoolTouch Monitors",@"Copelands",@"Cordell & Cordell",@"Corning Inc",@"Corrections Corporation of America",@"Corsair Memory",@"Costco",@"Cott Corporation",@"Coventry Health Care",@"Cox",@"Cracker Barrel",@"Craft Brew Alliance",@"Craigslist",@"Crane Carrier Company",@"Crane & Co Inc",@"Crane Company",@"Cray",@"Crazy Eddie",@"C R Bard Inc",@"Crowley Maritime",@"Crown Castle International",@"Crown Equipment Corporation",@"Crown Holdings",@"C&S Wholesale Grocers",@"CSX Corporation",@"Cubic Corporation",@"Culvers Franchising System Inc",@"Cumberland Farms",@"Cummins",@"CurtissWright",@"Curves International",@"CVS Caremark",@"Cypress Semiconductor",@"Daktronics",@"Dana Corporation",@"Danaher",@"Darden Restaurants",@"Dart Container Corporation",@"DaVita",@"Day & Zimmermann",@"Dayton Superior",@"DC Comics",@"DC Shoes",@"Dean Foods",@"Deere & Company",@"Del Monte Foods",@"Dell",@"Delphi",@"Delta Air Lines",@"Deluxe Corporation",@"Denbury Resources",@"Dennys",@"Dentsply",@"Devon Energy",@"DeVry Inc",@"DEX One",@"Diamond Foods",@"Diamond Offshore Drilling",@"Dicks Sporting Goods",@"DiC Entertainment",@"Diebold",@"DigiKey",@"Dillards",@"DineEquity",@"Dippin Dots",@"DirecTV",@"Discover Financial",@"Discovery Communications",@"Dish Network",@"The Walt Disney Company",@"DivX Inc",@"Djarum",@"Doculabs",@"Dogfish Head Brewery",@"Dole Food Company",@"Dollar General",@"Dollar Tree",@"Dominion Resources",@"Dominos Pizza",@"Domtar",@"Dover Corporation",@"Dow Chemical Company",@"Dow Jones & Company",@"D R Horton",@"Dr Pepper Snapple Group",@"Dresser Industries",@"DRS Technologies",@"DST Systems",@"DTE Energy",@"Duke Energy",@"Dun & Bradstreet",@"Dunkin Donuts",@"DuPont",@"Dura Automotive Systems",@"DynCorp",@"Dynegy",@"E*Trade Financial Corporation",@"Eastman Chemical Company",@"Eastman Kodak",@"Eaton Corporation",@"eBay",@"Ebonite International",@"EBSCO Industries",@"EchoStar",@"Ecolab",@"Eddie Bauer",@"Edward Jones",@"Edwards Lifesciences",@"E & J Gallo Winery",@"Egglands Best",@"El Paso Corp",@"Electronic Arts",@"Electronic Data Systems",@"Electronics for Imaging Inc",@"Eli Lilly and Company",@"Elizabeth Arden",@"El Pollo Loco",@"EMC Corporation",@"Emcor",@"Emerson Electric Company",@"Emerson Radio",@"Energizer Holdings",@"Enterasys Networks",@"Entergy",@"Enterprise Holdings",@"Enterprise Products",@"EOG Resources",@"Equifax",@"Equinix",@"Erickson AirCrane",@"Erie Insurance Group",@"Esselte",@"Estée Lauder Companies",@"Estes Industries",@"Estwing Manufacturing Company",@"Ethan Allen",@"Eureka",@"Evergreen International Airlines",@"Exelon",@"Exide Technologies",@"Expedia",@"Expeditors International",@"Express Scripts",@"Extron",@"ExxonMobil",@"F5 Networks",@"Fabrik Inc",@"Facebook",@"Fairchild Semiconductor",@"Family Dollar Stores",@"Fannie Mae",@"Far West Capital",@"Farmers Insurance Group",@"FatPipe networks",@"Faultless Starch/Bon Ami Company",@"FederalMogul Corporation",@"Federal Signal Corporation",@"FedEx",@"Fender Musical Instruments Corporation",@"Fenway Partners",@"FICO",@"Fidelity Investments",@"FileMaker Inc formerly Claris Corp",@"Firestone Tire and Rubber Company",@"First Hawaiian Bank",@"Firstsource",@"Fidelity National Information Services",@"Fiserv",@"Fisher Electronics",@"Fisker Automotive",@"Five Guys Enterprises",@"FLIR Systems",@"Flowers Foods",@"Flowserve",@"Fluor Corporation",@"FMC Technologies",@"Focus Brands",@"Foot Locker",@"Ford Motor Company",@"Forest Laboratories",@"Forrester Research",@"Fortune Brands Home & Security Inc",@"Forum Communications",@"Fossil Inc",@"Foster Farms",@"Fosters Freeze",@"Fox Entertainment Group",@"Franklin Templeton",@"Frasca International",@"Fred Meyer",@"Freddie Mac",@"Freedom Group",@"FreeportMcMoRan",@"Freescale Semiconductor",@"FreeWave Technologies",@"Fresh & Easy",@"Friedman Fleischer & Lowe",@"Frontier Airlines",@"Frontier Communications",@"Fruit of the Loom",@"Frys Electronics",@"GameStop",@"Gannett Company",@"Gap",@"Gardner Denver",@"Garmin",@"Gartner",@"Gateway Inc",@"Gatorade",@"GCI",@"GEICO",@"Gemini Sound Products",@"GenCorp",@"Genentech",@"Generac Power Systems",@"General Atomics",@"General Cable",@"General Dynamics",@"Bath Iron Works",@"General Dynamics Electric Boat",@"Gulfstream Aerospace",@"General Electric",@"GE Consumer & Industrial",@"General Mills",@"General Motors",@"Genesco Inc",@"Gentiva Health Services",@"Genuine Parts Company",@"Genworth Financial",@"GeorgiaPacific",@"Gerber Scientific",@"GHD Group",@"Giant Food",@"Gibson Guitar Corporation",@"Gilead Sciences",@"Gillette",@"Global Insight",@"GlobalFoundries",@"Go Daddy",@"Gojo Industries",@"Golden Corral",@"Goldman Sachs",@"Goodwill",@"Goodyear",@"Google",@"Gordon Food Service",@"Graco",@"Graham Holdings Company",@"Gray Line Worldwide",@"The Greenbrier Companies",@"Green Mountain Coffee Roasters",@"Ground Round",@"Group O",@"Groupon",@"Growmark",@"GTECH",@"Guardian Industries",@"H&R Block",@"Haas Automation",@"Hain Celestial Group",@"Hallmark Cards",@"Halliburton",@"HanesBrands",@"The Hanover Insurance Group",@"Harbor Freight Tools",@"Hard Rock Cafe",@"HarleyDavidson",@"Harman International Industries",@"Harris Corporation",@"Harsco Corporation",@"The Hartford Financial Services Group",@"Hartzell Propeller",@"Hasbro",@"Hastings Entertainment",@"Hawaiian Airlines",@"Haworth Inc",@"Hearst Corporation",@"HEB",@"Heaven Hill Distilleries Inc",@"Henry Repeating Arms",@"Henry Schein Inc",@"Herbalife",@"Herman Miller Inc",@"The Hershey Company",@"The Hertz Corporation",@"Hess Corporation",@"HewlettPackard",@"Hexcel Corporation",@"Hillerich & Bradsby Company",@"HiPoint Firearms",@"Hilton Worldwide",@"H J Heinz Company",@"HNI Corporation",@"Hobbico Inc",@"Hobby Lobby",@"Holley Performance Products",@"Hollister Clothing",@"Hologic Inc",@"Home City Ice",@"Home Depot",@"Home Shopping Network",@"Honeywell",@"Hormel Foods Corporation",@"Hornbeck Offshore Services",@"Hospital Corporation of America",@"Hostess Brands",@"Host Hotels & Resorts Inc",@"Hot Topic",@"Houchens Industries",@"Houghton Mifflin Harcourt Learning Technology",@"Houlihans",@"House of Deréon",@"H T Hackney Company",@"Hughes Communications",@"Human Kinetics",@"Humana",@"Hunt Petroleum",@"Huntington Ingalls Industries",@"Huntsman Corporation",@"Hyland Software",@"HyVee",@"IBM",@"Iconix Brand Group",@"Ideal Industries",@"Ilitch Holdings",@"Illinois Tool Works",@"Imation",@"Infinity Ward",@"Infor Global Solutions",@"Ingram Industries",@"Ingram Micro",@"InNOut Burger",@"Intel",@"Interactive Brokers",@"IntercontinentalExchange",@"Intercontinental Manufacturing Company",@"International Dairy Queen",@"International Flavors & Fragrances",@"International Game Technology",@"International Lease Finance Corporation",@"International Paper",@"Interplay Entertainment",@"Interpublic Group",@"Intersil Corporation",@"Interstate Batteries",@"Interstate Van Lines",@"Ingredion Incorporated",@"Intuit",@"Intuitive Surgical",@"Invacare Corporation",@"Invesco",@"Ion Media Networks",@"iRobot",@"Iron City Brewing Company",@"Iron Mountain Incorporated",@"ITT Corporation",@"ITT Technical Institute",@"IXYS Corporation",@"Jabil Circuit",@"Jack in the Box",@"Jacobs Engineering Group",@"Jamba Juice",@"Janus Capital Group",@"Jarden",@"J B Hunt Transport Services",@"J C Penney",@"J Crew Group",@"JDS Uniphase",@"The Jelly Belly Candy Company",@"JetBlue Airways",@"Jimmy Johns",@"JL Audio",@"JM Family Enterprises",@"The JM Smucker Company",@"JNInternational Medical Corporation",@"Jobing",@"Jockey International Inc",@"Jones Soda",@"Johnson & Johnson",@"Johnson Controls",@"Johnsonville Foods",@"John Wiley & Sons",@"Joseph A Bank Clothiers",@"Journal Communications",@"JPMorgan Chase",@"J R Simplot Company",@"Juniper Networks",@"Kahala Corporation",@"Kahr Arms",@"Kaiser Aluminum",@"Kaiser Permanente",@"Kalitta Air",@"Kaman Aerospace",@"Kampgrounds of America KOA",@"Kansas City Southern Railway",@"KB Home",@"KBR",@"KFC",@"KelTec CNC Industries",@"Kellogg Company",@"Kelly Services",@"KendallJackson",@"Kenexa",@"Kennametal",@"Kenworth",@"KerrMcGee",@"KeyBank",@"Kiewit Corporation",@"Kimball International",@"Kimber Manufacturing",@"KimberlyClark",@"Kinder Morgan",@"King Kullen Grocery Company",@"Kingston Technology",@"KLA Tencor",@"Klipsch Audio Technologies",@"Kohlberg Kravis Roberts KKR",@"Kmart",@"Knights Armament Company",@"Koch Industries",@"Kohler Company",@"Kohls",@"KPMG",@"Kraft Foods",@"Krispy Kreme",@"Kroger",@"KSwiss",@"Kurzweil Educational Systems",@"L Brands",@"L3 Communications",@"LabCorp",@"Lam Research",@"Land O Lakes",@"Laserfiche",@"Las Vegas Sands Corp",@"LaZBoy",@"LeapFrog Enterprises",@"Lear Corporation",@"Lee Enterprises",@"Legg Mason",@"Leggett & Platt",@"Lennar Corporation",@"Lennox International",@"Leonard Green & Partners",@"Les Schwab Tire Centers",@"Leucadia National",@"Levi Strauss & Co",@"Leviton Manufacturing Company",@"Lexmark",@"Liberty Global",@"Liberty Media",@"Liberty Mutual",@"Liberty Tax Service",@"Life Technologies",@"Lincoln Industries",@"Lincoln National Corporation",@"Line and Space",@"Linear Technology",@"LinkedIn",@"Little Caesars",@"Live Nation Entertainment",@"Liz Claiborne",@"LLBean",@"L&L Hawaiian Barbecue",@"Local Matters",@"Local Motion",@"Lockheed Martin",@"Lodge Manufacturing Company",@"Loews Corporation",@"Long John Silvers",@"Loral Space & Communications",@"Lorillard",@"LouisianaPacific",@"Loves Travel Stops & Country Stores",@"Lowes",@"L W Seecamp Company",@"LSI Corporation",@"LS Starrett Company",@"Lubys Inc",@"Lucas Oil",@"Lucasfilm",@"Lumencraft",@"MacAndrews & Forbes Holdings",@"Macys",@"Madison Dearborn Partners",@"Magellan Navigation",@"Magnavox",@"Magpul Industries",@"Maidenform Brands",@"The Manischewitz Company",@"Manpower Inc",@"Marantz",@"Marathon Oil",@"Marathon Petroleum",@"Marble Slab Creamery",@"Marie Callenders",@"Marlin Firearms",@"Marriott Corporation",@"Mars Incorporated",@"Marsh & McLennan Companies",@"Marshall Pottery",@"Martha Stewart Living Omnimedia",@"Martin Marietta Materials",@"Marvell Technology Group",@"Mary Kay",@"Masco Corporation",@"MasterCard",@"MasterCraft",@"Mattel",@"Mauna Loa Macadamia Nut Corporation",@"Maxim Integrated",@"Maxtor",@"The McClatchy Company",@"McAfee",@"McCormick & Company",@"McDonalds",@"MCI Inc",@"McIntosh Laboratory",@"McGrawHill",@"McIlhenny Company",@"McKee Foods Corporation",@"McKesson Corporation",@"McKinsey & Company",@"MD Helicopters",@"Mead Johnson",@"MeadWestvaco",@"Medimix International",@"Medtronic",@"Meijer",@"Meineke Car Care Centers",@"Menards",@"Mens Wearhouse",@"Mentor Graphics",@"Merck & Co",@"Mercury Insurance Group",@"Mercury Marine",@"Meredith Corporation",@"Meritor",@"Mesa Airlines",@"MetLife",@"MetroGoldwynMayer MGM",@"MettlerToledo",@"Michaels Stores Inc",@"Microchip Technology",@"Micron Technology",@"Microsoft",@"Midway Games",@"Midwest Communications",@"MIG Inc",@"Miller Brewing Company",@"Miro Technologies",@"Mohawk Industries",@"Molex Inc",@"Molycorp",@"Momentive",@"Mondelēz International",@"Monotype Imaging Holdings",@"Monsanto",@"Monster Beverage Corporation",@"Montana Resources",@"Moodys",@"Moog Incorporated",@"Monro Muffler Brake Inc",@"Morgan Stanley",@"Morningstar",@"The Mosaic Company",@"Motorola",@"Movado",@"Mozilla Foundation",@"MTX Audio",@"Murphy Oil Corporation",@"Musco Lighting",@"Mutual of Omaha",@"Mylan Inc",@"Myspace",@"Nabisco",@"NACCO Industries",@"Nalge Nunc International",@"NASDAQ OMX Group",@"Nathans Famous Inc",@"National Airlines",@"National Beverage",@"National Oilwell Varco",@"National Presto Industries",@"National Railway Equipment Company",@"Nationwide Mutual Insurance Company",@"Nautilus Inc",@"NBCUniversal",@"NCR Corporation",@"Necco",@"Neiman Marcus Group",@"NetApp",@"Netcordia",@"Netflix",@"Netgear",@"NetZero",@"New Balance",@"Neweggcom Inc",@"New Era Tickets",@"Newell Rubbermaid",@"Newfield Exploration",@"Newmont Mining Corporation",@"NewPage Corporation",@"News Corporation",@"New York Life Insurance Company",@"Nielsen",@"Nike Inc",@"NL Industries",@"Noble Energy",@"Nordstrom",@"Norfolk Southern Railway",@"Northrop Grumman",@"North Sails",@"Northwest Airlines",@"Norwegian Cruise Line",@"Novell",@"Novellus Systems",@"NRG Energy",@"Nuance Communications",@"Nucor",@"Numark Industries",@"Nvidia",@"NYSE Euronext",@"Oak Hill Capital Partners",@"Oaktree Capital Management",@"Oberto Sausage Company",@"Oberweis Dairy",@"Occidental Petroleum",@"Oceaneering International",@"Ocean Spray",@"OCZ Technology",@"Odwalla Inc",@"OF Mossberg & Sons",@"Office Depot",@"OfficeMax",@"Olan Mills",@"Old Dominion Freight Line",@"Olin Corporation",@"Olympic Steel",@"Omaha Steaks",@"Omni Air International",@"The Omni Group",@"Omnicare",@"Omnicom Group",@"ON Semiconductor",@"ONEOK",@"Onvia",@"Open Interface North America",@"OpenTable",@"Opower",@"OptiRTC",@"Oracle Corporation",@"Oracle Financial Services Software",@"Orbital Sciences Corporation",@"Oreck Corporation",@"OReilly Auto Parts",@"OReilly Media",@"Oshkosh Corporation",@"OSI Restaurant Partners",@"Overcast Media",@"Overstockcom Inc",@"Owens Corning",@"OwensIllinois",@"Pabst Brewing Company",@"PACCAR",@"Pacer International",@"Pacific Gas and Electric Company PG&E",@"Pacific Life Insurance Company",@"Packaging Corporation of America",@"Pall Corporation",@"Panda Energy International",@"Panda Express",@"Panera Bread",@"Papa Johns Pizza",@"Papa Murphys",@"Paramount Pictures",@"Park Seed Company",@"Parker Hannifin Corporation",@"Patterson Companies",@"Paxton Media Group",@"Paychex Inc",@"Payless ShoeSource",@"PC Power and Cooling",@"Peabody Energy",@"Pearsons Candy Company",@"Peavey Electronics Corporation",@"Peets Coffee",@"Pelican Products",@"Penn National Insurance",@"Penske Corporation",@"Pep Boys",@"PepsiCo",@"Perdue Farms",@"PerkinElmer",@"Perrigo",@"Perry Ellis International",@"Petco Animal Supplies",@"Peterbilt",@"PetMeds",@"PetSmart",@"Pfizer",@"Philip Morris",@"Phillips 66",@"Phillips Van HeusenPhilip Morris",@"Pier 1 Imports",@"Piggybackr",@"Pilgrims Pride",@"Pilot Travel Centers",@"Pinnacle Foods Group",@"Pinnacle Systems",@"Pioneer Natural Resources",@"Pioneer Railcorp",@"Piper Jaffray",@"Pitney Bowes",@"Pizza Hut",@"Plains All American Pipeline",@"Planet Hollywood",@"Plantronics",@"Plochmans",@"PMCSierra",@"PNY Technologies",@"Polaroid Corporation",@"Polaris Industries",@"Popeyes Louisiana Kitchen",@"PPG Industries",@"Praxair",@"Precision Castparts Corp",@"Prestige Brands",@"Priceline",@"PricewaterhouseCoopers",@"Primerica",@"Principal Financial Group",@"Procter & Gamble",@"Progressive Corporation",@"Protective Life Corporation",@"Prudential Financial",@"PSSC Labs",@"Public Storage",@"Publishers Clearing House",@"Publix",@"Pulte Homes",@"QCR Holdings",@"Qpass",@"Qualcomm",@"Quanta Services",@"Quantrix",@"Quantum Corporation",@"Quest Diagnostics",@"Quest Software",@"QuikTrip Corporation",@"Quincy Newspapers",@"QVC",@"Qwest",@"Quiznos",@"RaceTrac Petroleum",@"RadioShack",@"Ralcorp",@"Raleys Supermarkets",@"Ralph Lauren",@"Rand McNally",@"Ranger Boats",@"Raybestos",@"Raycom Media",@"Raymond James Financial",@"Raytheon",@"RCA",@"Realogy",@"Red Hat",@"Red Robin Gourmet Burgers",@"Red River Broadcasting",@"REI",@"RegalBeloit",@"Regal Entertainment Group",@"Regeneron Pharmaceuticals",@"Regions Financial Corporation",@"Regis Corporation",@"Reliance Steel & Aluminum Co",@"RE/MAX International",@"Renco Group",@"RentACenter",@"RentAWreck",@"Renys",@"Republic Services Inc",@"Respironics",@"Reyes Holdings",@"Reynolds American",@"Riceland Foods",@"Rite Aid",@"RJ Corman Railroad Group",@"Roark Capital Group",@"Robert Half International",@"Robinson Helicopter Company",@"Rockford Fosgate",@"Rockport Company",@"Rockstar Inc",@"Rockstar Games",@"RockTenn Company",@"Rockwell Automation",@"Rockwell Collins",@"Rodale Inc",@"Rollins Inc",@"Roper Industries",@"Rosetta Stone Inc",@"Ross Stores",@"Round Table Pizza",@"Roush Performance",@"Rovi Corporation",@"Rowan Companies",@"Royal Caribbean International",@"RPM International",@"RR Donnelley",@"Ruby Tuesday",@"Russell Investments",@"Russell Stover Candies",@"Ryder",@"Ryland Homes",@"S3 Graphics",@"Sabre Holdings",@"Safeco",@"Safeway Inc",@"SAIC",@"Salem Communications",@"Salesforcecom Inc",@"Saleen Automotive",@"SanDisk",@"Sara Lee Corporation",@"SauerDanfoss",@"Savage Arms Company",@"Save Mart Supermarkets",@"Sbarro",@"SC Johnson & Son",@"SCANA Corporation",@"Schlumberger",@"Schnitzer Steel Industries",@"Schoeps Ice Cream",@"Scholastic Corporation",@"Schneider National Inc",@"Schnucks",@"Schwan Food Company",@"Scottrade",@"The Scotts MiracleGro Company",@"Scripps Networks Interactive",@"Seaboard Corporation",@"Seagate Technology",@"Sealed Air Corporation",@"Sears",@"Seattles Best Coffee",@"Seneca Foods Corporation",@"Sequoia Capital",@"Sequoia Voting Systems",@"Service Corporation International",@"SERVPRO Industries",@"SFN Group",@"Shaklee Corporation",@"Shea Homes",@"Sheetz Inc",@"Shell",@"SherwinWilliams",@"Shirokiya",@"Shoneys",@"Shop n Save",@"Shure",@"Sierra Nevada Brewing Company",@"Sierra Nevada Corporation",@"SigmaAldrich",@"Silicon Graphics International",@"Silicon Image",@"Silver Lake Partners",@"Simon Property Group",@"Sinclair Oil Corporation",@"Sirius XM Radio",@"SIRVA Inc",@"Six Flags",@"Sizzler",@"Skechers",@"SkyWest Airlines",@"Smart & Final",@"Smith & Wesson",@"SnapOn",@"SnydersLance Inc",@"Sociometric Solutions",@"Sonic Restaurants Inc",@"Sonic Solutions",@"Sony Pictures Entertainment",@"Sothebys",@"Southern Air",@"Southern California Edison",@"Southern Progress Corporation",@"Southern Wine & Spirits",@"Southwest Airlines",@"Soyo Group",@"Space Exploration Technologies Corporation",@"SpaceX",@"Spansion",@"Spanx",@"Specialized Bicycle Components Inc",@"Spectra Energy",@"Spectrum Brands",@"Speedway Motorsports",@"Spirit AeroSystems",@"Spirit Airlines",@"Springfield Armory Inc",@"Sprint Corporation",@"SPX Corporation",@"Standard Pacific Homes",@"Stanley Black & Decker",@"Staples Inc",@"Starbucks",@"Starwood Hotels & Resorts Worldwide",@"Starz",@"State Farm Insurance",@"State Street Corporation",@"Stater Bros Markets",@"Steak n Shake",@"Steelcase Inc",@"Steel Dynamics",@"Steinway & Sons",@"Stephens Inc",@"Stericycle",@"Sterling Ledet & Associates",@"Stewart & Stevenson",@"StewartWarner",@"Stew Leonards",@"STI International",@"Storage Technology Corporation",@"StrayerVoigt Inc",@"Stryker Corporation",@"Stuckeys",@"Sturm Ruger & Company",@"STX",@"Subway",@"Sun Capital Partners",@"SunMaid Growers of California",@"Sunny Delight Beverages",@"Sunoco",@"Sun Products",@"Sunsweet Growers Incorporated",@"SunTrust Banks Inc",@"Super One Foods",@"SuperValu",@"Sur La Table",@"Swayne Robinson and Company",@"SweetWater Brewing Company",@"Synopsys",@"Syntel",@"Symantec",@"Synovus Financial Corporation",@"Sysco Corporation",@"Taco Bell",@"TakeTwo Interactive",@"Talbots",@"Talend",@"Tanadgusix Corporation",@"Target Corporation",@"Taser International",@"TasteeFreez",@"Taunton Press",@"TD Ameritrade",@"Tektronix",@"Teledyne Technologies",@"Tellabs",@"TempurPedic",@"Tenet Healthcare",@"Teradata",@"Teradyne",@"Terex Corporation",@"Tesla Motors",@"Tesoro",@"Testor Corporation",@"Texas Instruments",@"Textron",@"Bell Helicopter",@"Cessna Aircraft",@"The Compleat Sculptor Inc",@"The Library Corporation",@"Thermo Fisher Scientific",@"Thor Industries",@"THQ",@"TIAACREF",@"Tiffany & Company",@"Time Warner",@"Timken Company",@"TiVo Inc",@"TJX Companies",@"Togos Eateries Inc",@"Toll Brothers",@"Torry Harris Business Solutions",@"Tony Romas",@"Tootsie Roll Industries",@"The Toro Company",@"Total System Services",@"Tower Automotive",@"Towers Perrin",@"Toys R Us",@"TPG Capital",@"TRAFFIK Advertising",@"TransDigm Group",@"T Rowe Price",@"The Travelers Companies",@"Trader Vics",@"Transamerica Corporation",@"Transammonia Inc",@"TreeRing",@"Trek Bicycle Corporation",@"Trijicon",@"Trimble Navigation",@"Trinity Industries",@"Tropicana Products",@"Trianz",@"Triumph Group",@"TRT Holdings",@"Trump Organization",@"TRW Automotive",@"Tuff Shed",@"Tullys Coffee",@"Tupperware Brands",@"Turtle Wax",@"Twitter",@"Tyr Sport Inc",@"Tyson Foods",@"Uber",@"UberOffices",@"Ubu Productions",@"UHaul",@"Ultimate Software",@"Under Armour",@"Underwriters Laboratories",@"Unified Grocers",@"Union Bank",@"Union Pacific Railroad",@"Unisys",@"United Airlines",@"United Country Real Estate",@"United Parcel Service",@"UPS",@"United Rentals",@"United States Enrichment Corporation",@"United Technologies Corporation",@"Carrier Corporation",@"Otis Elevator Company",@"Pratt & Whitney",@"Sikorsky Aircraft",@"UnitedHealth Group",@"Universal Forest Products",@"Universal Studios",@"Uno Chicago Grill",@"Unum Group",@"Upland Brewing Company",@"Upper Deck Company",@"Urban Outfitters",@"US Airways",@"USAA",@"USRobotics",@"US Foods",@"USG Corporation",@"US Bancorp",@"US Cellular",@"US Ordnance Inc",@"US Steel",@"US Venture Partners",@"UTStarcom",@"Uwajimaya",@"Vail Resorts Inc",@"Valero Energy Corporation",@"The Valspar Corporation",@"Valve Corporation",@"VantagePoint Capital Partners",@"Vantec",@"The Vanguard Group",@"Varian Medical Systems",@"Vaughan & Bushnell Manufacturing",@"VECO Corporation",@"Vectren",@"Venrock",@"Venus Swimwear",@"Verbatim Corporation",@"VeriFone Systems Inc",@"Verisign",@"Verisk Analytics",@"Verizon Communications",@"Verizon Wireless",@"Vertex Pharmaceuticals",@"VF Corporation",@"Lee",@"The North Face",@"Wrangler",@"Viacom",@"ViaSat",@"Victorias Secret",@"Victorious 22",@"ViewSonic",@"Visa Inc",@"Vishay Intertechnology",@"Visteon Corporation",@"Vivitar",@"VIZ Media",@"Vizio",@"VMware",@"Vonage",@"Vornado Realty Trust",@"Vulcan Corporation",@"Vulcan Materials Company",@"VWR International",@"Wabash National",@"Wabtec Corporation",@"Waffle House",@"Wahl",@"Wakefern Food Corporation",@"Walgreens",@"Walmart",@"The Walt Disney Company",@"Warburg Pincus",@"Warner Bros.",@"Washburn Guitars",@"Waste Management",@"Watco Companies",@"Waters Corporation",@"Watkins Incorporated",@"WatkinsJohnson Company",@"Watsco Inc",@"Wausau Paper",@"Wawa Inc",@"W C Bradley Co",@"WD40 Company",@"Wegmans Food Markets",@"The Weinstein Company",@"Weis Markets",@"Welchs",@"WellPoint",@"Wells Fargo",@"Wendys",@"Werner Enterprises",@"Westat",@"West Liberty Foods",@"Western Digital",@"Western Refining",@"Western Sugar Cooperative",@"Western Union",@"Westinghouse Digital LLC",@"Weyerhaeuser",@"Whataburger",@"WheelingPittsburgh Steel",@"Whirlpool Corporation",@"White Castle",@"Whole Foods Market",@"Wienerschnitzel",@"Willett Distilling Company",@"William Blair & Company",@"Williams Companies",@"WilliamsonDickie Manufacturing Company",@"WilliamsSonoma",@"WinCo Foods Inc",@"Windstream Communications",@"The Wine Group",@"WinnDixie",@"Winnebago Industries",@"Wizards of the Coast",@"W L Gore and Associates",@"GoreTex",@"Wolverine Worldwide",@"Woodward Inc",@"Woolrich Inc",@"World Airways",@"World Financial Group",@"World Fuel Services",@"World Wrestling Entertainment WWE",@"Worthington Industries",@"W R Grace and Company",@"W W Grainger",@"Wyndham Worldwide",@"Wynn Resorts",@"Xcel Energy",@"Xerox",@"Xilinx",@"XIM Inc",@"XPAC",@"XPLANE",@"XRite",@"Xylem Inc",@"Yahoo!",@"Yelp Inc",@"YRC Worldwide",@"Yum Brands",@"YumYum Donuts",@"Zale Corporation",@"Zapata Corporation",@"Zappos",@"Zaxbys",@"Zenith Electronics",@"Zilog",@"Zimmer Holdings",@"Zions Bancorp",@"Zippo Manufacturing Company",@"Zoetis Inc",@"Zoo York",@"Zoom Telephonics",@"Zune",@"Zynga",@"Zumiez",@"Zildjia"];
        });
    NSString *stringToLookFor;
    NSArray *componentsString = [prefix componentsSeparatedByString:@":"];
    NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ignoreCase)
    {
        stringToLookFor = [prefixLastComponent lowercaseString];
    }
    else
    {
        stringToLookFor = prefixLastComponent;
    }
    
    for (NSString *stringFromReference in companys)
    {
        NSString *stringToCompare;
        if (ignoreCase)
        {
            stringToCompare = [stringFromReference lowercaseString];
        }
        else
        {
            stringToCompare = stringFromReference;
        }
        
        if ([stringToCompare hasPrefix:stringToLookFor])
        {
            return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
        }
        
    }
    }else if (textField.autocompleteType == HTAutocompleteTypeCata){
        static dispatch_once_t cataOnceToken;
        static NSArray *cata;
        
        dispatch_once(&cataOnceToken, ^ {cata = @[@"Business",@"Personal",@"Corporate",@"Auto", @"Fuel", @"Bank",@"ATM",@"Computer", @"Internet", @"General Retail", @"Groceries", @"Insurance", @"Meals",@"Entertainment",@"Medical",@"Health",@"Office Supplies",@"Postage", @"Shipping",@"Professional Fees",@"Promotion", @"Advertising",@"Telecommunications", @"Travel", @"Transport", @"Utilities"];});
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@":"];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in cata)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeMethod){
        //static dispatch_once_t cataOnceToken;
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        
        
        NSArray *cata = [appdelegate getCards];
        

        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@":"];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in cata)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }else if (textField.autocompleteType == HTAutocompleteTypeSource){
        //static dispatch_once_t cataOnceToken;
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        
        
        NSArray *cata = [appdelegate LoadSource];
        
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@":"];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in cata)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }else if (textField.autocompleteType == HTAutocompleteTypeRecieve){
        //static dispatch_once_t cataOnceToken;
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        
        
        NSArray *cata = [appdelegate getIncomeMethods];
        
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@":"];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in cata)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    
    return @"";
}


@end
