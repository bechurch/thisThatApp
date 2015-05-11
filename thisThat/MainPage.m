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
 
 //   [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    
    
    
 //   UIColor *redColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(102/255.0) alpha:1];
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    
   /* UIImage *backgroundImage = [UIImage imageNamed:@"IMG_6322.jpg"];
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundImageView.image = backgroundImage;
    backGroundImageView.contentMode = UIViewContentModeScaleToFill;
    backGroundImageView.clipsToBounds = YES;
    [self.view addSubview:backGroundImageView];*/
    self.view.backgroundColor = redColor;
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    self.personalButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-25, (height/2)-90, 100, 30)];
    [self.personalButton setTitle:@"personal" forState:UIControlStateNormal];
    self.personalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.personalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.personalButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.personalButton addTarget:self action:@selector(personalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.personalButton addTarget:self action:@selector(personalButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
    [self.personalButton addTarget:self action:@selector(personalButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.personalButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.personalButton addTarget:self action:@selector(personalPostsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.personalButton];
    
    
  //  UIImage *personalIcon = [UIImage imageNamed:@"personalIconexport.png"];
    UIImage *personalIcon = [UIImage imageNamed:@"personal.png"];
    UIImage *personalIconSelected = [UIImage imageNamed:@"personalSelected.png"];
    self.personalImageButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-75, (height/2)-100, 50, 50)];
    [self.personalImageButton setImage:personalIcon forState:UIControlStateNormal];
    [self.personalImageButton setImage:personalIconSelected forState:UIControlStateHighlighted];
    [self.personalImageButton addTarget:self action:@selector(personalImageButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.personalImageButton addTarget:self action:@selector(personalImageButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
   [self.personalImageButton addTarget:self action:@selector(personalImageButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.personalImageButton addTarget:self action:@selector(personalPostsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.personalImageButton];

    

    
    self.feedButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-25, (height/2)-15, 100, 30)];
    [self.feedButton setTitle:@"thisThat" forState:UIControlStateNormal];
    self.feedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.feedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.feedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.feedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.feedButton addTarget:self action:@selector(feedButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.feedButton addTarget:self action:@selector(feedButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
    [self.feedButton addTarget:self action:@selector(feedButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.feedButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.feedButton addTarget:self action:@selector(feedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.feedButton];
    
    
    UIImage *feedIcon = [UIImage imageNamed:@"newsFeedIconWhite.png"];
    UIImage *feedIconSelected = [UIImage imageNamed:@"newsFeedIconWhiteSelected.png"];
    self.feedImageButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-75, (height/2)-25, 50, 50)];
    [self.feedImageButton setImage:feedIcon forState:UIControlStateNormal];
    [self.feedImageButton setImage:feedIconSelected forState:UIControlStateHighlighted];
    [self.feedImageButton addTarget:self action:@selector(feedImageButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.feedImageButton addTarget:self action:@selector(feedImageButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
    [self.feedImageButton addTarget:self action:@selector(feedImageButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.feedImageButton addTarget:self action:@selector(feedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.feedImageButton];
    
    
    
    
    self.votedButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-25, (height/2)+60, 100, 30)];
    [self.votedButton setTitle:@"voted" forState:UIControlStateNormal];
    self.votedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.votedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.votedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.votedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.votedButton addTarget:self action:@selector(votedButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.votedButton addTarget:self action:@selector(votedButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
    [self.votedButton addTarget:self action:@selector(votedButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    
    [self.votedButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.votedButton addTarget:self action:@selector(votedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.votedButton];
    
    UIImage *votedIcon = [UIImage imageNamed:@"voted.png"];
    UIImage *votedSelectedIcon = [UIImage imageNamed:@"votedSelected.png"];
    self.votedImageButton = [[UIButton alloc] initWithFrame:CGRectMake((width/2)-75, (height/2)+50, 50, 50)];
    [self.votedImageButton setImage:votedIcon forState:UIControlStateNormal];
    [self.votedImageButton setImage:votedSelectedIcon forState:UIControlStateHighlighted];
    [self.votedImageButton addTarget:self action:@selector(votedImageButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.votedImageButton addTarget:self action:@selector(votedImageButtonUnhighlighted:) forControlEvents:UIControlEventTouchDragOutside];
    [self.votedImageButton addTarget:self action:@selector(votedImageButtonDragHighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.votedImageButton addTarget:self action:@selector(votedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.votedImageButton];
    
    [self configureRestKit];
    
    //App already launched
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"]){
        NSLog(@"Already launched");
    }
    //App first time launch, display few pics on how to use
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        NSLog(@"First Launch Ever");
        self.firstLaunchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.firstLaunchScrollView.delegate = self;
        self.firstLaunchScrollView.scrollEnabled = YES;
        self.firstLaunchScrollView.userInteractionEnabled = YES;
        self.firstLaunchScrollView.bounces = NO;
        self.firstLaunchScrollView.pagingEnabled = YES;
        self.firstLaunchScrollView.showsHorizontalScrollIndicator = YES;
        self.firstLaunchScrollView.contentSize = CGSizeMake(4*self.view.frame.size.width, self.view.frame.size.height);
        [self.navigationController.view addSubview:self.firstLaunchScrollView];
        self.firstLaunchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4*self.view.frame.size.width, self.view.frame.size.height)];
        self.firstLaunchView.backgroundColor = [UIColor whiteColor];
        self.firstLaunchView.userInteractionEnabled = YES;
        [self.firstLaunchScrollView addSubview:self.firstLaunchView];
        
        UIImage *image = [UIImage imageNamed:@"welcomeFirstOpening.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.firstLaunchView addSubview:imageView];
        
        UIImage *imageTwoFirstLaunch = [UIImage imageNamed:@"secondPageFirstOpening.png"];
        UIImageView *imageViewTwoFirstLaunch = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageViewTwoFirstLaunch.image = imageTwoFirstLaunch;
        imageViewTwoFirstLaunch.contentMode = UIViewContentModeScaleToFill;
        [self.firstLaunchView addSubview:imageViewTwoFirstLaunch];
        
        UIImage *imageThreeFirstLaunch = [UIImage imageNamed:@"thirdPageFirstOpening.png"];
        UIImageView *imageViewThreeFirstLaunch = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageViewThreeFirstLaunch.image = imageThreeFirstLaunch;
        imageViewThreeFirstLaunch.contentMode = UIViewContentModeScaleToFill;
        [self.firstLaunchView addSubview:imageViewThreeFirstLaunch];

        UIImage *imageFourFirstLaunch = [UIImage imageNamed:@"fourthPageFirstOpening.png"];
        UIImageView *imageViewFourFirstLaunch = [[UIImageView alloc] initWithFrame:CGRectMake(3*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageViewFourFirstLaunch.image = imageFourFirstLaunch;
        imageViewFourFirstLaunch.userInteractionEnabled = YES;
        [self.firstLaunchView addSubview:imageViewFourFirstLaunch];
        UIButton *closeFirstLaunchViewButton = [[UIButton alloc] initWithFrame:CGRectMake(4*(self.view.frame.size.width)-60, self.view.frame.size.height-40, 50, 30)];
        [closeFirstLaunchViewButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeFirstLaunchViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeFirstLaunchViewButton setBackgroundColor:[UIColor clearColor]];
        [closeFirstLaunchViewButton addTarget:self action:@selector(closeFirstLaunchView:) forControlEvents:UIControlEventTouchUpInside];
        [self.firstLaunchView addSubview:closeFirstLaunchViewButton];
    }



}

-(void)personalImageButtonHighlighted:(UIButton *)sender {
    [self.personalButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}
-(void)personalImageButtonUnhighlighted:(UIButton *)sender {
    [self.personalButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
}
-(void)personalImageButtonDragHighlighted:(UIButton*)sender {
    [self.personalButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}
-(void)personalButtonHighlighted:(UIButton*)sender {
    UIImage *personalIconSelected = [UIImage imageNamed:@"personalSelected.png"];
    [self.personalImageButton setImage:personalIconSelected forState:UIControlStateNormal];
}
-(void)personalButtonUnhighlighted:(UIButton*)sender {
    UIImage *personalIcon = [UIImage imageNamed:@"personal.png"];
    [self.personalImageButton setImage:personalIcon forState:UIControlStateNormal];
}
-(void)personalButtonDragHighlighted:(UIButton*)sender {
    UIImage *personalIconSelected = [UIImage imageNamed:@"personalSelected.png"];
    [self.personalImageButton setImage:personalIconSelected forState:UIControlStateNormal];
    
}
-(void)feedImageButtonHighlighted:(UIButton*)sender {
    [self.feedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}
-(void)feedImageButtonUnhighlighted:(UIButton*)sender {
    [self.feedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
}
-(void)feedImageButtonDragHighlighted:(UIButton*)sender {
    [self.feedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}


-(void)feedButtonHighlighted:(UIButton*)sender {
    UIImage *feedIconSelected = [UIImage imageNamed:@"newsFeedIconWhiteSelected.png"];
    [self.feedImageButton setImage:feedIconSelected forState:UIControlStateNormal];
    
}
-(void)feedButtonUnhighlighted:(UIButton*)sender {
        UIImage *feedIcon = [UIImage imageNamed:@"newsFeedIconWhite.png"];
        [self.feedImageButton setImage:feedIcon forState:UIControlStateNormal];
    
}
-(void)feedButtonDragHighlighted:(UIButton*)sender {
    UIImage *feedIcon = [UIImage imageNamed:@"newsFeedIconWhiteSelected.png"];
    [self.feedImageButton setImage:feedIcon forState:UIControlStateNormal];
}
-(void)votedImageButtonHighlighted:(UIButton*)sender {
    [self.votedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}
-(void)votedImageButtonUnhighlighted:(UIButton*)sender {
    [self.votedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
}
-(void)votedImageButtonDragHighlighted:(UIButton*)sender {
    [self.votedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}
-(void)votedButtonHighlighted:(UIButton*)sender {
    UIImage *votedSelectedIcon = [UIImage imageNamed:@"votedSelected.png"];
    [self.votedImageButton setImage:votedSelectedIcon forState:UIControlStateNormal];
    
}
-(void)votedButtonUnhighlighted:(UIButton*)sender {
    UIImage *votedIcon = [UIImage imageNamed:@"voted.png"];
    [self.votedImageButton setImage:votedIcon forState:UIControlStateNormal];
    
}
-(void)votedButtonDragHighlighted:(UIButton*)sender {
    UIImage *votedSelectedIcon = [UIImage imageNamed:@"votedSelected.png"];
    [self.votedImageButton setImage:votedSelectedIcon forState:UIControlStateNormal];
}


-(void)closeFirstLaunchView:(UIButton*)button {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.firstLaunchView removeFromSuperview];
    [self.firstLaunchScrollView removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    if(userDefaultObject != nil){
        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername= %@",currentIDObject,userDefaultObject,usernameObject);
    
        NSString *username = [NSString stringWithFormat:@"%@",usernameObject];
       
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : redColor };
        self.navigationItem.title = username;
        

        
    } else {
       // if no contents in userdefaults show login screen
        LoginScreen *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        [self.parentViewController presentViewController:loginVC animated:YES completion:nil];

        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken =%@",currentIDObject,userDefaultObject);
    }
  //  [self.navigationController.navigationBar setHidden:NO];
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//settings
- (IBAction)settings:(id)sender {
    [self initalizeSettingsview];
}

-(void)initalizeSettingsview {
    [self presentInvisibleView];
    self.settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.settingsView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.settingsView];
    self.pinchRecognizerSettingsView = [[UIPinchGestureRecognizer alloc] initWithTarget:self  action:@selector(recognizePinchToCloseCurrentView:)];
    [self.settingsView addGestureRecognizer:self.pinchRecognizerSettingsView];
    self.settingsSection0LabelArray = [[NSArray alloc] initWithObjects:@"How to use thisThat", nil];
    self.settingsSection1LabelArray = [[NSArray alloc] initWithObjects:@"Invite your friends to thisThat", nil];
    self.settingsSection2LabelArray = [[NSArray alloc] initWithObjects:@"Instagram",@"Twitter", nil];
    self.settingsSection3LabelArray = [[NSArray alloc] initWithObjects:@"thisThat website",@"Suggestions/Report a problem", nil];
    self.settingsSection4LaeblArray = [[NSArray alloc] initWithObjects:@"Logout of thisThat", nil];
    
    UIImage *twitterImage = [UIImage imageNamed:@"Twitter_logo_blue.png"];
    UIImage *instagramImage = [UIImage imageNamed:@"Instagram_Icon_Large.png"];
    self.twitterIntstagramImagesArray = [[NSArray alloc] initWithObjects:instagramImage,twitterImage, nil];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
     UIView *statusBarViewColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, statusBarHeight)];
    statusBarViewColor.backgroundColor = redColor;
    [self.settingsView addSubview:statusBarViewColor];
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    navBar.barTintColor = redColor;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
   
    [navBar setTranslucent:NO];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    [navBar setItems:[NSArray arrayWithObjects:navItem, nil]];
    [navBar setTintColor:[UIColor whiteColor]];
    [self.settingsView addSubview:navBar];
  
    
    CGFloat maxNavBarY = CGRectGetMaxY(navBar.frame);
    
    self.settingsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, maxNavBarY, self.view.frame.size.width, self.view.frame.size.height-maxNavBarY) style:UITableViewStyleGrouped];
    self.settingsTableview.delegate = self;
    self.settingsTableview.dataSource = self;
    self.settingsTableview.userInteractionEnabled = YES;
    self.settingsTableview.bounces = YES;
    
    [self.settingsTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.settingsView addSubview:self.settingsTableview];
    
    
}
//uploadPost initalize
- (IBAction)upload:(id)sender {
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    UIColor *redColor2 = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:0.8];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
       CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
   /* UIColor *redThisThatColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
     UIColor *blueishThisThatColor = [UIColor colorWithRed:(60/255.0) green:(104/255.0) blue:(150/255.0) alpha:1];
    UIColor *greyishThisThatColor = [UIColor colorWithRed:(172/255.0) green:(166/255.0) blue:(158/255.0) alpha:1];*/
    UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
    UIColor *blackThisThatColor2 = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:0.8];
    [self presentInvisibleView];
    
    self.uploadPostView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    self.uploadPostView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.uploadPostView];
    self.uploadPostPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.uploadPostView addGestureRecognizer:self.uploadPostPinchGesture];
    CGFloat heightOfCell = (viewWidth/2) + 130;
    CGFloat heighOfInstructionsLabel = (viewHeight/2)-(heightOfCell/2);
    
    self.uploadPostInstructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (heighOfInstructionsLabel/2)-15, viewWidth-20, 30)];
    self.uploadPostInstructionsLabel.text = @"Create a new post";
    self.uploadPostInstructionsLabel.textAlignment = NSTextAlignmentCenter;
    [self.uploadPostView addSubview:self.uploadPostInstructionsLabel];
    
    self.uploadPostExampleTableViewCellView = [[UIView alloc] initWithFrame:CGRectMake(0, (viewHeight/2)-(heightOfCell/2), viewWidth, (viewWidth/2)+130)];
    self.uploadPostExampleTableViewCellView.backgroundColor = [UIColor whiteColor];
    [self.uploadPostView addSubview:self.uploadPostExampleTableViewCellView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 1)];
    topLine.backgroundColor = [UIColor blackColor];
    [self.uploadPostExampleTableViewCellView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightOfCell-1, viewWidth, 1)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [self.uploadPostExampleTableViewCellView addSubview:bottomLine];
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    self.uploadPostUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth/2)+5, (heightOfCell-(viewWidth/2)+15)/2 -30, (viewWidth/2)-5, 30)];
    self.uploadPostUsernameLabel.backgroundColor = [UIColor clearColor];
    [self.uploadPostUsernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    self.uploadPostUsernameLabel.textColor = redColor;
    self.uploadPostUsernameLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadPostUsernameLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostUsernameLabel.minimumScaleFactor = 0.8;
    self.uploadPostUsernameLabel.text = [NSString stringWithFormat:@"%@",usernameObject];
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostUsernameLabel];
    
   /* self.uploadPostTimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth/2)+5,100,(viewWidth/2)-15,30)];
    [self.uploadPostTimeStampLabel setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostTimeStampLabel.text = @"Just now";
    self.uploadPostTimeStampLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadPostTimeStampLabel.backgroundColor = [UIColor clearColor];
    self.uploadPostTimeStampLabel.textColor = greyishThisThatColor;
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostTimeStampLabel];*/
    
   // self.uploadPostCameraButtonOne = [[UIButton alloc ] initWithFrame:CGRectMake(10, 100, (viewWidth/2)-15, self.uploadPostExampleTableViewCellView.frame.size.height-110)];
    self.uploadPostCameraButtonOne = [[UIButton alloc ] initWithFrame:CGRectMake(10, 10, (viewWidth/2)-15, (viewWidth/2)-15)];
    [self.uploadPostCameraButtonOne setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.uploadPostCameraButtonOne setTitle:@"Add photo" forState:UIControlStateNormal];
    [self.uploadPostCameraButtonOne addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostCameraButtonOne];
    
   // self.uploadPostCameraButtonTwo = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2)+5, 100, (viewWidth/2)-15, self.uploadPostExampleTableViewCellView.frame.size.height-110)];
     self.uploadPostCameraButtonTwo = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2)+5, (self.uploadPostExampleTableViewCellView.frame.size.height)-(viewWidth/2)+5, (viewWidth/2)-15, (viewWidth/2)-15)];
    [self.uploadPostCameraButtonTwo setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.uploadPostCameraButtonTwo setTitle:@"Add photo" forState:UIControlStateNormal];
    [self.uploadPostCameraButtonTwo addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostCameraButtonTwo];
    
    
    self.uploadPostTextViewPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (viewWidth/2)+5, (viewWidth/2)-15, self.uploadPostExampleTableViewCellView.frame.size.height-15-(viewWidth/2))];
    self.uploadPostTextViewPlaceHolderLabel.text = @"What are you comparing?";
    self.uploadPostTextViewPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadPostTextViewPlaceHolderLabel.numberOfLines = 0;
    [self.uploadPostTextViewPlaceHolderLabel sizeToFit];
    self.uploadPostTextViewPlaceHolderLabel.frame = CGRectMake((viewWidth/2)/2 - (self.uploadPostTextViewPlaceHolderLabel.frame.size.width/2), self.uploadPostTextViewPlaceHolderLabel.frame.origin.y, self.uploadPostTextViewPlaceHolderLabel.frame.size.width, self.uploadPostTextViewPlaceHolderLabel.frame.size.height);
    [self.uploadPostTextViewPlaceHolderLabel setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostTextViewPlaceHolderLabel.textColor = [UIColor lightGrayColor];
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostTextViewPlaceHolderLabel];
    
    
    self.uploadPostTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, (viewWidth/2)+5, (viewWidth/2)-15, self.uploadPostExampleTableViewCellView.frame.size.height-15-(viewWidth/2))];
    self.uploadPostTextView.backgroundColor = [UIColor clearColor];
    self.uploadPostTextView.delegate = self;
    [self.uploadPostTextView setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostTextView.textColor = [UIColor blackColor];
    self.uploadPostTextView.layer.borderWidth = 1.0;
    self.uploadPostTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.uploadPostTextView.textAlignment = NSTextAlignmentCenter;
    //self.uploadPostTextView.text = @"What are you comparing?";
    self.uploadPostTextView.returnKeyType = UIReturnKeyDone;
    [self.uploadPostExampleTableViewCellView addSubview:self.uploadPostTextView];
    
    CGFloat maxCellYValue = CGRectGetMaxY(self.uploadPostExampleTableViewCellView.frame);
    CGFloat lengthEndCellToEndScreen = viewHeight - maxCellYValue;
    
    
    self.uploadPostPreviewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, maxCellYValue + lengthEndCellToEndScreen/2 - 15, viewWidth/3 -15
                                                                              , 30)];
    [self.uploadPostPreviewButton setBackgroundImage:[self imageWithColor:blackThisThatColor] forState:UIControlStateNormal];
    [self.uploadPostPreviewButton setBackgroundImage:[self imageWithColor:blackThisThatColor2] forState:UIControlStateHighlighted];
    
    [self.uploadPostPreviewButton setTitle:@"Preview" forState:UIControlStateNormal];
    [self.uploadPostPreviewButton addTarget:self action:@selector(previewUploadThisThat:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostView addSubview:self.uploadPostPreviewButton];
    [self.uploadPostPreviewButton setHidden:YES];
    
    self.uploadPostButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/3+5, maxCellYValue + lengthEndCellToEndScreen/2 - 15, 2*(viewWidth/3)-15, 30)];
    [self.uploadPostButton setBackgroundImage:[self imageWithColor:redColor] forState:UIControlStateNormal];
    [self.uploadPostButton setBackgroundImage:[self imageWithColor:redColor2] forState:UIControlStateHighlighted];
    
    [self.uploadPostButton setTitle:@"Upload" forState:UIControlStateNormal];
    [self.uploadPostButton addTarget:self action:@selector(uploadPostAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostView addSubview:self.uploadPostButton];
    [self.uploadPostButton setHidden:YES];
    
    /*
    self.uploadPostSlideToUploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (viewWidth/2)+220, 180, 30)];
    self.uploadPostSlideToUploadLabel.textColor = [UIColor blackColor];
    self.uploadPostSlideToUploadLabel.text = @">> Slide to upload >>";
    [self.uploadPostView addSubview:self.uploadPostSlideToUploadLabel];
    [self.uploadPostSlideToUploadLabel setHidden:YES];
    
    self.uploadPostSlideToUploadView = [[UIView alloc] initWithFrame:CGRectMake(10, (viewWidth/2)+200, 70, 70)];
    self.uploadPostSlideToUploadView.backgroundColor = [UIColor redColor];
    
    self.uploadPostSlideToUploadView.layer.cornerRadius = 35;
    self.uploadPostSlideToUploadView.clipsToBounds = YES;
    self.uploadPostPanGestureSlideToUploadView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePanUploadThisThatView:)];
    [self.uploadPostSlideToUploadView addGestureRecognizer:self.uploadPostPanGestureSlideToUploadView];
    [self.uploadPostView addSubview:self.uploadPostSlideToUploadView];
    [self.uploadPostSlideToUploadView setHidden:YES];

    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.uploadPostSlideToUploadView.frame.size.width/2)-25, (self.uploadPostSlideToUploadView.frame.size.height/2)-15, 50, 30)];
    [uploadLabel setFont:[UIFont systemFontOfSize:15]];
    uploadLabel.text = @"Upload";
    [self.uploadPostSlideToUploadView addSubview:uploadLabel];
        */
    /*
    self.uploadPostAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth/2)+5,50,(viewWidth/2)-15,40)];
    self.uploadPostAddressLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadPostAddressLabel.backgroundColor = [UIColor clearColor];
    [self.uploadPostAddressLabel setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostAddressLabel.textColor = [UIColor grayColor];
    self.uploadPostAddressLabel.numberOfLines = 0;
    self.uploadPostAddressLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostAddressLabel.minimumScaleFactor = 0.5;
    self.uploadPostAddressLabel.text = @"Earth";
    [self.uploadPostView addSubview:self.uploadPostAddressLabel];
    */
    /*
    self.uploadPostLocationEnabledSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(viewWidth-60, (viewWidth/2)+130, 30, 30)];
    [self.uploadPostLocationEnabledSwitch addTarget:self action:@selector(onOffSwitch:) forControlEvents:UIControlEventValueChanged];
    self.uploadPostLocationEnabledSwitch.onTintColor = blueishThisThatColor;
    [self.uploadPostView addSubview:self.uploadPostLocationEnabledSwitch];
    self.uploadPostLocationEnabledLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (viewWidth/2)+130, viewWidth-80, 30)];
    self.uploadPostLocationEnabledLabel.text = @"Enable current location";
    [self.uploadPostView addSubview:self.uploadPostLocationEnabledLabel];
    
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    geocoder = [[CLGeocoder alloc] init];
*/

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
//pan to upload new post
-(void)uploadPostAction:(UIButton *)recognize {
    if([self.uploadPostTextView.text isEqualToString:@""]) {
        self.uploadPostNoTextContentAlertView = [[UIAlertView alloc] initWithTitle:@"What are you comparing?" message:@"Add some text to describe what you are comparing." delegate:self cancelButtonTitle:@"Continue without" otherButtonTitles:@"Add text", nil];
        [self.uploadPostNoTextContentAlertView show];
    }
    else {
    [self uploadThisThat];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView isEqual:self.uploadPostTextView]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
}
-(void)keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardSize.size.height;
    self.maxYKeyboard = self.view.frame.size.height - keyboardHeight;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat heightOfCell = (viewWidth/2) + 130;
   // CGFloat heighOfInstructionsLabel = (viewHeight/2)-(heightOfCell/2);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.uploadPostExampleTableViewCellView.frame = CGRectMake(0, viewHeight-heightOfCell-keyboardHeight, viewWidth, (viewWidth/2)+130);
        self.uploadPostInstructionsLabel.frame = CGRectMake(10, viewHeight-heightOfCell-keyboardHeight-self.uploadPostInstructionsLabel.frame.size.height, viewWidth-20, 30);
    } completion:^(BOOL finished) {
        self.uploadPostCameraButtonOne.enabled = NO;
        self.uploadPostCameraButtonTwo.enabled = NO;
        self.uploadPostTapGestureToCloseKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
        [self.uploadPostView addGestureRecognizer:self.uploadPostTapGestureToCloseKeyboard];
    }];
    
}
-(void)tapToCloseKeyboard:(UITapGestureRecognizer*)recognize {
    [self.uploadPostTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGFloat viewHeight = self.view.frame.size.height;
        CGFloat viewWidth = self.view.frame.size.width;
        CGFloat heightOfCell = (viewWidth/2) + 130;
        CGFloat heighOfInstructionsLabel = (viewHeight/2)-(heightOfCell/2);
        self.uploadPostExampleTableViewCellView.frame = CGRectMake(0, (viewHeight/2)-(heightOfCell/2), viewWidth, (viewWidth/2)+130);
        self.uploadPostInstructionsLabel.frame = CGRectMake(10, (heighOfInstructionsLabel/2)-15, viewWidth-20, 30);
    } completion:^(BOOL finished) {
        self.uploadPostCameraButtonOne.enabled = YES;
        self.uploadPostCameraButtonTwo.enabled = YES;
        [self.uploadPostTextView removeGestureRecognizer:self.uploadPostTapGestureToCloseKeyboard];
    }];
    
}
/*
-(void)recognizePanUploadThisThatView:(UIPanGestureRecognizer*)recognize {


    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognize translationInView:self.uploadPostView];
            recognize.view.center = CGPointMake(recognize.view.center.x+currentPoint.x, recognize.view.center.y);
            [recognize setTranslation:CGPointMake(0, 0) inView:self.uploadPostView];
           CGFloat maxX = CGRectGetMaxX(self.uploadPostSlideToUploadView.frame);
            CGFloat minX = CGRectGetMinX(self.uploadPostSlideToUploadView.frame);
            if(maxX >=self.uploadPostView.frame.size.width){
                self.uploadPostSlideToUploadView.frame = CGRectMake(self.view.frame.size.width - 70, (self.view.frame.size.width/2)+200, 70 , 70);
            }
            if(minX <= 10){
                self.uploadPostSlideToUploadView.frame = CGRectMake(10, (self.view.frame.size.width/2)+200, 70 , 70);
            }
            CGFloat getMinX = CGRectGetMinX(self.uploadPostSlideToUploadView.frame);
            CGFloat viewWidth = CGRectGetWidth(self.view.frame);
            CGFloat percentCovered = getMinX/viewWidth;
            if(percentCovered < 0.3) {
                self.uploadPostSlideToUploadView.backgroundColor = [UIColor redColor];
            }
            if(percentCovered >= 0.3) {
                self.uploadPostSlideToUploadView.backgroundColor = [UIColor greenColor];
            }
            
            
            
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGFloat getCurrentMinPanMin = CGRectGetMinX(self.uploadPostSlideToUploadView.frame);
            CGFloat viewWidth = CGRectGetWidth(self.view.frame);
            CGFloat percentCovered = getCurrentMinPanMin/viewWidth;
            if(percentCovered >= 0.3){
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.uploadPostSlideToUploadView.frame = CGRectMake(self.view.frame.size.width - 70, (self.view.frame.size.width/2)+200, 70 , 70);
                } completion:^(BOOL finished) {
                        [self uploadThisThat];
                    }];
            }
            else {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.uploadPostSlideToUploadView.frame = CGRectMake(10, (self.view.frame.size.width/2)+200, 70 , 70);
                self.uploadPostSlideToUploadView.backgroundColor = [UIColor redColor];
            } completion:^(BOOL finished) {
                
            }];
        }
        }
        default:
            break;
    }
    
} */
//called when pan to upload post is complete
-(void)uploadThisThat {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self uploadingNavBarDetail];
    [self.uploadPostView removeFromSuperview];
    [self.invisibleView removeFromSuperview];
   
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userToken = [userDefaultContents objectForKey:@"tokenIDString"];
    self.uploadPostPathString = [NSString stringWithFormat:@"/api/v1/thisthats/?access_token=%@",userToken];
    self.uploadPostImageOneData = [self compressImage:self.uploadPostTempImageOne];
    self.uploadPostImageTwoData = [self compressImage:self.uploadPostTempImageTwo];
    if([self.uploadPostTextView.text isEqualToString:@"What are you comparing?"]) {
        self.uploadPostTextView.text = @"";
    }
    self.uploadPostDictionaryTextViewContents = @{@"message" : self.uploadPostTextView.text};
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:self.uploadPostPathString parameters:self.uploadPostDictionaryTextViewContents constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:self.uploadPostImageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:self.uploadPostImageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
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
//if error in upload, save contents in dictionary to try again later
-(void)errorSaveContentsOfUpload {
    self.uploadPostErrorMutableDictionarySaveContents = [[NSMutableDictionary alloc] init];
    [self.uploadPostErrorMutableDictionarySaveContents setObject:self.uploadPostPathString forKey:@"uploadPathString"];
    [self.uploadPostErrorMutableDictionarySaveContents setObject:self.uploadPostImageOneData forKey:@"imageOneData"];
    [self.uploadPostErrorMutableDictionarySaveContents setObject:self.uploadPostImageTwoData forKey:@"imageTwoData"];
    [self.uploadPostErrorMutableDictionarySaveContents setObject:self.uploadPostDictionaryTextViewContents forKey:@"textContentsDict"];
    
    
}
// upload progress displaye on nav bar
-(void)uploadErrorUpdateNavBar {
    self.uploadPostNavigationBarUploadLabel.text = @"Failed. Please try again.";
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    self.uploadPostNavigationBarRetryUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, [UIApplication sharedApplication].statusBarFrame.size.height+5, 50, 30)];
    self.uploadPostNavigationBarRetryUploadButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.uploadPostNavigationBarRetryUploadButton setTitleColor:redColor forState:UIControlStateNormal];
    self.uploadPostNavigationBarRetryUploadButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostNavigationBarRetryUploadButton.titleLabel.minimumScaleFactor = 0.6;
    [self.uploadPostNavigationBarRetryUploadButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.uploadPostNavigationBarRetryUploadButton addTarget:self action:@selector(retryUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostNavigationBarUploadView addSubview:self.uploadPostNavigationBarRetryUploadButton];
    
    self.uploadPostNavigationBarDeleteUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIApplication sharedApplication].statusBarFrame.size.height+5, 50, 30)];
    self.uploadPostNavigationBarDeleteUploadButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.uploadPostNavigationBarDeleteUploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.uploadPostNavigationBarDeleteUploadButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostNavigationBarDeleteUploadButton.titleLabel.minimumScaleFactor = 0.6;
    [self.uploadPostNavigationBarDeleteUploadButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.uploadPostNavigationBarDeleteUploadButton addTarget:self action:@selector(deleteUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostNavigationBarUploadView addSubview:self.uploadPostNavigationBarDeleteUploadButton];
    
   // [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:4];
}
//upload failed, delete upload
-(void)deleteUpload:(UIButton*)button{
    self.uploadPostNavigationBarUploadLabel.text = @"Upload was cancelled";
    [self.uploadPostNavigationBarRetryUploadButton removeFromSuperview];
    [self.uploadPostNavigationBarDeleteUploadButton removeFromSuperview];
    [self.uploadPostErrorMutableDictionarySaveContents removeAllObjects];
    [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:3];
    
}
//upload failed, try uploading again
-(void)retryUpload:(UIButton*)button {
    [self.uploadPostNavigationBarRetryUploadButton removeFromSuperview];
    [self.uploadPostNavigationBarDeleteUploadButton removeFromSuperview];
    self.uploadPostNavigationBarUploadLabel.text = @"uploading your thisThat..";
    NSString *pathString =  [self.uploadPostErrorMutableDictionarySaveContents objectForKey:@"uploadPathString"];
    NSData *imageOneData = [self.uploadPostErrorMutableDictionarySaveContents objectForKey:@"imageOneData"];
    NSData *imageTwoData = [self.uploadPostErrorMutableDictionarySaveContents objectForKey:@"imageTwoData"];
    NSDictionary *parameters = [self.uploadPostErrorMutableDictionarySaveContents objectForKey:@"textContentsDict"];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]multipartFormRequestWithObject:[objects class] method:RKRequestMethodPOST path:pathString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageOneData name:@"image1" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageTwoData name:@"image2" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self performSelector:@selector(uploadSuccesfulUpdateNavBar) withObject:nil afterDelay:2];
        [self.uploadPostErrorMutableDictionarySaveContents removeAllObjects];
        NSLog(@"succss");
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
       // [self errorSaveContentsOfUpload];
        [self performSelector:@selector(uploadErrorUpdateNavBar) withObject:nil afterDelay:2];
        NSLog(@"Error");
    }];
    [operation start];
    
}
//upload successful, displayed on nav bar
-(void)uploadSuccesfulUpdateNavBar{
    UIImage *checkimage = [UIImage imageNamed:@"check.png"];
    self.uploadPostNavigationBarUploadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, [UIApplication sharedApplication].statusBarFrame.size.height, 45, 45)];
    self.uploadPostNavigationBarUploadImageView.image = checkimage;
    [self.uploadPostNavigationBarUploadView addSubview:self.uploadPostNavigationBarUploadImageView];
    self.uploadPostNavigationBarUploadLabel.text = @"thisThat uploaded successfully";
    [self performSelector:@selector(removeUploadingNavViewFromSuperView) withObject:nil afterDelay:4];

}
//remove nav bar from view
-(void)removeUploadingNavViewFromSuperView {
    [self.uploadPostNavigationBarUploadView removeFromSuperview];
    
}
//upload post, allow location to be found
/*
-(void)onOffSwitch:(id)recognize {
    if([recognize isOn]){
        NSLog(@"switchON");
        self.uploadPostAddressLabel.text = @"Retrieving location..";
        [locationManager startUpdatingLocation];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else {
        NSLog(@"switchOff");
        self.uploadPostAddressLabel.text = @"Earth";
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
            self.uploadPostAddressLabel.textAlignment = NSTextAlignmentCenter;
            self.uploadPostAddressLabel.text = [NSString stringWithFormat:@"%@ %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
        }
    }];
}
 */

