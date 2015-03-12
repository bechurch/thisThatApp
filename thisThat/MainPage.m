//
//  MainPage.m
//  thisThat
//
//  Created by James Connerton on 2015-01-21.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "MainPage.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "objects.h"
#import "personalPostsTableViewCell.h"
#import "LoginScreen.h"

@interface MainPage ()

@end

@implementation MainPage {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
 

    [self configureRestKit];
    
    //[self loadPersonalPosts];
    //initalize counter to zero
   
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    if(userDefaultObject != nil){
        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername= %@",currentIDObject,userDefaultObject,usernameObject);
      //  [self loadPersonalPosts];
        NSString *username = [NSString stringWithFormat:@"%@",usernameObject];
        self.navigationItem.title = username;
        
    } else {
       // [self performSegueWithIdentifier:@"showLogin" sender:self];
        LoginScreen *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        [self.parentViewController presentViewController:loginVC animated:YES completion:nil];

        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken =%@",currentIDObject,userDefaultObject);
    }
    [self.navigationController.navigationBar setHidden:NO];
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)settings:(id)sender {
  //  [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
    [self performSegueWithIdentifier:@"settings" sender:self];
}

- (IBAction)upload:(id)sender {

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
       CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    UIColor *redThisThatColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
     UIColor *blueishThisThatColor = [UIColor colorWithRed:(60/255.0) green:(104/255.0) blue:(150/255.0) alpha:1];
    UIColor *greyishThisThatColor = [UIColor colorWithRed:(172/255.0) green:(166/255.0) blue:(158/255.0) alpha:1];
    UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
    [self presentInvisibleView];
    self.addPhotosView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    self.addPhotosView.backgroundColor = [UIColor grayColor];
    [self.navigationController.view addSubview:self.addPhotosView];
    self.pinchToCloseView = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.addPhotosView addGestureRecognizer:self.pinchToCloseView];
    self.exampleTableViewCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, (viewHeight/4)+100)];
    self.exampleTableViewCellView.backgroundColor = [UIColor whiteColor];
    [self.addPhotosView addSubview:self.exampleTableViewCellView];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    self.uploadUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 3*(viewWidth/4)-15, 25)];
    self.uploadUsernameLabel.backgroundColor = [UIColor clearColor];
    [self.uploadUsernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    self.uploadUsernameLabel.textColor = redThisThatColor;
    self.uploadUsernameLabel.text = [NSString stringWithFormat:@"%@",usernameObject];
    [self.exampleTableViewCellView addSubview:self.uploadUsernameLabel];
    
    self.uploadTimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*(viewWidth/4)+5, 10, (viewWidth/4)-15, 30)];
    [self.uploadTimeStampLabel setFont:[UIFont systemFontOfSize:10]];
    self.uploadTimeStampLabel.text = @"Just now";
    self.uploadTimeStampLabel.textAlignment = NSTextAlignmentRight;
    self.uploadTimeStampLabel.backgroundColor = [UIColor clearColor];
    self.uploadTimeStampLabel.textColor = greyishThisThatColor;
    [self.exampleTableViewCellView addSubview:self.uploadTimeStampLabel];
    
    self.buttonImageOne = [[UIButton alloc ] initWithFrame:CGRectMake(10, 100, (viewWidth/2)-15, self.exampleTableViewCellView.frame.size.height-110)];
    self.buttonImageOne.backgroundColor = [UIColor blackColor];
    [self.buttonImageOne setTitle:@"Add photo" forState:UIControlStateNormal];
    [self.buttonImageOne addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.exampleTableViewCellView addSubview:self.buttonImageOne];
    
    self.buttonImageTwo = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2)+5, 100, (viewWidth/2)-15, self.exampleTableViewCellView.frame.size.height-110)];
    self.buttonImageTwo.backgroundColor = [UIColor blackColor];
    [self.buttonImageTwo setTitle:@"Add photo" forState:UIControlStateNormal];
    [self.buttonImageTwo addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.exampleTableViewCellView addSubview:self.buttonImageTwo];
    
    self.textViewInput = [[UITextView alloc] initWithFrame:CGRectMake(10, 55, viewWidth-20, 40)];
    self.textViewInput.backgroundColor = [UIColor clearColor];
    self.textViewInput.delegate = self;
    [self.textViewInput setFont:[UIFont systemFontOfSize:15]];
    self.textViewInput.textColor = [UIColor grayColor];
    self.textViewInput.layer.borderWidth = 1.0;
    self.textViewInput.layer.borderColor = [UIColor blackColor].CGColor;
    self.textViewInput.text = @"What are you comparing?";
    [self.exampleTableViewCellView addSubview:self.textViewInput];
    
    self.uploadPreviewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (viewHeight/4)+145, viewWidth, 40)];
    self.uploadPreviewButton.backgroundColor = blackThisThatColor;
    [self.uploadPreviewButton setTitle:@"PREVIEW POST" forState:UIControlStateNormal];
    [self.uploadPreviewButton addTarget:self action:@selector(previewUploadThisThat:) forControlEvents:UIControlEventTouchUpInside];
    [self.addPhotosView addSubview:self.uploadPreviewButton];
    [self.uploadPreviewButton setHidden:YES];
    

    self.uploadThisThatView = [[UIView alloc] initWithFrame:CGRectMake(10, (viewHeight/4)+205, 70, 70)];
    self.uploadThisThatView.backgroundColor = [UIColor orangeColor];
    
    self.uploadThisThatView.layer.cornerRadius = 35;
    self.uploadThisThatView.clipsToBounds = YES;
    self.uploadThisThatPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePanUploadThisThatView:)];
    [self.uploadThisThatView addGestureRecognizer:self.uploadThisThatPanGestureRecognizer];
    [self.addPhotosView addSubview:self.uploadThisThatView];
    [self.uploadThisThatView setHidden:YES];

    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.uploadThisThatView.frame.size.width/2)-25, (self.uploadThisThatView.frame.size.height/2)-15, 50, 30)];
    [uploadLabel setFont:[UIFont systemFontOfSize:15]];
    uploadLabel.text = @"Upload";
    [self.uploadThisThatView addSubview:uploadLabel];
                                                                     
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, viewWidth-20, 20)];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    [self.addressLabel setFont:[UIFont systemFontOfSize:10]];
    self.addressLabel.textColor = blueishThisThatColor;
    self.addressLabel.text = @"Earth";
    [self.addPhotosView addSubview:self.addressLabel];
    
    self.showLocationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(viewWidth-60, (viewHeight/4)+110, 30, 30)];
    [self.showLocationSwitch addTarget:self action:@selector(onOffSwitch:) forControlEvents:UIControlEventValueChanged];
    self.showLocationSwitch.onTintColor = blueishThisThatColor;
    [self.addPhotosView addSubview:self.showLocationSwitch];
    self.uploadEnableLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (viewHeight/4)+110, viewWidth-80, 30)];
    self.uploadEnableLocationLabel.text = @"Enable current location";
    //self.uploadEnableLocationLabel.backgroundColor = [UIColor yellowColor];
    [self.addPhotosView addSubview:self.uploadEnableLocationLabel];
    
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    geocoder = [[CLGeocoder alloc] init];


}
-(void)recognizePanUploadThisThatView:(UIPanGestureRecognizer*)recognize {


    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognize translationInView:self.addPhotosView];
            recognize.view.center = CGPointMake(recognize.view.center.x+currentPoint.x, recognize.view.center.y);
            [recognize setTranslation:CGPointMake(0, 0) inView:self.addPhotosView];
           CGFloat maxX = CGRectGetMaxX(self.uploadThisThatView.frame);
            CGFloat minX = CGRectGetMinX(self.uploadThisThatView.frame);
            if(maxX >=self.addPhotosView.frame.size.width){
                self.uploadThisThatView.frame = CGRectMake(self.view.frame.size.width - 70, (self.view.frame.size.height/4)+205, 70 , 70);
            }
            if(minX <= 10){
                self.uploadThisThatView.frame = CGRectMake(10, (self.view.frame.size.height/4)+205, 70 , 70);
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGFloat getCurrentMinPanMin = CGRectGetMinX(self.uploadThisThatView.frame);
            if(getCurrentMinPanMin >= (self.view.frame.size.width/2)){
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.uploadThisThatView.frame = CGRectMake(self.view.frame.size.width - 70, (self.view.frame.size.height/4)+205, 70 , 70);
                } completion:^(BOOL finished) {
                        [self uploadThisThat];
                    }];
            }
            else {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.uploadThisThatView.frame = CGRectMake(10, (self.view.frame.size.height/4)+205, 70 , 70);
            } completion:^(BOOL finished) {
                
            }];
        }
        }
        default:
            break;
    }
    
}
-(void)uploadThisThat {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self uploadingNavBarDetail];
    [self.addPhotosView removeFromSuperview];
    [self.invisibleView removeFromSuperview];
   
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userToken = [userDefaultContents objectForKey:@"tokenIDString"];
    self.uploadPathString = [NSString stringWithFormat:@"/api/v1/thisthats/?access_token=%@",userToken];
    self.uploadImageOneData = [self compressImage:self.uploadTempImageOne];
    self.uploadImageTwoData = [self compressImage:self.uploadTempImageTwo];
    if([self.textViewInput.text isEqualToString:@"What are you comparing?"]) {
        self.textViewInput.text = @"";
    }
    self.uploadTextViewParameters = @{@"message" : self.textViewInput.text};
    NSLog(@"\npathToVote:%@",self.uploadPathString);
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:self.uploadPathString parameters:self.uploadTextViewParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:self.uploadImageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:self.uploadImageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self performSelector:@selector(uploadSuccesfulUpdateNavBar) withObject:nil afterDelay:2];
        
        NSLog(@"succss");
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorSaveContentsOfUpload];
        [self performSelector:@selector(uploadErrorUpdateNavBar) withObject:nil afterDelay:2];
        NSLog(@"Error");
    }];
    [operation start];
    
}
-(void)errorSaveContentsOfUpload {
    self.uploadErrorSaveContentsDictionary = [[NSMutableDictionary alloc] init];
    [self.uploadErrorSaveContentsDictionary setObject:self.uploadPathString forKey:@"uploadPathString"];
    [self.uploadErrorSaveContentsDictionary setObject:self.uploadImageOneData forKey:@"imageOneData"];
    [self.uploadErrorSaveContentsDictionary setObject:self.uploadImageTwoData forKey:@"imageTwoData"];
    [self.uploadErrorSaveContentsDictionary setObject:self.uploadTextViewParameters forKey:@"textContentsDict"];
    
    
}
-(void)uploadErrorUpdateNavBar {
    self.uploadingNavBarLabel.text = @"Failed. Please try again.";
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    self.retryUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, [UIApplication sharedApplication].statusBarFrame.size.height+5, 40, 30)];
    self.retryUploadButton.backgroundColor = [UIColor whiteColor];
    [self.retryUploadButton setTitleColor:redColor forState:UIControlStateNormal];
    self.retryUploadButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.retryUploadButton.titleLabel.minimumScaleFactor = 0.6;
    [self.retryUploadButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.retryUploadButton addTarget:self action:@selector(retryUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadingNavBarView addSubview:self.retryUploadButton];
    
    self.deleteFailedUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIApplication sharedApplication].statusBarFrame.size.height+5, 50, 30)];
    self.deleteFailedUploadButton.backgroundColor = [UIColor whiteColor];
    [self.deleteFailedUploadButton setTitleColor:redColor forState:UIControlStateNormal];
    self.deleteFailedUploadButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.deleteFailedUploadButton.titleLabel.minimumScaleFactor = 0.6;
    [self.deleteFailedUploadButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.deleteFailedUploadButton addTarget:self action:@selector(deleteUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadingNavBarView addSubview:self.deleteFailedUploadButton];
    
   // [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:4];
}
-(void)deleteUpload:(UIButton*)button{
    self.uploadingNavBarLabel.text = @"Upload was cancelled";
    [self.retryUploadButton removeFromSuperview];
    [self.deleteFailedUploadButton removeFromSuperview];
    [self.uploadErrorSaveContentsDictionary removeAllObjects];
    [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:3];
    
}
-(void)retryUpload:(UIButton*)button {
    [self.retryUploadButton removeFromSuperview];
    [self.deleteFailedUploadButton removeFromSuperview];
    self.uploadingNavBarLabel.text = @"uploading your thisThat..";
    NSString *pathString =  [self.uploadErrorSaveContentsDictionary objectForKey:@"uploadPathString"];
    NSData *imageOneData = [self.uploadErrorSaveContentsDictionary objectForKey:@"imageOneData"];
    NSData *imageTwoData = [self.uploadErrorSaveContentsDictionary objectForKey:@"imageTwoData"];
    NSDictionary *parameters = [self.uploadErrorSaveContentsDictionary objectForKey:@"textContentsDict"];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:pathString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self performSelector:@selector(uploadSuccesfulUpdateNavBar) withObject:nil afterDelay:2];
        [self.uploadErrorSaveContentsDictionary removeAllObjects];
        NSLog(@"succss");
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
       // [self errorSaveContentsOfUpload];
        [self performSelector:@selector(uploadErrorUpdateNavBar) withObject:nil afterDelay:2];
        NSLog(@"Error");
    }];
    [operation start];
    
}
-(void)uploadSuccesfulUpdateNavBar{
    UIImage *checkimage = [UIImage imageNamed:@"check.png"];
    self.uploadingNavBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, [UIApplication sharedApplication].statusBarFrame.size.height, 45, 45)];
    self.uploadingNavBarImageView.image = checkimage;
    [self.uploadingNavBarView addSubview:self.uploadingNavBarImageView];
    self.uploadingNavBarLabel.text = @"thisThat uploaded successfully";
    [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:4];

}
-(void)removeUploadingNavViewFromSuperView {
    [self.uploadingNavBarView removeFromSuperview];
    
}
-(void)onOffSwitch:(id)recognize {
    if([recognize isOn]){
        NSLog(@"switchON");
        self.addressLabel.text = @"Retrieving location..";
        [locationManager startUpdatingLocation];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else {
        NSLog(@"switchOff");
        self.addressLabel.text = @"Earth";
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error Failed to get location");
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && [placemarks count]>0) {
            placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
        }
    }];
}

