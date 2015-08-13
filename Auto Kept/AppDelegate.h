//
//  AppDelegate.h
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#define baseurl @"http://localhost:3000/quickbooks/"
//#define baseurl @"https://autokept.herokuapp.com/api/v1/"
//#define baseurl @"https://aqueous-everglades-9684.herokuapp.com/api/v1/"

//#define baseurl @"https://still-beyond-6524.herokuapp.com/api/v1/" //Current Test Server
#define baseurl @"https://still-beyond-6524.herokuapp.com/quickbooks/"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{

NSManagedObjectModel *managedObjectModel;
NSManagedObjectContext *managedObjectContext;
NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;




- (void)saveLocalFile:(NSString *)datatoSave;
- (NSArray *) oldSaves;
- (NSUInteger)getCoresize;
- (void)deleteOldCore:(NSManagedObject *)objecttodelete;
- (void)saveCompanyLogo:(NSData *)datatoSaveLogo:(NSString *)imagename;
- (NSManagedObject *)getCompanyInfo:(NSString *)imagename;
- (void)deleteCompanyInfo;
- (void)wipeCore;
- (BOOL)saveCardInfo:(NSString *)cardinfo;
- (NSArray *)getCards;
- (void)deleteCards;
- (void)SaveSource:(NSString *)sourceToSave;
- (NSArray *)LoadSource;
- (void)wipeSources;
-(void)setIncomeMethod:(NSString *)incomeMethod;
-(NSArray *)getIncomeMethods;
- (void)wipeMethodSources;
@end