//upload see photos 1/2 size of viewscreen
-(void)previewUploadThisThat:(UIButton *)recognize {
    self.invisibleView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.uploadPostView addSubview:self.invisibleView2];
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    
    self.uploadPostViewForImageViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.uploadPostViewForImageViews.backgroundColor = [UIColor whiteColor];
    [self.uploadPostView addSubview:self.uploadPostViewForImageViews];
    
    self.uploadPostPreviewViewForLabels = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/2)-115, self.view.frame.size.width, 230)];
    self.uploadPostPreviewViewForLabels.layer.borderWidth = 5;
    self.uploadPostPreviewViewForLabels.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.uploadPostViewForImageViews addSubview:self.uploadPostPreviewViewForLabels];
    
    
    self.uploadPostPreviewTextContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,70, self.view.frame.size.width-20, 120)];
    self.uploadPostPreviewTextContentLabel.text = self.uploadPostTextViewString;
    self.uploadPostPreviewTextContentLabel.textColor = [UIColor darkGrayColor];
    [self.uploadPostPreviewTextContentLabel setFont:[UIFont systemFontOfSize:25]];
    self.uploadPostPreviewTextContentLabel.numberOfLines = 0;
    self.uploadPostPreviewTextContentLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostPreviewTextContentLabel.minimumScaleFactor = 0.8;
    self.uploadPostPreviewTextContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.uploadPostPreviewViewForLabels addSubview:self.uploadPostPreviewTextContentLabel];
    
    self.uploadPostPreviewUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, (self.view.frame.size.width)-20, 35)];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    NSString *usernameString = [NSString stringWithFormat:@"%@",usernameObject];
    self.uploadPostPreviewUsernameLabel.text = usernameString;
    self.uploadPostPreviewUsernameLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadPostPreviewUsernameLabel.textColor = redColor;
    [self.uploadPostPreviewUsernameLabel setFont:[UIFont systemFontOfSize:30]];
    self.uploadPostPreviewUsernameLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostPreviewUsernameLabel.minimumScaleFactor = 0.5;
    [self.uploadPostPreviewViewForLabels addSubview:self.uploadPostPreviewUsernameLabel];
    
  /*  self.uploadPostPreviewTimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*(self.view.frame.size.width/4), 10, (self.view.frame.size.width/4)-10, 20)];
    self.uploadPostPreviewTimeStampLabel.text = @"Just now";
    self.uploadPostPreviewTimeStampLabel.textColor = [UIColor grayColor];
    [self.uploadPostPreviewTimeStampLabel setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostPreviewTimeStampLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostPreviewTimeStampLabel.minimumScaleFactor = 0.8;
    [self.uploadPostPreviewViewForLabels addSubview:self.uploadPostPreviewTimeStampLabel];*/
    
   /* self.uploadPostPreviewLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 3*(self.view.frame.size.width/4)-10, 20)];
    self.uploadPostPreviewLocationLabel.text = self.uploadPostAddressLabel.text;
    [self.uploadPostPreviewLocationLabel setFont:[UIFont systemFontOfSize:15]];
    self.uploadPostPreviewLocationLabel.textColor = [UIColor grayColor];
    self.uploadPostPreviewLocationLabel.adjustsFontSizeToFitWidth = YES;
    self.uploadPostPreviewLocationLabel.minimumScaleFactor = 0.6;
    [self.uploadPostPreviewViewForLabels addSubview:self.uploadPostPreviewLocationLabel];
    */
    
    self.uploadPostImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height/2))];
    self.uploadPostImageViewOne.image = [self cropImage:self.uploadPostTempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.uploadPostViewForImageViews.frame.size.height/2)];

    
    [self.uploadPostViewForImageViews addSubview:self.uploadPostImageViewOne];
    self.uploadPostTapGestureToOpenImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToSeeFullSizeImage:)];
    [self.uploadPostImageViewOne setUserInteractionEnabled:YES];
    [self.uploadPostImageViewOne addGestureRecognizer:self.uploadPostTapGestureToOpenImageViewOne];
    
    self.uploadPostImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height/2), self.view.frame.size.width, self.view.frame.size.height/2)];
    self.uploadPostImageViewTwo.image = [self cropImage:self.uploadPostTempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.uploadPostViewForImageViews.frame.size.height/2)];

    [self.uploadPostViewForImageViews addSubview:self.uploadPostImageViewTwo];
    self.uploadPostTapGestureToOpenImageViewTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToSeeFullSizeImage:)];
    [self.uploadPostImageViewTwo setUserInteractionEnabled:YES];
    [self.uploadPostImageViewTwo addGestureRecognizer:self.uploadPostTapGestureToOpenImageViewTwo];
    
    
    
    self.uploadPostPinchGestureImageViews = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.uploadPostViewForImageViews addGestureRecognizer:self.uploadPostPinchGestureImageViews];
    
    self.uploadPostYellowMenuButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-25, (self.view.frame.size.height/2)-25, 50, 50)];
    UIImage *yellowMenuButtonImage = [UIImage imageNamed:@"yellowMenu.png"];
    [self.uploadPostYellowMenuButton setImage:yellowMenuButtonImage forState:UIControlStateNormal];
    [self.uploadPostYellowMenuButton addTarget:self action:@selector(uploadPostYellowMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPostViewForImageViews addSubview:self.uploadPostYellowMenuButton];
    
    
    
}
//upload post yellow menu button pressed
-(void)uploadPostYellowMenuButtonPressed:(UIButton*)button {
    [self.uploadPostYellowMenuButton setAlpha:0];
    [self.uploadPostTapGestureToOpenImageViewOne setEnabled:NO];
    [self.uploadPostTapGestureToOpenImageViewTwo setEnabled:NO];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.uploadPostImageViewOne.frame =CGRectMake(0, -115, [self viewWidth], [self viewHeight]/2);
        self.uploadPostImageViewTwo.frame = CGRectMake(0, ([self viewHeight]/2)+115, [self viewWidth], [self viewHeight]/2);

    } completion:^(BOOL finished) {
        UITapGestureRecognizer *uploadPostTapToCloseLabelMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPostCloseMenuAction:)];
        [self.uploadPostViewForImageViews addGestureRecognizer:uploadPostTapToCloseLabelMenu];
    }];
    
    
}

