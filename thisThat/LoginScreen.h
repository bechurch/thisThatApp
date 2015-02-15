//
//  LoginScreen.h
//  thisThat
//
//  Created by James Connerton on 2014-12-28.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreen : UIViewController <UITextFieldDelegate>
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;

@end