-(void)previewUploadThisThat:(UIButton *)recognize {
    
    self.uploadTempImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.uploadTempImageView.backgroundColor = [UIColor whiteColor];
    [self.addPhotosView addSubview:self.uploadTempImageView];
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height/2))];
    imageViewOne.image = [self cropImage:self.uploadTempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.uploadTempImageView.frame.size.height/2)];

    // imageViewOne.image = self.uploadTempImageOne;
   
    // imageViewOne.clipsToBounds = YES;
   // imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    [self.uploadTempImageView addSubview:imageViewOne];
    self.uploadTapFullSizeImageOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToSeeFullSizeImage:)];
    [imageViewOne setUserInteractionEnabled:YES];
    [imageViewOne addGestureRecognizer:self.uploadTapFullSizeImageOne];
    UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/2), self.view.frame.size.width, self.view.frame.size.height/2)];
    imageViewTwo.image = [self cropImage:self.uploadTempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.uploadTempImageView.frame.size.height/2)];
   // imageViewTwo.image = self.uploadTempImageTwo;
    //imageViewTwo.clipsToBounds = YES;
    //imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
    [self.uploadTempImageView addSubview:imageViewTwo];
    self.uploadTapFullSizeImageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToSeeFullSizeImage:)];
    [imageViewTwo setUserInteractionEnabled:YES];
    [imageViewTwo addGestureRecognizer:self.uploadTapFullSizeImageTwo];
    
    
    
    self.pinchToCloseUploadPreview = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.uploadTempImageView addGestureRecognizer:self.pinchToCloseUploadPreview];
    
    
}
-(void)uploadTapToSeeFullSizeImage:(UITapGestureRecognizer*)recognize {
    self.uploadViewForFullSizeImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.uploadViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.uploadTempImageView addSubview:self.uploadViewForFullSizeImageView];
    self.uploadFullSizeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    if(recognize == self.uploadTapFullSizeImageOne){
        self.uploadFullSizeImageView = [self inputImage:self.uploadTempImageOne];
    }
    if(recognize == self.uploadTapFullSizeImageTwo){
        self.uploadFullSizeImageView = [self inputImage:self.uploadTempImageTwo];
    }
    [self.uploadViewForFullSizeImageView addSubview:self.uploadFullSizeImageView];
    self.uploadCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToCloseFullSizeImageView:)];
    [self.uploadFullSizeImageView setUserInteractionEnabled:YES];
    [self.uploadFullSizeImageView addGestureRecognizer:self.uploadCloseFullSizeImageView];
    
    
}
-(void)uploadTapToCloseFullSizeImageView:(UITapGestureRecognizer*)recognize{
    [self.uploadViewForFullSizeImageView removeFromSuperview];
}
- (IBAction)personalPosts:(id)sender {
   // [self initalizeTableView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self loadPersonalPosts];
    }