-(void)uploadPostCloseMenuAction:(UIButton*)button {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.uploadPostImageViewOne.frame =CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
        self.uploadPostImageViewTwo.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
    } completion:^(BOOL finished) {
        [self.uploadPostYellowMenuButton setAlpha:1];
        [self.uploadPostTapGestureToOpenImageViewOne setEnabled:YES];
        [self.uploadPostTapGestureToOpenImageViewTwo setEnabled:YES];
    }];
}

//upload see fullsize photos
-(void)uploadTapToSeeFullSizeImage:(UITapGestureRecognizer*)recognize {
    [self.uploadPostYellowMenuButton setAlpha:0];
    self.uploadPostViewForFullSizeImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.uploadPostViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.uploadPostViewForImageViews addSubview:self.uploadPostViewForFullSizeImageView];
    self.uploadFullSizeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    if(recognize == self.uploadPostTapGestureToOpenImageViewOne){
        self.uploadFullSizeImageView = [self inputImage:self.uploadPostTempImageOne];
    }
    if(recognize == self.uploadPostTapGestureToOpenImageViewTwo){
        self.uploadFullSizeImageView = [self inputImage:self.uploadPostTempImageTwo];
    }
    [self.uploadPostViewForFullSizeImageView addSubview:self.uploadFullSizeImageView];
    self.uploadCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTapToCloseFullSizeImageView:)];
    [self.uploadFullSizeImageView setUserInteractionEnabled:YES];
    [self.uploadFullSizeImageView addGestureRecognizer:self.uploadCloseFullSizeImageView];
    
    self.uploadPostPanToZoomInOnFullSizeImageView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToZoomInOnFullSizeImageView:)];
    [self.uploadFullSizeImageView addGestureRecognizer:self.uploadPostPanToZoomInOnFullSizeImageView];
    
}
-(void)panToZoomInOnFullSizeImageView:(UIPanGestureRecognizer*)recognize {
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            if(recognize == self.uploadPostPanToZoomInOnFullSizeImageView) {
            CGPoint locationPoint = [recognize locationInView:self.uploadFullSizeImageView];
            self.zoomInStartingYPosition = locationPoint.y;
            }
            if(recognize == self.personalPostsPanToZoomInOnFullSizeImageView) {
                CGPoint locationPoint = [recognize locationInView:self.personalPostsFullSizeImageView];
                self.zoomInStartingYPosition = locationPoint.y;
            }
            if(recognize == self.newsFeedPanToZoomInOnFullSizeImageView) {
                CGPoint locationPoint = [recognize locationInView:self.newsFeedFullSizeImageView];
                self.zoomInStartingYPosition = locationPoint.y;
                NSLog(@"yourMom");
            }
            if(recognize == self.postsVotedOnPanToZoomInOnFullSizeImageView) {
                CGPoint locationPoint = [recognize locationInView:self.postsVotedOnFullSizeImageView];
                self.zoomInStartingYPosition = locationPoint.y;
                NSLog(@"yourMom");
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if(recognize == self.uploadPostPanToZoomInOnFullSizeImageView) {
                
            CGPoint currentLocationPoint = [recognize locationInView:self.uploadFullSizeImageView];
            CGFloat currentLocationPointY = currentLocationPoint.y;
            if (currentLocationPointY < self.zoomInStartingYPosition) {
                currentLocationPointY = self.zoomInStartingYPosition;
            }
            CGFloat yDistanceMoved = fabsf(self.zoomInStartingYPosition - fabsf(currentLocationPointY));
            CGFloat yAmountZoomedIn = 1 + (yDistanceMoved/self.uploadFullSizeImageView.frame.size.height);
            CGAffineTransform transform = CGAffineTransformMakeScale(yAmountZoomedIn, yAmountZoomedIn);
            self.uploadFullSizeImageView.transform = transform;
        }
            if(recognize == self.personalPostsPanToZoomInOnFullSizeImageView) {
                
                CGPoint currentLocationPoint = [recognize locationInView:self.personalPostsFullSizeImageView];
                CGFloat currentLocationPointY = currentLocationPoint.y;
                if (currentLocationPointY < self.zoomInStartingYPosition) {
                    currentLocationPointY = self.zoomInStartingYPosition;
                }
                CGFloat yDistanceMoved = fabsf(self.zoomInStartingYPosition - fabsf(currentLocationPointY));
                CGFloat yAmountZoomedIn = 1 + (yDistanceMoved/self.personalPostsFullSizeImageView.frame.size.height);
                CGAffineTransform transform = CGAffineTransformMakeScale(yAmountZoomedIn, yAmountZoomedIn);
                self.personalPostsFullSizeImageView.transform = transform;
            }
            if(recognize == self.newsFeedPanToZoomInOnFullSizeImageView) {
                
                CGPoint currentLocationPoint = [recognize locationInView:self.newsFeedFullSizeImageView];
                CGFloat currentLocationPointY = currentLocationPoint.y;
                if (currentLocationPointY < self.zoomInStartingYPosition) {
                    currentLocationPointY = self.zoomInStartingYPosition;
                }
                CGFloat yDistanceMoved = fabsf(self.zoomInStartingYPosition - fabsf(currentLocationPointY));
                CGFloat yAmountZoomedIn = 1 + (yDistanceMoved/self.newsFeedFullSizeImageView.frame.size.height);
                CGAffineTransform transform = CGAffineTransformMakeScale(yAmountZoomedIn, yAmountZoomedIn);
                self.newsFeedFullSizeImageView.transform = transform;
            }
            if(recognize == self.postsVotedOnPanToZoomInOnFullSizeImageView) {
                
                CGPoint currentLocationPoint = [recognize locationInView:self.postsVotedOnFullSizeImageView];
                CGFloat currentLocationPointY = currentLocationPoint.y;
                if (currentLocationPointY < self.zoomInStartingYPosition) {
                    currentLocationPointY = self.zoomInStartingYPosition;
                }
                CGFloat yDistanceMoved = fabsf(self.zoomInStartingYPosition - fabsf(currentLocationPointY));
                CGFloat yAmountZoomedIn = 1 + (yDistanceMoved/self.postsVotedOnFullSizeImageView.frame.size.height);
                CGAffineTransform transform = CGAffineTransformMakeScale(yAmountZoomedIn, yAmountZoomedIn);
                self.postsVotedOnFullSizeImageView.transform = transform;
            }

        }
            break;
        case UIGestureRecognizerStateEnded:{
            if(recognize == self.uploadPostPanToZoomInOnFullSizeImageView) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                self.uploadFullSizeImageView.transform = transform;
            } completion:^(BOOL finished) {
                self.zoomInStartingYPosition = 0;
            }];
        }
            if(recognize == self.personalPostsPanToZoomInOnFullSizeImageView) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                    self.personalPostsFullSizeImageView.transform = transform;
                } completion:^(BOOL finished) {
                    self.zoomInStartingYPosition = 0;
                }];
            }
            if(recognize == self.newsFeedPanToZoomInOnFullSizeImageView) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                    self.newsFeedFullSizeImageView.transform = transform;
                } completion:^(BOOL finished) {
                    self.zoomInStartingYPosition = 0;
                }];
            }
            if(recognize == self.postsVotedOnPanToZoomInOnFullSizeImageView) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                    self.postsVotedOnFullSizeImageView.transform = transform;
                } completion:^(BOOL finished) {
                    self.zoomInStartingYPosition = 0;
                }];
            }
        }
        default:
            break;
    }
}
-(void)uploadTapToCloseFullSizeImageView:(UITapGestureRecognizer*)recognize{
    [self.uploadPostViewForFullSizeImageView removeFromSuperview];
    [self.uploadPostYellowMenuButton setAlpha:1];
}
//action to load personal posts
-(void)personalPostsButtonAction:(UIButton*)sender {
    UIImage *personalIcon = [UIImage imageNamed:@"personal.png"];
    [self.personalImageButton setImage:personalIcon forState:UIControlStateNormal];
    [self.personalButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self loadPersonalPosts];
}
/*
- (IBAction)personalPosts:(id)sender {
   // [self initalizeTableView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self loadPersonalPosts];
    }
 */
