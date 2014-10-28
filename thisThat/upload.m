//
//  upload.m
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "upload.h"

typedef NS_ENUM(NSInteger, PhotoType){
    PhotoTypeOne = 10,
    PhotoTypeTwo = 20
};

@interface upload ()
@property (nonatomic, assign) PhotoType selectedPhotoType;
@end

@implementation upload

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    self.cancel.layer.cornerRadius = 10.0f;
    self.cancel.clipsToBounds = YES;
    self.cancel.layer.borderWidth = 2.0f;
    self.cancel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.upload setHidden:YES];
    self.upload.layer.cornerRadius = 10.0f;
    self.upload.clipsToBounds = YES;
    self.upload.layer.borderWidth = 2.0f;
    self.upload.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.takePhotoLabelOne.layer.cornerRadius = 20.0f;
    self.takePhotoLabelOne.clipsToBounds = YES;
    self.takePhotoLabelOne.layer.borderWidth = 3.0f;
    self.takePhotoLabelOne.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.takePhotoLabelTwo.layer.cornerRadius = 20.0f;
    self.takePhotoLabelTwo.clipsToBounds = YES;
    self.takePhotoLabelTwo.layer.borderWidth = 3.0f;
    self.takePhotoLabelTwo.layer.borderColor = [UIColor grayColor].CGColor;
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

- (IBAction)takePhoto:(id)sender {
    
    if([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = sender;
        self.selectedPhotoType = button.tag;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    //imagePicker.allowsEditing = YES;
    type = UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    switch (self.selectedPhotoType) {
        case PhotoTypeOne:
            self.imageViewOne.image = [info objectForKey:UIImagePickerControllerOriginalImage];
            self.imageViewOne.layer.cornerRadius = 20.0f;
            self.imageViewOne.clipsToBounds = YES;
            self.imageViewOne.layer.borderWidth = 3.0f;
            self.imageViewOne.layer.borderColor = [UIColor grayColor].CGColor;
            if(self.imageViewOne != nil) {
                [self.takePhotoLabelOne setHidden:YES];
            }
            break;
            case PhotoTypeTwo:
            self.imageViewTwo.image = [info objectForKey:UIImagePickerControllerOriginalImage];
            self.imageViewTwo.layer.cornerRadius = 20.0f;
            self.imageViewTwo.clipsToBounds = YES;
            self.imageViewTwo.layer.borderWidth = 3.0f;
            self.imageViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
            if(self.imageViewTwo != nil) {
                [self.takePhotoLabelTwo setHidden:YES];
            }
            break;
        default:
            break;
    }
    if(self.imageViewOne.image != nil && self.imageViewTwo.image != nil) {
        [self.upload setHidden:NO];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    if(self.imageViewOne.image != nil || self.imageViewTwo.image != nil || self.textField.text.length != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will delete photos and text." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alertView show];
        NSLog(@"imageivewone: %@/n imageviewtwo: %@/n textfield: %@",self.imageViewOne.image, self.imageViewTwo.image, self.textField.text);
    } else {
        
    }
}

- (IBAction)upload:(id)sender {
    
    // send imageViewOne, imageViewTwo and textField to server
}

//dismiss keyboard when hit return

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        self.imageViewOne.image = nil;
        self.imageViewTwo.image = nil;
        self.textField.text = nil;
        [self.takePhotoLabelOne setHidden:NO];
        [self.takePhotoLabelTwo setHidden:NO];
    }
    else {
        
    }
}
@end
