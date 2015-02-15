//
//  LoginScreen.m
//  thisThat
//
//  Created by James Connerton on 2014-12-28.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "LoginScreen.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import "objects.h"
#import "token.h"
@interface LoginScreen ()

@end

@implementation LoginScreen


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    self.usernameTxtFld.delegate = self;
    self.passwordTxtFld.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self.navigationController.navigationBar setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {

   
    NSString *username = self.usernameTxtFld.text;
    NSString *password = self.passwordTxtFld.text;

    NSURL *baseURL  = [NSURL URLWithString:hostUrl]; //host url : http://local-app.co:1337
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[token class]];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    [objectMapping addAttributeMappingsFromDictionary:@{@"token":@"token",
                                                        @"userId":@"userId"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodPOST pathPattern:@"/api/v1/auth/login" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:201]];
    [objectManager addResponseDescriptor:responseDescriptor];


    [objectManager postObject:nil path:@"http://local-app.co:1337/api/v1/auth/login" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
         NSArray *tokenID = mappingResult.array;
        token *theToken = [tokenID objectAtIndex:0];
       
        NSString *tokenIDString = theToken.token;
        NSString *userIDString = theToken.userId;
        NSLog(@"\ntokenValue:%@\n userId:%@",tokenIDString,userIDString);
        
        [[NSUserDefaults standardUserDefaults] setObject:tokenIDString forKey:@"tokenIDString"];
        [[NSUserDefaults standardUserDefaults] setObject:userIDString forKey:@"userIDString"];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
    }];
    
//[self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
