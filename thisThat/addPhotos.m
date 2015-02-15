//
//  addPhotos.m
//  thisThat
//
//  Created by James Connerton on 2015-01-25.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "addPhotos.h"
#import "tableViewCustomCell.h"
#import "objects.h"
#import <RestKit/RestKit.h>
#import "constants.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface addPhotos ()

@end

@implementation addPhotos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellTextLabelArray = [[NSArray alloc] initWithObjects:@"Photo one",@"Photo two", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.previewButton setEnabled:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    } if(section == 1) {
        return 1;
    } else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        
        return @"Take two photos for comparison";
    } if(section == 1) {
        return @"What are you comparing?";
    } else {
        return @"";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath indexAtPosition:[indexPath length]-2];
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    if(section == 0){
        tableViewCustomCell *cell1 = [self.myTableView dequeueReusableCellWithIdentifier:cellID1];
        NSString *arrayContentsString = [self.cellTextLabelArray objectAtIndex:indexPath.row];
        cell1.cellTextLabel.text = arrayContentsString;
        return cell1;
    } if(section == 1) {
        tableViewCustomCell *cell2 = [self.myTableView dequeueReusableCellWithIdentifier:cellID2];
        cell2.cellTextField.delegate = self;
        if([indexPath row] == 0){
            cell2.cellTextField.tag = 0;
        }
        return cell2;
    } else {
        tableViewCustomCell *cell3 = [self.myTableView dequeueReusableCellWithIdentifier:cellID3];
        [cell3.uploadthisThatButton addTarget:self action:@selector(uploadthisThat:) forControlEvents:UIControlEventTouchUpInside];
        cell3.uploadthisThatButton.tag = 1;
        return cell3;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = [indexPath indexAtPosition:[indexPath length]-2];
    if(section == 0){
        self.selectedRow= [self.cellTextLabelArray objectAtIndex:indexPath.row];
       self.imagePicker = [[UIImagePickerController alloc] init];
        UIImagePickerControllerSourceType type;
        type = UIImagePickerControllerSourceTypeCamera;
       // type = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.sourceType = type;
        self.imagePicker.delegate = self;
       
        
        
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        CGFloat viewHeight = CGRectGetHeight(self.view.frame);
        self.chosePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2)-40, 5, 80, 30)];
        [self.chosePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.chosePhotoButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.chosePhotoButton setTitle:@"Library" forState:UIControlStateNormal];
       // chosePhotoButton.titleLabel.text = @"Library";
        self.chosePhotoButton.titleLabel.textColor = [UIColor whiteColor];
        self.chosePhotoButton.backgroundColor = [UIColor clearColor];
      //  [chosePhotoButton setTitle:@"Library" forState:UIControlStateNormal];
        [self.chosePhotoButton addTarget:self action:@selector(chooseFromLibrary:) forControlEvents:UIControlEventTouchUpInside];
        [self.imagePicker.view addSubview:self.chosePhotoButton];
        //[self.imagePicker.cameraOverlayView addSubview:chosePhotoButton];
                [self presentViewController:self.imagePicker animated:YES completion:nil];
    }

    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];

}
-(void)chooseFromLibrary:(UIButton *)button {
    NSLog(@"butotnWasPressed");
   // [self.chosePhotoButton setEnabled:NO];
    [self.chosePhotoButton setHidden:YES];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   // self.imagePicker.allowsEditing = YES;
    

    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if([self.selectedRow isEqual:@"Photo one"]) {
        self.imageTempOne = [info objectForKey:UIImagePickerControllerOriginalImage];

        
    }
    if([self.selectedRow isEqual:@"Photo two"]){
        self.imageTempTwo = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.textFieldString.length != 0 && self.imageViewOneTemp != nil && self.imageViewTwoTemp != nil){
        [self.previewButton setEnabled:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    tableViewCustomCell *cell2 = [self.myTableView dequeueReusableCellWithIdentifier:@"cell2"];
    if(cell2.cellTextField.tag == 0){
        self.textFieldString = textField.text;
        NSLog(@"textFieldContent:%@",self.textFieldString);
        if(self.textFieldString.length != 0 && self.imageTempOne != nil && self.imageTempTwo != nil){
            [self.previewButton setEnabled:YES];
        } else {
            [self.previewButton setEnabled:NO];
        }
    }
    return YES;
}
- (IBAction)previewButton:(id)sender {
   
    CGFloat getWidth = CGRectGetWidth(self.navigationController.view.frame);
    CGFloat getHeight = CGRectGetHeight(self.navigationController.view.frame);
    CGRect showPhotosViewSize = CGRectMake(0, 0, getWidth, getHeight);
    self.showPhotosView = [[UIView alloc] initWithFrame:showPhotosViewSize];
    self.showPhotosView.backgroundColor = [UIColor whiteColor];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self.showPhotosView];
    //[self.navigationController.view addSubview:self.showPhotosView];
    
    CGRect imageViewOneSize = CGRectMake( 0, 0, getWidth, (getHeight/2));
    self.imageViewOne = [[UIImageView alloc] initWithFrame:imageViewOneSize];
  //  self.imageViewOne.image = self.imageViewOneTemp.image;
    self.imageViewOne.image = self.imageTempOne;
    self.imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewOne.clipsToBounds = YES;
    [self.showPhotosView addSubview:self.imageViewOne];
    
    
    CGRect imageViewTwoSize = CGRectMake(0, (getHeight/2), getWidth, (getHeight/2));
    self.imageViewTwo = [[UIImageView alloc] initWithFrame:imageViewTwoSize];
    self.imageViewTwo.image = self.imageTempTwo;
    self.imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewTwo.clipsToBounds = YES;
    [self.showPhotosView addSubview:self.imageViewTwo];
    
    self.pinchRecogizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePinch:)];
    [self.showPhotosView addGestureRecognizer:self.pinchRecogizer];
    
    self.tapGestureFullSizeImageOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTap:)];
    [self.imageViewOne addGestureRecognizer:self.tapGestureFullSizeImageOne];
    self.tapGestureFullSizeImageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTap:)];
    [self.imageViewTwo addGestureRecognizer:self.tapGestureFullSizeImageTwo];
    self.tapGestureCloseFullSizeImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTap:)];
    
    [self.imageViewOne setUserInteractionEnabled:YES];
    [self.imageViewTwo setUserInteractionEnabled:YES];
    self.x = 0;
}
-(void)recognizeTap:(UITapGestureRecognizer *)recognize {
    
    
    if(recognize == self.tapGestureFullSizeImageOne || recognize == self.tapGestureFullSizeImageTwo){
     
        self.additionalView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.additionalView.backgroundColor = [UIColor blackColor];
        [self.showPhotosView addSubview:self.additionalView];
        self.fullSizeImageView = [[UIImageView alloc] init];
      
        if(recognize == self.tapGestureFullSizeImageOne){
        self.fullSizeImageView = [self inputImage:self.imageTempOne];
           // self.fullSizeImageView.image = [self compressImage:self.imageTempOne];
        [self.additionalView addSubview:self.fullSizeImageView];
        [self.additionalView addGestureRecognizer:self.tapGestureCloseFullSizeImage];
    }
    if(recognize == self.tapGestureFullSizeImageTwo){
            
            self.fullSizeImageView = [self inputImage:self.imageTempTwo];
            [self.additionalView addSubview:self.fullSizeImageView];
            [self.additionalView addGestureRecognizer:self.tapGestureCloseFullSizeImage];
        }
    }
    if(recognize == self.tapGestureCloseFullSizeImage) {
        NSLog(@"swag");
        [self.additionalView removeFromSuperview];
    }
    }
    
    
   
    



