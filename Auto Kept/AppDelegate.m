 //
//  AppDelegate.m
//  Auto Kept
//
//  Created by Kamal Mittal on 28/12/14.
//  Copyright (c) 2014 Woodenlabs. All rights reserved.
//

#import "AppDelegate.h"
@import Foundation;
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    HomeViewController *home = (HomeViewController *)[[UIApplication sharedApplication] delegate];
    [home.voiceSearch cancel];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "VGM.ThrowAway" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LocalPictures" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AutoKept.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    //NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (self.managedObjectContext != nil) {
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)SaveSource:(NSString *)sourceToSave{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSources" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    if ([sourceToSave isEqualToString:@""]){
        return;
    }
    if([sourceToSave characterAtIndex:0] == ' '){
        sourceToSave =[sourceToSave substringFromIndex:1];
    }
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *localSaves in fetchedObjects){
        NSLog(@"Sources:%@", [localSaves valueForKey:@"Source"]);
        if([sourceToSave rangeOfString:[localSaves valueForKey:@"Source"]].length > [[localSaves valueForKey:@"Source"] length]/2){
            return;
        }
    }
    
   
    NSManagedObject *localSaves  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalSources" inManagedObjectContext:context];
    [localSaves setValue:sourceToSave forKey:@"source"];
    //[localSaves setValue:NO forKey:@"uploaded"];

    if(![context save:&error]){
        NSLog(@"something happened %@", [error localizedDescription]);
        
    }

}
#pragma - QuickTalk Core Data Saving and Loading


// Saves and Loads Categories to the Core Data; type = 0 Save Categories; type = 1 Load Category; type = 2 Delete Categories
- (NSDictionary *)CategoriesStorage:(NSDictionary *)categoriesFromServer :(int)type{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Saves Category's to the Core Data
    if(type == 0){
        NSManagedObject *categoryStorageCore;
        NSMutableArray *categoryKeys = [[categoriesFromServer allKeys] mutableCopy];
    
        NSError *error;
        for (NSString *categories in categoryKeys){
            NSLog(@"%@",[[categoriesFromServer valueForKey:categories] stringValue]);
            categoryStorageCore = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryStorage" inManagedObjectContext:context];
            [categoryStorageCore setValue:[[categoriesFromServer valueForKey:categories] stringValue] forKey:@"categoryID"];
            [categoryStorageCore setValue:categories forKey:@"category"];
            if(![context save:&error]){
                NSLog(@"Category Core Save Failed! \n Reason: %@",[error description]);
            }
        }
        return NULL;
    //Loads or Delete Category's to the Core Data
    }else{
     
        NSFetchRequest *categoryCoreFetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *categoryEntity = [NSEntityDescription entityForName:@"CategoryStorage" inManagedObjectContext:context];
        [categoryCoreFetch setEntity:categoryEntity];
        [categoryCoreFetch setIncludesPropertyValues:NO];
        NSError *error;
        NSArray *fetchedCategories = [context executeFetchRequest:categoryCoreFetch error:&error];
        
        
        
        if(type == 1){
        NSMutableDictionary *categoryDictionary = [[NSMutableDictionary alloc] init];
        for (NSManagedObject *categoryObject in fetchedCategories){
            [categoryDictionary setObject:[categoryObject valueForKey:@"categoryID"] forKey:[categoryObject valueForKey:@"category"]];
        }
        NSDictionary *returnDictionary = [categoryDictionary copy];
        return returnDictionary;
           }else{
               if(!([fetchedCategories count] == 0)){
                   for(NSManagedObject *categoryObject in fetchedCategories){
                       [context deleteObject:categoryObject];
                   }
                   
               }
               if (![context save:&error]){
                   NSLog(@"Deletion of Categories in Core Data failed \n Reason:%@", error);
               }
           }
    }
    return NULL;
    
}

