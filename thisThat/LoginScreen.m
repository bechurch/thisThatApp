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
   // [self.navigationController.navigationBar setHidden:YES];
    [self initalizeLoginView];
    
    
    
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
-(void)initalizeLoginView {
 
    UIColor *blueColor = [UIColor colorWithRed:(0/255.0) green:(196/255.0) blue:(222/255.0) alpha:1];
    UIColor *blueColor2 = [UIColor colorWithRed:(0/255.0) green:(196/255.0) blue:(222/255.0) alpha:0.8];
    UIImage *backGroundImage = [UIImage imageNamed:@"IMG_6151.jpg"];
    self.backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backGroundImageView.image = backGroundImage;
    self.backGroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backGroundImageView.clipsToBounds = YES;
    [self.backGroundImageView setUserInteractionEnabled:YES];
    [self.view addSubview:self.backGroundImageView];
    
   self.thisThatTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/4)-self.view.frame.size.height/8, self.view.frame.size.width, self.view.frame.size.height/4)];
    NSLog(@"\nviewHeight:%f\nviewWidth:%f",self.view.frame.size.height,self.view.frame.size.width);
    self.thisThatTitleLabel.backgroundColor = [UIColor clearColor];
    self.thisThatTitleLabel.text = @"thisThat";
    self.thisThatTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.thisThatTitleLabel.textColor = [UIColor whiteColor];
    [self.thisThatTitleLabel setFont:[UIFont systemFontOfSize:50]];
    self.thisThatTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.thisThatTitleLabel.minimumScaleFactor = 0.8;
    [self.backGroundImageView addSubview:self.thisThatTitleLabel];
    
    UILabel *thisThatLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-35, (self.view.frame.size.height/4)+20, 70, 30)];
    thisThatLoginLabel.text = @"Login";
    thisThatLoginLabel.textColor = [UIColor whiteColor];
    thisThatLoginLabel.textAlignment = NSTextAlignmentCenter;
    thisThatLoginLabel.font = [UIFont systemFontOfSize:20];
    [self.backGroundImageView addSubview:thisThatLoginLabel];
    
    self.usernameTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height/2)-31, self.view.frame.size.width-20, 30)];
    self.usernameTxtFld.delegate = self;
    self.usernameTxtFld.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTxtFld.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTxtFld.borderStyle = UITextBorderStyleNone;
    self.usernameTxtFld.keyboardType = UIKeyboardTypeDefault;
    self.usernameTxtFld.backgroundColor = [UIColor whiteColor];
    self.usernameTxtFld.font = [UIFont systemFontOfSize:12];
    self.usernameTxtFld.placeholder = @"username";
    //[self.usernameTxtFld setUserInteractionEnabled:YES];
    [self.usernameTxtFld setTextColor:[UIColor blackColor]];
    [self.backGroundImageView addSubview:self.usernameTxtFld];
    UIView *spacerViewUsername = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.usernameTxtFld setLeftViewMode:UITextFieldViewModeAlways];
    [self.usernameTxtFld setLeftView:spacerViewUsername];
    
    self.passwordTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height/2), self.view.frame.size.width-20, 30)];
    self.passwordTxtFld.delegate = self;
    self.passwordTxtFld.borderStyle = UITextBorderStyleNone;
    self.passwordTxtFld.keyboardType = UIKeyboardTypeDefault;
    [self.passwordTxtFld setSecureTextEntry:YES];
    self.passwordTxtFld.backgroundColor = [UIColor whiteColor];
    self.passwordTxtFld.font = [UIFont systemFontOfSize:12];
    self.passwordTxtFld.placeholder = @"password";
    [self.passwordTxtFld setTextColor:[UIColor blackColor]];
    [self.backGroundImageView addSubview:self.passwordTxtFld];
    UIView *spacerViewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.passwordTxtFld setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTxtFld setLeftView:spacerViewPassword];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-35, (self.view.frame.size.height/2)+60, 70, 30)];
    [self.loginButton setBackgroundImage:[self imageWithColor:blueColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[self imageWithColor:blueColor2] forState:UIControlStateHighlighted];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
   // self.loginButton.showsTouchWhenHighlighted = YES;
    [self.loginButton addTarget:self action:@selector(loginbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundImageView addSubview:self.loginButton];
    
    
    self.signUpButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)+45, self.view.frame.size.height-40, 60, 30)];
    [self.signUpButton setBackgroundImage:[self imageWithColor:blueColor] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundImage:[self imageWithColor:blueColor2] forState:UIControlStateHighlighted];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.signUpButton addTarget:self action:@selector(signUpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundImageView addSubview:self.signUpButton];
    
    
    self.dontHaveAnAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-105, self.view.frame.size.height-40, 140, 30)];
    //self.dontHaveAnAccountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.dontHaveAnAccountLabel.textAlignment = NSTextAlignmentCenter;
    self.dontHaveAnAccountLabel.text = @"Don't have an account?";
    self.dontHaveAnAccountLabel.textColor = [UIColor whiteColor];
    [self.dontHaveAnAccountLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.backGroundImageView addSubview:self.dontHaveAnAccountLabel];
    self.maxYPassword = CGRectGetMaxY(self.passwordTxtFld.frame);
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameTxtFld resignFirstResponder];
    [self.passwordTxtFld resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.usernameTxtFld.frame =  CGRectMake(10, (self.view.frame.size.height/2)-31, self.view.frame.size.width-20, 30);
        self.passwordTxtFld.frame =  CGRectMake(10, (self.view.frame.size.height/2), self.view.frame.size.width-20, 30);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loginbuttonAction:(UIButton*)button {
    [self loginActionReturnKeyAndButton];
   
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"didBegin");
    if([textField isEqual:self.usernameTxtFld] || [textField isEqual:self.passwordTxtFld]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        if(textField == self.passwordTxtFld){
            textField.returnKeyType = UIReturnKeyGo;
        }
        if(textField == self.usernameTxtFld){
            textField.returnKeyType = UIReturnKeyNext;
        }
    }

   }