-(void)initalizeTableView{
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    CGRect tableViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    [self presentInvisibleView];
    self.personalPostsTableView = [[UITableView alloc] initWithFrame:CGRectMake(widthFrame/2, heightFrame/2, 0, 0) style:UITableViewStylePlain];

        self.personalPostsTableView.frame = tableViewSize;
   
    self.pinchRecognizerPersonalPosts = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.personalPostsTableView addGestureRecognizer:self.pinchRecognizerPersonalPosts];
    
    self.personalPostsTableView.delegate = self;
    self.personalPostsTableView.dataSource = self;
    self.personalPostsTableView.backgroundColor = [UIColor whiteColor];
    //self.personalPostsTableView.rowHeight = (heightFrame/4)+100;
    self.personalPostsTableView.rowHeight = (widthFrame/2)+130;
    
    self.personalPostsTableView.userInteractionEnabled = YES;
    self.personalPostsTableView.bounces = YES;
    
    [self.personalPostsTableView registerClass:[personalPostsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.navigationController.view addSubview:self.personalPostsTableView];
    [self.personalPostsTableView setSeparatorColor:[UIColor darkGrayColor]];
    
}
-(void)initalizePostsVotedOnTableView{
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    CGRect tableViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    [self presentInvisibleView];
    self.postsVotedOnTableView = [[UITableView alloc] initWithFrame:CGRectMake(widthFrame/2, heightFrame/2, 0, 0) style:UITableViewStylePlain];

        self.postsVotedOnTableView.frame = tableViewSize;
    
    self.pinchRecognizerPostsVotedOn = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.postsVotedOnTableView addGestureRecognizer:self.pinchRecognizerPostsVotedOn];
    self.postsVotedOnTableView.delegate = self;
    self.postsVotedOnTableView.dataSource = self;
    self.postsVotedOnTableView.backgroundColor = [UIColor whiteColor];
    self.postsVotedOnTableView.rowHeight = (widthFrame/2)+130;
    
    self.postsVotedOnTableView.userInteractionEnabled = YES;
    self.postsVotedOnTableView.bounces = YES;
    
    [self.postsVotedOnTableView registerClass:[personalPostsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.navigationController.view addSubview:self.postsVotedOnTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.personalPostsTableView){
          if([self.personalPostsArray count] >=1) {
            return 1;
        }
        else {
            UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            messageLabel.text = @"You have not yet posted any thisThats";
            messageLabel.backgroundColor = blackThisThatColor;
            messageLabel.textColor = [UIColor whiteColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            //messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20];
            [messageLabel sizeToFit];
            self.personalPostsTableView.backgroundView = messageLabel;
            self.personalPostsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        }
    
    }
    if(tableView == self.postsVotedOnTableView) {
        if([self.postsVotedOnArray count]>= 1){
            return 1;
        }
        else {
            UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            messageLabel.text = @"You have not yet voted on any thisThat posts";
            messageLabel.backgroundColor = blackThisThatColor;
            messageLabel.textColor = [UIColor whiteColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            //messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20];
            [messageLabel sizeToFit];
            self.postsVotedOnTableView.backgroundView = messageLabel;
            self.postsVotedOnTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.personalPostsTableView){
    return [self.personalPostsArray count];
    }
    else {
        return [self.postsVotedOnArray count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    
    personalPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if(cell == nil) {
        NSLog(@"log");
        cell = [[personalPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(tableView == self.personalPostsTableView){
    objects *personalPost = [self.personalPostsArray objectAtIndex:indexPath.row];

        cell.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (cell.contentView.frame.size.width/2)-15, (cell.contentView.frame.size.width/2)-15)];

    cell.imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewOne.clipsToBounds = YES;
    cell.imageViewOne.backgroundColor = [UIColor blackColor];
    cell.spinnerImageViewOne = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    cell.spinnerImageViewOne.center = CGPointMake(cell.imageViewOne.frame.size.width/2, cell.imageViewOne.frame.size.height/2);
    [cell.spinnerImageViewOne startAnimating];
    [cell.imageViewOne addSubview:cell.spinnerImageViewOne];
 
    
    NSMutableString *imageUrlOne = [NSMutableString string];
    [imageUrlOne appendString:hostUrl];
    [imageUrlOne appendString:personalPost.imageOne];
    NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOne]];
    __weak typeof(cell) weakCell = cell;
    [cell.imageViewOne setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.tempImageOne = image;
        
        weakCell.imageViewOne.image = image;
        
        
        [weakCell.spinnerImageViewOne stopAnimating];
        [weakCell.spinnerImageViewOne removeFromSuperview];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    [cell.imageViewOne setUserInteractionEnabled:YES];
   
    
  
     cell.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, cell.contentView.frame.size.height-(cell.contentView.frame.size.width/2)+5, (cell.contentView.frame.size.width/2)-15, (cell.contentView.frame.size.width/2)-15)];
        cell.imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewTwo.clipsToBounds = YES;
    cell.imageViewTwo.backgroundColor = [UIColor blackColor];
    cell.spinnerImageViewTwo = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    cell.spinnerImageViewTwo.center = CGPointMake(cell.imageViewTwo.frame.size.width/2, cell.imageViewTwo.frame.size.height/2);
    [cell.spinnerImageViewTwo startAnimating];
    [cell.imageViewTwo addSubview:cell.spinnerImageViewTwo];
    
    NSMutableString *imageUrlTwo = [NSMutableString string];
    [imageUrlTwo appendString:hostUrl];
    [imageUrlTwo appendString:personalPost.imageTwo];
    NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlTwo]];
 

    [cell.imageViewTwo setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageViewTwo.image = image;
        weakCell.tempImageTwo = image;
        [weakCell.spinnerImageViewTwo stopAnimating];
        [weakCell.spinnerImageViewTwo removeFromSuperview];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    cell.backgroundColor = [UIColor whiteColor];

        cell.username = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 10, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.username.textAlignment = NSTextAlignmentCenter;
        cell.username.backgroundColor = [UIColor clearColor];
    cell.username.textColor = [UIColor darkGrayColor];
    cell.username.font = [UIFont boldSystemFontOfSize:20];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
        
        cell.username.adjustsFontSizeToFitWidth = YES;
        cell.username.minimumScaleFactor = 0.5;
        
        cell.username.text = [NSString stringWithFormat:@"%@",usernameObject];
        cell.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 40)];
        cell.locationLabel.textAlignment = NSTextAlignmentCenter;
        cell.locationLabel.backgroundColor = [UIColor clearColor];
        cell.locationLabel.textColor = [UIColor lightGrayColor];
        cell.locationLabel.font = [UIFont systemFontOfSize:15];
        cell.locationLabel.numberOfLines = 0;
        cell.locationLabel.text = @"Victoria BC";
        cell.locationLabel.adjustsFontSizeToFitWidth = YES;
        cell.locationLabel.minimumScaleFactor = 0.5;
        

        cell.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 100, (cell.contentView.frame.size.width/4)-15, 30)];
        cell.timeStamp.backgroundColor = [UIColor clearColor];
    cell.timeStamp.textColor = [UIColor lightGrayColor];
    cell.timeStamp.font = [UIFont systemFontOfSize:15];
    cell.timeStamp.textAlignment = NSTextAlignmentLeft;
    cell.timeStamp.text = [self inputDate:personalPost.createdAt];

        cell.textContent = [[UILabel alloc] initWithFrame:CGRectMake(10, (cell.contentView.frame.size.width/2)+5, (cell.contentView.frame.size.width/2)-15, cell.contentView.frame.size.height-15-(cell.contentView.frame.size.width/2))];
    cell.textContent.backgroundColor = [UIColor clearColor];
        cell.textContent.numberOfLines = 0;
    cell.textContent.textColor = [UIColor darkGrayColor];
        cell.textContent.adjustsFontSizeToFitWidth = YES;
        cell.textContent.minimumScaleFactor = 0.8;
    cell.textContent.font = [UIFont systemFontOfSize:20];
        cell.textContent.textAlignment = NSTextAlignmentCenter;
    cell.textContent.text = personalPost.textContent;
 // cell.textContent.text = @"testing number of characters we can use yooooo son whats up with you? Manchester United of Course will get";
        cell.totalVotesLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*(cell.contentView.frame.size.width/4)-15, 100, (cell.contentView.frame.size.width/4)+5, 30)];
        cell.totalVotesLabel.backgroundColor = [UIColor clearColor];
        cell.totalVotesLabel.textColor = [UIColor lightGrayColor];
        [cell.totalVotesLabel setFont:[UIFont systemFontOfSize:15]];
        cell.totalVotesLabel.textAlignment = NSTextAlignmentRight;
        cell.totalVotesLabel.text = [self ForTotalVotesVoteCountOne:personalPost.voteCountOne ForTotalVotesVoteCountTwo:personalPost.voteCountTwo];
        
    cell.votePercentageOneLabel = [[UILabel alloc] initWithFrame:cell.imageViewOne.frame];
    cell.votePercentageOneLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
       cell.votePercentageOneLabel.textColor = [UIColor whiteColor];
    cell.votePercentageOneLabel.font = [UIFont boldSystemFontOfSize:40];
    cell.votePercentageOneLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableArray *voteCountArray = [self voteCountOne:personalPost.voteCountOne voteCountTwo:personalPost.voteCountTwo];
        cell.votePercentageOneLabel.text = [voteCountArray objectAtIndex:0];
        cell.votePercentageTwoLabel = [[UILabel alloc] initWithFrame:cell.imageViewTwo.frame];
    cell.votePercentageTwoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        cell.votePercentageTwoLabel.textColor = [UIColor whiteColor];
    cell.votePercentageTwoLabel.font = [UIFont boldSystemFontOfSize:40];
    cell.votePercentageTwoLabel.textAlignment = NSTextAlignmentCenter;
    cell.votePercentageTwoLabel.text = [voteCountArray objectAtIndex:1];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:cell.imageViewOne];
    [cell.contentView addSubview:cell.imageViewTwo];
    [cell.contentView addSubview:cell.username];
    [cell.contentView addSubview:cell.timeStamp];
    [cell.contentView addSubview:cell.textContent];
    [cell.contentView addSubview:cell.votePercentageOneLabel];
    [cell.contentView addSubview:cell.votePercentageTwoLabel];
        [cell.contentView addSubview:cell.totalVotesLabel];
        [cell.contentView addSubview:cell.locationLabel];
    
    return cell;
    }
    else {
        objects *personalPost = [self.postsVotedOnArray objectAtIndex:indexPath.row];
            cell.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (cell.contentView.frame.size.width/2)-15, (cell.contentView.frame.size.width/2)-15)];
        
        cell.imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageViewOne.clipsToBounds = YES;
        cell.imageViewOne.backgroundColor = [UIColor blackColor];
        cell.spinnerImageViewOne = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        cell.spinnerImageViewOne.center = CGPointMake(cell.imageViewOne.frame.size.width/2, cell.imageViewOne.frame.size.height/2);
        [cell.spinnerImageViewOne startAnimating];
        [cell.imageViewOne addSubview:cell.spinnerImageViewOne];
        
        
        NSMutableString *imageUrlOne = [NSMutableString string];
        [imageUrlOne appendString:hostUrl];
        [imageUrlOne appendString:personalPost.imageOne];
        NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOne]];
        __weak typeof(cell) weakCell = cell;
        [cell.imageViewOne setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakCell.tempImageOne = image;
            
            weakCell.imageViewOne.image = image;
            
            
            [weakCell.spinnerImageViewOne stopAnimating];
            [weakCell.spinnerImageViewOne removeFromSuperview];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        [cell.imageViewOne setUserInteractionEnabled:YES];
        
        
        
        cell.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, cell.contentView.frame.size.height-(cell.contentView.frame.size.width/2)+5, (cell.contentView.frame.size.width/2)-15, (cell.contentView.frame.size.width/2)-15)];
        cell.imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageViewTwo.clipsToBounds = YES;
        cell.imageViewTwo.backgroundColor = [UIColor blackColor];
        cell.spinnerImageViewTwo = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        cell.spinnerImageViewTwo.center = CGPointMake(cell.imageViewTwo.frame.size.width/2, cell.imageViewTwo.frame.size.height/2);
        [cell.spinnerImageViewTwo startAnimating];
        [cell.imageViewTwo addSubview:cell.spinnerImageViewTwo];
        
        NSMutableString *imageUrlTwo = [NSMutableString string];
        [imageUrlTwo appendString:hostUrl];
        [imageUrlTwo appendString:personalPost.imageTwo];
        NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlTwo]];
        
        
        [cell.imageViewTwo setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakCell.imageViewTwo.image = image;
            weakCell.tempImageTwo = image;
            [weakCell.spinnerImageViewTwo stopAnimating];
            [weakCell.spinnerImageViewTwo removeFromSuperview];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.username = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 10, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.username.textAlignment = NSTextAlignmentCenter;
        cell.username.backgroundColor = [UIColor clearColor];
        cell.username.textColor = [UIColor darkGrayColor];
        cell.username.font = [UIFont boldSystemFontOfSize:20];
 
        cell.username.adjustsFontSizeToFitWidth = YES;
        cell.username.minimumScaleFactor = 0.5;
        
        cell.username.text = personalPost.username;
        cell.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 40)];
        cell.locationLabel.textAlignment = NSTextAlignmentCenter;
        cell.locationLabel.backgroundColor = [UIColor clearColor];
        cell.locationLabel.textColor = [UIColor lightGrayColor];
        cell.locationLabel.font = [UIFont systemFontOfSize:15];
        cell.locationLabel.numberOfLines = 0;
        cell.locationLabel.text = @"Victoria BC";
        cell.locationLabel.adjustsFontSizeToFitWidth = YES;
        cell.locationLabel.minimumScaleFactor = 0.5;
        
        
        cell.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 100, (cell.contentView.frame.size.width/4)-15, 30)];
        cell.timeStamp.backgroundColor = [UIColor clearColor];
        cell.timeStamp.textColor = [UIColor lightGrayColor];
        cell.timeStamp.font = [UIFont systemFontOfSize:15];
        cell.timeStamp.textAlignment = NSTextAlignmentLeft;
        cell.timeStamp.text = [self inputDate:personalPost.createdAt];
        
        cell.textContent = [[UILabel alloc] initWithFrame:CGRectMake(10, (cell.contentView.frame.size.width/2)+5, (cell.contentView.frame.size.width/2)-15, cell.contentView.frame.size.height-15-(cell.contentView.frame.size.width/2))];
        cell.textContent.backgroundColor = [UIColor clearColor];
        cell.textContent.numberOfLines = 0;
        cell.textContent.textColor = [UIColor darkGrayColor];
        cell.textContent.adjustsFontSizeToFitWidth = YES;
        cell.textContent.minimumScaleFactor = 0.8;
        cell.textContent.font = [UIFont systemFontOfSize:20];
        cell.textContent.textAlignment = NSTextAlignmentCenter;
        cell.textContent.text = personalPost.textContent;
    
        cell.totalVotesLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*(cell.contentView.frame.size.width/4)-15, 100, (cell.contentView.frame.size.width/4)+5, 30)];
        cell.totalVotesLabel.backgroundColor = [UIColor clearColor];
        cell.totalVotesLabel.textColor = [UIColor lightGrayColor];
        [cell.totalVotesLabel setFont:[UIFont systemFontOfSize:15]];
        cell.totalVotesLabel.textAlignment = NSTextAlignmentRight;
        cell.totalVotesLabel.text = [self ForTotalVotesVoteCountOne:personalPost.voteCountOne ForTotalVotesVoteCountTwo:personalPost.voteCountTwo];
        
        cell.votePercentageOneLabel = [[UILabel alloc] initWithFrame:cell.imageViewOne.frame];
        cell.votePercentageOneLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        cell.votePercentageOneLabel.textColor = [UIColor whiteColor];
        cell.votePercentageOneLabel.font = [UIFont boldSystemFontOfSize:40];
        cell.votePercentageOneLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableArray *voteCountArray = [self voteCountOne:personalPost.voteCountOne voteCountTwo:personalPost.voteCountTwo];
        cell.votePercentageOneLabel.text = [voteCountArray objectAtIndex:0];
        cell.votePercentageTwoLabel = [[UILabel alloc] initWithFrame:cell.imageViewTwo.frame];
        cell.votePercentageTwoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        cell.votePercentageTwoLabel.textColor = [UIColor whiteColor];
        cell.votePercentageTwoLabel.font = [UIFont boldSystemFontOfSize:40];
        cell.votePercentageTwoLabel.textAlignment = NSTextAlignmentCenter;
        cell.votePercentageTwoLabel.text = [voteCountArray objectAtIndex:1];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        //
        UIImage *checkMarkImage = [UIImage imageNamed:@"check.png"];
        NSInteger imageVotedFor = [personalPost.vote integerValue];
        if(imageVotedFor == 1) {
            cell.checkMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 30, 30)];
            [cell.checkMarkImageView setAlpha:1];
            cell.checkMarkImageView.layer.cornerRadius = 15;
            cell.checkMarkImageView.clipsToBounds = YES;
            cell.checkMarkImageView.image = checkMarkImage;
            [cell.votePercentageOneLabel addSubview:cell.checkMarkImageView];
        }
        
        if(imageVotedFor == 2) {
            cell.checkMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
            cell.checkMarkImageView.layer.cornerRadius = 15;
            cell.checkMarkImageView.clipsToBounds = YES;
            cell.checkMarkImageView.image = checkMarkImage;
            [cell.votePercentageTwoLabel addSubview:cell.checkMarkImageView];           
        }
      
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:cell.imageViewOne];
        [cell.contentView addSubview:cell.imageViewTwo];
        [cell.contentView addSubview:cell.username];
        [cell.contentView addSubview:cell.timeStamp];
        [cell.contentView addSubview:cell.textContent];
        [cell.contentView addSubview:cell.locationLabel];
        [cell.contentView addSubview:cell.votePercentageOneLabel];
        [cell.contentView addSubview:cell.votePercentageTwoLabel];
        [cell.contentView addSubview:cell.totalVotesLabel];
        return  cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView == self.personalPostsTableView){
        
        self.personalPostsIndexPath = indexPath;
    self.personalPostsTableView.scrollEnabled= NO;
    CGFloat minHeight = CGRectGetMinY(self.personalPostsTableView.bounds);
        self.invisibleViewTableView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
        [self.personalPostsTableView addSubview:self.invisibleViewTableView];
    self.personalPostsBothImagesBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
    
    self.personalPostsBothImagesBackGroundView.backgroundColor = [UIColor blackColor];
    [self.personalPostsTableView addSubview:self.personalPostsBothImagesBackGroundView];
    self.pinchRecognizerPersonalPostsPreviewImages = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.personalPostsBothImagesBackGroundView addGestureRecognizer:self.pinchRecognizerPersonalPostsPreviewImages];
   
    
    self.personalPostsImageOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageOne.image = [self cropImage:cell.tempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageOne.userInteractionEnabled = YES;
       [self.personalPostsBothImagesBackGroundView addSubview:self.personalPostsImageOne];
    self.personalPostsImageTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.personalPostsTableView.frame.size.height/2, self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
    self.personalPostsImageTwo.image = [self cropImage:cell.tempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageTwo.userInteractionEnabled = YES;
    [self.personalPostsBothImagesBackGroundView addSubview:self.personalPostsImageTwo];
        
        self.personalPostsTapImageOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
        [self.personalPostsImageOne addGestureRecognizer:self.personalPostsTapImageOne];
        
        self.personalPostsTapImageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
        [self.personalPostsImageTwo addGestureRecognizer:self.personalPostsTapImageTwo];
        
        
    [self.personalPostsTableView deselectRowAtIndexPath:[self.personalPostsTableView indexPathForSelectedRow] animated:YES];
    }
    if(tableView == self.postsVotedOnTableView){
        self.postsVotedOnInexPath = indexPath;
         objects *personalPost = [self.postsVotedOnArray objectAtIndex:indexPath.row];
        self.postsVotedOnTableView.scrollEnabled = NO;
        CGFloat minHeight = CGRectGetMinY(self.postsVotedOnTableView.bounds);
        self.invisibleViewTableView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
        [self.postsVotedOnTableView addSubview:self.invisibleViewTableView];
        self.postsVotedOnBothPhotosView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
        //self.postsVotedOnBothPhotosView.backgroundColor = [UIColor blueColor];
        [self.postsVotedOnTableView addSubview:self.postsVotedOnBothPhotosView];
        self.pinchRecognizerPostsVotedOnPreviewView = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
        [self.postsVotedOnBothPhotosView addGestureRecognizer:self.pinchRecognizerPostsVotedOnPreviewView];
        
        self.postsVotedOnImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        self.postsVotedOnImageViewOne.image = [self cropImage:cell.tempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        [self.postsVotedOnBothPhotosView addSubview:self.postsVotedOnImageViewOne];
        self.postsVotedOnImageViewOne.userInteractionEnabled = YES;
        self.postsVotedOnImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.postsVotedOnTableView.frame.size.height/2, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        self.postsVotedOnImageViewTwo.image = [self cropImage:cell.tempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        [self.postsVotedOnBothPhotosView addSubview:self.postsVotedOnImageViewTwo];
        self.postsVotedOnImageViewTwo.userInteractionEnabled = YES;
        [self.postsVotedOnTableView deselectRowAtIndexPath:[self.postsVotedOnTableView indexPathForSelectedRow] animated:YES];
        self.postsVotedOnTapImageOneFullSize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnTapRecognizer:)];
        [self.postsVotedOnImageViewOne addGestureRecognizer:self.postsVotedOnTapImageOneFullSize];
        self.postsVotedOnTapImageTwoFullSize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnTapRecognizer:)];
        [self.postsVotedOnImageViewTwo addGestureRecognizer:self.postsVotedOnTapImageTwoFullSize];
        NSInteger imageVotedFor = [personalPost.vote integerValue];
        UIImage *greenCheckImage = [UIImage imageNamed:@"check.png"];
        UIImageView *greenCheckImageView = [[UIImageView alloc] init];
        greenCheckImageView.image = greenCheckImage;
        if(imageVotedFor == 1){
            greenCheckImageView.frame = CGRectMake(10, 10, 50, 50);
            [self.postsVotedOnImageViewOne addSubview:greenCheckImageView];
        }
        if(imageVotedFor == 2){
            greenCheckImageView.frame = CGRectMake(10, 10, 50, 50);
            [self.postsVotedOnImageViewTwo addSubview:greenCheckImageView];
            
        }
    }

}
-(void)personalPostsTapRecognizer:(UITapGestureRecognizer*)recognize {
    personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[self.personalPostsTableView cellForRowAtIndexPath:self.personalPostsIndexPath];
    self.personalPostsViewForFullSizeImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
    self.personalPostsViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.personalPostsBothImagesBackGroundView addSubview:self.personalPostsViewForFullSizeImageView];
    if(recognize == self.personalPostsTapImageOne){
    
        self.personalPostsFullSizeImageView = [self inputImage:cell.tempImageOne];
        [self.personalPostsViewForFullSizeImageView addSubview:self.personalPostsFullSizeImageView];
    }
    if(recognize == self.personalPostsTapImageTwo){
        self.personalPostsFullSizeImageView = [self inputImage:cell.tempImageTwo];
        [self.personalPostsViewForFullSizeImageView addSubview:self.personalPostsFullSizeImageView];
    }
    self.personalPostsFullSizeImageView.userInteractionEnabled = YES;
    self.personalPostsTapToCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsCloseFullSizeImage:)];
    [self.personalPostsFullSizeImageView addGestureRecognizer:self.personalPostsTapToCloseFullSizeImageView];
    
}
-(void)personalPostsCloseFullSizeImage:(UITapGestureRecognizer*)recognize {
    NSLog(@"logging");
    [self.personalPostsViewForFullSizeImageView removeFromSuperview];

}
-(void)postsVotedOnTapRecognizer:(UITapGestureRecognizer*)recognize {
    personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[self.postsVotedOnTableView cellForRowAtIndexPath:self.postsVotedOnInexPath];
    
    self.postsVotedOnFullSizeViewForImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
    self.postsVotedOnFullSizeViewForImageView.backgroundColor = [UIColor blackColor];
    [self.postsVotedOnBothPhotosView addSubview:self.postsVotedOnFullSizeViewForImageView];
    if(recognize == self.postsVotedOnTapImageOneFullSize){
        self.postsVotedOnFullSizeImageView = [self inputImage:cell.tempImageOne];
        [self.postsVotedOnFullSizeViewForImageView addSubview:self.postsVotedOnFullSizeImageView];
        
    }
    if(recognize == self.postsVotedOnTapImageTwoFullSize){
        self.postsVotedOnFullSizeImageView = [self inputImage:cell.tempImageTwo];
        [self.postsVotedOnFullSizeViewForImageView addSubview:self.postsVotedOnFullSizeImageView];
    }
    self.postsVotedOnFullSizeImageView.userInteractionEnabled = YES;
    self.postsVotedOnTapCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnCloseFullSizeImage:)];
    [self.postsVotedOnFullSizeImageView addGestureRecognizer:self.postsVotedOnTapCloseFullSizeImageView];
}
-(void)postsVotedOnCloseFullSizeImage:(UITapGestureRecognizer*)recognize {
    [self.postsVotedOnFullSizeViewForImageView removeFromSuperview];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.personalPostsTableView){
        return YES;
    }
    else {
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.personalPostsTableView){
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        objects *personalPost = [self.personalPostsArray objectAtIndex:indexPath.row];
        [self.personalPostsArray removeObjectAtIndex:indexPath.row];
        [self.personalPostsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        NSLog(@"\npostID:%@",personalPost.postId);
        [self.personalPostsTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *currentIDTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
        NSLog(@"\nDeleteWithString: /api/v1/thisthats/%@?access_token=%@",personalPost.postId,currentIDTokenObject);
      
        NSString *deletePostPath = [NSString stringWithFormat:@"/api/v1/thisthats/%@?access_token=%@",personalPost.postId,currentIDTokenObject];
        
        [[RKObjectManager sharedManager] deleteObject:nil path:deletePostPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"deletedPost:%@ successfully",personalPost.postId);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"fail");
        }];

        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([self.textViewInput.text isEqualToString:@"What are you comparing?"]) {
        self.textViewInput.text = @"";
    }
   
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if([self.textViewInput.text isEqualToString:@""]){
        self.textViewInput.text = @"What are you comparing?";
    } else {
        self.uploadTextViewString = self.textViewInput.text;
        NSLog(@"textViewSting:%@",self.uploadTextViewString);
        
    }
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound) {
        NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        return !([newString length] >100);
    }
    [textView resignFirstResponder];
    return NO;
}


