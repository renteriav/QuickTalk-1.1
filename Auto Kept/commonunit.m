//
//  commonunit.m

//
//  Created by Suresh Jagnani on 21/07/14.
//  Copyright (c) 2014 Suresh Jagnani. All rights reserved.
//

#import "commonunit.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

#define userdetailkey @"com.gameapp.userdetail"
NSString *userid;
@implementation commonunit




#pragma mark - File Functions
+(NSString *) GetPathForFileName:(NSString *)imagename
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],imagename];
//    return filePath;
      NSString *outputDirectory = NSTemporaryDirectory();
      NSString *outputPath = [outputDirectory stringByAppendingPathComponent:imagename];
      return outputPath;
}

+(BOOL) SaveImageInApp:(NSString *)imagename Image:(UIImage *)image
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData *imageData2 = UIImagePNGRepresentation(image);
    [appDelegate saveCompanyLogo:imageData2:imagename];
    //[appDelegate getCompanyInfo:];
    
    
    /*
    if([[imagename stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
        return FALSE;
    //Delete mage if already exist with samename
    NSString *filePath = [self GetPathForFileName:imagename];
    [self DeleteFileFromApp:imagename];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    return [self isFileExist:imagename];
     */
    return true;
    
}

+(UIImage *) GetImageFromApp:(NSString *)imagename
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObject *temp = [appDelegate getCompanyInfo:imagename];
    NSData *data;
    if([imagename isEqualToString:@"profile.png"]){
        NSLog(@"Profile!");
        data = [temp valueForKey:@"profile"];
 
    }
    if ([imagename isEqualToString:@"header.png"]){
        NSLog(@"Header!");
        data = [temp valueForKey:@"logo"];

    }

      UIImage *img =[[UIImage alloc] initWithData:data];
    

    return img;
    /*
    NSString *filePath = [self GetPathForFileName:imagename];
    UIImage *bottleimage = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        bottleimage = [UIImage imageWithContentsOfFile:filePath];
    }
    return bottleimage;
    
    */
    
    
}

+(BOOL) DeleteFileFromApp:(NSString *)imagename
{
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    //NSLog(@"Deleted Image Name:...%@....",imagename);
    /*
    if([[imagename stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
        return FALSE;
    NSString *filePath = [self GetPathForFileName:imagename];
    NSError *error=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    if(error) return FALSE;
     */
    return TRUE;
    
}

+(BOOL) isFileExist:(NSString *)imagename
{
    NSString *filePath = [self GetPathForFileName:imagename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return TRUE;
    }
    return FALSE;
}


+(BOOL) CreateFolder:(NSString *)foldername
{
    if(![commonunit isFileExist:foldername] && [[foldername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)
    {
        NSError *error = nil;
        NSString *yourDirPath = [self GetPathForFileName:foldername];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error == nil)
        {
            return TRUE;
        }
    }
    return FALSE;
}


+(void) setTblOffset:(UITableView *)tbl  IsOffSet:(BOOL)isset
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        [tbl setContentInset:UIEdgeInsetsMake(44, 0, 66, 0)];
        if(isset)
           [tbl setContentOffset:CGPointMake(0, -44)];
    }
    else
    {
        [tbl setContentInset:UIEdgeInsetsMake(0, 0, 66, 0)];
    }
}


+(BOOL) IsOnlyNumber:(NSString *)number
{
    return ([number rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound);
}


@end