//initalize personal posts tableview
-(void)initalizeTableView{
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    CGRect tableViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    [self presentInvisibleView];
    self.personalPostsTableView = [[UITableView alloc] initWithFrame:CGRectMake(widthFrame/2, heightFrame/2, 0, 0) style:UITableViewStylePlain];

        self.personalPostsTableView.frame = tableViewSize;
   
    self.personalPostsPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.personalPostsTableView addGestureRecognizer:self.personalPostsPinchGesture];
    
    self.personalPostsTableView.delegate = self;
    self.personalPostsTableView.dataSource = self;
    self.personalPostsTableView.backgroundColor = [UIColor whiteColor];
    self.personalPostsTableView.rowHeight = (widthFrame/2)+130;
    
    self.personalPostsTableView.userInteractionEnabled = YES;
    self.personalPostsTableView.bounces = YES;
    
    [self.personalPostsTableView registerClass:[personalPostsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.navigationController.view addSubview:self.personalPostsTableView];
    [self.personalPostsTableView setSeparatorColor:[UIColor darkGrayColor]];
    
}
//initalize posts Voted On Tableview
-(void)initalizePostsVotedOnTableView{
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    CGRect tableViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    [self presentInvisibleView];
    self.postsVotedOnTableView = [[UITableView alloc] initWithFrame:CGRectMake(widthFrame/2, heightFrame/2, 0, 0) style:UITableViewStylePlain];

        self.postsVotedOnTableView.frame = tableViewSize;
    
    self.postsVotedOnPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.postsVotedOnTableView addGestureRecognizer:self.postsVotedOnPinchGesture];
    self.postsVotedOnTableView.delegate = self;
    self.postsVotedOnTableView.dataSource = self;
    self.postsVotedOnTableView.backgroundColor = [UIColor whiteColor];
    self.postsVotedOnTableView.rowHeight = (widthFrame/2)+130;
    
    self.postsVotedOnTableView.userInteractionEnabled = YES;
    self.postsVotedOnTableView.bounces = YES;
    
    [self.postsVotedOnTableView registerClass:[personalPostsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.navigationController.view addSubview:self.postsVotedOnTableView];
}
//number of sections in tableview, personal, voted on and settings
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
            messageLabel.font = [UIFont systemFontOfSize:20];
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
            messageLabel.font = [UIFont systemFontOfSize:20];
            [messageLabel sizeToFit];
            self.postsVotedOnTableView.backgroundView = messageLabel;
            self.postsVotedOnTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    if(tableView == self.settingsTableview) {
        return 5;
    }
    return 0;
}
//number of rows in tableview for personal, voted on and settings
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.personalPostsTableView){
    return [self.personalPostsArray count];
    }
    if(tableView == self.postsVotedOnTableView){
        return [self.postsVotedOnArray count];
    }
    if(tableView == self.settingsTableview) {
        if(section == 0) {
            return 1;
        }
        if(section == 1) {
            return 1;
        }
        if(section == 2){
            return 2;
        }
        if(section == 3) {
            return 2;
        }
        if(section == 4) {
            return 1;
        }
        return 0;
    }
    else {
        return 0;
    }
}
//tittle header for settings tableview
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.settingsTableview) {
        if(section == 0) {
            return @"instructions";
        }
        if(section == 1) {
            return @"share";
        }
        if(section == 2) {
            return @"find us on social media";
        }
        if(section == 3) {
            return @"contact us";
        }
        if(section == 4) {
            return @"logout";
        }
        return @"";
    }
    return @"";
}
//cell for row at index for personal, voted on and settings tableview
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.personalPostsTableView){
        static NSString *cellID = @"cell";
        
        personalPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if(cell == nil) {
            NSLog(@"log");
            cell = [[personalPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }

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
UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
        cell.username = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 10, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.username.textAlignment = NSTextAlignmentCenter;
        cell.username.backgroundColor = [UIColor clearColor];
        cell.username.textColor = redColor;
    cell.username.font = [UIFont boldSystemFontOfSize:20];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
        
        cell.username.adjustsFontSizeToFitWidth = YES;
        cell.username.minimumScaleFactor = 0.5;
        
        cell.username.text = [NSString stringWithFormat:@"%@",usernameObject];
     /*   cell.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 40)];
        cell.locationLabel.textAlignment = NSTextAlignmentCenter;
        cell.locationLabel.backgroundColor = [UIColor clearColor];
        cell.locationLabel.textColor = [UIColor lightGrayColor];
        cell.locationLabel.font = [UIFont systemFontOfSize:15];
        cell.locationLabel.numberOfLines = 0;
        cell.locationLabel.text = @"Victoria BC";
        cell.locationLabel.adjustsFontSizeToFitWidth = YES;
        cell.locationLabel.minimumScaleFactor = 0.5;*/
        

        cell.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 100, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.timeStamp.backgroundColor = [UIColor clearColor];
    cell.timeStamp.textColor = [UIColor lightGrayColor];
    cell.timeStamp.font = [UIFont systemFontOfSize:15];
    cell.timeStamp.textAlignment = NSTextAlignmentCenter;
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
        
        cell.totalVotesLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 40)];
        cell.totalVotesLabel.backgroundColor = [UIColor clearColor];
        cell.totalVotesLabel.textColor = [UIColor darkGrayColor];
        [cell.totalVotesLabel setFont:[UIFont systemFontOfSize:15]];
        cell.totalVotesLabel.textAlignment = NSTextAlignmentCenter;
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
       // [cell.contentView addSubview:cell.locationLabel];
    
    return cell;
    }
    if(tableView == self.postsVotedOnTableView) {
        static NSString *cellID = @"cell";
        
        personalPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if(cell == nil) {
            NSLog(@"log");
            cell = [[personalPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }

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
        UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.username = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 10, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.username.textAlignment = NSTextAlignmentCenter;
        cell.username.backgroundColor = [UIColor clearColor];
        cell.username.textColor = redColor;
        cell.username.font = [UIFont boldSystemFontOfSize:20];
 
        cell.username.adjustsFontSizeToFitWidth = YES;
        cell.username.minimumScaleFactor = 0.5;
        
        cell.username.text = personalPost.username;
    /*    cell.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 40)];
        cell.locationLabel.textAlignment = NSTextAlignmentCenter;
        cell.locationLabel.backgroundColor = [UIColor clearColor];
        cell.locationLabel.textColor = [UIColor lightGrayColor];
        cell.locationLabel.font = [UIFont systemFontOfSize:15];
        cell.locationLabel.numberOfLines = 0;
        cell.locationLabel.text = @"Victoria BC";
        cell.locationLabel.adjustsFontSizeToFitWidth = YES;
        cell.locationLabel.minimumScaleFactor = 0.5;*/
        
        
        cell.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 100, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.timeStamp.backgroundColor = [UIColor clearColor];
        cell.timeStamp.textColor = [UIColor lightGrayColor];
        cell.timeStamp.font = [UIFont systemFontOfSize:15];
        cell.timeStamp.textAlignment = NSTextAlignmentCenter;
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
    
        cell.totalVotesLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 50, (cell.contentView.frame.size.width/2)-15, 30)];
        cell.totalVotesLabel.backgroundColor = [UIColor clearColor];
        cell.totalVotesLabel.textColor = [UIColor darkGrayColor];
        [cell.totalVotesLabel setFont:[UIFont systemFontOfSize:15]];
        cell.totalVotesLabel.textAlignment = NSTextAlignmentCenter;
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
      //  [cell.contentView addSubview:cell.locationLabel];
        [cell.contentView addSubview:cell.votePercentageOneLabel];
        [cell.contentView addSubview:cell.votePercentageTwoLabel];
        [cell.contentView addSubview:cell.totalVotesLabel];
        return  cell;
        
    }
    else {
        UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];

        NSUInteger section = [indexPath indexAtPosition:[indexPath length]-2];
        static NSString *cellID0 = @"cell";
        static NSString *cellID1 = @"cell";
        static NSString *cellID2 = @"cell";
        static NSString *cellID3 = @"cell";
        static NSString *cellID4 = @"cell";
        if(section == 0) {
            UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:cellID0 forIndexPath:indexPath];
            NSString *sectionZeroString = [self.settingsSection0LabelArray objectAtIndex:indexPath.row];
            cell0.textLabel.text = sectionZeroString;
            cell0.textLabel.textColor = [UIColor blackColor];
            cell0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell0;
        }
        if(section == 1) {
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1 forIndexPath:indexPath];
            NSString *sectionOneString = [self.settingsSection1LabelArray objectAtIndex:indexPath.row];
            cell1.textLabel.text = sectionOneString;
            cell1.textLabel.textColor = [UIColor blackColor];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell1;
        }
        if(section == 2) {
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2 forIndexPath:indexPath];
            NSString *sectionOneString = [self.settingsSection2LabelArray objectAtIndex:indexPath.row];
            cell2.textLabel.text = sectionOneString;
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           // UIImage *image = [self.twitterIntstagramImagesArray objectAtIndex:indexPath.row];
           // cell2.imageView.image = image;
        
            
            
            return cell2;
        }
        if(section == 3) {
            UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID3 forIndexPath:indexPath];
            NSString *sectionTwoString = [self.settingsSection3LabelArray objectAtIndex:indexPath.row];
            cell3.textLabel.text = sectionTwoString;
            cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell3;
        }
        else {
            UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:cellID4 forIndexPath:indexPath];
            NSString *sectionThreeString = [self.settingsSection4LaeblArray objectAtIndex:indexPath.row];
            cell4.textLabel.textColor = redColor;
            cell4.textLabel.text = sectionThreeString;
            cell4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            
            return cell4;
        }

        
    }
    
}
//selecting tableview row for personal, voted on and settings tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(tableView == self.personalPostsTableView){
        personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.personalPostsIndexPath = indexPath;
    self.personalPostsTableView.scrollEnabled= NO;
    CGFloat minHeight = CGRectGetMinY(self.personalPostsTableView.bounds);
        self.invisibleViewTableView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
        [self.personalPostsTableView addSubview:self.invisibleViewTableView];
    self.personalPostsViewForImageViews = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
    
    self.personalPostsViewForImageViews.backgroundColor = [UIColor blackColor];
    [self.personalPostsTableView addSubview:self.personalPostsViewForImageViews];
    self.personalPostsPinchGestureImageViews = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.personalPostsViewForImageViews addGestureRecognizer:self.personalPostsPinchGestureImageViews];
   
    
    self.personalPostsImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(self.view.frame.size.height/2), self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageViewOne.image = [self cropImage:cell.tempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageViewOne.userInteractionEnabled = YES;
       [self.personalPostsViewForImageViews addSubview:self.personalPostsImageViewOne];
    self.personalPostsImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.personalPostsTableView.frame.size.height, self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
    self.personalPostsImageViewTwo.image = [self cropImage:cell.tempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.personalPostsTableView.frame.size.height/2)];
        self.personalPostsImageViewTwo.userInteractionEnabled = YES;
    [self.personalPostsViewForImageViews addSubview:self.personalPostsImageViewTwo];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.personalPostsImageViewOne.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
            self.personalPostsImageViewTwo.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
        } completion:^(BOOL finished) {
            self.personalPostsTapGestureToOpenImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
            [self.personalPostsImageViewOne addGestureRecognizer:self.personalPostsTapGestureToOpenImageViewOne];
            
            self.personalPostsTapGestureToOpenImageViewTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
            [self.personalPostsImageViewTwo addGestureRecognizer:self.personalPostsTapGestureToOpenImageViewTwo];

        }];
        
     /*   self.personalPostsTapGestureToOpenImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
        [self.personalPostsImageViewOne addGestureRecognizer:self.personalPostsTapGestureToOpenImageViewOne];
        
        self.personalPostsTapGestureToOpenImageViewTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsTapRecognizer:)];
        [self.personalPostsImageViewTwo addGestureRecognizer:self.personalPostsTapGestureToOpenImageViewTwo];
        */
        
    [self.personalPostsTableView deselectRowAtIndexPath:[self.personalPostsTableView indexPathForSelectedRow] animated:YES];
    }
    if(tableView == self.postsVotedOnTableView){
        personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.postsVotedOnInexPath = indexPath;
         objects *postsVotedOnObject = [self.postsVotedOnArray objectAtIndex:indexPath.row];
        self.postsVotedOnTableView.scrollEnabled = NO;
        CGFloat minHeight = CGRectGetMinY(self.postsVotedOnTableView.bounds);
        self.invisibleViewTableView = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
        [self.postsVotedOnTableView addSubview:self.invisibleViewTableView];
        self.postsVotedOnViewForImageViews = [[UIView alloc] initWithFrame:CGRectMake(0, minHeight, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
        self.postsVotedOnViewForImageViews.backgroundColor = [UIColor blackColor];
        [self.postsVotedOnTableView addSubview:self.postsVotedOnViewForImageViews];
        self.postsVotedOnPinchGestureImageViews = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
        [self.postsVotedOnViewForImageViews addGestureRecognizer:self.postsVotedOnPinchGestureImageViews];
        
        self.postsVotedOnImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(self.view.frame.size.height/2), self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        self.postsVotedOnImageViewOne.image = [self cropImage:cell.tempImageOne cropSize:CGSizeMake(self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        [self.postsVotedOnViewForImageViews addSubview:self.postsVotedOnImageViewOne];
        self.postsVotedOnImageViewOne.userInteractionEnabled = YES;
        self.postsVotedOnImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        self.postsVotedOnImageViewTwo.image = [self cropImage:cell.tempImageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height/2)];
        [self.postsVotedOnViewForImageViews addSubview:self.postsVotedOnImageViewTwo];
        self.postsVotedOnImageViewTwo.userInteractionEnabled = YES;
        
        NSInteger imageVotedFor = [postsVotedOnObject.vote integerValue];
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
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.postsVotedOnImageViewOne.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
            self.postsVotedOnImageViewTwo.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
        } completion:^(BOOL finished) {
            self.postsVotedOnTapGestureToOpenImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnTapRecognizer:)];
            [self.postsVotedOnImageViewOne addGestureRecognizer:self.postsVotedOnTapGestureToOpenImageViewOne];
            self.postsVotedOnTapGestureToOpenImageViewTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnTapRecognizer:)];
            [self.postsVotedOnImageViewTwo addGestureRecognizer:self.postsVotedOnTapGestureToOpenImageViewTwo];
        }];
        
        
        [self.postsVotedOnTableView deselectRowAtIndexPath:[self.postsVotedOnTableView indexPathForSelectedRow] animated:YES];
       
     
    }
    
    if(tableView == self.settingsTableview) {
        NSInteger selectedSection = indexPath.section;
        NSInteger selectedRow = indexPath.row;
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
        NSString *username = [NSString stringWithFormat:@"%@",usernameObject];
        if(selectedSection == 0) {
            if(selectedRow == 0){
                UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                [self.settingsTableview setScrollEnabled:NO];
            [self presentInvisibleView2];
            self.settingsInstructionsView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20)];
                
                [self.settingsInstructionsView setBackgroundColor:[UIColor whiteColor]];
            [self.navigationController.view addSubview:self.settingsInstructionsView];
                
                
                UILabel *instructionsViewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.settingsInstructionsView.frame.size.width-20, 40)];
                instructionsViewTitleLabel.text = @"Instructions";
                instructionsViewTitleLabel.textAlignment = NSTextAlignmentCenter;
                instructionsViewTitleLabel.textColor = redColor;
                instructionsViewTitleLabel.font = [UIFont boldSystemFontOfSize:30];
                [instructionsViewTitleLabel setMinimumScaleFactor:0.5];
                instructionsViewTitleLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:instructionsViewTitleLabel];
                
                UILabel *pinchToCloseCurrentViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.settingsInstructionsView.frame.size.width-20, 30)];
                pinchToCloseCurrentViewLabel.text = @"1. Pinch to Close Current View";
                pinchToCloseCurrentViewLabel.textAlignment = NSTextAlignmentLeft;
                pinchToCloseCurrentViewLabel.textColor = [UIColor blackColor];
                pinchToCloseCurrentViewLabel.font = [UIFont boldSystemFontOfSize:20];
                [pinchToCloseCurrentViewLabel setMinimumScaleFactor:0.5];
                pinchToCloseCurrentViewLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:pinchToCloseCurrentViewLabel];
                
                UILabel *pinchToCloseCurrentViewInstructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.settingsInstructionsView.frame.size.width-20, 30)];
                pinchToCloseCurrentViewInstructionsLabel.text = @"Using your thumb and index finger, press and hold both. Then glide your thumb and index finger towards each other with continuous contact on the screen. Continue this motion until the current view closes.";
                pinchToCloseCurrentViewInstructionsLabel.textAlignment = NSTextAlignmentLeft;
                pinchToCloseCurrentViewInstructionsLabel.textColor = [UIColor blackColor];
                pinchToCloseCurrentViewInstructionsLabel.font = [UIFont systemFontOfSize:15];
                pinchToCloseCurrentViewInstructionsLabel.numberOfLines = 0;
                [pinchToCloseCurrentViewInstructionsLabel sizeToFit];
               // [pinchToCloseCurrentViewInstructionsLabel setMinimumScaleFactor:0.5];
               // pinchToCloseCurrentViewInstructionsLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:pinchToCloseCurrentViewInstructionsLabel];
                CGFloat maxPinchToCloseCurrentViewInstructionLabelHeight = CGRectGetMaxY(pinchToCloseCurrentViewInstructionsLabel.frame);
                
                UILabel *voteForImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxPinchToCloseCurrentViewInstructionLabelHeight+10, self.settingsInstructionsView.frame.size.width-20, 30)];
                voteForImageLabel.text = @"2. Vote for an Image";
                voteForImageLabel.textAlignment = NSTextAlignmentLeft;
                voteForImageLabel.textColor = [UIColor blackColor];
                voteForImageLabel.font = [UIFont boldSystemFontOfSize:20];
                [voteForImageLabel setMinimumScaleFactor:0.5];
                voteForImageLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:voteForImageLabel];
                
                CGFloat maxVoteForImageLabelHeight = CGRectGetMaxY(voteForImageLabel.frame);
                
                UILabel *voteForImageInstructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxVoteForImageLabelHeight+10, self.settingsInstructionsView.frame.size.width-20, 30)];
                voteForImageInstructionsLabel.text = @"Swipe right on the image you want to vote for, releasing it after it has covered half the distance of the screen.";
                voteForImageInstructionsLabel.textAlignment = NSTextAlignmentLeft;
                voteForImageInstructionsLabel.textColor = [UIColor blackColor];
                voteForImageInstructionsLabel.font = [UIFont systemFontOfSize:15];
                voteForImageInstructionsLabel.numberOfLines = 0;
                [voteForImageInstructionsLabel sizeToFit];
                [self.settingsInstructionsView addSubview:voteForImageInstructionsLabel];
                
                CGFloat maxVoteForImageInstructionLabelHeight = CGRectGetMaxY(voteForImageInstructionsLabel.frame);
                
                UILabel *uploadPostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxVoteForImageInstructionLabelHeight+10, self.settingsInstructionsView.frame.size.width-20, 30)];
                uploadPostLabel.text = @"3. Upload a thisThat Post";
                uploadPostLabel.textAlignment = NSTextAlignmentLeft;
                uploadPostLabel.textColor = [UIColor blackColor];
                uploadPostLabel.font = [UIFont boldSystemFontOfSize:20];
                [uploadPostLabel setMinimumScaleFactor:0.5];
                uploadPostLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:uploadPostLabel];
                
                CGFloat maxUploadPostLabelHeight = CGRectGetMaxY(uploadPostLabel.frame);
                
                UILabel *uploadPostInstructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxUploadPostLabelHeight+10, self.settingsInstructionsView.frame.size.width-20, 30)];
                uploadPostInstructionsLabel.text = @"To upload a thisThat, you must select two images. These images can be selected from your photo library or taken in the moment. You can also add optional text to describe the images you are comparing. The preview button allows you to see your thisThat post as other users will view it. After selecting the upload button, you will be informed when your post is uploaded successfully.";
                uploadPostInstructionsLabel.textAlignment = NSTextAlignmentLeft;
                uploadPostInstructionsLabel.textColor = [UIColor blackColor];
                uploadPostInstructionsLabel.font = [UIFont systemFontOfSize:15];
                uploadPostInstructionsLabel.numberOfLines = 0;
                [uploadPostInstructionsLabel sizeToFit];
                [self.settingsInstructionsView addSubview:uploadPostInstructionsLabel];
                
                CGFloat maxUploadPostInstructionLabelHeight = CGRectGetMaxY(uploadPostInstructionsLabel.frame);
                
                UILabel *haveFunLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxUploadPostInstructionLabelHeight+10, self.settingsInstructionsView.frame.size.width-20, 30)];
                haveFunLabel.text = @"Have fun - thisThat Crew";
                haveFunLabel.textAlignment = NSTextAlignmentCenter;
                haveFunLabel.textColor = redColor;
                haveFunLabel.font = [UIFont boldSystemFontOfSize:20];
                [haveFunLabel setMinimumScaleFactor:0.5];
                haveFunLabel.adjustsFontSizeToFitWidth = YES;
                [self.settingsInstructionsView addSubview:haveFunLabel];
                
                CGFloat maxHaveFunLabelHeight = CGRectGetMaxY(haveFunLabel.frame);
                
                
            UIButton *closeSettingsInstructionViewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.settingsInstructionsView.frame.size.width-60, maxHaveFunLabelHeight+10, 50, 30)];
            closeSettingsInstructionViewButton.backgroundColor = [UIColor blackColor];
            [closeSettingsInstructionViewButton setTitle:@"Close" forState:UIControlStateNormal];
            [closeSettingsInstructionViewButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [closeSettingsInstructionViewButton.titleLabel setMinimumScaleFactor:0.5];
            closeSettingsInstructionViewButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.settingsInstructionsView addSubview:closeSettingsInstructionViewButton];
            [closeSettingsInstructionViewButton addTarget:self action:@selector(closeSettingsInstructionViewAction:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat maxButtonHeight = CGRectGetMaxY(closeSettingsInstructionViewButton.frame);
                [self.settingsInstructionsView sizeToFit];
                self.settingsInstructionsView.frame = CGRectMake(0, 0, self.view.frame.size.width-20, maxButtonHeight+10);
                self.settingsInstructionViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20)];
                self.settingsInstructionViewScrollView.delegate = self;
                self.settingsInstructionViewScrollView.scrollEnabled = YES;
                self.settingsInstructionViewScrollView.bounces = NO;
                self.settingsInstructionViewScrollView.userInteractionEnabled = YES;
                self.settingsInstructionViewScrollView.contentSize = CGSizeMake(self.view.frame.size.width-20, maxButtonHeight+20);
                [self.navigationController.view addSubview:self.settingsInstructionViewScrollView];
                [self.settingsInstructionViewScrollView addSubview:self.settingsInstructionsView];
                
            }
        }
        if(selectedSection == 1) {
            if(selectedRow == 0) {
                if([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] initWithNibName:nil bundle:nil];
                    [composeViewController setMessageComposeDelegate:self];
                    [composeViewController setBody:@"Come join me on thisThat, http://itunes.com/apps/thisThat"];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                    
                }
                
            }
        }
        if(selectedSection == 2){
            if(selectedRow == 0){
                //instagram
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://instagram.com"]];
            }
            if(selectedRow == 1) {
                //twitter
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com"]];
            }
        }
        if(selectedSection == 3){
            if(selectedRow == 0){
                //thisThat website
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://local-app.co:1337"]];
                
            }
            if(selectedRow == 1){
                //suggestions
                if([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                    [composeViewController setMailComposeDelegate:self];
                    [composeViewController setToRecipients:@[@"thisthatapplication@gmail.com"]];
                    NSString *subjectString = [NSString stringWithFormat:@"Suggestions/Report a problem, user: %@",username];
                    [composeViewController setSubject:subjectString];
                    [composeViewController setMessageBody:@"I have a suggestion for thisThat..." isHTML:YES];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                    
                }
            }
           /* if(selectedRow == 2) {
                //report a problem
                if([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                    [composeViewController setMailComposeDelegate:self];
                    [composeViewController setToRecipients:@[@"reportAProblem@thisThat.me"]];
                    NSString *subjectString = [NSString stringWithFormat:@"Report a problem, user: %@",username];
                    [composeViewController setSubject:subjectString];
                    [composeViewController setMessageBody:@"I would like to report a problem..." isHTML:YES];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                    
                }
                
                
            }*/
           /* if(selectedRow == 3){
                //delete account
                if([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                    [composeViewController setMailComposeDelegate:self];
                    [composeViewController setToRecipients:@[@"deleteAccount@thisThat.me"]];
                    NSString *subjectString = [NSString stringWithFormat:@"Delete account, user: %@",username];
                    [composeViewController setSubject:subjectString];
                    [composeViewController setMessageBody:@"I would like to delete my account because..." isHTML:YES];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                    
                }
                
                
            }*/
        }
        if(selectedSection == 4){
            if(selectedRow == 0){
                //logout
                
                [self logoutAction];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
        }
        
        
        [self.settingsTableview deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

        
    }

}
-(void)closeSettingsInstructionViewAction:(UIButton*)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.settingsTableview setScrollEnabled:YES];
    [self.settingsInstructionsView removeFromSuperview];
    [self.settingsInstructionViewScrollView removeFromSuperview];
    [self.invisibleView2 removeFromSuperview];
}
//logout action from settings tableview
-(void)logoutAction {
    
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSDictionary *parameters = @{@"token" : userTokenObject};
    
    [[RKObjectManager sharedManager] postObject:nil path:@"/api/v1/auth/logout" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
        NSLog(@"errorSuggestion:%@",[error localizedRecoverySuggestion]);
        NSLog(@"errorOptions:%@",[error localizedRecoveryOptions]);
        NSLog(@"errorReason:%@",[error localizedFailureReason]);
        NSLog(@"errorDescription:%@",[error localizedDescription]);
        
    }];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIDString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    userTokenObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@\nUsername = %@\n",currentIDObject,userTokenObject,usernameObject);
    
    
    LoginScreen *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    [self presentViewController:loginVC animated:YES completion:nil];
    [self.settingsView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    [self.invisibleView removeFromSuperview];

}
//dismissing new mail message from settings tableview
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//dismissing new text message view controller from settings tableview
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//personal posts tap gesture to see fullsize imageview
-(void)personalPostsTapRecognizer:(UITapGestureRecognizer*)recognize {
    personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[self.personalPostsTableView cellForRowAtIndexPath:self.personalPostsIndexPath];
    self.personalPostsViewForFullSizeImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.personalPostsTableView.frame.size.height)];
    self.personalPostsViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.personalPostsViewForImageViews addSubview:self.personalPostsViewForFullSizeImageView];
    if(recognize == self.personalPostsTapGestureToOpenImageViewOne){
    
        self.personalPostsFullSizeImageView = [self inputImage:cell.tempImageOne];
        [self.personalPostsViewForFullSizeImageView addSubview:self.personalPostsFullSizeImageView];
    }
    if(recognize == self.personalPostsTapGestureToOpenImageViewTwo){
        self.personalPostsFullSizeImageView = [self inputImage:cell.tempImageTwo];
        [self.personalPostsViewForFullSizeImageView addSubview:self.personalPostsFullSizeImageView];
    }
    self.personalPostsFullSizeImageView.userInteractionEnabled = YES;
    self.personalPostsTapGestureToCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalPostsCloseFullSizeImage:)];
    [self.personalPostsFullSizeImageView addGestureRecognizer:self.personalPostsTapGestureToCloseFullSizeImageView];
    self.personalPostsPanToZoomInOnFullSizeImageView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToZoomInOnFullSizeImageView:)];
    [self.personalPostsFullSizeImageView addGestureRecognizer:self.personalPostsPanToZoomInOnFullSizeImageView];
    
}
-(void)personalPostsCloseFullSizeImage:(UITapGestureRecognizer*)recognize {
    NSLog(@"logging");
    [self.personalPostsViewForFullSizeImageView removeFromSuperview];

}
//posts voted on tap gesture to see fullsize imageview
-(void)postsVotedOnTapRecognizer:(UITapGestureRecognizer*)recognize {
    personalPostsTableViewCell *cell = (personalPostsTableViewCell*)[self.postsVotedOnTableView cellForRowAtIndexPath:self.postsVotedOnInexPath];
    
    self.postsVotedOnViewForFullSizeImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.postsVotedOnTableView.frame.size.height)];
    self.postsVotedOnViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.postsVotedOnViewForImageViews addSubview:self.postsVotedOnViewForFullSizeImageView];
    if(recognize == self.postsVotedOnTapGestureToOpenImageViewOne){
        self.postsVotedOnFullSizeImageView = [self inputImage:cell.tempImageOne];
        [self.postsVotedOnViewForFullSizeImageView addSubview:self.postsVotedOnFullSizeImageView];
        
    }
    if(recognize == self.postsVotedOnTapGestureToOpenImageViewTwo){
        self.postsVotedOnFullSizeImageView = [self inputImage:cell.tempImageTwo];
        [self.postsVotedOnViewForFullSizeImageView addSubview:self.postsVotedOnFullSizeImageView];
    }
    self.postsVotedOnFullSizeImageView.userInteractionEnabled = YES;
    self.postsVotedOnTapCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postsVotedOnCloseFullSizeImage:)];
    [self.postsVotedOnFullSizeImageView addGestureRecognizer:self.postsVotedOnTapCloseFullSizeImageView];
    
    self.postsVotedOnPanToZoomInOnFullSizeImageView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToZoomInOnFullSizeImageView:)];
    [self.postsVotedOnFullSizeImageView addGestureRecognizer:self.postsVotedOnPanToZoomInOnFullSizeImageView];
}
-(void)postsVotedOnCloseFullSizeImage:(UITapGestureRecognizer*)recognize {
    [self.postsVotedOnViewForFullSizeImageView removeFromSuperview];
}
// allowing personal posts tableview to be edited for slide to delete
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.personalPostsTableView){
        return YES;
    }
    else {
        return NO;
    }
}
//slide to delete on personal posts tabelview
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.personalPostsTableView){
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        if([self.personalPostsArray count] == 1) {
            NSLog(@"YPPP");
            objects *personalPost = [self.personalPostsArray objectAtIndex:indexPath.row];
            [self.personalPostsArray removeObjectAtIndex:indexPath.row];
            [self.personalPostsTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
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
            [self.invisibleView removeFromSuperview];

        }
        if([self.personalPostsArray count] > 1) {
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
}
// upload post text view begin editing

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  /*  if([self.uploadPostTextView.text isEqualToString:@"What are you comparing?"]) {
        self.uploadPostTextView.text = @"";
    }*/
    [self.uploadPostTextViewPlaceHolderLabel setHidden:YES];
   
    return YES;
}
//upload post text view end edditing
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
   /* if([self.uploadPostTextView.text isEqualToString:@""]){
        self.uploadPostTextView.text = @"What are you comparing?";
    } else {
        self.uploadPostTextViewString = self.uploadPostTextView.text;       
    }*/
    if([self.uploadPostTextView.text isEqualToString:@""]){
        [self.uploadPostTextViewPlaceHolderLabel setHidden:NO];
    } else {
        self.uploadPostTextViewString = self.uploadPostTextView.text;
    }
    
    return YES;
}

