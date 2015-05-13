//
//  signUpScreen.h
//  thisThat
//
//  Created by James Connerton on 2015-02-16.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpScreen : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *thisThatTitleLabel;
@property (nonatomic, strong) UILabel *alreadyHaveAnAccountLabel;

@property (nonatomic, strong) UIAlertView *usernameAlreadySelectedAlert;
@property (nonatomic, strong) UIAlertView *phoneNumberAlreadyExistsAlert;
@property (nonatomic, strong) UIAlertView *internetConnectionOfflineAlert;
@property (nonatomic, strong) UIAlertView *missingParametersAlert;
@property (nonatomic, strong) UIAlertView *accountSuccessfullyCreated;
@property (nonatomic, strong) NSString *characterCountUsernameString;
@property (nonatomic, strong) NSString *characterCountPhoneNumberString;
@property (nonatomic, strong) UILabel *characterCountUsernameLabel;
@property (nonatomic, strong) UILabel *characterCountPhoneNumberLabel;
@property CGFloat maxYKeyboard;
@property CGFloat maxYPhoneNumber;
@end
