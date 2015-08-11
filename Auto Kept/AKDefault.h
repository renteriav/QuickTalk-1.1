//
//  AKDefault.h
//  Auto Kept
//
//  Created by Renteria Family on 4/29/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKDefault : NSObject

@property(nonatomic) int showPersonalInfoForm;
@property(nonatomic) int hidePermissionPage;
@property(nonatomic) int hideTutorialPage;

-(void)setRedirectPageSettings:(NSMutableDictionary*)result;
-(void)getRedirectPageSettings;

@end
