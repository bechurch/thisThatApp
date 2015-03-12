//
//  userSettings.m
//  thisThat
//
//  Created by James Connerton on 2014-11-11.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "userSettings.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import "objects.h"
#import "LoginScreen.h"

@interface userSettings ()

@end

@implementation userSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButton:(id)sender {
  /*
   NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:pathString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
   [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
   [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
   }];
   
   RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
   

    */
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
 NSDictionary *parameters = @{@"token" : userTokenObject};
//NEW
  /*
    NSURL *baseURL  = [NSURL URLWithString:hostUrl]; //host url : http://local-app.co:1337
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[objects class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{@"token":@"token",
                                                       // @"userId":@"userId"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodPOST pathPattern:@"/api/v1/auth/logout" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    [objectManager postObject:nil path:@"http://local-app.co:1337/api/v1/auth/logout" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"fail");
    }];

    */
    
    
    
   // [RKMIMETypeSerialization registerClass:[RKMIMETypeSerialization class] forMIMEType:@"text/plain"];
 ///////////////////////
    [[RKObjectManager sharedManager] postObject:nil path:@"/api/v1/auth/logout" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
        NSLog(@"errorSuggestion:%@",[error localizedRecoverySuggestion]);
        NSLog(@"errorOptions:%@",[error localizedRecoveryOptions]);
        NSLog(@"errorReason:%@",[error localizedFailureReason]);
        NSLog(@"errorDescription:%@",[error localizedDescription]);

    }];
  

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername = %@\n",currentIDObject,userTokenObject,usernameObject);

    //[self performSegueWithIdentifier:@"showLogin2" sender:self];
    LoginScreen *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    [self.parentViewController presentViewController:loginVC animated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
 /*   NSURL *baseURL  = [NSURL URLWithString:hostUrl]; //host url : http://local-app.co:1337
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[token class]];
    [objectMapping addAttributeMappingsFromDictionary:@{@"token":@"token",
                                                        @"userId":@"userId"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodPOST pathPattern:@"/api/v1/auth/login" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:201]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:nil path:@"/api/v1/users" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
    }];*/

    
    
    /*
    
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
   // NSArray *tokenArray = [[NSArray alloc] initWithObjects:userTokenObject, nil];
   // NSDictionary *userToken = [[NSDictionary alloc] initWithObjectsAndKeys:userTokenObject, nil];
    NSMutableDictionary *userTokenDict = [[NSMutableDictionary alloc] init];
    [userTokenDict setValue:userTokenObject forKey:@"token"];
    
    NSURL *baseURL = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSMutableURLRequest *operation = [[RKObjectManager sharedManager] requestWithObject:[objects class] method:RKRequestMethodPOST path:@"/api/v1/auth/logout" parameters:userTokenDict];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:operation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self performSegueWithIdentifier:@"showLogin2" sender:self];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenIDString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIDString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
        NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
        NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername = %@\n",currentIDObject,userTokenObject,usernameObject);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        NSLog(@"fail");
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:objectRequestOperation];
 */
  
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLogin2"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
       
    }
}*/
@end
