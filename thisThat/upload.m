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
    
  /* RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[objects class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"user_id": @"userId",@"image_1": @"imageOne", @"image_2": @"imageTwo", @"message": @"textContent", @"createdAt": @"createdAt"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:@"ThisThats" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{@"user_id": @"userId",@"image_1": @"imageOne", @"image_2": @"imageTwo", @"message": @"textContent", @"createdAt": @"createdAt"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[objects class] rootKeyPath:@"ThisThats" method:RKRequestMethodPOST];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:hostUrl]];
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    objects *objectAdd = [objects new];
    UIImage *image1 = self.imageViewOne.image;
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:objectAdd method:RKRequestMethodPOST path:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image1) name:objectAdd.imageOne fileName:@"photo.png" mimeType:@"image1/png"];
        
    }];
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:nil failure:nil];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
    objectAdd.username = @"James";
    objectAdd.password = @"james";
    objectAdd.textContent = self.textField.text;
    //objectAdd.userId = self.userIdJames;
//    objectAdd.imageOne = nil;
 //   objectAdd.imageTwo = nil;
    [objectManager postObject:objectAdd path:@"/api/v1/ThisThats" parameters:nil success:nil failure:nil];
   */
    
/*
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[objects class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"user_id": @"userId",@"image_1": @"imageOne", @"image_2": @"imageTwo", @"message": @"textContent", @"createdAt": @"createdAt"}];
     RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil @"ThisThats" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];//mappingForClass:[objects class]];
    [requestMapping addAttributeMappingsFromDictionary:@{@"user_id": @"userId",@"image_1": @"imageOne", @"image_2": @"imageTwo", @"message": @"textContent", @"createdAt": @"createdAt"}];

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[objects class] rootKeyPath:nil @"ThisThats" method:RKRequestMethodAny];
   
    NSURL *baseURL = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    objects *AddObject = [objects new];
    AddObject.textContent = self.textField.text;
    AddObject.username = @"James";
    AddObject.password = @"james";
    
  //  AddObject.userId = [[NSNumber alloc] initWithInt:2];
    //AddObject.imageOne = nil;
    //AddObject.imageTwo = nil;
    [manager postObject:AddObject path:@"/api/v1/ThisThats" parameters:nil success:nil failure:nil];
    
*/
  /*  RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[objects class]];
    [responseMapping addAttributeMappingsFromArray:@[@"username", @"password", @"textContent", @"image_1",@"image_2"]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:@"/api/v1/ThisThats" keyPath:@"thisThat" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKObjectMapping *requestMaping = [RKObjectMapping requestMapping];
    [requestMaping addAttributeMappingsFromArray:@[@"username", @"password", @"texContent", @"image_1",@"image_2"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMaping objectClass:[objects class] rootKeyPath:@"ThisThats" method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:hostUrl]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    objects *AddObject = [objects new];
    
    AddObject.username = @"James";
    AddObject.password = @"james";
    AddObject.textContent = self.textField.text;
    
    [manager postObject:AddObject path:@"/api/v1/ThisThats" parameters:nil success:nil failure:nil];
*/
    /*
    NSString *textFieldTextString = [[NSString alloc] init];
    textFieldTextString = self.textField.text;
    NSDictionary *parameters = @{@"username" : @"James",
                                 @"password" : @"james",
                                 @"message" : textFieldTextString};
                               //  @"image_1" : self.imageViewOne.image,
                                // @"image_2" : self.imageViewTwo.image};
    [[RKObjectManager sharedManager] postObject:nil path:@"/api/v1/ThisThats" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"we did it");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    objects *newPost = [objects new];
    UIImage *imageONE = self.imageViewOne.image;
   // UIImage *imageTWO = self.imageViewTwo.image;
    NSMutableURLRequest *request1 = [[RKObjectManager sharedManager] multipartFormRequestWithObject:newPost method:RKRequestMethodPOST path:@"/api/v1/ThisThats" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(imageONE) name:@"imageOne" fileName:@"photo1.png" mimeType:@"image1/png"];
    }];

    [[RKObjectManager sharedManager] postObject:request1 path:@"api/v1/ThisThats" parameters:parameters success:nil failure:nil];

    */
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
    /*-(void)loadImage {
     // NSDictionary *getInfo = @{@"user_Id" : [NSNumber numberWithInt:userID]};
     NSString *usernameString = [[NSString alloc] init];
     usernameString = @"James";
     
     NSDictionary *param = @{@"username" : usernameString };
     [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v1/ThisThats/all" parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     _thisThatArray = mappingResult.array;
     [self loadView];
     NSLog(@"contents of array: %@",_thisThatArray);
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     NSLog(@"Error loading from API: %@", error);
     }];
     
     }*//*
    NSString *textContentString = [[NSString alloc] init];
    textContentString = self.textField.text;
    UIImage *imageOne = self.imageViewOne.image;
    UIImage *imageTwo = self.imageViewTwo.image;
    NSDictionary *params = @{@"username" : @"James",
                             @"password" : @"james",
                             @"message"  : textContentString};
                            // @"image1" : imageOne,
                            // @"image2" : imageTwo};
    objects *newPost = [objects new];
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:newPost method:RKRequestMethodPOST path:@"/api/v1/ThisThats" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(imageOne) name:@"image1" fileName:@"photo.png" mimeType:@"imageOne/png"];
        [formData appendPartWithFileData:UIImagePNGRepresentation(imageTwo) name:@"image2" fileName:@"photo.png" mimeType:@"imageTwo/png"];
        NSLog(@"form data: %@",formData);
    }];
    
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"we made it");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fuckity fuck");
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];*/
    
    NSURL *baseURL  = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSData *imageOneData = UIImageJPEGRepresentation(self.imageViewOne.image, 0.5);
    NSData *imageTwoData = UIImageJPEGRepresentation(self.imageViewTwo.image, 0.5);
    NSDictionary *parameters = @{@"username" : @"James", @"password" : @"james", @"message" : self.textField.text};
    NSMutableURLRequest *operation = [[RKObjectManager sharedManager]multipartFormRequestWithObject:client method:RKRequestMethodPOST path:@"/api/v1/ThisThats" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
RKObjectRequestOperation *objectRequestOperation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:operation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    NSLog(@"succss");
} failure:^(RKObjectRequestOperation *operation, NSError *error) {
    NSLog(@"Error");
}];
    [objectRequestOperation start];
  
  
    
}

@end
