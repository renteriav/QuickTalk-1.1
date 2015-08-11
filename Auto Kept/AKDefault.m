//
//  AKDefault.m
//  Auto Kept
//
//  Created by Renteria Family on 4/29/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "AKDefault.h"

@implementation AKDefault

@synthesize showPersonalInfoForm;
@synthesize hidePermissionPage;
@synthesize hideTutorialPage;

-(void)setRedirectPageSettings:(NSMutableDictionary*)result{
    [[NSUserDefaults standardUserDefaults] setObject:result[@"show_personal_info_form"] forKey:@"show_personal_info_form"];
    
    [[NSUserDefaults standardUserDefaults] setObject:result[@"hide_permission_page"] forKey:@"hide_permission_page"];
    
    [[NSUserDefaults standardUserDefaults] setObject:result[@"hide_tutorial_page"] forKey:@"hide_tutorial_page"];
    
    [[NSUserDefaults standardUserDefaults] setObject:result[@"profile_id"] forKey:@"profile_id"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
 }

-(void)getRedirectPageSettings{

    self.showPersonalInfoForm = [[[NSUserDefaults standardUserDefaults] objectForKey:@"show_personal_info_form"]intValue];
    
    self.hidePermissionPage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hide_permission_page"]intValue];

    self.hideTutorialPage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hide_tutorial_page"]intValue];
}
@end
