//
//  upload.m
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//


#import "upload.h"
#import "objects.h"
#import <RestKit/RestKit.h>
#import "constants.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"





typedef NS_ENUM(NSInteger, PhotoType){
    PhotoTypeOne = 10,
    PhotoTypeTwo = 20
};

@interface upload ()
@property (nonatomic, assign) PhotoType selectedPhotoType;
@property (nonatomic, strong) NSNumber *userIdJames;
@end
@implementation upload
@synthesize userIdJames;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    self.cancel.layer.cornerRadius = 10.0f;
    self.cancel.clipsToBounds = YES;
    self.cancel.layer.borderWidth = 2.0f;
    self.cancel.layer.borderColor = [UIColor blackColor].CGColor;
    
  //  [self.upload setHidden:YES];
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
    
    self.userIdJames = [[NSNumber alloc] initWithInt:2];
    
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
   // imagePicker.allowsEditing = YES;
    type = UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    switch (self.selectedPhotoType) {
        case PhotoTypeOne:
            self.imageViewOne.image = [info objectForKey:UIImagePickerControllerOriginalImage];
            self.imageViewOne.image = [self scaleImage:self.imageViewOne.image toSize:CGSizeMake(240, 240)];
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
            self.imageViewTwo.image = [self scaleImage:self.imageViewTwo.image toSize:CGSizeMake((240), 240)];
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
   /* if(self.imageViewOne.image != nil && self.imageViewTwo.image != nil) {
        [self.upload setHidden:NO];
    }*/
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    if(self.imageViewOne.image != nil || self.imageViewTwo.image != nil || self.textField.text.length != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will delete photos and text." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alertView show];
        NSLog(@"imageivewone: %@/n imageviewtwo: %@/n textfield: %@",self.imageViewOne.image, self.imageViewTwo.image, self.textField.text);
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)upload:(id)sender {
    
    [self postTheFuckingImage];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
    }
}
-(UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)postTheFuckingImage {
 
    NSURL *baseURL  = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSData *imageOneData = UIImageJPEGRepresentation(self.imageViewOne.image, 0.5);
    NSData *imageTwoData = UIImageJPEGRepresentation(self.imageViewTwo.image, 0.5);
    NSDictionary *parameters = @{@"username" : @"James", @"password" : @"james", @"message" : self.textField.text};
    
    NSMutableURLRequest *operation = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:@"/api/v1/ThisThats" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:operation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"succss");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];

    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:objectRequestOperation];
    
    
}

@end
