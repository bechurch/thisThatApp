//
//  LoginScreen.h
//  thisThat
//
//  Created by James Connerton on 2014-12-28.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreen : UIViewController <UITextFieldDelegate>
/*- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
- (IBAction)signUpButton:(id)sender;*/

@property (nonatomic, strong) UITextField *usernameTxtFld;
@property (nonatomic, strong) UITextField *passwordTxtFld;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIAlertView *wrongUsernamePasswordAlert;
@property (nonatomic, strong) UIAlertView *internetConnectionOffline;
@property (nonatomic, strong) UIAlertView *usernameOrPasswordNotEntered;
@property (nonatomic, strong) UILabel *thisThatTitleLabel;
@property (nonatomic, strong) UILabel *dontHaveAnAccountLabel;
@property (nonatomic, strong) UIImageView *backGroundImageView;
@property CGFloat maxYPassword;
@property CGFloat maxYKeyboard;
@end
