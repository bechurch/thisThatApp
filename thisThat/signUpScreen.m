//
//  signUpScreen.m
//  thisThat
//
//  Created by James Connerton on 2015-02-16.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "signUpScreen.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import "objects.h"
#import "token.h"

@interface signUpScreen ()

@end

@implementation signUpScreen

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initalizeSignupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initalizeSignupView {
   // UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
   // UIColor *redColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(102/255.0) alpha:1];
     UIColor *redColor2 = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    UIColor *redColor2Alpha = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:0.8];
    UIImage *backgroundImage = [UIImage imageNamed:@"IMG_6322.jpg"];
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.backgroundImageView];
    

    
    self.thisThatTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/4)-(self.view.frame.size.height/8), self.view.frame.size.width, self.view.frame.size.height/4)];
    self.thisThatTitleLabel.backgroundColor = [UIColor clearColor];
    self.thisThatTitleLabel.font = [UIFont systemFontOfSize:50];
    self.thisThatTitleLabel.textColor = [UIColor whiteColor];
    self.thisThatTitleLabel.text = @"thisThat";
    self.thisThatTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundImageView addSubview:self.thisThatTitleLabel];
    
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height/2)-15, self.view.frame.size.width-20, 30)];
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    [self.passwordTextField setBorderStyle:UITextBorderStyleNone];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeDefault];
    [self.passwordTextField setSecureTextEntry:YES];
    self.passwordTextField.font = [UIFont systemFontOfSize:12];
    self.passwordTextField.placeholder = @"password";
    [self.backgroundImageView addSubview:self.passwordTextField];
    self.passwordTextField.delegate = self;
    UIView *spacerViewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextField setLeftView:spacerViewPassword];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height/2)-46, self.view.frame.size.width-20, 30)];
    self.usernameTextField.backgroundColor = [UIColor whiteColor];
    [self.usernameTextField setBorderStyle:UITextBorderStyleNone];
    [self.usernameTextField setKeyboardType:UIKeyboardTypeDefault];
    self.usernameTextField.font = [UIFont systemFontOfSize:12];
    self.usernameTextField.placeholder = @"username";
    [self.backgroundImageView addSubview:self.usernameTextField];
    self.usernameTextField.delegate = self;
    UIView *spacerViewUsername = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.usernameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.usernameTextField setLeftView:spacerViewUsername];
    
    
    self.characterCountUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameTextField.frame.size.width-55, 0, 50, 30)];
    self.characterCountUsernameLabel.textAlignment = NSTextAlignmentRight;
    self.characterCountUsernameLabel.textColor = [UIColor lightGrayColor];
    self.characterCountUsernameLabel.font = [UIFont systemFontOfSize:10];
    self.characterCountUsernameString = [[NSString alloc] init];
    [self.usernameTextField addSubview:self.characterCountUsernameLabel];

    
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height/2)+16, self.view.frame.size.width-20, 30)];
    self.phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    [self.phoneNumberTextField setBorderStyle:UITextBorderStyleNone];
    [self.phoneNumberTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:12];
    self.phoneNumberTextField.placeholder = @"10 digit phone number ex. 8557872437";
    [self.backgroundImageView addSubview:self.phoneNumberTextField];
    self.phoneNumberTextField.delegate = self;
    UIView *spacerViewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.phoneNumberTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.phoneNumberTextField setLeftView:spacerViewPhone];
    
    self.maxYPhoneNumber = CGRectGetMaxY(self.phoneNumberTextField.frame);
    
    self.signupButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)+76, 80, 30)];
    [self.signupButton setBackgroundImage:[self imageWithColor:redColor2] forState:UIControlStateNormal];
    [self.signupButton setBackgroundImage:[self imageWithColor:redColor2Alpha] forState:UIControlStateHighlighted];

    [self.signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  //  self.signupButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.signupButton addTarget:self action:@selector(buttonWasPressedDown:) forControlEvents:UIControlEventValueChanged];

    [self.signupButton addTarget:self action:@selector(signupButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.backgroundImageView addSubview:self.signupButton];
    
    self.alreadyHaveAnAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-105, self.view.frame.size.height-40, 150, 30)];
    self.alreadyHaveAnAccountLabel.backgroundColor = [UIColor clearColor];
    self.alreadyHaveAnAccountLabel.textColor = [UIColor whiteColor];
    self.alreadyHaveAnAccountLabel.font = [UIFont boldSystemFontOfSize:12];
    self.alreadyHaveAnAccountLabel.text = @"Already have an account?";
    self.alreadyHaveAnAccountLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundImageView addSubview:self.alreadyHaveAnAccountLabel];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)+55, self.view.frame.size.height-40, 50, 30)];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.loginButton setBackgroundImage:[self imageWithColor:redColor2] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[self imageWithColor:redColor2Alpha] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:self.loginButton];
    
    
}
-(UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)buttonWasPressedDown:(UIButton*)button {
    if([button isEqual:self.signupButton]){
        NSLog(@"swag");
        if(button.state == UIControlEventTouchDown){
        self.signupButton.backgroundColor = [UIColor grayColor];
    }
        if(button.state == UIControlEventValueChanged){
            self.signupButton.backgroundColor = [UIColor redColor];
        }
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.characterCountUsernameLabel setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.phoneNumberTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)+16, self.view.frame.size.width-20, 30);
        self.usernameTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-46, self.view.frame.size.width-20, 30);
        self.passwordTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-15, self.view.frame.size.width-20, 30);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual:self.usernameTextField] || [textField isEqual:self.passwordTextField] || [textField isEqual:self.phoneNumberTextField]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        if(textField == self.usernameTextField){
            textField.returnKeyType = UIReturnKeyNext;
            [self.characterCountUsernameLabel setAlpha:1];
            
        }
        if(textField == self.passwordTextField) {
            [self.characterCountUsernameLabel setAlpha:0];
            textField.returnKeyType = UIReturnKeyNext;
        }
        if(textField == self.phoneNumberTextField){
            [self.characterCountUsernameLabel setAlpha:0];
            textField.returnKeyType = UIReturnKeyGo;
        }
    }
}
-(void)keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardSize);
    self.maxYKeyboard = self.view.frame.size.height - keyboardHeight;
    
    if(self.maxYPhoneNumber > self.maxYKeyboard) {
        CGFloat difference = self.maxYPhoneNumber - self.maxYKeyboard;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.phoneNumberTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)+16-difference-10, self.view.frame.size.width-20, 30);
            self.passwordTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-15-difference-10, self.view.frame.size.width-20, 30);
            self.usernameTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-46-difference-10, self.view.frame.size.width-20, 30);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.phoneNumberTextField){
        [self signUpActionReturnKeyAndButton];
        [textField resignFirstResponder];
    }
    if(textField == self.passwordTextField) {
        [self.phoneNumberTextField becomeFirstResponder];
    }
    if(textField == self.usernameTextField) {
        [self.characterCountUsernameLabel setAlpha:0];
        [self.passwordTextField becomeFirstResponder];
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.phoneNumberTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)+16, self.view.frame.size.width-20, 30);
        self.usernameTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-46, self.view.frame.size.width-20, 30);
        self.passwordTextField.frame = CGRectMake(10, (self.view.frame.size.height/2)-15, self.view.frame.size.width-20, 30);
    } completion:^(BOOL finished) {
        
    }];
    
    //[textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
     
    if([textField isEqual:self.usernameTextField]) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"textfield character count: %lu",(unsigned long)[textField.text length]);
        NSInteger characterCount = [newString lengthOfBytesUsingEncoding:NSUTF32StringEncoding]/4;
        if([newString length]>15) {
            self.characterCountUsernameString = [NSString stringWithFormat:@"15/15"];
            self.characterCountUsernameLabel.text = self.characterCountUsernameString;
        }
        else {
        self.characterCountUsernameString = [NSString stringWithFormat:@"%d/15",characterCount];
        self.characterCountUsernameLabel.text = self.characterCountUsernameString;
        }
        return !([newString length]>15);
    }
  
    else {
        //[textField resignFirstResponder];
        return YES;
    }
}