//setting maximum number of charcters in upload text to 100
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound) {
        NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        return !([newString length] >80);
    }
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGFloat viewHeight = self.view.frame.size.height;
        CGFloat viewWidth = self.view.frame.size.width;
        CGFloat heightOfCell = (viewWidth/2) + 130;
        CGFloat heighOfInstructionsLabel = (viewHeight/2)-(heightOfCell/2);
        
        self.uploadPostExampleTableViewCellView.frame = CGRectMake(0, (viewHeight/2)-(heightOfCell/2), viewWidth, (viewWidth/2)+130);
        self.uploadPostInstructionsLabel.frame = CGRectMake(10, (heighOfInstructionsLabel/2)-15, viewWidth-20, 30);
        
    } completion:^(BOOL finished) {
        self.uploadPostCameraButtonOne.enabled = YES;
        self.uploadPostCameraButtonTwo.enabled = YES;
        
    }];
    return NO;
}


//determingin which camera button was pressed for imagepicker and initalizing imagepicker
-(void)takePhotoButtonPressed:(UIButton*)button {
    
    
    if(button == self.uploadPostCameraButtonOne){
        self.selectedCameraInt = 1;
        NSLog(@"buttonOnePressed");
    }
    if(button == self.uploadPostCameraButtonTwo){
        self.selectedCameraInt = 2;
        NSLog(@"buttonTwoPressed");
    }
    self.imagePicker =[[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    type = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.sourceType = type;
    self.imagePicker.delegate = self;
    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    self.uploadPostLibraryPhotosButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75,5, 150, 30)];
    [self.uploadPostLibraryPhotosButton setTitle:@"Photo Library" forState:UIControlStateNormal];
    [self.uploadPostLibraryPhotosButton addTarget:self action:@selector(photoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    self.imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.imagePicker.toolbarHidden = YES;
    [self.imagePicker.view addSubview:self.uploadPostLibraryPhotosButton];


   // [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
    [self presentViewController:self.imagePicker animated:YES completion:nil];

    
        
    
   
}
//initalize photolibary to choose photos from
-(void)photoLibrary:(UIButton*)recognize {
    UIImagePickerControllerSourceType type;
    type = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.sourceType = type;
}
//returning image whether it is captured or picked from library
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.uploadPostLibraryPhotosButton setHidden:YES];
    if(self.selectedCameraInt == 1) {
        NSLog(@"YOLOONE");
        self.uploadPostTempImageOne = [[UIImage alloc] init];
        self.uploadPostTempImageOne = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[self.uploadPostCameraButtonOne imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [self.uploadPostCameraButtonOne setImage:self.uploadPostTempImageOne forState:UIControlStateNormal];
        [self.uploadPostCameraButtonOne setImage:self.uploadPostTempImageOne forState:UIControlStateDisabled];
        [self.uploadPostCameraButtonOne setTitle:@"" forState:UIControlStateNormal];
    }
    if(self.selectedCameraInt == 2){
        NSLog(@"YOLOTWO");
        self.uploadPostTempImageTwo = [[UIImage alloc] init];
        self.uploadPostTempImageTwo = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[self.uploadPostCameraButtonTwo imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [self.uploadPostCameraButtonTwo setImage:self.uploadPostTempImageTwo forState:UIControlStateNormal];
        [self.uploadPostCameraButtonTwo setImage:self.uploadPostTempImageTwo forState:UIControlStateDisabled];
        [self.uploadPostCameraButtonTwo setTitle:@"" forState:UIControlStateNormal];
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.uploadPostTempImageOne != nil && self.uploadPostTempImageTwo != nil) {
        [self.uploadPostPreviewButton setHidden:NO];
        [self.uploadPostButton setHidden:NO];
    }
    
}
//open newsfeed action
-(void)feedButtonAction:(UIButton*)sender {
    UIImage *feedIcon = [UIImage imageNamed:@"newsFeedIconWhite.png"];
    [self.feedButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
    [self.feedImageButton setImage:feedIcon forState:UIControlStateNormal];
    
    [self presentLoadingView];
    [self loadNewsFeedArray];
}
/*
- (IBAction)newsFeed:(id)sender {
    [self presentLoadingView];
    [self loadNewsFeedArray];

}*/
// news feed menu button to animate pictures to see text below it
-(void)menuButtonSelected:(UIButton*)recognize{
        [self.newsFeedPanGestureImageViewOne setEnabled:NO];
        [self.newsFeedPanGestureImageViewTwo setEnabled:NO];
        [self.newsFeedTapGestureToOpenImageViewOne setEnabled:NO];
        [self.newsFeedTapGestureToOpenImageViewTwo setEnabled:NO];
        [self.newsFeedYellowMenuButton setAlpha:0];
        [self.newsFeedViewForLabels setAlpha:1];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.newsFeedImageViewOne.frame =CGRectMake(0, -115, [self viewWidth], [self viewHeight]/2);
        self.newsFeedImageViewTwo.frame = CGRectMake(0, ([self viewHeight]/2)+115, [self viewWidth], [self viewHeight]/2);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *closeMenu = [[UITapGestureRecognizer alloc] init];
        [closeMenu addTarget:self action:@selector(closeMenuSelector:)];
        [self.newsFeedView addGestureRecognizer:closeMenu];
    
    }];
    
}
//news feed animate pictures to close to hide text
-(void)closeMenuSelector:(UITapGestureRecognizer*)recognize{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.newsFeedImageViewOne.frame =CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
        self.newsFeedImageViewTwo.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
        
    } completion:^(BOOL finished) {
        [self.newsFeedYellowMenuButton setAlpha:1.0];
        [self.newsFeedView removeGestureRecognizer:recognize];
        [self.newsFeedPanGestureImageViewOne setEnabled:YES];
        [self.newsFeedPanGestureImageViewTwo setEnabled:YES];
        [self.newsFeedTapGestureToOpenImageViewOne setEnabled:YES];
        [self.newsFeedTapGestureToOpenImageViewTwo setEnabled:YES];
        [self.newsFeedViewForLabels setAlpha:0];
    }];
    
}
//news feed tap gesture to see fullsize image view
-(void)recognizeTapToOpenImages:(UITapGestureRecognizer*)recognize {
    
    self.newsFeedViewForFullSizeImageView = [[UIView alloc] initWithFrame:self.view.frame];
    self.newsFeedViewForFullSizeImageView.backgroundColor = [UIColor blackColor];
    [self.newsFeedView addSubview:self.newsFeedViewForFullSizeImageView];
    self.newsFeedFullSizeImageView = [[UIImageView alloc] init];
    
    if(recognize == self.newsFeedTapGestureToOpenImageViewOne){
    self.newsFeedFullSizeImageView = [self inputImage:self.newsFeedTempImageOne];
    [self.newsFeedViewForFullSizeImageView addSubview:self.newsFeedFullSizeImageView];
    }
    if(recognize == self.newsFeedTapGestureToOpenImageViewTwo){
        self.newsFeedFullSizeImageView = [self inputImage:self.newsFeedTempImageTwo];
        [self.newsFeedViewForFullSizeImageView addSubview:self.newsFeedFullSizeImageView];
    }
    self.newsFeedFullSizeImageView.userInteractionEnabled = YES;
    self.newsFeedTapGestureToCloseFullSizeImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullSizeView:)];
    [self.newsFeedViewForFullSizeImageView addGestureRecognizer:self.newsFeedTapGestureToCloseFullSizeImageView];
    
    self.newsFeedPanToZoomInOnFullSizeImageView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToZoomInOnFullSizeImageView:)];
    [self.newsFeedFullSizeImageView addGestureRecognizer:self.newsFeedPanToZoomInOnFullSizeImageView];
    
}
-(void)closeFullSizeView:(UITapGestureRecognizer *)recognize {
    [self.newsFeedViewForFullSizeImageView removeFromSuperview];
}