- (NSDictionary *)TypeStorage:(NSDictionary *)paymentTypesFromServer :(int)type{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Saves Category's to the Core Data
    if(type == 0){
        NSManagedObject *paymentStorageCore;
        NSMutableArray *paymentKeys = [[paymentTypesFromServer allKeys] mutableCopy];
        
        NSError *error;
        for (NSString *payment in paymentKeys){
            NSLog(@"%@",[[paymentTypesFromServer valueForKey:payment] stringValue]);
            paymentStorageCore = [NSEntityDescription insertNewObjectForEntityForName:@"TypeStorage" inManagedObjectContext:context];
            [paymentStorageCore setValue:[[paymentTypesFromServer valueForKey:payment] stringValue] forKey:@"TypeID"];
            [paymentStorageCore setValue:payment forKey:@"type"];
            if(![context save:&error]){
                NSLog(@"Type Core Save Failed! \n Reason: %@",[error description]);
            }
        }
        return NULL;
        //Loads or Delete Category's to the Core Data
    }else{
        
        NSFetchRequest *categoryCoreFetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *categoryEntity = [NSEntityDescription entityForName:@"TypeStorage" inManagedObjectContext:context];
        [categoryCoreFetch setEntity:categoryEntity];
        [categoryCoreFetch setIncludesPropertyValues:NO];
        NSError *error;
        NSArray *fetchedPayments = [context executeFetchRequest:categoryCoreFetch error:&error];
        
        
        
        if(type == 1){
            NSMutableDictionary *paymentDictionary = [[NSMutableDictionary alloc] init];
            for (NSManagedObject *paymentObject in fetchedPayments){
                [paymentDictionary setObject:[paymentObject valueForKey:@"typeID"] forKey:[paymentObject valueForKey:@"type"]];
            }
            NSDictionary *returnDictionary = [paymentDictionary copy];
            return returnDictionary;
        }else{
            if(!([fetchedPayments count] == 0)){
                for(NSManagedObject *paymentObject in fetchedPayments){
                    [context deleteObject:paymentObject];
                }
                
            }
            if (![context save:&error]){
                NSLog(@"Deletion of Payment Type  in Core Data failed \n Reason:%@", error);
            }
        }
    }

    return NULL;
    
    
}

- (NSDictionary *)PayeeStorage:(NSDictionary *)payeesFromServer :(int)type{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Saves Payee's to the Core Data
    if(type == 0){
    NSManagedObject *payeeStorageCore;
    NSMutableArray *payeeKeys = [[payeesFromServer allKeys] mutableCopy];
    
    NSError *error;
    for (NSString *payee in payeeKeys){
        NSLog(@"%@",[[payeesFromServer valueForKey:payee] stringValue]);
        payeeStorageCore = [NSEntityDescription insertNewObjectForEntityForName:@"PayeeStorage" inManagedObjectContext:context];
        [payeeStorageCore setValue:[[payeesFromServer valueForKey:payee] stringValue] forKey:@"payeeID"];
        [payeeStorageCore setValue:payee forKey:@"payee"];
        if(![context save:&error]){
            NSLog(@"Payee Core Save Failed! \n Reason: %@",[error description]);
        }
    }
    return NULL;
    //Loads or Delete Payee's to the Core Data
}else{
    NSFetchRequest *payeeCoreFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *payeeEntity = [NSEntityDescription entityForName:@"PayeeStorage" inManagedObjectContext:context];
    [payeeCoreFetch setEntity:payeeEntity];
    [payeeCoreFetch setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *fetchedPayee = [context executeFetchRequest:payeeCoreFetch error:&error];
    
    
    
    if(type == 1){
        NSMutableDictionary *payeeDictionary = [[NSMutableDictionary alloc] init];
        for (NSManagedObject *payeeObject in fetchedPayee){
            [payeeDictionary setObject:[payeeObject valueForKey:@"payeeID"] forKey:[payeeObject valueForKey:@"payee"]];
        }
        NSDictionary *returnDictionary = [payeeDictionary copy];
        return returnDictionary;
    }else{
        if(!([fetchedPayee count] == 0)){
            for(NSManagedObject *paymentObject in fetchedPayee){
                [context deleteObject:paymentObject];
            }
            
        }
        if (![context save:&error]){
            NSLog(@"Deletion of Payee in Core Data failed \n Reason:%@", error);
        }
    }
}
    return NULL;


}

#pragma Old Core Storage Methods
- (NSArray *)LoadSource{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSources" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *Sources =[[NSMutableArray alloc] init];
    for (NSManagedObject *details in fetchedObjects){
        [Sources addObject:[details valueForKey:@"source"]];
    }
    NSArray *returnArray = [Sources copy];
    return returnArray;
}

- (void)saveLocalFile:(NSString *)datatoSave{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *localSaves  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalSaves" inManagedObjectContext:context];
    [localSaves setValue:datatoSave forKey:@"savedData"];
    //[localSaves setValue:NO forKey:@"uploaded"];
    NSError *error;
    if(![context save:&error]){
        NSLog(@"something happened %@", [error localizedDescription]);
        
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSaves" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *localSaves in fetchedObjects){
        NSLog(@"Stuff: %@", [localSaves valueForKey:@"savedData"]);
        NSLog(@" %s", [localSaves valueForKey:@"uploaded"] ? "true" : "false");

    }
    
}



-(NSArray *) oldSaves{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSaves" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
     NSError *error;
    
    NSArray *oldFiles = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *localSaves in oldFiles){
        NSLog(@"Stuff: %@", [localSaves valueForKey:@"savedData"]);
    }
    return oldFiles;
    
}

