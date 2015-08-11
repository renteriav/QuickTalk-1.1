//
//  commonunit.h

//
//  Created by Suresh Jagnani on 21/07/14.
//  Copyright (c) 2014 Suresh Jagnani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#define KillTimer(t)  if(t){ [t invalidate]; t = nil;}
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 (IS_HEIGHT_GTE_568)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)


#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]
#define RGBCOLORAlpha(r,g,b,a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]


#define appblue RGBCOLOR(99, 197, 234)
#define appgray RGBCOLOR(155, 174, 178)
#define appblack RGBCOLOR(0, 0, 0)

#define imagesize CGSizeMake(960, 960)
#define maxvideotime 300.0 //Seconds


#define userData @"com.autokept.userdata"

@interface commonunit : NSObject

#pragma mark - File Functions
+(NSString *) GetPathForFileName:(NSString *)imagename;
+(BOOL) isFileExist:(NSString *)imagename;
+(BOOL) SaveImageInApp:(NSString *)imagename Image:(UIImage *)image;
+(UIImage *) GetImageFromApp:(NSString *)imagename;
+(BOOL) DeleteFileFromApp:(NSString *)imagename;
+(BOOL) CreateFolder:(NSString *)foldername;

+(void) setTblOffset:(UITableView *)tbl IsOffSet:(BOOL)isset;


+(BOOL) IsOnlyNumber:(NSString *)number;


@end
