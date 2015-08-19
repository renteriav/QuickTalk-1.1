#import "OproAPIClient.h"

@interface OproAPIClient ()
- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;
@end

@implementation OproAPIClient

////////////////////////////////////////////////////////////////////////
+ (instancetype)sharedClient
{
    static OproAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OproAPIClient alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
    });
    
    return _sharedClient;
}

////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"RefreshToken"];
        
        [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
- (void)authenticateUsingOAuthWithUsername:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSString *accessToken, NSString *refreshToken, NSString *expiresIn))success
                                   failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{ @"username"       : username,
                              @"password"       : password,
                              @"client_id"      : oClientID,
                              @"client_secret"  : oClientSecret };
    
    [self POST:@"oauth/token.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *accessToken = responseObject[@"access_token"];
           NSString *refreshToken = responseObject[@"refresh_token"];
           NSString *expiresIn = responseObject[@"expires_in"];
           
           [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
           
           if (success) success(accessToken, refreshToken, expiresIn);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (failure) failure(error);
       }];
}

- (void)getAccessKeyWithRefreshToken: (NSString *)refreshToken
                             success:(void (^)(NSString *accessToken, NSString *refreshToken, NSString *expiresIn))success
                             failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{ @"refresh_token"  : refreshToken,
                              @"client_id"      : oClientID,
                              @"client_secret"  : oClientSecret };
    
    [self POST:@"oauth/token.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *accessToken = responseObject[@"access_token"];
           NSString *refreshToken = responseObject[@"refresh_token"];
           NSString *expiresIn = responseObject[@"expires_in"];
           
           [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
           
           if (success) success(accessToken, refreshToken, expiresIn);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (failure) failure(error);
       }];
}


- (void)logout
{
    [self setIsAuthenticated:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RefreshToken"];
    [self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];

}

#pragma mark - Private

////////////////////////////////////////////////////////////////////////
- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
{
    if (accessToken != nil && ![accessToken isEqualToString:@""]) {
        [self setIsAuthenticated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"AccessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"RefreshToken"];

        [[self requestSerializer] setValue:[NSString stringWithFormat:@"token %@",accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

@end
