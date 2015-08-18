#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface OproAPIClient : AFHTTPSessionManager

@property (nonatomic, assign) BOOL isAuthenticated;

+ (instancetype)sharedClient;

- (void)authenticateUsingOAuthWithUsername:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSString *accessToken, NSString *refreshToken, NSString *expiresIn))success
                                   failure:(void (^)(NSError *error))failure;

- (void)getAccessKeyWithRefreshToken:(NSString *)refreshToken
                             success:(void (^)(NSString *accessToken, NSString *refreshToken, NSString *expiresIn))success
                             failure:(void (^)(NSError *error))failure;

- (void)logout;

// Credentials for the opro demo server you will can modify oClientID and oClientSecret
//#define oClientID            @"bd443d6eb471fb36fb80481079bbc226"
//#define oClientSecret        @"0065ff3ac5940e42577756e0d8a74272"

// Credentials if the server is local, you will need to modify oClientID and oClientSecret
#define oClientBaseURLString @"http://localhost:3000/"
#define oClientID            @"7cf6d1f67e1897943505b9dc9cc2b48b"
#define oClientSecret        @"c4d5e3295979c50639fa3fa630682097"




@end