// ****************************************************************************************************
// Pinch Recognizer closing views

-(void)recognizePinchToCloseCurrentView:(UIPinchGestureRecognizer *)recognize {
    
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)recognize scale];
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
           
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (factor < 1) {
                if(recognize == self.newsFeedPinchGesture){
                self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            }
                if(recognize == self.uploadPostPinchGesture){
                    self.uploadPostView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.uploadPostPinchGestureImageViews){
                    self.uploadPostViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.personalPostsPinchGestureImageViews) {
                    self.personalPostsViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.personalPostsPinchGesture) {
                    self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);

                }
                if(recognize == self.postsVotedOnPinchGesture) {
                    self.postsVotedOnTableView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                    
                }
                if(recognize == self.postsVotedOnPinchGestureImageViews){
                    self.postsVotedOnViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchToCloseLoadingView){
                    self.loadingView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
                if(recognize == self.pinchRecognizerSettingsView){
                    self.settingsView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
                }
            }
            if(factor < 0.45) {
                if(recognize == self.newsFeedPinchGesture){
                   [self.newsFeedView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

                }
                if(recognize == self.uploadPostPinchGesture){
                    [self.uploadPostView removeFromSuperview];
                    [self.invisibleView2 removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    self.uploadPostTextViewString = nil;
                    self.uploadPostTempImageOne = nil;
                    self.uploadPostTempImageTwo = nil;

                }
                if(recognize == self.uploadPostPinchGestureImageViews){
                    [self.uploadPostViewForImageViews removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [self.invisibleView2 removeFromSuperview];
                    

                }
                if(recognize == self.personalPostsPinchGestureImageViews){
                    [self.personalPostsViewForImageViews removeFromSuperview];
                    [self.invisibleViewTableView removeFromSuperview];
                    self.personalPostsTableView.scrollEnabled = YES;
                }
                if(recognize == self.personalPostsPinchGesture){
                    [self.personalPostsTableView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

                }
                if(recognize == self.postsVotedOnPinchGesture){
                    [self.postsVotedOnTableView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    
                }
                if(recognize == self.postsVotedOnPinchGestureImageViews){
                    [self.postsVotedOnViewForImageViews removeFromSuperview];
                    [self.invisibleViewTableView removeFromSuperview];
                    self.postsVotedOnTableView.scrollEnabled = YES;
                }
                if(recognize == self.pinchToCloseLoadingView){
                    [self.loadingView removeFromSuperview];
                    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    
                }
                if(recognize == self.pinchRecognizerSettingsView){
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    [self.settingsView removeFromSuperview];
                    [self.invisibleView removeFromSuperview];
                }
                            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if(factor > 0.45) {
                if(recognize == self.newsFeedPinchGesture){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.uploadPostPinchGesture){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.uploadPostView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }
                if(recognize == self.uploadPostPinchGestureImageViews){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.uploadPostViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.personalPostsPinchGestureImageViews){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.personalPostsViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                    
                    }];
                }
                if(recognize == self.personalPostsPinchGesture){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.personalPostsTableView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.postsVotedOnPinchGesture){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.postsVotedOnTableView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.postsVotedOnPinchGestureImageViews){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.postsVotedOnViewForImageViews.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchToCloseLoadingView){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.loadingView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                if(recognize == self.pinchRecognizerSettingsView){
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.settingsView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                    } completion:^(BOOL finished) {
                        
                    }];
                }

                
            }
        }
        default:
            break;
    
}
    }
//pinch gesture personalposts needs to be moved with rest of pinch gestures
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
               // [self.personalPostsButton setEnabled:YES];
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
// Pan Recognizer Image Current in news feed for voting