-(void)takePhotoButtonPressed:(UIButton*)button {
    
    
    if(button == self.buttonImageOne){
        self.selectedCameraInt = 1;
        NSLog(@"buttonOnePressed");
    }
    if(button == self.buttonImageTwo){
        self.selectedCameraInt = 2;
        NSLog(@"buttonTwoPressed");
    }
    self.imagePicker =[[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    type = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.sourceType = type;
    self.imagePicker.delegate = self;
    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    self.viewLibraryPhotosButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75,5, 150, 30)];
    [self.viewLibraryPhotosButton setTitle:@"Photo Library" forState:UIControlStateNormal];
    [self.viewLibraryPhotosButton addTarget:self action:@selector(photoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.imagePicker.toolbarHidden = YES;
    [self.imagePicker.view addSubview:self.viewLibraryPhotosButton];
    [self presentViewController:self.imagePicker animated:YES completion:nil];

    
        
    
   
}

-(void)photoLibrary:(UIButton*)recognize {
   // [self.viewLibraryPhotosButton setHidden:YES];
    UIImagePickerControllerSourceType type;
    type = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.sourceType = type;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.viewLibraryPhotosButton setHidden:YES];
    if(self.selectedCameraInt == 1) {
        NSLog(@"YOLOONE");
        self.uploadTempImageOne = [[UIImage alloc] init];
        self.uploadTempImageOne = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[self.buttonImageOne imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [self.buttonImageOne setImage:self.uploadTempImageOne forState:UIControlStateNormal];
        [self.buttonImageOne setTitle:@"" forState:UIControlStateNormal];
    }
    if(self.selectedCameraInt == 2){
        NSLog(@"YOLOTWO");
        self.uploadTempImageTwo = [[UIImage alloc] init];
        self.uploadTempImageTwo = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[self.buttonImageTwo imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [self.buttonImageTwo setImage:self.uploadTempImageTwo forState:UIControlStateNormal];
        [self.buttonImageTwo setTitle:@"" forState:UIControlStateNormal];
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.uploadTempImageOne != nil && self.uploadTempImageTwo != nil) {
        [self.uploadPreviewButton setHidden:NO];
       // [self.uploadthisThatButton setHidden:NO];
        [self.uploadThisThatView setHidden:NO];
    }
    
}

- (IBAction)newsFeed:(id)sender {
    [self presentLoadingView];
    [self loadNewsFeedArray];

}
-(void)menuButtonSelected:(UIButton*)recognize{
        [self.panRecognizerImageOne setEnabled:NO];
        [self.panRecognizerImageTwo setEnabled:NO];
        [self.tapToOpenImageOne setEnabled:NO];
        [self.tapToOpenImageTwo setEnabled:NO];
        [self.yellowMenuButotn setAlpha:0];
        [self.viewForLabels setAlpha:1];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.imageViewOneCurrent.frame =CGRectMake(0, -115, [self viewWidth], [self viewHeight]/2);
        self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2)+115, [self viewWidth], [self viewHeight]/2);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *closeMenu = [[UITapGestureRecognizer alloc] init];
        [closeMenu addTarget:self action:@selector(closeMenuSelector:)];
        [self.newsFeedView addGestureRecognizer:closeMenu];
    
    }];
    
}
-(void)closeMenuSelector:(UITapGestureRecognizer*)recognize{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageViewOneCurrent.frame =CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
        self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
        
    } completion:^(BOOL finished) {
        [self.yellowMenuButotn setAlpha:1.0];
        [self.newsFeedView removeGestureRecognizer:recognize];
        [self.panRecognizerImageOne setEnabled:YES];
        [self.panRecognizerImageTwo setEnabled:YES];
        [self.tapToOpenImageOne setEnabled:YES];
        [self.tapToOpenImageTwo setEnabled:YES];
        [self.viewForLabels setAlpha:0];
    }];
    
}
-(void)recognizeTapToOpenImages:(UITapGestureRecognizer*)recognize {
    
    self.viewForFullSizeImageView = [[UIView alloc] initWithFrame:self.view.frame];
    self.viewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.newsFeedView addSubview:self.viewForFullSizeImageView];
    self.fullSizeImageView = [[UIImageView alloc] init];
    if(recognize == self.tapToOpenImageOne){
    self.fullSizeImageView = [self inputImage:self.tempImageOneCurrent];
    [self.viewForFullSizeImageView addSubview:self.fullSizeImageView];
    }
    if(recognize == self.tapToOpenImageTwo){
        self.fullSizeImageView = [self inputImage:self.tempImageTwoCurrent];
        [self.viewForFullSizeImageView addSubview:self.fullSizeImageView];
    }
    self.tapToCloesImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullSizeView:)];
    [self.viewForFullSizeImageView addGestureRecognizer:self.tapToCloesImage];
}
-(void)closeFullSizeView:(UITapGestureRecognizer *)recognize {
    [self.viewForFullSizeImageView removeFromSuperview];
}


// ****************************************************************************************************
// Pinch Recognizer