-(NSArray *)getCards{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalCard" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *Error;
    
    NSArray *cards = [context executeFetchRequest:fetchRequest error:&Error];
    NSMutableArray *formatedCards =[[NSMutableArray alloc] init];
    for (NSManagedObject *details in cards){
        [formatedCards addObject:[NSString stringWithFormat:@"%@ %@",[[details valueForKey:@"card"]capitalizedString],[details valueForKey:@"cardNumber"]]];
    }
    NSArray *returnArray = [formatedCards copy];
    return returnArray;
    
}

- (BOOL)saveCardInfo:(NSString *)cardinfo{
    BOOL exisits = NO;
    BOOL skip = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalCard" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *Error;
    NSString *cardnumbertobeadded = @"";
    NSString *cardName = @"";
    
    if([cardinfo isEqualToString:@"Login"]){
        skip = YES;
    }
    if (!skip){
    cardnumbertobeadded =  [[cardinfo componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    cardName = [cardinfo stringByReplacingOccurrencesOfString:cardnumbertobeadded withString:@""];
    cardinfo = [NSString stringWithFormat:@"%@%@",cardName,cardnumbertobeadded];
    NSLog(@"Card Name:%@",cardName);
    NSLog(@"Card Number:%@",cardnumbertobeadded);
    }
    
    NSArray *cards = [context executeFetchRequest:fetchRequest error:&Error];
    if([cards count] == 0){
        //Add Defaults
        NSManagedObject *newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        //Visa
        [newDefault setValue:@"Visa " forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
        //Mastercard
        newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [newDefault setValue:@"Mastercard" forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
        //American Express
        newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [newDefault setValue:@"American Express" forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
        //Discover
        newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [newDefault setValue:@"Discover" forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
        //Cash
        newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [newDefault setValue:@"Cash" forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
        //Amex
        newDefault  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [newDefault setValue:@"AMEX" forKey:@"card"];
        [newDefault setValue:@"" forKey:@"cardNumber"];
        [context save:&Error];
    }
    if(!skip){
    for (NSManagedObject *value in cards){
       
        NSString *filledcard = [NSString stringWithFormat:@"%@ %@",[value valueForKey:@"card"],[value valueForKey:@"cardNumber"]];
         NSLog(@"Saved:%@ Local:%@", filledcard, cardinfo);
        NSLog(@"my range is %li",[[[filledcard lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:[[cardinfo lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]].length);
        if([[[filledcard lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:[[cardinfo lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]].length > 7){
            exisits = YES;
            break;
        }else if([[[cardName lowercaseString]  stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[[[value valueForKey:@"card"] lowercaseString]  stringByReplacingOccurrencesOfString:@" " withString:@""]] && (![cardnumbertobeadded isEqualToString:@""]) && [[value valueForKey:@"cardNumber"] isEqualToString:@""]){
            [context deleteObject:value];
            [context save:&Error];
            break;
        }
        /*
       NSString *cardnumbersaved = [[[value valueForKey:@"card"]  componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        if ([cardnumbersaved isEqualToString:cardnumbertobeadded]){
            [context deleteObject:value];
            [context save:&Error];
        }
        */
        
    
    }
        if ([[[cardName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] isEqualToString:@"americanexpress"]){
            cardName = @"American Express";
        }else if([[[cardName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] isEqualToString:@"visa"] || [[[cardName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] isEqualToString:@"mastercard"] || [[[cardName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] isEqualToString:@"discover"]){
            cardName = [[[cardName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString] capitalizedString];
        }
        
    
    if (!exisits){
    NSManagedObject *localSaves  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalCard" inManagedObjectContext:context];
        [localSaves setValue:cardName  forKey:@"card"];
        [localSaves setValue:cardnumbertobeadded forKey:@"cardNumber"];
        if(![context save:&Error]){
            NSLog(@"something happened %@", [Error localizedDescription]);
        }
        return YES;
    }
    }
    return NO;
    
}

-(NSUInteger)getCoresize{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSaves" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;

    NSArray *oldFiles = [context executeFetchRequest:fetchRequest error:&error];
    return [oldFiles count];
    
}



-(void)saveCompanyLogo:(NSData *)datatoSaveLogo :(NSString *)imagename{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *localSaves  = [NSEntityDescription insertNewObjectForEntityForName:@"LogoStorage" inManagedObjectContext:context];
    if([imagename isEqualToString:@"profile.png"]){
        NSLog(@"Profile!");
        [localSaves setValue:datatoSaveLogo forKey:@"profile"];
    }
    if ([imagename isEqualToString:@"header.png"]){
          NSLog(@"Header!");
         [localSaves setValue:datatoSaveLogo forKey:@"logo"];
    }
   // [localSaves setValue:datatoSave forKey:@"logo"];
    NSError *error;
    if(![context save:&error]){
        NSLog(@"something happened %@", [error localizedDescription]);
    }
}


//GetArray of all Income Methods
-(NSArray *)getIncomeMethods{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalIncome" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *Error;
    NSArray *savedIncomeMethodLists = [context executeFetchRequest:fetchRequest error:&Error];
    NSMutableArray *Sources =[[NSMutableArray alloc] init];
    for (NSManagedObject *details in savedIncomeMethodLists){
        [Sources addObject:[details valueForKey:@"type"]];
    }
    NSArray *returnArray = [Sources copy];
    return returnArray;
}


//Save's income Method
-(void)setIncomeMethod:(NSString *)incomeMethod{
    if([incomeMethod isEqualToString:@""]){
        return;
    }
    NSRange range = NSMakeRange(0,1);
    if([incomeMethod characterAtIndex:0] == ' '){
         incomeMethod = [incomeMethod stringByReplacingCharactersInRange:range withString:@""];
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalIncome" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *Error;
     NSArray *savedIncomeMethodLists = [context executeFetchRequest:fetchRequest error:&Error];
    
    
    for (NSManagedObject *value in savedIncomeMethodLists){
         NSString *filledcard = [value valueForKey:@"type"];
        if([[[filledcard stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]  isEqualToString:[[incomeMethod stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]]){
            return;
        }
    }
    
    NSManagedObject *localSaves  = [NSEntityDescription insertNewObjectForEntityForName:@"LocalIncome" inManagedObjectContext:context];
    [localSaves setValue:incomeMethod forKey:@"type"];

    if(![context save:&Error]){
        NSLog(@"something happened %@", [Error localizedDescription]);
    }

}


-(NSManagedObject *)getCompanyInfo:(NSString *)imagename{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LogoStorage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *oldFiles = [context executeFetchRequest:fetchRequest error:&error];
   // for (NSManagedObject *localSaves in oldFiles){
        //NSLog(@"Stuff: %@", [localSaves valueForKey:@"logo"]);
   // }
    
    if([oldFiles count] == 0){
        return nil;
    }else{
        for (NSManagedObject *localSaves in oldFiles){
            //NSLog(@"Stuff: %@", [localSaves valueForKey:@"logo"]);
            //NSLog(@"Stuff: %@", [localSaves valueForKey:@"profile"]);
            if([imagename isEqualToString:@"profile.png"] && [localSaves valueForKey:@"profile"]){
                return localSaves;
            }
            if ([imagename isEqualToString:@"header.png"] && [localSaves valueForKey:@"logo"]){
                return localSaves;
            }

        }
        return nil;
    }
    
}

-(void)deleteCompanyInfo{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LogoStorage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    NSArray *oldFiles = [context executeFetchRequest:fetchRequest error:&error];
    if(![oldFiles count] == 0){
        for (NSManagedObject *localSaves in oldFiles){
            [context deleteObject:localSaves];
    }
    
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", error);
    }
    }
    
}
-(void)deleteCards{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalCard" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    NSArray *wipeme = [context executeFetchRequest:fetchRequest error:&error ];
    
    if(!([wipeme count] == 0)){
        for(NSManagedObject *stuff in wipeme){
            [context deleteObject:stuff];
        }
        
    }
    if (![context save:&error]){
        NSLog(@"Save Failed: %@", error);
    }
    
}
-(void)deleteOldCore:(NSManagedObject *)objecttodelete{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSaves" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    [context deleteObject:objecttodelete];
    /*
    NSArray *oldFiles = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *localSaves in oldFiles){
           NSLog(@"Stuff: %@", [localSaves valueForKey:@"savedData"]);
        [context deleteObject:localSaves];
    }
     */
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", error);
    }
}


// Empty all stored Documents only used on log out
- (void)wipeCore{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSaves" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    NSArray *wipeme = [context executeFetchRequest:fetchRequest error:&error ];
    
    if(!([wipeme count] == 0)){
        for(NSManagedObject *stuff in wipeme){
            [context deleteObject:stuff];
        }
        
    }
    if (![context save:&error]){
        NSLog(@"Save Failed: %@", error);
    }
    
}
- (void)wipeSources{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalSources" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    NSArray *wipeme = [context executeFetchRequest:fetchRequest error:&error ];
    
    if(!([wipeme count] == 0)){
        for(NSManagedObject *stuff in wipeme){
            [context deleteObject:stuff];
        }
        
    }
    if (![context save:&error]){
        NSLog(@"Save Failed: %@", error);
    }
    
}

- (void)wipeMethodSources{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalIncome" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    
    NSArray *wipeme = [context executeFetchRequest:fetchRequest error:&error ];
    
    if(!([wipeme count] == 0)){
        for(NSManagedObject *stuff in wipeme){
            [context deleteObject:stuff];
        }
        
    }
    if (![context save:&error]){
        NSLog(@"Save Failed: %@", error);
    }
    
}







@end