-(void)recognizeThePinch:(UIPinchGestureRecognizer *)recognize {
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)recognize scale];
    
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (factor < 1) {
                self.showPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            }
            if(factor < 0.45) {
                [self.showPhotosView setHidden:YES];
                [self.showPhotosView removeFromSuperview];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if(factor > 0.45) {
                self.showPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
            }
        }
        default:
            break;
    }
    
}
-(void)uploadthisThat: (UIButton *)sender {
    if([self.previewButton isEnabled]){
    
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *userToken = [userDefaultContents objectForKey:@"tokenIDString"];
        NSString *pathString = [NSString stringWithFormat:@"/api/v1/thisthats/?access_token=%@",userToken];
      //  NSURL *baseURL  = [NSURL URLWithString:hostUrl];
       // AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //    NSData *imageOneData = UIImageJPEGRepresentation([self inputImage:self.imageTempOne].image, 0.5);
        NSData *imageOneData = [self compressImage:self.imageTempOne];
        NSData *imageTwoData = [self compressImage:self.imageTempTwo];
        // NSData *imageTwoData = UIImageJPEGRepresentation([self inputImage:self.imageTempTwo].image, 0.5);
        NSLog(@"\nimageOneData:%d\nimageTwoData:%d",imageOneData.length,imageTwoData.length);
       // NSDictionary *parameters = @{@"image_1" : imageOneData, @"image_2" : imageTwoData, @"message" : self.textFieldString};
    //    NSMutableURLRequest *operation = [[RKObjectManager sharedManager] requestWithObject:[objects class] method:RKRequestMethodPOST path:pathString parameters:parameters];
        
        NSDictionary *parameters = @{@"message" : self.textFieldString};
        NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:pathString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }];
      
        RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
           
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"succss");
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error");
        }];
        __block float totalAmount;
        __block float totalWritten;
        
        [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            totalAmount = (float)totalBytesExpectedToWrite;
            totalWritten = (float)totalBytesWritten;
            NSLog(@"\ntotalBytesWritten:%lld\ntotalBytesExpectedToWrite:%lld",totalBytesWritten,totalBytesExpectedToWrite);
             self.update = (float)totalWritten / (float)totalAmount;
            
        }];
        [operation start];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
        self.progressView.progressTintColor = [UIColor blackColor];
        self.progressView.progress = 0;
        [self.progressView targetForAction:@selector(progressView) withSender:self];
        //[self.progressView performSelector:@selector(updateProgress) withObject:nil afterDelay:0.3];
        [self.myTableView addSubview:self.progressView];
      //  [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
   
    }
    
}
-(void)updateProgress {
    self.progressView.progress = self.update;
        
}
//fullSizeImageView
-(UIImageView*)inputImage:(UIImage*)image {
    CGFloat imageOriginalWidth = image.size.width;
    CGFloat imageOriginalHeight = image.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat scaleFactor = imageOriginalWidth/viewWidth;
    CGFloat newImageHeight = imageOriginalHeight/scaleFactor;
    CGFloat yStartingPosition = (viewHeight - newImageHeight)/2;
   // [image drawInRect:CGRectMake(0, yStartingPosition, viewWidth, newImageHeight)];
    
    UIImageView *resizedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, yStartingPosition, viewWidth, newImageHeight)];
    resizedImage.image = image;
    
    return resizedImage;
    
}
-(NSData*)compressImage:(UIImage*)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return imageData;
    //return [UIImage imageWithData:imageData];
}
@end