-(void)recognizePinchToCloseCurrentView:(UIPinchGestureRecognizer *)recognize {
    
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)recognize scale];
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
           
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (factor < 1) {
                if(recognize == self.pinchRecognizerNewsFeed){
                self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            }
                if(recognize == self.pinchToCloseView){
                    self.addPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchToCloseUploadPreview){
                    self.uploadTempImageView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchRecognizerPersonalPostsPreviewImages) {
                    self.personalPostsBothImagesBackGroundView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchRecognizerPersonalPosts) {
                    self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);

                }
                if(recognize == self.pinchRecognizerPostsVotedOn) {
                    self.postsVotedOnTableView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                    
                }
                if(recognize == self.pinchRecognizerPostsVotedOnPreviewView){
                    self.postsVotedOnBothPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchToCloseLoadingView){
                    self.loadingView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
            }
            if(factor < 0.45) {
                if(recognize == self.pinchRecognizerNewsFeed){
                   [self.newsFeedView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

                }
                if(recognize == self.pinchToCloseView){
                    [self.addPhotosView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

                }
                if(recognize == self.pinchToCloseUploadPreview){
                    [self.uploadTempImageView removeFromSuperview];
                    

                }
                if(recognize == self.pinchRecognizerPersonalPostsPreviewImages){
                    [self.personalPostsBothImagesBackGroundView removeFromSuperview];
                    [self.invisibleViewTableView removeFromSuperview];
                    self.personalPostsTableView.scrollEnabled = YES;
                }
                if(recognize == self.pinchRecognizerPersonalPosts){
                    [self.personalPostsTableView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

                }
                if(recognize == self.pinchRecognizerPostsVotedOn){
                    [self.postsVotedOnTableView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    
                }
                if(recognize == self.pinchRecognizerPostsVotedOnPreviewView){
                    [self.postsVotedOnBothPhotosView removeFromSuperview];
                    [self.invisibleViewTableView removeFromSuperview];
                    self.postsVotedOnTableView.scrollEnabled = YES;
                }
                if(recognize == self.pinchToCloseLoadingView){
                    [self.loadingView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    
                }
                            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if(factor > 0.45) {
                if(recognize == self.pinchRecognizerNewsFeed){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchToCloseView){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.addPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }
                if(recognize == self.pinchToCloseUploadPreview){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.uploadTempImageView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchRecognizerPersonalPostsPreviewImages){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.personalPostsBothImagesBackGroundView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                    
                    }];
                }
                if(recognize == self.pinchRecognizerPersonalPosts){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchRecognizerPostsVotedOn){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.postsVotedOnTableView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchRecognizerPostsVotedOnPreviewView){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.postsVotedOnBothPhotosView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchToCloseLoadingView){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.loadingView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }
        }
        default:
            break;
    
}
    }
-(void)returnStatusbarToNormal {
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
}
-(void)recognizeThePinchPersonalPosts:(UIPinchGestureRecognizer *)recognize{
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)recognize scale];
    
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (factor < 1) {
                self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            }
            if(factor < 0.45) {
                [self.personalPostsButton setEnabled:YES];
                [self.personalPostsTableView removeFromSuperview];
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if(factor > 0.45) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                } completion:^(BOOL finished) {
                    
                }];
                
            }
        }
        default:
            break;
    }

    
}

// ****************************************************************************************************
// Pan Recognizer Image Current

-(void)recognizeThePanImageCurrent:(UIPanGestureRecognizer *)recognize {
    CGFloat widthFrame = CGRectGetWidth(self.newsFeedView.frame);
    CGFloat heightFrame = CGRectGetHeight(self.newsFeedView.frame);

   // CGFloat imageViewOneCurrentMaxX = CGRectGetMaxX(self.imageViewOneCurrent.frame);
    CGFloat imageViewOneCurrentMinX = CGRectGetMinX(self.imageViewOneCurrent.frame);
    CGFloat imageViewTwoCurrentMinX = CGRectGetMinX(self.imageViewTwoCurrent.frame);
    CGFloat viewControllerMaxX = CGRectGetMaxX(self.view.frame);
    CGFloat viewControllerMinX = CGRectGetMinX(self.view.frame);
 
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            [self.yellowMenuButotn setAlpha:0];
            if(recognize == self.panRecognizerImageOne){
            [self.panRecognizerImageTwo setEnabled:NO];
                [self.tapToOpenImageTwo setEnabled:NO];
            }
            if(recognize == self.panRecognizerImageTwo){
                [self.panRecognizerImageOne setEnabled:NO];
                [self.tapToOpenImageOne setEnabled:NO];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint currentPoint = [recognize translationInView:self.newsFeedView];
            if(recognize == self.panRecognizerImageOne){
            recognize.view.center = CGPointMake(recognize.view.center.x + currentPoint.x, recognize.view.center.y);
            [recognize setTranslation:CGPointMake(0, 0) inView:self.newsFeedView];
            self.imageViewTwoCurrent.center = CGPointMake(-recognize.view.center.x + currentPoint.x + widthFrame, recognize.view.center.y + heightFrame/2);
                if(imageViewOneCurrentMinX > viewControllerMinX){//vote for image 1
                    
                    CGFloat minXView = CGRectGetMinX(self.imageViewOneCurrent.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    [self.voteForThisImageView setAlpha:alphaValue2];
                    [self.notThatImageView setAlpha:alphaValue2];
               /*     self.viewNewsFeedImageOneOverlay.backgroundColor = [self greenThisThatColor];
                   [self.viewNewsFeedImageOneOverlay setAlpha:alphaValue];
                    self.viewNewsFeedImageTwoOverlay.backgroundColor = [self redThisThatColor];
                    [self.viewNewsFeedImageTwoOverlay setAlpha:alphaValue];*/
                    
                   
                    [self.newsFeedImageOneCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                }
             /*   if(imageViewOneCurrentMinX == viewControllerMinX){
                  
                }*/
                if(imageViewTwoCurrentMinX > viewControllerMinX){//vote for image 2
                   
                    CGFloat minXView = CGRectGetMinX(self.imageViewTwoCurrent.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    
                    [self.notThisImageView setAlpha:alphaValue2];
                    [self.voteForThatImageView setAlpha:alphaValue2];
                  //  self.viewNewsFeedImageOneOverlay.backgroundColor = [self redThisThatColor];
                   // [self.viewNewsFeedImageOneOverlay setAlpha:alphaValue];
                    [self.newsFeedImageOneXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                }
        }
            if(recognize == self.panRecognizerImageTwo){
                recognize.view.center = CGPointMake(recognize.view.center.x + currentPoint.x, recognize.view.center.y);
                [recognize setTranslation:CGPointZero inView:self.newsFeedView];
                self.imageViewOneCurrent.center = CGPointMake(-recognize.view.center.x + currentPoint.x + widthFrame, recognize.view.center.y - heightFrame/2);
                if(imageViewOneCurrentMinX > viewControllerMinX){// vote for image 1
                    CGFloat minXView = CGRectGetMinX(self.imageViewOneCurrent.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    
                    
                    [self.voteForThisImageView setAlpha:alphaValue2];
                    [self.notThatImageView setAlpha:alphaValue2];
                    [self.newsFeedImageOneCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    
                                   }
                if(imageViewTwoCurrentMinX > viewControllerMinX){// vote for image 2
                    CGFloat minXView = CGRectGetMinX(self.imageViewTwoCurrent.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    [self.notThisImageView setAlpha:alphaValue2];
                    [self.voteForThatImageView setAlpha:alphaValue2];
                    
                    [self.newsFeedImageOneXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                                    }

            }
        }
            
        default:
            break;
        case UIGestureRecognizerStateEnded:{
            [self.panRecognizerImageOne setEnabled:YES];
            [self.panRecognizerImageTwo setEnabled:YES];
            [self.tapToOpenImageOne setEnabled:YES];
            [self.tapToOpenImageTwo setEnabled:YES];
            // VOTE FOR IMAGE ONE
            if(imageViewOneCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 1;
                [self voteForImage];
                [self.voteForThisImageView setAlpha:1];
                [self.notThatImageView setAlpha:1];
                    CGFloat velocityX = fabsf([recognize velocityInView:self.imageViewOneCurrent].x);
                NSLog(@"\nvelcotity:%f",velocityX);
                    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
                    CGFloat distanceToOffScreen = fabsf(viewWidth - imageViewOneCurrentMinX);
                    NSTimeInterval timeRemainingToOffScreen = distanceToOffScreen/velocityX;
                
                if(timeRemainingToOffScreen > 0.5) {
                    timeRemainingToOffScreen = 0.5;
                }
      
                
                [UIView animateWithDuration:timeRemainingToOffScreen delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(widthFrame, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(-widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                    
                } completion:^(BOOL finished) {
                    //[self loadImagesAfterSwipe];
                    [self imagesAreDonePreLoading];
                    self.imageViewOneCurrent.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [self.voteForThisImageView setAlpha:0];
                        [self.notThatImageView setAlpha:0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.imageViewOneCurrent.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                            self.imageViewTwoCurrent.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                            
                        } completion:^(BOOL finished) {
                            [self.yellowMenuButotn setAlpha:1.0];
                            
                        }];

                        
                    }];
                    
                    }];
                
                
            }
            //VOTE FOR IMAGE TWO
            if(imageViewTwoCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 2;
                [self voteForImage];
                [self.notThisImageView setAlpha:1];
                [self.voteForThatImageView setAlpha:1];
                CGFloat velocityX = fabsf([recognize velocityInView:self.imageViewTwoCurrent].x);
                NSLog(@"\nvelcotity:%f",velocityX);
                CGFloat viewWidth = CGRectGetWidth(self.view.frame);
                CGFloat distanceToOffScreen = fabsf(viewWidth - imageViewTwoCurrentMinX);
                NSTimeInterval timeRemainingToOffScreen = distanceToOffScreen/velocityX;
                
                if(timeRemainingToOffScreen > 0.5) {
                    timeRemainingToOffScreen = 0.5;
                }
                
                [UIView animateWithDuration:timeRemainingToOffScreen delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(-widthFrame, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                } completion:^(BOOL finished) {
                    //[self loadImagesAfterSwipe];
                    [self imagesAreDonePreLoading];
                    self.imageViewOneCurrent.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [self.notThisImageView setAlpha:0];
                        [self.voteForThatImageView setAlpha:0];
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.imageViewOneCurrent.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                            self.imageViewTwoCurrent.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                        } completion:^(BOOL finished) {
                            [self.yellowMenuButotn setAlpha:1.0];
                            
                        }];
                    }];
                    
                    
                    
                }];
               
            }
            if(imageViewOneCurrentMinX < 5*(viewControllerMaxX/10) && imageViewTwoCurrentMinX < 5*(viewControllerMaxX/10)){
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(0, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame/2, widthFrame, heightFrame/2);
         
                    [self.voteForThisImageView setAlpha:0];
                    [self.notThatImageView setAlpha:0];
                    [self.notThisImageView setAlpha:0];
                    [self.voteForThatImageView setAlpha:0];
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                } completion:^(BOOL finished) {

                    [self.yellowMenuButotn setAlpha:1.0];
                }];
            }

        }
    }
    
}

-(CGFloat)minXImageView:(CGFloat)minXPosition viewWdith:(CGFloat)viewWdith {
    CGFloat percentCovered = minXPosition/viewWdith;
    if(percentCovered> 0.27) {
        return 1.0;
    }
    if(percentCovered >0.24){
        return 0.9;
    }
    if(percentCovered>0.21){
        return 0.8;
    }
    if(percentCovered> 0.18) {
        return 0.7;
    }
    if(percentCovered >0.15){
        return 0.6;
    }
    if(percentCovered>0.12){
        return 0.5;
    }if(percentCovered> 0.09) {
        return .40;
    }
    if(percentCovered >0.06){
        return 0.3;
    }
    if(percentCovered>0.03){
        return 0.2;
    }
    else {
     return 0.0;
    }
    
    
    
}
-(CGFloat)newMinXImageView:(CGFloat)minXPosition newViewWdith:(CGFloat)viewWdith {
    CGFloat percentCovered = minXPosition/viewWdith;
    if(percentCovered > 0.67) {
        return 1.0;
    }
    if(percentCovered> 0.64) {
        return 0.9;
    }
    if(percentCovered >0.61){
        return 0.8;
    }
    if(percentCovered>0.58){
        return 0.7;
    }
    if(percentCovered> 0.55) {
        return 0.6;
    }
    if(percentCovered >0.52){
        return 0.5;
    }
    if(percentCovered>0.49){
        return 0.4;
    }if(percentCovered> 0.46) {
        return .3;
    }
    if(percentCovered >0.43){
        return 0.2;
    }
    if(percentCovered>0.4){
        return 0.1;
    }
    else {
        return 0.0;
    }
    
    
    
}


