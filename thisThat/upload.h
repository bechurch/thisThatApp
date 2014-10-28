//
//  upload.h
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface upload : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *takePhotoLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *takePhotoLabelTwo;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *upload;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end