-(void)keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardSize);
    self.maxYKeyboard = self.view.frame.size.height - keyboardHeight;
    if(self.maxYPassword > self.maxYKeyboard){
        NSLog(@"insideLoop");
       
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.passwordTxtFld.frame = CGRectMake(self.passwordTxtFld.frame.origin.x, self.maxYKeyboard-10-30, self.passwordTxtFld.frame.size.width,self.passwordTxtFld.frame.size.height);
            self.usernameTxtFld.frame = CGRectMake(self.usernameTxtFld.frame.origin.x, self.maxYKeyboard-10-30-31, self.usernameTxtFld.frame.size.width, self.usernameTxtFld.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
     
    }
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.passwordTxtFld){
        [self loginActionReturnKeyAndButton];
        [textField resignFirstResponder];
    }
    if(textField == self.usernameTxtFld){
        [self.passwordTxtFld becomeFirstResponder];
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.usernameTxtFld.frame =  CGRectMake(10, (self.view.frame.size.height/2)-31, self.view.frame.size.width-20, 30);
        self.passwordTxtFld.frame =  CGRectMake(10, (self.view.frame.size.height/2), self.view.frame.size.width-20, 30);
    } completion:^(BOOL finished) {
        
    }];
    
    //[textField resignFirstResponder];
    return YES;
}
-(void)signUpButtonAction:(UIButton*)button{
    [self performSegueWithIdentifier:@"signUp" sender:self];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(void)loginActionReturnKeyAndButton {
    [self.loginButton setEnabled:NO];
    NSString *username = [self.usernameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSURL *baseURL  = [NSURL URLWithString:hostUrl]; //host url : http://local-app.co:1337
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //[RKMIMETypeSerialization registerClass:[RKMIMETypeSerialization class] forMIMEType:@"textPlain"];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[token class]];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    [objectMapping addAttributeMappingsFromDictionary:@{@"token":@"token",
                                                        @"userId":@"userId"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodPOST pathPattern:@"/api/v1/auth/login" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    [objectManager postObject:nil path:@"http://local-app.co:1337/api/v1/auth/login" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.loginButton setEnabled:YES];
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
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.loginButton setEnabled:YES];
        NSLog(@"fail");
        NSString *localizedRecoverySuggestion = [error localizedRecoverySuggestion];
        NSString *localizedDescription = [error localizedDescription];
        if([localizedRecoverySuggestion isEqualToString:@"Unauthorized"]) {
            if([username isEqualToString:@""] || [password isEqualToString:@""]) {
                self.usernameOrPasswordNotEntered = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username and password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [self.usernameOrPasswordNotEntered show];
            }
            else {
                self.wrongUsernamePasswordAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username and password combination. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [self.wrongUsernamePasswordAlert show];
            }
        }
        if([localizedDescription isEqualToString:@"The Internet connection appears to be offline."] || [localizedDescription isEqualToString:@"A server with the specified hostname could not be found."] || [localizedDescription isEqualToString:@"The network connection was lost."]){
            self.internetConnectionOffline = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your internet connection appears to be offline. Please try again when you are connected." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.internetConnectionOffline show];
        }
        
    }];
    

}
@end