-(void)recognizeTheLongPress:(UILongPressGestureRecognizer *)recognize {
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.imageViewOneCurrent.frame =CGRectMake(0, -115, [self viewWidth], [self viewHeight]/2);
               self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2)+115, [self viewWidth], [self viewHeight]/2);
               

            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.imageViewOneCurrent.frame =CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
                self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
                
            } completion:^(BOOL finished) {
                
            }];
          
        }
        default:
            break;
    }
}


// ****************************************************************************************************
// Vote For Image

-(void)voteForImage{
    objects *voting = [self.newsFeedArray objectAtIndex:self.newsFeedCounter];
    NSString *postID = [NSString stringWithFormat:@"%@",voting.postId];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userToken = [userDefaultContents objectForKey:@"tokenIDString"];
    NSLog(@"voteCounter:%d",self.voteCounter);
    if(self.voteCounter == 1){
              NSString *pathVoteImageOne = [NSString stringWithFormat:@"/api/v1/thisthats/%@/1/vote?access_token=%@",postID,userToken];
        [[RKObjectManager sharedManager] postObject:nil path:pathVoteImageOne parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"voteForImageOneSuccess");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"voteForImageOneFail");
            NSLog(@"\noperation:%@",operation);
        }];
        NSLog(@"\nVoteUsing:%@",pathVoteImageOne);
    }
    if(self.voteCounter == 2){
        NSString *pathVoteImageTwo = [NSString stringWithFormat:@"/api/v1/thisthats/%@/2/vote?access_token=%@",postID,userToken];
        NSLog(@"\nvoteUsing:%@",pathVoteImageTwo);
        [[RKObjectManager sharedManager] postObject:nil path:pathVoteImageTwo parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"voteForImageTwoSuccess");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"voteForImageTwoFail");
        }];
    }
    self.newsFeedCounter++;
}


// ****************************************************************************************************
// Configure Restkit

-(void)configureRestKit {
    
    NSURL *baseURL  = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [objectManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];

    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[objects class]];
    [objectMapping addAttributeMappingsFromDictionary:@{@"userId": @"userId",
                                                        @"image_1": @"imageOne",
                                                        @"image_2": @"imageTwo",
                                                        @"message": @"textContent",
                                                        @"createdAt": @"createdAt",
                                                        @"username": @"username",
                                                        @"id":@"postId",
                                                        @"vote_count_1" :@"voteCountOne",
                                                        @"vote_count_2": @"voteCountTwo",
                                                        @"vote":@"vote"}];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"ThisThats" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSObject class]];
    RKResponseDescriptor * responseDescriptorTwo = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping
                                                                                                method:RKRequestMethodPOST
                                                                                           pathPattern:nil keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTwo];
 /// RKRequestDescriptor
  /*  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[emptyMapping inverseMapping] objectClass:[objects class] rootKeyPath:nil method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    */
    
}

// ****************************************************************************************************
// Load News Feed

-(void)loadNewsFeedArray{
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/?access_token=%@",userDefaultObject];
//    NSString *fullURL = [NSString stringWithFormat:@"http://local-app.co:1337%@",tokenIDString];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.newsFeedArray = [mappingResult.array mutableCopy];
        
        NSLog(@"mappingResultCount:%d",[mappingResult count]);
        NSLog(@"success");
        NSLog(@"newsFeedArrayContents:\n%@",self.newsFeedArray);
        if([self.newsFeedArray count] >0){
            [self initalizeNewsFeedView];
        [self preLoadImages];
        }
        if([self.newsFeedArray count] == 0) {
            NSLog(@"noContentsToVoteON");
            [self initalizedNewsFeedViewNoPostsToVoteOn];
            
        }
    }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // figureOut how to map error to invalidToken
            NSLog(@"ERROR");
            NSString *recoverySuggestion = [error localizedRecoverySuggestion];
            NSString *description = [error localizedDescription];
            if([recoverySuggestion isEqualToString:@"Unauthorized"]){
                NSLog(@"performLogout");
                [self invaidTokenPresentLoginScreen];
            }
            if([description isEqualToString:@"The Internet connection appears to be offline."] || [description isEqualToString:@"A server with the specified hostname could not be found."]){
                NSLog(@"internetOffLine");
                [self internetOffline];
                
            }
        }];
    
}
// ****************************************************************************************************
// Load Personal Posts

-(void)loadPersonalPosts {
    [self presentLoadingView];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/my/?access_token=%@",userDefaultObject];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.personalPostsArray = [mappingResult.array mutableCopy];
        [UIView animateWithDuration:0 delay:2.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.loadingView removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
            [self initalizeTableView];
        }];
        
        
        NSLog(@"\npersonalPostsArrayContents:\n%@",self.personalPostsArray);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        NSLog(@"description:%@",[error localizedDescription]);
        NSString *recoverySuggestion = [error localizedRecoverySuggestion];
        NSString *description = [error localizedDescription];
        if([recoverySuggestion isEqualToString:@"Unauthorized"]){
            NSLog(@"performLogout");
            [self invaidTokenPresentLoginScreen];
        }
        if([description isEqualToString:@"The Internet connection appears to be offline."] || [description isEqualToString:@"A server with the specified hostname could not be found."]){
            NSLog(@"internetOffLine");
            [self internetOffline];
            
        }
  
    }];
    
}

// ****************************************************************************************************
// Load Personal Posts

-(void)loadPostsVotedOn {
    [self presentLoadingView];
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/my/votes?access_token=%@",userDefaultObject];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.postsVotedOnArray = [mappingResult.array mutableCopy];
        [UIView animateWithDuration:0 delay:2.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.loadingView removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
        }];
        [self initalizePostsVotedOnTableView];
    
        NSLog(@"\npostsVotedOnArrayContents:\n%@",self.postsVotedOnArray);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString *recoverySuggestion = [error localizedRecoverySuggestion];
        NSString *description = [error localizedDescription];
        if([recoverySuggestion isEqualToString:@"Unauthorized"]){
            NSLog(@"performLogout");
            [self invaidTokenPresentLoginScreen];
        }
        if([description isEqualToString:@"The Internet connection appears to be offline."] || [description isEqualToString:@"A server with the specified hostname could not be found."]){
            NSLog(@"internetOffLine");
            [self internetOffline];
            
        }
    }];
  
    
}
// ****************************************************************************************************
// Return View Height and Width

-(float)viewWidth {
    return CGRectGetWidth(self.view.frame);
}
-(float)viewHeight {
    return CGRectGetHeight(self.view.frame);
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
// ****************************************************************************************************
// Format timeStamp

-(NSString *)inputDate:(NSDate *)timeStamp {
    NSDate *currentDate = [NSDate date];
    double timeSinceToday =[timeStamp timeIntervalSinceDate:currentDate];
    timeSinceToday = timeSinceToday*-1;
    NSString *postingTime = [[NSString alloc] init];
    if(timeSinceToday < 60) {
        postingTime = @"just now";
    }
    if(timeSinceToday > 60 && timeSinceToday < 3600) {
        timeSinceToday = timeSinceToday/60;
        postingTime = [NSString stringWithFormat:@"%dm ago",(int)roundf(timeSinceToday)];
    }
    if(timeSinceToday > 3600 && timeSinceToday < 84600) {
        timeSinceToday = timeSinceToday/60/60;
        postingTime = [NSString stringWithFormat:@"%dh ago",(int)roundf(timeSinceToday)];
    }
    if(timeSinceToday > 84600 && timeSinceToday < 604800){
        timeSinceToday = timeSinceToday/3600/24;
        postingTime = [NSString stringWithFormat:@"%dd ago",(int)roundf(timeSinceToday)];
    }
    if(timeSinceToday > 604800 && timeSinceToday < 31449600) {
        timeSinceToday = timeSinceToday/3600/24/7;
        postingTime = [NSString stringWithFormat:@"%dw ago",(int)roundf(timeSinceToday)];
    }
    if(timeSinceToday > 31449600){
        timeSinceToday = timeSinceToday/3600/24/7/52;
        postingTime = [NSString stringWithFormat:@"%dy ago",(int)roundf(timeSinceToday)];
    }
    return postingTime;
}

-(UIImageView*)inputImage:(UIImage*)image {
    CGFloat imageOriginalWidth = image.size.width;
    CGFloat imageOriginalHeight = image.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat scaleFactor = imageOriginalWidth/viewWidth;
    NSLog(@"scalefactor:%f",scaleFactor);
    CGFloat newImageHeight = imageOriginalHeight/scaleFactor;
    CGFloat yStartingPosition = (viewHeight - newImageHeight)/2;
    
  
    UIImageView *resizedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, yStartingPosition, viewWidth, newImageHeight)];
//    UIImageView *resizedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, newImageHeight)];

    resizedImage.image = image;
    
    return resizedImage;
    
}
-(CGRect)inputImageForResizeFrame:(UIImage*)image {
    CGFloat imageOriginalWidth = image.size.width;
    CGFloat imageOriginalHeight = image.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat scaleFactor = imageOriginalWidth/viewWidth;
    NSLog(@"scalefactor:%f",scaleFactor);
    CGFloat newImageHeight = imageOriginalHeight/scaleFactor;
    CGFloat yStartingPosition = (viewHeight - newImageHeight)/2;
    CGRect newRect = CGRectMake(0, yStartingPosition, viewWidth, newImageHeight);
    return newRect;
    
}