-(void)signupButtonAction:(UIButton*)button {
    
    [self signUpActionReturnKeyAndButton];
    
    
}
-(void)signUpActionReturnKeyAndButton {
    NSString *usernameString = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordString = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phoneString = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *parameters = @{@"username" : usernameString, @"password" : passwordString, @"phone_number" : phoneString};
    
    NSURL *baseURL  = [NSURL URLWithString:hostUrl]; //host url : http://local-app.co:1337
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    
    [[RKObjectManager sharedManager] postObject:nil path:@"/api/v1/users" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[token class]];
        [objectManager.HTTPClient setAuthorizationHeaderWithUsername:usernameString password:passwordString];
        
        [objectMapping addAttributeMappingsFromDictionary:@{@"token":@"token",
                                                            @"userId":@"userId"}];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodPOST pathPattern:@"/api/v1/auth/login" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
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
            [[NSUserDefaults standardUserDefaults] setObject:usernameString forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self createdAccountSuccessfully];
            
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"fail");
            NSLog(@"errorLogingin:%@",error);
            NSLog(@"localizedDescription:%@",[error localizedDescription]);
            NSLog(@"localizedFailureReason:%@",[error localizedFailureReason]);
            NSLog(@"localizedRecoverySuggestion:%@",[error localizedRecoverySuggestion]);
            NSLog(@"localizedRecoveryOption:%@",[error localizedRecoveryOptions]);
        }];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
        NSLog(@"errorSigningUp:%@",error);
        NSString *localizedRecoverySuggestion = [error localizedRecoverySuggestion];
        NSString *localizedDescriptor = [error localizedDescription];
        NSString *usernameAlreadyInUseString = [NSString stringWithFormat:@"\{\"message\":\"an error occured while creating user: Key (username)=(%@) already exists.\"\}",usernameString];
        NSString *numberAlreadyInUseString = [NSString stringWithFormat:@"\{\"message\":\"an error occured while creating user: Key (phone_number)=(%@) already exists.\"\}",phoneString];
        NSString *missingParameters = @"\{\"message\":\"missing parameters!\"\}";
        
        if([localizedRecoverySuggestion isEqualToString:usernameAlreadyInUseString]){
            NSString *errorMessage = [NSString stringWithFormat:@"The username: \"%@\" already exists. Please select a different one.",usernameString];
            self.usernameAlreadySelectedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.usernameAlreadySelectedAlert show];
        }
        if([localizedRecoverySuggestion isEqualToString:numberAlreadyInUseString]){
            NSString *errorMessage = [NSString stringWithFormat:@"The phone number: \"%@\" is already linked to another user. Please enter a different phone number.",phoneString];
            self.phoneNumberAlreadyExistsAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.phoneNumberAlreadyExistsAlert show];
            
        }
        if([localizedRecoverySuggestion isEqualToString:missingParameters]) {
            self.missingParametersAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username, password and phone number." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.missingParametersAlert show];
            
        }
        if([localizedDescriptor isEqualToString:@"The Internet connection appears to be offline."] || [localizedDescriptor isEqualToString:@"The network connection was lost."] || [localizedDescriptor isEqualToString:@"A server with the specified hostname could not be found."]) {
            self.internetConnectionOfflineAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your internet connection appears to be offline. Please try again when you are connected." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.internetConnectionOfflineAlert show];
            
        }
        
    }];
    

}
-(void)createdAccountSuccessfully {
    self.accountSuccessfullyCreated = [[UIAlertView alloc] initWithTitle:@"Welcome to thisThat" message:@"Your account has been created, have fun!"  delegate:self cancelButtonTitle:@"Enter" otherButtonTitles:nil];
    [self.accountSuccessfullyCreated show];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView isEqual:self.accountSuccessfullyCreated]) {
        if(buttonIndex == [alertView cancelButtonIndex]){
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

-(void)loginButtonAction:(UIButton*)button {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
