//
//  URLEncoding.m
//  Auto Kept
//
//  Created by Kamal Mittal on 05/01/15.
//  Copyright (c) 2015 Woodenlabs. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString(URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end