-(NSMutableArray*)voteCountOne:(NSNumber*)voteCountOne voteCountTwo:(NSNumber*)voteCountTwo{
    float voteCountOneFloat = [voteCountOne floatValue];
    float votecountTwoFloat = [voteCountTwo floatValue];
    float totalVotecountFloat = voteCountOneFloat + votecountTwoFloat;
    NSString *voteCountOneString = [[NSString alloc]init];
    NSString *voteCountTwoString = [[NSString alloc] init];

    if(voteCountOneFloat == 0 && votecountTwoFloat == 0) {
        voteCountOneString = [NSString stringWithFormat:@"0%%"];
        voteCountTwoString = [NSString stringWithFormat:@"0%%"];

    }
    else {
        float voteCountOnePercentage = (voteCountOneFloat/totalVotecountFloat)*100;
        int voteCountOnePercentageINT = (int)roundf(voteCountOnePercentage);
        int voteCounteTwoPercentageINT = 100-voteCountOnePercentageINT;
        voteCountOneString = [NSString stringWithFormat:@"%d%%",voteCountOnePercentageINT];
        voteCountTwoString = [NSString stringWithFormat:@"%d%%",voteCounteTwoPercentageINT];
    }
 
    NSMutableArray *voteCountArray  = [[NSMutableArray alloc] initWithObjects:voteCountOneString,voteCountTwoString, nil];
    return voteCountArray;
    
}
-(BOOL)prefersStatusBarHidden {
    return NO;
}
//BLUR
- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@5 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, self.view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, self.view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
/*
-(void)downloadImageWithURL:(NSURL*)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
}*/
-(void)preLoadImages {
   
    self.newsFeedMutableDictionary = [[NSMutableDictionary alloc] init];
    self.newsFeedImageOneDictionary = [[NSMutableDictionary alloc] init];
    self.newsFeedImageTwoDictionary = [[NSMutableDictionary alloc] init];
/*    self.newsFeedImagesMutableArray = [[NSMutableArray alloc] initWithCapacity:[self.newsFeedArray count]];
    for(int i =0;i<[self.newsFeedArray count];i++){
      [self.newsFeedImagesMutableArray insertObject:[NSNull null]atIndex:i];
        
    }
    */
    if([self.newsFeedArray count] > 0){
    dispatch_group_t group = dispatch_group_create();
 
   // SDWebImageManager *manager = [SDWebImageManager sharedManager];
  //  manager.imageDownloader.maxConcurrentDownloads = 1;
    

    for(int i = 0; i < [self.newsFeedArray count]; i++) {
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        __weak typeof(imageViewOne) weakImageViewOne = imageViewOne;
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        __weak typeof (imageViewTwo) weakImageViewTwo = imageViewTwo;

        objects *current = [self.newsFeedArray objectAtIndex:i];
        NSMutableString *imageUrlOneCurrent = [NSMutableString string];
        [imageUrlOneCurrent appendString:hostUrl];
        [imageUrlOneCurrent appendString:current.imageOne];
        dispatch_group_enter(group);
        NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOneCurrent]];
        [imageViewOne setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakImageViewOne.image = image;
            NSString *imageOneIndex = [NSString stringWithFormat:@"imageOneIndex:%d",i];
            [self.newsFeedImageOneDictionary setObject:image forKey:imageOneIndex];
            
            NSMutableString *imageURLTwoCurrent = [NSMutableString string];
            [imageURLTwoCurrent appendString:hostUrl];
            [imageURLTwoCurrent appendString:current.imageTwo];
            NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLTwoCurrent]];
            [imageViewTwo setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakImageViewTwo.image = image;
                
                NSString *imageTwoIndex = [NSString stringWithFormat:@"imageTwoIndex:%d",i];
                [self.newsFeedImageTwoDictionary setObject:image forKey:imageTwoIndex];

                dispatch_group_leave(group);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            dispatch_group_leave(group);
          

        }];
    }
    NSLog(@"mutableDictionaryContents:%@",self.newsFeedMutableDictionary);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.loadingView removeFromSuperview];
        NSLog(@"complete");
    //    NSLog(@"contentsofArray:%@",self.newsFeedImagesMutableArray);
        NSLog(@"\nimageOneDict:%@\nimageTwoDict:%@",self.newsFeedImageOneDictionary,self.newsFeedImageTwoDictionary);
        NSLog(@"contentsofdictatindex:%@",[self.newsFeedMutableDictionary objectForKey:@"imageOneIndex:0"]);
        [self imagesAreDonePreLoading];

    });
    }
    else {
        NSLog(@"no contents to load");
    }

}
-(void)imagesAreDonePreLoading{
    
    if(self.newsFeedCounter < [self.newsFeedImageOneDictionary count]) {
        objects *newsFeedObject = [self.newsFeedArray objectAtIndex:self.newsFeedCounter];
        NSString *imageOneKey = [NSString stringWithFormat:@"imageOneIndex:%d",self.newsFeedCounter];
        NSString *imageTwoKey = [NSString stringWithFormat:@"imageTwoIndex:%d",self.newsFeedCounter];
        UIImage *imageOne = [[UIImage alloc] init];
        imageOne = [self.newsFeedImageOneDictionary objectForKey:imageOneKey];
        UIImage *imageTwo = [[UIImage alloc] init];
        imageTwo = [self.newsFeedImageTwoDictionary objectForKey:imageTwoKey];
        self.tempImageOneCurrent = imageOne;
        self.tempImageTwoCurrent = imageTwo;
        CGFloat imageWidth = imageOne.size.width;
        imageWidth = 2*imageWidth;
        CGFloat imageHeight = imageOne.size.height;
        imageHeight = 2*imageHeight;
        imageOne = [UIImage imageWithCGImage:imageOne.CGImage scale:2 orientation:imageOne.imageOrientation];
        

        
        self.imageViewOneCurrent.image = [self cropImage:imageOne cropSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2)];
        self.imageViewTwoCurrent.image = [self cropImage:imageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2)];
        self.usernameLabel.text = newsFeedObject.username;
        self.textContentLabel.text = newsFeedObject.textContent;
        self.timeStampLabel.text = [self inputDate:newsFeedObject.createdAt];
         NSMutableArray *voteCountArray = [self voteCountOne:newsFeedObject.voteCountOne voteCountTwo:newsFeedObject.voteCountTwo];
        self.imageOnePercentage.text = [voteCountArray objectAtIndex:0];
        self.imageTwoPercentage.text = [voteCountArray objectAtIndex:1];
        self.totalNumberOfVotes.text = [self ForTotalVotesVoteCountOne:newsFeedObject.voteCountOne ForTotalVotesVoteCountTwo:newsFeedObject.voteCountTwo];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.imageViewOneCurrent.frame = CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
            self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
            
        } completion:^(BOOL finished) {
            [self.yellowMenuButotn setAlpha:1];
            
        }];

    }
    else {
        //add new request to find posts when finished voting on first 20
        NSLog(@"noContentsToLoad");
       // UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
       // [self.imageViewOneCurrent removeFromSuperview];
       // [self.imageViewTwoCurrent removeFromSuperview];
       // [self.viewForLabels removeFromSuperview];
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
        //newSHIT to retrieve mroe
        [self.newsFeedImageOneDictionary removeAllObjects];
        [self.newsFeedImageTwoDictionary removeAllObjects];
        [self.newsFeedArray removeAllObjects];
        self.newsFeedCounter = 0;
        [self presentLoadingView];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
        NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/?access_token=%@",userDefaultObject];
        
        [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            self.newsFeedArray = [mappingResult.array mutableCopy];
            NSLog(@"mappingResultCount:%d",[mappingResult count]);
            NSLog(@"success");
            NSLog(@"newsFeedArrayContents:\n%@",self.newsFeedArray);
            NSLog(@"newsfeedArrayCount:%d",[self.newsFeedArray count]);
            if([self.newsFeedArray count]>0){
            [self preLoadImages];
            }
            if([self.newsFeedArray count] == 0){
                NSLog(@"noMOrePosts");
                [self.imageViewOneCurrent removeFromSuperview];
                [self.imageViewTwoCurrent removeFromSuperview];
                [self.viewForLabels removeFromSuperview];
                [self.loadingView removeFromSuperview];
                UILabel *noMorePostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                noMorePostsLabel.numberOfLines = 0;
                noMorePostsLabel.backgroundColor  = [UIColor whiteColor];
                noMorePostsLabel.textAlignment = NSTextAlignmentCenter;
                noMorePostsLabel.text = @"There are no more thisThat posts for you to vote on.";
                [self.newsFeedView addSubview:noMorePostsLabel];
            }
        }
            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      // figureOut how to map error to invalidToken
            NSLog(@"ERROR");
            NSString *recoverySuggestion = [error localizedRecoverySuggestion];
            NSString *description = [error localizedDescription];
            if([recoverySuggestion isEqualToString:@"Unauthorized"]){
            NSLog(@"performLogout");
                [self invaidTokenPresentLoginScreen];
            }
            if([description isEqualToString:@"The Internet connection appears to be offline."] || [description isEqualToString:@"A server with the specified hostname could not be found."]){
                NSLog(@"internetOffLine");
                [self internetOffline];
                                                          
                }
                }];

        
       
    }
}

-(NSString*)ForTotalVotesVoteCountOne:(NSNumber*)voteCountOne ForTotalVotesVoteCountTwo:(NSNumber*)voteCountTwo{
    NSInteger voteCountOneINT = [voteCountOne integerValue];
    NSInteger voteCountTwoINT = [voteCountTwo integerValue];
    NSInteger totalVoteCount = voteCountOneINT + voteCountTwoINT;
    NSString *totalVoteCountSTRING = [NSString stringWithFormat:@"%ld votes",(long)totalVoteCount];
    return totalVoteCountSTRING;
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

}