-(void)recognizeThePanImageCurrent:(UIPanGestureRecognizer *)recognize {
    CGFloat widthFrame = CGRectGetWidth(self.newsFeedView.frame);
    CGFloat heightFrame = CGRectGetHeight(self.newsFeedView.frame);

   
    CGFloat imageViewOneCurrentMinX = CGRectGetMinX(self.newsFeedImageViewOne.frame);
    CGFloat imageViewTwoCurrentMinX = CGRectGetMinX(self.newsFeedImageViewTwo.frame);
    CGFloat viewControllerMaxX = CGRectGetMaxX(self.view.frame);
    CGFloat viewControllerMinX = CGRectGetMinX(self.view.frame);
 
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            [self.newsFeedYellowMenuButton setAlpha:0];
            if(recognize == self.newsFeedPanGestureImageViewOne){
            [self.newsFeedPanGestureImageViewTwo setEnabled:NO];
                [self.newsFeedTapGestureToOpenImageViewTwo setEnabled:NO];
            }
            if(recognize == self.newsFeedPanGestureImageViewTwo){
                [self.newsFeedPanGestureImageViewOne setEnabled:NO];
                [self.newsFeedTapGestureToOpenImageViewOne setEnabled:NO];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint currentPoint = [recognize translationInView:self.newsFeedView];
            if(recognize == self.newsFeedPanGestureImageViewOne){
            recognize.view.center = CGPointMake(recognize.view.center.x + currentPoint.x, recognize.view.center.y);
            [recognize setTranslation:CGPointMake(0, 0) inView:self.newsFeedView];
            self.newsFeedImageViewTwo.center = CGPointMake(-recognize.view.center.x + currentPoint.x + widthFrame, recognize.view.center.y + heightFrame/2);
                if(imageViewOneCurrentMinX > viewControllerMinX){//vote for image 1
                    
                    CGFloat minXView = CGRectGetMinX(self.newsFeedImageViewOne.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    [self.newsFeedVoteForThisImageView setAlpha:alphaValue2];
                    [self.newsFeedNotThatImageView setAlpha:alphaValue2];
                            
                   
                    [self.newsFeedImageOneCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                }
             /*   if(imageViewOneCurrentMinX == viewControllerMinX){
                  
                }*/
                if(imageViewTwoCurrentMinX > viewControllerMinX){//vote for image 2
                   
                    CGFloat minXView = CGRectGetMinX(self.newsFeedImageViewTwo.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    
                    [self.newsFeedNotThisImageView setAlpha:alphaValue2];
                    [self.newsFeedVoteForThatImageView setAlpha:alphaValue2];
                    [self.newsFeedImageOneXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                }
        }
            if(recognize == self.newsFeedPanGestureImageViewTwo){
                recognize.view.center = CGPointMake(recognize.view.center.x + currentPoint.x, recognize.view.center.y);
                [recognize setTranslation:CGPointZero inView:self.newsFeedView];
                self.newsFeedImageViewOne.center = CGPointMake(-recognize.view.center.x + currentPoint.x + widthFrame, recognize.view.center.y - heightFrame/2);
                if(imageViewOneCurrentMinX > viewControllerMinX){// vote for image 1
                    CGFloat minXView = CGRectGetMinX(self.newsFeedImageViewOne.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    
                    
                    [self.newsFeedVoteForThisImageView setAlpha:alphaValue2];
                    [self.newsFeedNotThatImageView setAlpha:alphaValue2];
                    [self.newsFeedImageOneCheckMarkView setAlpha:alphaValue];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:alphaValue];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    
                                   }
                if(imageViewTwoCurrentMinX > viewControllerMinX){// vote for image 2
                    CGFloat minXView = CGRectGetMinX(self.newsFeedImageViewTwo.frame);
                    CGFloat viewWdith = CGRectGetWidth(self.view.frame);
                    CGFloat alphaValue = [self minXImageView:minXView viewWdith:viewWdith];
                    CGFloat alphaValue2 = [self newMinXImageView:minXView newViewWdith:viewWdith];
                    [self.newsFeedNotThisImageView setAlpha:alphaValue2];
                    [self.newsFeedVoteForThatImageView setAlpha:alphaValue2];
                    
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
            [self.newsFeedPanGestureImageViewOne setEnabled:YES];
            [self.newsFeedPanGestureImageViewTwo setEnabled:YES];
            [self.newsFeedTapGestureToOpenImageViewOne setEnabled:YES];
            [self.newsFeedTapGestureToOpenImageViewTwo setEnabled:YES];
            // VOTE FOR IMAGE ONE
            if(imageViewOneCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 1;
                [self voteForImage];
                [self.newsFeedVoteForThisImageView setAlpha:1];
                [self.newsFeedNotThatImageView setAlpha:1];
                    CGFloat velocityX = fabsf([recognize velocityInView:self.newsFeedImageViewOne].x);
                NSLog(@"\nvelcotity:%f",velocityX);
                    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
                    CGFloat distanceToOffScreen = fabsf(viewWidth - imageViewOneCurrentMinX);
                    NSTimeInterval timeRemainingToOffScreen = distanceToOffScreen/velocityX;
                
                if(timeRemainingToOffScreen > 0.5) {
                    timeRemainingToOffScreen = 0.5;
                }
      
                
                [UIView animateWithDuration:timeRemainingToOffScreen delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.newsFeedImageViewOne.frame = CGRectMake(widthFrame, 0, widthFrame, heightFrame/2);
                    self.newsFeedImageViewTwo.frame = CGRectMake(-widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                    
                } completion:^(BOOL finished) {
                    //[self loadImagesAfterSwipe];
                    [self imagesAreDonePreLoading];
                    self.newsFeedImageViewOne.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.newsFeedImageViewTwo.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [self.newsFeedVoteForThisImageView setAlpha:0];
                        [self.newsFeedNotThatImageView setAlpha:0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.newsFeedImageViewOne.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                            self.newsFeedImageViewTwo.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                            
                        } completion:^(BOOL finished) {
                            [self.newsFeedYellowMenuButton setAlpha:1.0];
                            
                        }];

                        
                    }];
                    
                    }];
                
                
            }
            //VOTE FOR IMAGE TWO
            if(imageViewTwoCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 2;
                [self voteForImage];
                [self.newsFeedNotThisImageView setAlpha:1];
                [self.newsFeedVoteForThatImageView setAlpha:1];
                CGFloat velocityX = fabsf([recognize velocityInView:self.newsFeedImageViewTwo].x);
                NSLog(@"\nvelcotity:%f",velocityX);
                CGFloat viewWidth = CGRectGetWidth(self.view.frame);
                CGFloat distanceToOffScreen = fabsf(viewWidth - imageViewTwoCurrentMinX);
                NSTimeInterval timeRemainingToOffScreen = distanceToOffScreen/velocityX;
                
                if(timeRemainingToOffScreen > 0.5) {
                    timeRemainingToOffScreen = 0.5;
                }
                
                [UIView animateWithDuration:timeRemainingToOffScreen delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.newsFeedImageViewOne.frame = CGRectMake(-widthFrame, 0, widthFrame, heightFrame/2);
                    self.newsFeedImageViewTwo.frame = CGRectMake(widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                } completion:^(BOOL finished) {
                    //[self loadImagesAfterSwipe];
                    [self imagesAreDonePreLoading];
                    self.newsFeedImageViewOne.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.newsFeedImageViewTwo.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [self.newsFeedNotThisImageView setAlpha:0];
                        [self.newsFeedVoteForThatImageView setAlpha:0];
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            self.newsFeedImageViewOne.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                            self.newsFeedImageViewTwo.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                        } completion:^(BOOL finished) {
                            [self.newsFeedYellowMenuButton setAlpha:1.0];
                            
                        }];
                    }];
                    
                    
                    
                }];
               
            }
            if(imageViewOneCurrentMinX < 5*(viewControllerMaxX/10) && imageViewTwoCurrentMinX < 5*(viewControllerMaxX/10)){
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.newsFeedImageViewOne.frame = CGRectMake(0, 0, widthFrame, heightFrame/2);
                    self.newsFeedImageViewTwo.frame = CGRectMake(0, heightFrame/2, widthFrame, heightFrame/2);
         
                    [self.newsFeedVoteForThisImageView setAlpha:0];
                    [self.newsFeedNotThatImageView setAlpha:0];
                    [self.newsFeedNotThisImageView setAlpha:0];
                    [self.newsFeedVoteForThatImageView setAlpha:0];
                    [self.newsFeedImageOneCheckMarkView setAlpha:0];
                    [self.newsFeedImageOneXMarkView setAlpha:0];
                    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
                    [self.newsFeedImageTwoXMarkView setAlpha:0];
                } completion:^(BOOL finished) {

                    [self.newsFeedYellowMenuButton setAlpha:1.0];
                }];
            }

        }
    }
    
}
//returning alpha value for opacity depending on amount panned
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
//second alpha value for opacity
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
// news feed get request

