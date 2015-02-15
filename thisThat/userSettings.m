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
  
    [self performSegueWithIdentifier:@"showLogin2" sender:self];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername = %@\n",currentIDObject,userTokenObject,usernameObject);
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLogin2"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
@end