- (UIImage *) cropImage:(UIImage *)originalImage cropSize:(CGSize)cropSize
{
    
  //  NSLog(@"original image orientation:%d",originalImage.imageOrientation);
    NSLog(@"\noriginalImageSize(w,h):(%f,%f)",originalImage.size.width,originalImage.size.height);
    NSLog(@"\ncropSizze(w,h):(%f,%f)",cropSize.width,cropSize.height);
    //calculate scale factor to go between cropframe and original image
    float SF = originalImage.size.width / cropSize.width;
    NSLog(@"scaelFactor:%f",SF);
    //find the centre x,y coordinates of image
   // float centreX = originalImage.size.width / 2;
   // float centreY = originalImage.size.height / 2;
    
    //calculate crop parameters
  //  float cropX = centreX - ((cropSize.width / 2) * SF);
  //  float cropY = centreY - ((cropSize.height / 2) * SF);
    
     CGRect cropRect = CGRectMake(0, 0, (cropSize.width *SF), (cropSize.height *SF));
    //CGRect cropRect = CGRectMake(cropX, cropY, (cropSize.width *SF), (cropSize.height * SF));
    
    CGAffineTransform rectTransform;
    switch (originalImage.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -originalImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -originalImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -originalImage.size.width, -originalImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, originalImage.scale, originalImage.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectApplyAffineTransform(cropRect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:originalImage.scale orientation:originalImage.imageOrientation];
    CGImageRelease(imageRef);
    //return result;
    
    //Now want to scale down cropped image!
    //want to multiply frames by 2 to get retina resolution
    CGRect scaledImgRect = CGRectMake(0, 0, (cropSize.width*2), (cropSize.height*2));
    
    UIGraphicsBeginImageContextWithOptions(scaledImgRect.size, NO, [UIScreen mainScreen].scale);
    //scaleRect
    [result drawInRect:scaledImgRect];
    //scaleRect
    UIImage *scaledNewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledNewImage;
    
}



- (IBAction)postsVotedOn:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self loadPostsVotedOn];
    
    
    
}
-(void)presentLoadingView {
    UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:0.7];
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.loadingView.backgroundColor = [UIColor clearColor];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGFloat spinnerHeight = CGRectGetHeight(self.spinner.frame);
    CGFloat totalViewHeight = spinnerHeight + 120;
    UIView *loadingViewForLabels = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-(totalViewHeight/2), 200, totalViewHeight)];
    loadingViewForLabels.backgroundColor = redColor;
    loadingViewForLabels.layer.cornerRadius = 10;
    loadingViewForLabels.clipsToBounds = YES;
    [self.loadingView addSubview:loadingViewForLabels];
    self.spinner.center = CGPointMake(loadingViewForLabels.frame.size.width/2, 10+(spinnerHeight/2));
    [loadingViewForLabels addSubview:self.spinner];
    [self.spinner startAnimating];
    UILabel *loadingPostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,15+spinnerHeight , 190, loadingViewForLabels.frame.size.height - spinnerHeight - 20)];
    loadingPostsLabel.backgroundColor = [UIColor clearColor];
    loadingPostsLabel.textColor = [UIColor whiteColor];
    loadingPostsLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:25];
    loadingPostsLabel.textAlignment = NSTextAlignmentCenter;
    loadingPostsLabel.adjustsFontSizeToFitWidth = YES;
    loadingPostsLabel.minimumScaleFactor = 0.6;
    loadingPostsLabel.numberOfLines = 0;
    loadingPostsLabel.text = @"Loading thisThat's..";
    [loadingViewForLabels addSubview:loadingPostsLabel];
 
    self.pinchToCloseLoadingView = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.loadingView addGestureRecognizer:self.pinchToCloseLoadingView];
    [self.navigationController.view addSubview:self.loadingView];
}
-(void)initalizedNewsFeedViewNoPostsToVoteOn {
    [self presentInvisibleView];
    [self.loadingView removeFromSuperview];
    self.newsFeedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.newsFeedView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.newsFeedView];
    self.pinchRecognizerNewsFeed = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.newsFeedView addGestureRecognizer:self.pinchRecognizerNewsFeed];
    UILabel *noMorePostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    noMorePostsLabel.numberOfLines = 0;
    noMorePostsLabel.textAlignment = NSTextAlignmentCenter;
    noMorePostsLabel.text = @"There are no more thisThat posts for you to vote on.";
    [self.newsFeedView addSubview:noMorePostsLabel];
    
}
-(void)initalizeNewsFeedView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentInvisibleView];
    self.newsFeedCounter = 0;
    UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    NSLog(@"widthFrame:%f",widthFrame);
    CGRect personalPostsViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    self.newsFeedView = [[UIView alloc] initWithFrame:personalPostsViewSize];
    self.newsFeedView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.newsFeedView];
    self.pinchRecognizerNewsFeed = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.newsFeedView addGestureRecognizer:self.pinchRecognizerNewsFeed];


    //LABELS
    UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
    self.viewForLabels = [[UIView alloc] initWithFrame:CGRectMake(0, ([self viewHeight]/2)-115, [self viewWidth], 230)];
    self.viewForLabels.backgroundColor = blackThisThatColor;
    self.viewForLabels.layer.borderWidth = 5;
    self.viewForLabels.layer.borderColor = [UIColor grayColor].CGColor;
    [self.newsFeedView addSubview:self.viewForLabels];
    
    
    
    self.textContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, [self viewWidth]-20, 120)];
    self.textContentLabel.backgroundColor = [UIColor clearColor];
    // [self.textContentLabel setFont:[UIFont systemFontOfSize:30]];
    
    self.textContentLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:30];
    self.textContentLabel.numberOfLines = 0;
    self.textContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.textContentLabel setTextColor:redColor];
    [self.viewForLabels addSubview:self.textContentLabel];
    
    
    //    [messageLabel sizeToFit];
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (3*[self viewWidth]/4)-10, 30)];
    self.usernameLabel.backgroundColor = [UIColor clearColor];
    [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.usernameLabel setTextColor:redColor];
    [self.usernameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.viewForLabels addSubview:self.usernameLabel];
    
    
    self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*([self viewWidth]/4), 10, ([self viewWidth]/4)-10, 30)];
    self.timeStampLabel.backgroundColor = [UIColor clearColor];
    [self.timeStampLabel setFont:[UIFont systemFontOfSize:15]];
    [self.timeStampLabel setTextColor:[UIColor whiteColor]];
    [self.timeStampLabel setTextAlignment:NSTextAlignmentRight];
    [self.viewForLabels addSubview:self.timeStampLabel];
    
    self.locationWhereThisThatPosted = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, [self viewWidth]-20, 20)];
    self.locationWhereThisThatPosted.backgroundColor = [UIColor clearColor];
    [self.locationWhereThisThatPosted setFont:[UIFont systemFontOfSize:15]];
    [self.locationWhereThisThatPosted setTextAlignment:NSTextAlignmentLeft];
    self.locationWhereThisThatPosted.text = @"Victoria BC, Canada";
    self.locationWhereThisThatPosted.textColor = [UIColor grayColor];
    [self.viewForLabels addSubview:self.locationWhereThisThatPosted];
    
    self.totalNumberOfVotes = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, [self viewWidth]-20, 30)];
    self.totalNumberOfVotes.backgroundColor = [UIColor clearColor];
    self.totalNumberOfVotes.textColor = [UIColor whiteColor];
    [self.totalNumberOfVotes setFont:[UIFont systemFontOfSize:15]];
    [self.viewForLabels addSubview:self.totalNumberOfVotes];
    [self.viewForLabels setAlpha:0];
    //PercentageLabels

   // self.viewNewsFeedImageOneOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthFrame, heightFrame/2)];
   // self.viewNewsFeedImageOneOverlay.backgroundColor = [self greenThisThatColor];
    //[self.viewNewsFeedImageOneOverlay setAlpha:0];
   // [self.newsFeedView addSubview:self.viewNewsFeedImageOneOverlay];
    UIImage *voteForThisImageAI = [UIImage imageNamed:@"voteThisAI.png"];
    self.voteForThisImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.voteForThisImageView.image = voteForThisImageAI;
    self.voteForThisImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.voteForThisImageView setAlpha:0];
    [self.newsFeedView addSubview:self.voteForThisImageView];
    UIImage *notThis = [UIImage imageNamed:@"notThisAI.png"];
    self.notThisImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.notThisImageView.image = notThis;
    self.notThisImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.notThisImageView setAlpha:0];
    [self.newsFeedView addSubview:self.notThisImageView];
    
    
    
    CGRect imageViewOneCurrentRect = CGRectMake(0, -(heightFrame/2), widthFrame, (heightFrame/2));
    self.imageViewOneCurrent = [[UIImageView alloc] initWithFrame:imageViewOneCurrentRect];
    [self.imageViewOneCurrent setUserInteractionEnabled:YES];
    //   self.imageViewOneCurrent.image = [UIImage imageNamed:@"snowboarding.jpg"];
    [self.newsFeedView addSubview:self.imageViewOneCurrent];
   
    UIImage *greenCheckMarkImage = [[UIImage alloc] init];
    greenCheckMarkImage = [UIImage imageNamed:@"check.png"];
    self.newsFeedImageOneCheckMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.imageViewOneCurrent.frame.size.height-60, 50, 50)];
    self.newsFeedImageOneCheckMarkView.image = greenCheckMarkImage;
    self.newsFeedImageOneCheckMarkView.layer.cornerRadius = 25;
    self.newsFeedImageOneCheckMarkView.clipsToBounds = YES;
    [self.newsFeedImageOneCheckMarkView setAlpha:0];
    [self.imageViewOneCurrent addSubview:self.newsFeedImageOneCheckMarkView];
    UIImage *redXMarkImage = [[UIImage alloc] init];
    redXMarkImage = [UIImage imageNamed:@"redx.png"];
    self.newsFeedImageOneXMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageViewOneCurrent.frame.size.width-60, self.imageViewOneCurrent.frame.size.height-60, 50, 50)];
    self.newsFeedImageOneXMarkView.image = redXMarkImage;
    self.newsFeedImageOneXMarkView.layer.cornerRadius = 25;
    self.newsFeedImageOneXMarkView.clipsToBounds = YES;
    [self.newsFeedImageOneXMarkView setAlpha:0];
    [self.imageViewOneCurrent addSubview:self.newsFeedImageOneXMarkView];
    
    
    //ImageOnePanRecognizer
    self.panRecognizerImageOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.imageViewOneCurrent addGestureRecognizer:self.panRecognizerImageOne];
    
    
    /* self.imageViewTwoBehind = [[UIImageView alloc] init];
     self.imageViewTwoBehind.userInteractionEnabled = YES;
     [self.newsFeedView addSubview:self.imageViewTwoBehind];*/
    //ImageViewTwoCurrent
    UIImage *notThatImage = [UIImage imageNamed:@"notThatAI.png"];
    self.notThatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.notThatImageView.image = notThatImage;
    self.notThatImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.notThatImageView setAlpha:0];
    [self.newsFeedView addSubview:self.notThatImageView];
    
    UIImage *voteForThat = [UIImage imageNamed:@"voteThatAI.png"];
    self.voteForThatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.voteForThatImageView.image = voteForThat;
    self.voteForThatImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.voteForThatImageView setAlpha:0];
    [self.newsFeedView addSubview:self.voteForThatImageView];
    
    CGRect imageViewTwoCurrentRect = CGRectMake(0, (heightFrame), widthFrame, (heightFrame/2));
    self.imageViewTwoCurrent = [[UIImageView alloc] initWithFrame:imageViewTwoCurrentRect];
    [self.imageViewTwoCurrent setUserInteractionEnabled:YES];
    [self.newsFeedView addSubview:self.imageViewTwoCurrent];
    self.viewNewsFeedImageTwoOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthFrame, heightFrame/2)];
    [self.imageViewTwoCurrent addSubview:self.viewNewsFeedImageTwoOverlay];
    self.newsFeedImageTwoCheckMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.newsFeedImageTwoCheckMarkView.image = greenCheckMarkImage;
    self.newsFeedImageTwoCheckMarkView.layer.cornerRadius = 25;
    self.newsFeedImageTwoCheckMarkView.clipsToBounds = YES;
    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
    [self.imageViewTwoCurrent addSubview:self.newsFeedImageTwoCheckMarkView];
    
    self.newsFeedImageTwoXMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageViewTwoCurrent.frame.size.width-60, 10, 50, 50)];
    self.newsFeedImageTwoXMarkView.image = redXMarkImage;
    self.newsFeedImageTwoXMarkView.layer.cornerRadius = 25;
    self.newsFeedImageTwoXMarkView.clipsToBounds = YES;
    [self.newsFeedImageTwoXMarkView setAlpha:0];
    [self.imageViewTwoCurrent addSubview:self.newsFeedImageTwoXMarkView];
    
    
    UIImage *yellowMenuImage = [[UIImage alloc] init];
    yellowMenuImage = [UIImage imageNamed:@"yellowMenu.png"];
    self.yellowMenuButotn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-25, (self.view.frame.size.height/2)-25, 50, 50)];
    [self.yellowMenuButotn setImage:yellowMenuImage forState:UIControlStateNormal];
    [self.yellowMenuButotn setAlpha:0];
    [self.newsFeedView addSubview:self.yellowMenuButotn];
    [self.yellowMenuButotn addTarget:self action:@selector(menuButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //ImageTwoPanRecognizer
    self.panRecognizerImageTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.imageViewTwoCurrent addGestureRecognizer:self.panRecognizerImageTwo];
    
    
    //ActivityIndicator
    
    self.imageOnePercentage = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, 10, 100, 50)];
    self.imageOnePercentage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.imageOnePercentage.layer.cornerRadius = 7.0;
    self.imageOnePercentage.clipsToBounds = YES;
    [self.imageOnePercentage setTextColor:[UIColor whiteColor]];
    [self.imageOnePercentage setFont:[UIFont systemFontOfSize:30]];
    // self.imageOnePercentage.font = [UIFont fontWithName:@"System" size:30];
    [self.imageOnePercentage setTextAlignment:NSTextAlignmentCenter];
    [self.imageViewOneCurrent addSubview:self.imageOnePercentage];
    
    CGFloat maxYimageViewTwo = CGRectGetHeight(self.imageViewTwoCurrent.frame);
    self.imageTwoPercentage = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, maxYimageViewTwo-60, 100, 50)];
    self.imageTwoPercentage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.imageTwoPercentage.layer.cornerRadius = 7.0;
    self.imageTwoPercentage.clipsToBounds = YES;
    [self.imageTwoPercentage setTextColor:[UIColor whiteColor]];
    [self.imageTwoPercentage setFont:[UIFont systemFontOfSize:30]];
    //  self.imageTwoPercentage.font = [UIFont fontWithName:@"System" size:30];
    [self.imageTwoPercentage setTextAlignment:NSTextAlignmentCenter];
    [self.imageViewTwoCurrent addSubview:self.imageTwoPercentage];
    //[self loadNewsFeedArray];
    
    self.tapToOpenImageOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.imageViewOneCurrent addGestureRecognizer:self.tapToOpenImageOne];
    self.tapToOpenImageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.imageViewTwoCurrent addGestureRecognizer:self.tapToOpenImageTwo];
}
-(void)presentInvisibleView {
    self.invisibleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.navigationController.view addSubview:self.invisibleView];
}
-(UIColor*)greenThisThatColor {
    UIColor *greenThisThatColor = [UIColor colorWithRed:51/255.0 green:168/255.0 blue:70/255.0 alpha:1];
    return greenThisThatColor;
}
-(UIColor*)redThisThatColor {
     UIColor *redThisThatColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
    return redThisThatColor;
}
-(void)invaidTokenPresentLoginScreen {
    self.alertViewLogin = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your session is no longer valid. Please login" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.alertViewLogin show];
}
-(void)internetOffline {
    self.alertViewOffline = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your internet connection appears to be offline. Please try again when you are connected." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.alertViewOffline show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView isEqual:self.alertViewLogin]) {
        
        if(buttonIndex == [alertView cancelButtonIndex]){
            [self.loadingView removeFromSuperview];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenIDString"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIDString"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
            LoginScreen *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
            [self.parentViewController presentViewController:loginVC animated:YES completion:nil];
        }
    
    }
    if([alertView isEqual:self.alertViewOffline]){
        if(buttonIndex == [alertView cancelButtonIndex]){
            [self.loadingView removeFromSuperview];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
}
-(void)uploadingNavBarDetail {
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    self.uploadingNavBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height+5)];
    self.uploadingNavBarView.backgroundColor = redColor;
    [self.navigationController.view addSubview:self.uploadingNavBarView];
    self.uploadingNavBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, [UIApplication sharedApplication].statusBarFrame.size.height + 5, self.view.frame.size.width-70, 30)];
    self.uploadingNavBarLabel.textColor = [UIColor whiteColor];
    self.uploadingNavBarLabel.text = @"uploading your thisThat..";
    [self.uploadingNavBarView addSubview:self.uploadingNavBarLabel];

    
}
@end