-(void)loadNewsFeedArray{
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/?access_token=%@",userDefaultObject];
//    NSString *fullURL = [NSString stringWithFormat:@"http://local-app.co:1337%@",tokenIDString];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.newsFeedArray = [mappingResult.array mutableCopy];
        
       
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
// personal posts get request

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
// posts voted on get request

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
//resizing fullsize image to fit screen
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

//determing vote count percentage
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

//BLUR image unused
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

//preload newsfeed images
-(void)preLoadImages {
   
    
    self.newsFeedImageOneDictionary = [[NSMutableDictionary alloc] init];
    self.newsFeedImageTwoDictionary = [[NSMutableDictionary alloc] init];

    if([self.newsFeedArray count] > 0){
    dispatch_group_t group = dispatch_group_create();
 
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
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.loadingView removeFromSuperview];
        NSLog(@"complete");
        NSLog(@"\nimageOneDict:%@\nimageTwoDict:%@",self.newsFeedImageOneDictionary,self.newsFeedImageTwoDictionary);
       
        [self imagesAreDonePreLoading];

    });
    }
    else {
        NSLog(@"no contents to load");
    }

}
//images are done preloading, show them
-(void)imagesAreDonePreLoading{
    NSLog(@"\nnewsFeedCounter:%d\nnewsFeedDicCount:%d",self.newsFeedCounter,[self.newsFeedImageOneDictionary count]);
    if(self.newsFeedCounter < [self.newsFeedImageOneDictionary count]) {
        objects *newsFeedObject = [self.newsFeedArray objectAtIndex:self.newsFeedCounter];
        NSString *imageOneKey = [NSString stringWithFormat:@"imageOneIndex:%d",self.newsFeedCounter];
        NSString *imageTwoKey = [NSString stringWithFormat:@"imageTwoIndex:%d",self.newsFeedCounter];
        UIImage *imageOne = [[UIImage alloc] init];
        imageOne = [self.newsFeedImageOneDictionary objectForKey:imageOneKey];
        UIImage *imageTwo = [[UIImage alloc] init];
        imageTwo = [self.newsFeedImageTwoDictionary objectForKey:imageTwoKey];
        self.newsFeedTempImageOne = imageOne;
        self.newsFeedTempImageTwo = imageTwo;
        CGFloat imageWidth = imageOne.size.width;
        imageWidth = 2*imageWidth;
        CGFloat imageHeight = imageOne.size.height;
        imageHeight = 2*imageHeight;
        imageOne = [UIImage imageWithCGImage:imageOne.CGImage scale:2 orientation:imageOne.imageOrientation];
        

        
        self.newsFeedImageViewOne.image = [self cropImage:imageOne cropSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2)];
        self.newsFeedImageViewTwo.image = [self cropImage:imageTwo cropSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2)];
        self.newsFeedUsernameLabel.text = newsFeedObject.username;
        self.newsFeedTextContentLabel.text = newsFeedObject.textContent;
        self.newsFeedTimeStampLabel.text = [self inputDate:newsFeedObject.createdAt];
    //     NSMutableArray *voteCountArray = [self voteCountOne:newsFeedObject.voteCountOne voteCountTwo:newsFeedObject.voteCountTwo];
   //     self.newsFeedImageViewOnePercentageLabel.text = [voteCountArray objectAtIndex:0];
   //     self.newsFeedImageViewTwoPercentageLabel.text = [voteCountArray objectAtIndex:1];
        self.newsFeedTotalNumberOfVotesLabel.text = [self ForTotalVotesVoteCountOne:newsFeedObject.voteCountOne ForTotalVotesVoteCountTwo:newsFeedObject.voteCountTwo];
        [self.newsFeedImageViewOne setAlpha:1];
        [self.newsFeedImageViewTwo setAlpha:1];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.newsFeedImageViewOne.frame = CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
            self.newsFeedImageViewTwo.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
            
        } completion:^(BOOL finished) {
            [self.newsFeedYellowMenuButton setAlpha:1];
            
        }];

    }
    else {
        //add new request to find posts when finished voting on first 20
        NSLog(@"noContentsToLoad");
       // UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
      
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
        //newSHIT to retrieve mroe
        [self.newsFeedImageOneDictionary removeAllObjects];
        [self.newsFeedImageTwoDictionary removeAllObjects];
        [self.newsFeedArray removeAllObjects];
        [self.newsFeedImageViewOne setAlpha:0];
        [self.newsFeedImageViewTwo setAlpha:0];
        [self.newsFeedYellowMenuButton setAlpha:0];
        self.newsFeedCounter = 0;
        [self presentLoadingView];
        NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
        NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
        NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/?access_token=%@",userDefaultObject];
        
        [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            self.newsFeedArray = [mappingResult.array mutableCopy];
            NSLog(@"success");
            NSLog(@"newsFeedArrayContents:\n%@",self.newsFeedArray);
            if([self.newsFeedArray count]>0){
            [self preLoadImages];
            }
            if([self.newsFeedArray count] == 0){
                NSLog(@"noMOrePosts");
                [self.newsFeedImageViewOne removeFromSuperview];
                [self.newsFeedImageViewTwo removeFromSuperview];
                [self.newsFeedViewForLabels removeFromSuperview];
                [self.loadingView removeFromSuperview];
                UILabel *noMorePostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
                noMorePostsLabel.numberOfLines = 0;
                noMorePostsLabel.backgroundColor  = [UIColor whiteColor];
                noMorePostsLabel.textAlignment = NSTextAlignmentCenter;
                noMorePostsLabel.text = @"Currently there are no more thisThat posts for you to vote on.";
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
//total vote count
-(NSString*)ForTotalVotesVoteCountOne:(NSNumber*)voteCountOne ForTotalVotesVoteCountTwo:(NSNumber*)voteCountTwo{
    NSInteger voteCountOneINT = [voteCountOne integerValue];
    NSInteger voteCountTwoINT = [voteCountTwo integerValue];
    NSInteger totalVoteCount = voteCountOneINT + voteCountTwoINT;
    if(totalVoteCount == 1) {
        NSString *totalVoteCountSTRING = [NSString stringWithFormat:@"%ld vote",(long)totalVoteCount];
        return totalVoteCountSTRING;
    }
    else {
    NSString *totalVoteCountSTRING = [NSString stringWithFormat:@"%ld votes",(long)totalVoteCount];
    return totalVoteCountSTRING;
    }
}
//compress image for uploading to reduce size and quality
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

//cropping fullsize image to viewheight/2 for halfscreen imageviews
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

//posts voted on action
-(void)votedButtonAction:(UIButton*)sender {
    [self.votedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      UIImage *votedIcon = [UIImage imageNamed:@"voted.png"];
      [self.votedImageButton setImage:votedIcon forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self loadPostsVotedOn];
}
/*
- (IBAction)postsVotedOn:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self loadPostsVotedOn];
    
    
    
}*/
//loading view
-(void)presentLoadingView {
  //  UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:0.7];
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.loadingView.backgroundColor = [UIColor clearColor];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGFloat spinnerHeight = CGRectGetHeight(self.spinner.frame);
    CGFloat totalViewHeight = spinnerHeight + 120;
    UIView *loadingViewForLabels = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-(totalViewHeight/2), 200, totalViewHeight)];
    //loadingViewForLabels.backgroundColor = redColor;
    loadingViewForLabels.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
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
//no posts to vote on in newsfeed view
-(void)initalizedNewsFeedViewNoPostsToVoteOn {
 //   UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
    [self presentInvisibleView];
    [self.loadingView removeFromSuperview];
    self.newsFeedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.newsFeedView.backgroundColor = blackThisThatColor;
    [self.navigationController.view addSubview:self.newsFeedView];
    self.newsFeedPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.newsFeedView addGestureRecognizer:self.newsFeedPinchGesture];
    UILabel *noMorePostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    noMorePostsLabel.textColor = [UIColor whiteColor];
    noMorePostsLabel.numberOfLines = 0;
    noMorePostsLabel.font = [UIFont systemFontOfSize:20];
    noMorePostsLabel.textAlignment = NSTextAlignmentCenter;
    noMorePostsLabel.text = @"Currently there are no more thisThat posts for you to vote on.";
    [self.newsFeedView addSubview:noMorePostsLabel];
    
}
//initalize newsfeed view
-(void)initalizeNewsFeedView {
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentInvisibleView];
    self.newsFeedCounter = 0;
   // UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    NSLog(@"widthFrame:%f",widthFrame);
    CGRect personalPostsViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    self.newsFeedView = [[UIView alloc] initWithFrame:personalPostsViewSize];
    self.newsFeedView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.newsFeedView];
    self.newsFeedPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePinchToCloseCurrentView:)];
    [self.newsFeedView addGestureRecognizer:self.newsFeedPinchGesture];


    //LABELS
   // UIColor *blackThisThatColor = [UIColor colorWithRed:(39/255.0) green:(35/255.0) blue:(34/255.0) alpha:1];
    self.newsFeedViewForLabels = [[UIView alloc] initWithFrame:CGRectMake(0, ([self viewHeight]/2)-115, [self viewWidth], 230)];
    self.newsFeedViewForLabels.backgroundColor = [UIColor whiteColor];
    self.newsFeedViewForLabels.layer.borderWidth = 5;
    self.newsFeedViewForLabels.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.newsFeedView addSubview:self.newsFeedViewForLabels];
    
    
    
    self.newsFeedTextContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, [self viewWidth]-20, 120)];
    self.newsFeedTextContentLabel.backgroundColor = [UIColor clearColor];
       
    self.newsFeedTextContentLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:25];
    self.newsFeedTextContentLabel.numberOfLines = 0;
    self.newsFeedTextContentLabel.adjustsFontSizeToFitWidth = YES;
    [self.newsFeedTextContentLabel setMinimumScaleFactor:0.8];
    self.newsFeedTextContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.newsFeedTextContentLabel setTextColor:[UIColor darkGrayColor]];
    [self.newsFeedViewForLabels addSubview:self.newsFeedTextContentLabel];
    
    
    //    [messageLabel sizeToFit];
    
    self.newsFeedUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, [self viewWidth]-20, 35)];
    self.newsFeedUsernameLabel.backgroundColor = [UIColor clearColor];
    [self.newsFeedUsernameLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [self.newsFeedUsernameLabel setTextColor:redColor];
    [self.newsFeedUsernameLabel setTextAlignment:NSTextAlignmentCenter];
    self.newsFeedUsernameLabel.adjustsFontSizeToFitWidth = YES;
    self.newsFeedUsernameLabel.minimumScaleFactor = 0.5;
    [self.newsFeedViewForLabels addSubview:self.newsFeedUsernameLabel];
    
    
    self.newsFeedTimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*([self viewWidth]/4), 190, ([self viewWidth]/4)-10, 20)];
    self.newsFeedTimeStampLabel.backgroundColor = [UIColor clearColor];
    [self.newsFeedTimeStampLabel setFont:[UIFont systemFontOfSize:15]];
    [self.newsFeedTimeStampLabel setTextColor:[UIColor grayColor]];
    [self.newsFeedTimeStampLabel setTextAlignment:NSTextAlignmentRight];
    self.newsFeedTimeStampLabel.adjustsFontSizeToFitWidth = YES;
    self.newsFeedTimeStampLabel.minimumScaleFactor = 0.8;
    [self.newsFeedViewForLabels addSubview:self.newsFeedTimeStampLabel];
    
  /*  self.newsFeedLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (3*[self viewWidth]/4)-10, 20)];
    self.newsFeedLocationLabel.backgroundColor = [UIColor clearColor];
    [self.newsFeedLocationLabel setFont:[UIFont systemFontOfSize:15]];
    [self.newsFeedLocationLabel setTextAlignment:NSTextAlignmentLeft];
    self.newsFeedLocationLabel.text = @"Vancouver BC, Canada";
    self.newsFeedLocationLabel.textColor = [UIColor grayColor];
    self.newsFeedLocationLabel.adjustsFontSizeToFitWidth = YES;
    self.newsFeedLocationLabel.minimumScaleFactor = 0.6;
    [self.newsFeedViewForLabels addSubview:self.newsFeedLocationLabel];*/
    
    self.newsFeedTotalNumberOfVotesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, [self viewWidth]/2-20, 30)];
    self.newsFeedTotalNumberOfVotesLabel.backgroundColor = [UIColor clearColor];
    self.newsFeedTotalNumberOfVotesLabel.textColor = [UIColor grayColor];
    [self.newsFeedTotalNumberOfVotesLabel setFont:[UIFont systemFontOfSize:15]];
    [self.newsFeedViewForLabels addSubview:self.newsFeedTotalNumberOfVotesLabel];
    [self.newsFeedViewForLabels setAlpha:0];
    //PercentageLabels

    UIImage *voteForThisImageAI = [UIImage imageNamed:@"voteThisAI.png"];
    self.newsFeedVoteForThisImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.newsFeedVoteForThisImageView.image = voteForThisImageAI;
    self.newsFeedVoteForThisImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.newsFeedVoteForThisImageView setAlpha:0];
    [self.newsFeedView addSubview:self.newsFeedVoteForThisImageView];
    UIImage *notThis = [UIImage imageNamed:@"notThisAI.png"];
    self.newsFeedNotThisImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.newsFeedNotThisImageView.image = notThis;
    self.newsFeedNotThisImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.newsFeedNotThisImageView setAlpha:0];
    [self.newsFeedView addSubview:self.newsFeedNotThisImageView];
    
    
    
    CGRect imageViewOneCurrentRect = CGRectMake(0, -(heightFrame/2), widthFrame, (heightFrame/2));
    self.newsFeedImageViewOne = [[UIImageView alloc] initWithFrame:imageViewOneCurrentRect];
    [self.newsFeedImageViewOne setUserInteractionEnabled:YES];
    [self.newsFeedView addSubview:self.newsFeedImageViewOne];
   
    UIButton *closeNewsFeedViewButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
    closeNewsFeedViewButton.backgroundColor = [UIColor whiteColor];
    [closeNewsFeedViewButton addTarget:self action:@selector(closeNewsFeedViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.newsFeedImageViewOne addSubview:closeNewsFeedViewButton];
    
    
    UIImage *greenCheckMarkImage = [[UIImage alloc] init];
    greenCheckMarkImage = [UIImage imageNamed:@"check.png"];
    self.newsFeedImageOneCheckMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.newsFeedImageViewOne.frame.size.height-60, 50, 50)];
    self.newsFeedImageOneCheckMarkView.image = greenCheckMarkImage;
    self.newsFeedImageOneCheckMarkView.layer.cornerRadius = 25;
    self.newsFeedImageOneCheckMarkView.clipsToBounds = YES;
    [self.newsFeedImageOneCheckMarkView setAlpha:0];
    [self.newsFeedImageViewOne addSubview:self.newsFeedImageOneCheckMarkView];
    UIImage *redXMarkImage = [[UIImage alloc] init];
    redXMarkImage = [UIImage imageNamed:@"redx.png"];
    self.newsFeedImageOneXMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.newsFeedImageViewOne.frame.size.width-60, self.newsFeedImageViewOne.frame.size.height-60, 50, 50)];
    self.newsFeedImageOneXMarkView.image = redXMarkImage;
    self.newsFeedImageOneXMarkView.layer.cornerRadius = 25;
    self.newsFeedImageOneXMarkView.clipsToBounds = YES;
    [self.newsFeedImageOneXMarkView setAlpha:0];
    [self.newsFeedImageViewOne addSubview:self.newsFeedImageOneXMarkView];
    
    
    //ImageOnePanRecognizer
    self.newsFeedPanGestureImageViewOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.newsFeedImageViewOne addGestureRecognizer:self.newsFeedPanGestureImageViewOne];
    

   
    UIImage *notThatImage = [UIImage imageNamed:@"notThatAI.png"];
    self.newsFeedNotThatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.newsFeedNotThatImageView.image = notThatImage;
    self.newsFeedNotThatImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.newsFeedNotThatImageView setAlpha:0];
    [self.newsFeedView addSubview:self.newsFeedNotThatImageView];
    
    UIImage *voteForThat = [UIImage imageNamed:@"voteThatAI.png"];
    self.newsFeedVoteForThatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.newsFeedVoteForThatImageView.image = voteForThat;
    self.newsFeedVoteForThatImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.newsFeedVoteForThatImageView setAlpha:0];
    [self.newsFeedView addSubview:self.newsFeedVoteForThatImageView];
    
    CGRect imageViewTwoCurrentRect = CGRectMake(0, (heightFrame), widthFrame, (heightFrame/2));
    self.newsFeedImageViewTwo = [[UIImageView alloc] initWithFrame:imageViewTwoCurrentRect];
    [self.newsFeedImageViewTwo setUserInteractionEnabled:YES];
    [self.newsFeedView addSubview:self.newsFeedImageViewTwo];
    
    self.newsFeedImageTwoCheckMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.newsFeedImageTwoCheckMarkView.image = greenCheckMarkImage;
    self.newsFeedImageTwoCheckMarkView.layer.cornerRadius = 25;
    self.newsFeedImageTwoCheckMarkView.clipsToBounds = YES;
    [self.newsFeedImageTwoCheckMarkView setAlpha:0];
    [self.newsFeedImageViewTwo addSubview:self.newsFeedImageTwoCheckMarkView];
    
    self.newsFeedImageTwoXMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.newsFeedImageViewTwo.frame.size.width-60, 10, 50, 50)];
    self.newsFeedImageTwoXMarkView.image = redXMarkImage;
    self.newsFeedImageTwoXMarkView.layer.cornerRadius = 25;
    self.newsFeedImageTwoXMarkView.clipsToBounds = YES;
    [self.newsFeedImageTwoXMarkView setAlpha:0];
    [self.newsFeedImageViewTwo addSubview:self.newsFeedImageTwoXMarkView];
    
    
    UIImage *yellowMenuImage = [[UIImage alloc] init];
    yellowMenuImage = [UIImage imageNamed:@"yellowMenu.png"];
    self.newsFeedYellowMenuButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-25, (self.view.frame.size.height/2)-25, 50, 50)];
    [self.newsFeedYellowMenuButton setImage:yellowMenuImage forState:UIControlStateNormal];
    [self.newsFeedYellowMenuButton setAlpha:0];
    [self.newsFeedView addSubview:self.newsFeedYellowMenuButton];
    [self.newsFeedYellowMenuButton addTarget:self action:@selector(menuButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //ImageTwoPanRecognizer
    self.newsFeedPanGestureImageViewTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.newsFeedImageViewTwo addGestureRecognizer:self.newsFeedPanGestureImageViewTwo];
    
    
    //ActivityIndicator
    
  /*  self.newsFeedImageViewOnePercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, 10, 100, 50)];
    self.newsFeedImageViewOnePercentageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.newsFeedImageViewOnePercentageLabel.layer.cornerRadius = 7.0;
    self.newsFeedImageViewOnePercentageLabel.clipsToBounds = YES;
    [self.newsFeedImageViewOnePercentageLabel setTextColor:[UIColor whiteColor]];
    [self.newsFeedImageViewOnePercentageLabel setFont:[UIFont systemFontOfSize:30]];
    [self.newsFeedImageViewOnePercentageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.newsFeedImageViewOne addSubview:self.newsFeedImageViewOnePercentageLabel]; */
    
    //CGFloat maxYimageViewTwo = CGRectGetHeight(self.newsFeedImageViewTwo.frame);
   /* self.newsFeedImageViewTwoPercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, maxYimageViewTwo-60, 100, 50)];
    self.newsFeedImageViewTwoPercentageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.newsFeedImageViewTwoPercentageLabel.layer.cornerRadius = 7.0;
    self.newsFeedImageViewTwoPercentageLabel.clipsToBounds = YES;
    [self.newsFeedImageViewTwoPercentageLabel setTextColor:[UIColor whiteColor]];
    [self.newsFeedImageViewTwoPercentageLabel setFont:[UIFont systemFontOfSize:30]];
    [self.newsFeedImageViewTwoPercentageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.newsFeedImageViewTwo addSubview:self.newsFeedImageViewTwoPercentageLabel];*/
    //[self loadNewsFeedArray];
    
    self.newsFeedTapGestureToOpenImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.newsFeedImageViewOne addGestureRecognizer:self.newsFeedTapGestureToOpenImageViewOne];
    self.newsFeedTapGestureToOpenImageViewTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.newsFeedImageViewTwo addGestureRecognizer:self.newsFeedTapGestureToOpenImageViewTwo];
}
-(void)closeNewsFeedViewAction:(UIButton*)sender {
    [self.newsFeedView removeFromSuperview];
    [self.invisibleView removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
//invisbleview so when pinching can't click any view behind it
-(void)presentInvisibleView {
    self.invisibleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.navigationController.view addSubview:self.invisibleView];
}
-(void)presentInvisibleView2 {
    self.invisibleView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.navigationController.view addSubview:self.invisibleView2];
}
-(UIColor*)greenThisThatColor {
    UIColor *greenThisThatColor = [UIColor colorWithRed:51/255.0 green:168/255.0 blue:70/255.0 alpha:1];
    return greenThisThatColor;
}
-(UIColor*)redThisThatColor {
     UIColor *redThisThatColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
    return redThisThatColor;
}
//alertview invalid token
-(void)invaidTokenPresentLoginScreen {
    self.alertViewLogin = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your session is no longer valid. Please login" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.alertViewLogin show];
}
//alertview internetoffline
-(void)internetOffline {
    self.alertViewOffline = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your internet connection appears to be offline. Please try again when you are connected." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [self.alertViewOffline show];
}

//alertview actions
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
    if([alertView isEqual:self.uploadPostNoTextContentAlertView]){
        if(buttonIndex == [alertView cancelButtonIndex]) {
            [self uploadThisThat];
    }
        
}
}
//upload nav bar detail
-(void)uploadingNavBarDetail {
    UIColor *redColor = [UIColor colorWithRed:(207/255.0) green:(70/255.0) blue:(51/255.0) alpha:1];
    self.uploadPostNavigationBarUploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height+5)];
    self.uploadPostNavigationBarUploadView.backgroundColor = [UIColor whiteColor];
    UIView *blackLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height+4, self.view.frame.size.width, 1)];
    blackLineView.backgroundColor = [UIColor blackColor];
    [self.uploadPostNavigationBarUploadView addSubview:blackLineView];
    [self.navigationController.view addSubview:self.uploadPostNavigationBarUploadView];
    self.uploadPostNavigationBarUploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, [UIApplication sharedApplication].statusBarFrame.size.height + 5, self.view.frame.size.width-70, 30)];
    self.uploadPostNavigationBarUploadLabel.textColor = redColor;
    self.uploadPostNavigationBarUploadLabel.text = @"uploading your thisThat..";
    [self.uploadPostNavigationBarUploadView addSubview:self.uploadPostNavigationBarUploadLabel];

    
}
-(void)cancelAllGetRequests {
    
    
    
}
@end
