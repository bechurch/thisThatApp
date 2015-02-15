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



@interface MainPage ()

@end

@implementation MainPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRestKit];
    //[self loadPersonalPosts];
    //initalize counter to zero
    self.newsFeedCounter = 0;
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken =%@",currentIDObject,userDefaultObject);
    }
    [self.navigationController.navigationBar setHidden:NO];
  
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

- (IBAction)settings:(id)sender {
    [self performSegueWithIdentifier:@"settings" sender:self];
}

- (IBAction)upload:(id)sender {
    [self performSegueWithIdentifier:@"addPhotos" sender:self];
    
}

- (IBAction)personalPosts:(id)sender {
    [self.personalPostsButton setEnabled:NO];
    [self loadPersonalPosts];
    }
-(void)initalizeTableView{
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    CGRect tableViewSize = CGRectMake(0, 20, widthFrame, heightFrame-20);
    self.personalPostsTableView = [[UITableView alloc] initWithFrame:CGRectMake(widthFrame/2, heightFrame/2, 0, 0) style:UITableViewStylePlain];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.personalPostsTableView.frame = tableViewSize;
    } completion:^(BOOL finished) {
        
    }];
    self.pinchRecognizerPersonalPosts = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePinchPersonalPosts:)];
    [self.personalPostsTableView addGestureRecognizer:self.pinchRecognizerPersonalPosts];
    
    self.personalPostsTableView.delegate = self;
    self.personalPostsTableView.dataSource = self;
    self.personalPostsTableView.backgroundColor = [UIColor whiteColor];
    self.personalPostsTableView.rowHeight = (heightFrame/4)+100;
    
    self.personalPostsTableView.userInteractionEnabled = YES;
    self.personalPostsTableView.bounces = YES;
    
    [self.personalPostsTableView registerClass:[personalPostsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.navigationController.view addSubview:self.personalPostsTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.personalPostsArray count] >=1) {
    return 1;
    }
    else {
        UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"You have not yet posted any thisThats. Tap create on the home screen to create your first comparisson.";
        messageLabel.backgroundColor = redColor;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        self.personalPostsTableView.backgroundView = messageLabel;
        self.personalPostsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.personalPostsArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    personalPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if(cell == nil) {
        NSLog(@"log");
        cell = [[personalPostsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    objects *personalPost = [self.personalPostsArray objectAtIndex:indexPath.row];
    cell.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, (cell.contentView.frame.size.width/2)-15, cell.contentView.frame.size.height-110)];
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
        weakCell.imageViewOne.image = image;
        weakCell.tempImageOne = image;
        
        [weakCell.spinnerImageViewOne stopAnimating];
        [weakCell.spinnerImageViewOne removeFromSuperview];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    [cell.imageViewOne setUserInteractionEnabled:YES];
    [cell.imageViewOne addSubview:cell.imageViewOneButton];
    cell.tapGestureImageViewOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTableViewCellTap:)];
    cell.tapGestureImageViewOne.delegate = self;
    [cell.imageViewOne addGestureRecognizer:cell.tapGestureImageViewOne];
    
    cell.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width/2)+5, 100, (cell.contentView.frame.size.width/2)-15, cell.contentView.frame.size.height-110)];
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
        [weakCell.spinnerImageViewTwo stopAnimating];
        [weakCell.spinnerImageViewTwo removeFromSuperview];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.username = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 3*(cell.contentView.frame.size.width/4)-15, 30)];
    cell.username.backgroundColor = [UIColor blueColor];
    cell.username.textColor = [UIColor blackColor];
    cell.username.font = [UIFont boldSystemFontOfSize:15];
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    cell.username.text = [NSString stringWithFormat:@"%@",usernameObject];
    
    cell.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(3*(cell.contentView.frame.size.width/4)+5, 10, (cell.contentView.frame.size.width/4)-15, 30)];
    cell.timeStamp.backgroundColor = [UIColor yellowColor];
    cell.timeStamp.textColor = [UIColor blackColor];
    cell.timeStamp.font = [UIFont systemFontOfSize:10];
    cell.timeStamp.textAlignment = NSTextAlignmentRight;
    cell.timeStamp.text = [self inputDate:personalPost.createdAt];
    
    cell.textContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, cell.contentView.frame.size.width-20, 60)];
    cell.textContent.backgroundColor = [UIColor orangeColor];
    cell.textContent.textColor = [UIColor blackColor];
    cell.textContent.font = [UIFont systemFontOfSize:15];
    cell.textContent.text = personalPost.textContent;
    
    [cell.contentView addSubview:cell.imageViewOne];
    [cell.contentView addSubview:cell.imageViewTwo];
    [cell.contentView addSubview:cell.username];
    [cell.contentView addSubview:cell.timeStamp];
    [cell.contentView addSubview:cell.textContent];
    return cell;
}
-(void)recognizeTableViewCellTap:(UITapGestureRecognizer*)recognize {
  /*  personalPostsTableViewCell *cell = (personalPostsTableViewCell*)recognize.view;
    
    
   // NSIndexPath *path = [NSIndexPath indexPathForRow:(long)[sender tag] inSection:0];
    objects *personal = [self.personalPostsArray objectAtIndex:cell];
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    newView.backgroundColor = [UIColor blackColor];
    [self.personalPostsTableView addSubview:newView];
    self.fullSizeImageViewTableView = [[UIImageView alloc] init];//WithFrame:CGRectMake(0, 0, 250, 250)];
   
   // imageView.image =
 //   __weak typeof(UIImageView) *weakImageView = UIImageView;
    __weak typeof(self) weakSelf = self;
    NSMutableString *imageUrlOne = [NSMutableString string];
    [imageUrlOne appendString:hostUrl];
    [imageUrlOne appendString:personal.imageOne];
    NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOne]];
    [self.fullSizeImageViewTableView setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakSelf.fullSizeImageViewTableView = [weakSelf inputImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    [newView addSubview:self.fullSizeImageViewTableView];
    NSLog(@"cellTappedOn:%d",cell.tag);
    NSLog(@"tappedImageViewOne");
    */
}
- (IBAction)newsFeed:(id)sender {
   
    CGFloat widthFrame = CGRectGetWidth(self.view.frame);
    CGFloat heightFrame = CGRectGetHeight(self.view.frame);
    NSLog(@"widthFrame:%f",widthFrame);
    CGRect personalPostsViewSize = CGRectMake(0, 0, widthFrame, heightFrame);
    self.newsFeedView = [[UIView alloc] initWithFrame:personalPostsViewSize];
    self.newsFeedView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.newsFeedView];
    self.pinchRecognizerPersonalPosts = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePinchNewsFeed:)];

    
    [self.newsFeedView addGestureRecognizer:self.pinchRecognizerPersonalPosts];
    
    self.imageViewOneBehind = [[UIImageView alloc] init];
    
    //ImageViewOneCurrent
    CGRect imageViewOneCurrentRect = CGRectMake(0, -(heightFrame/2), widthFrame, (heightFrame/2));
    self.imageViewOneCurrent = [[UIImageView alloc] initWithFrame:imageViewOneCurrentRect];
    [self.imageViewOneCurrent setUserInteractionEnabled:YES];
 //   self.imageViewOneCurrent.image = [UIImage imageNamed:@"snowboarding.jpg"];
    [self.newsFeedView addSubview:self.imageViewOneCurrent];
    
    //ImageOnePanRecognizer
    self.panRecognizerImageOne = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.imageViewOneCurrent addGestureRecognizer:self.panRecognizerImageOne];
    
    
    self.imageViewTwoBehind = [[UIImageView alloc] init];
    
    //ImageViewTwoCurrent
    CGRect imageViewTwoCurrentRect = CGRectMake(0, (heightFrame), widthFrame, (heightFrame/2));
    self.imageViewTwoCurrent = [[UIImageView alloc] initWithFrame:imageViewTwoCurrentRect];
    [self.imageViewTwoCurrent setUserInteractionEnabled:YES];
  //  self.imageViewTwoCurrent.image = [UIImage imageNamed:@"snowboarding.jpg"];
    [self.newsFeedView addSubview:self.imageViewTwoCurrent];
    
    //ImageTwoPanRecognizer
    self.panRecognizerImageTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeThePanImageCurrent:)];
    [self.imageViewTwoCurrent addGestureRecognizer:self.panRecognizerImageTwo];
    
    
    //tapToHideTextLabels
       //longPressRecognizer
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTheLongPress:)];
    [self.longPressRecognizer setMinimumPressDuration:0.5];
    [self.newsFeedView addGestureRecognizer:self.longPressRecognizer];
    
    //ActivityIndicator
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 
    
 //   UIColor *darkGrey = [UIColor colorWithRed:(57/255.0) green:(58/255.0) blue:(71/255.0) alpha:1.0];
    self.viewForLabels = [[UIView alloc] initWithFrame:CGRectMake(0, ([self viewHeight]/2)-40, [self viewWidth], 80)];
    self.viewForLabels.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //  self.viewForLabels.layer.borderWidth = 1;
    self.viewForLabels.layer.borderColor = [UIColor blackColor].CGColor;
    [self.newsFeedView addSubview:self.viewForLabels];
    [self.viewForLabels setAlpha:0];
    
    
    
    CGFloat viewForLabelsHeight = CGRectGetHeight(self.viewForLabels.frame);
    self.textContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (viewForLabelsHeight/2)-35, [self viewWidth]-20, 30)];
    self.textContentLabel.backgroundColor = [UIColor clearColor];
    [self.textContentLabel setFont:[UIFont systemFontOfSize:15]];
    [self.textContentLabel setTextColor:[UIColor whiteColor]];
    [self.viewForLabels addSubview:self.textContentLabel];
    
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (viewForLabelsHeight/2)+5, ([self viewWidth]/2)-20, 30)];
    self.usernameLabel.backgroundColor = [UIColor clearColor];
    [self.usernameLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.usernameLabel setTextColor:[UIColor whiteColor]];
    [self.usernameLabel setTextAlignment:NSTextAlignmentRight];
    [self.viewForLabels addSubview:self.usernameLabel];
    
    
    self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(([self viewWidth]/2)+10, (viewForLabelsHeight/2)+5, ([self viewWidth]/2)-20, 30)];
    self.timeStampLabel.backgroundColor = [UIColor clearColor];
    [self.timeStampLabel setFont:[UIFont systemFontOfSize:15]];
    [self.timeStampLabel setTextColor:[UIColor whiteColor]];
    [self.timeStampLabel setTextAlignment:NSTextAlignmentLeft];
    [self.viewForLabels addSubview:self.timeStampLabel];
    
    self.horizontalLineLabelView = [[UIView alloc] initWithFrame:CGRectMake(10, viewForLabelsHeight/2, [self viewWidth]-20, 1)];
    self.horizontalLineLabelView.backgroundColor = [UIColor whiteColor];
    [self.viewForLabels addSubview:self.horizontalLineLabelView];
    
    self.verticalLineOneLabelView = [[UIView alloc] initWithFrame:CGRectMake([self viewWidth]/2, viewForLabelsHeight/2, 1, (viewForLabelsHeight/2)-10)];
    self.verticalLineOneLabelView.backgroundColor = [UIColor whiteColor];
    [self.viewForLabels addSubview:self.verticalLineOneLabelView];
    //PercentageLabels
    UIColor *redColor = [UIColor colorWithRed:(231/255.0) green:(80/255.0) blue:(80/255.0) alpha:1];
    
    self.imageOnePercentage = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, 10, 100, 50)];
    self.imageOnePercentage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.imageOnePercentage.layer.cornerRadius = 7.0;
    self.imageOnePercentage.clipsToBounds = YES;
    [self.imageOnePercentage setTextColor:redColor];
    [self.imageOnePercentage setFont:[UIFont systemFontOfSize:30]];
    [self.imageOnePercentage setTextAlignment:NSTextAlignmentCenter];
    [self.imageViewOneCurrent addSubview:self.imageOnePercentage];
    
    CGFloat maxYimageViewTwo = CGRectGetHeight(self.imageViewTwoCurrent.frame);
    self.imageTwoPercentage = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth]-110, maxYimageViewTwo-60, 100, 50)];
    self.imageTwoPercentage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.imageTwoPercentage.layer.cornerRadius = 7.0;
    self.imageTwoPercentage.clipsToBounds = YES;
    [self.imageTwoPercentage setTextColor:redColor];
    [self.imageTwoPercentage setFont:[UIFont systemFontOfSize:30]];
    [self.imageTwoPercentage setTextAlignment:NSTextAlignmentCenter];
    [self.imageViewTwoCurrent addSubview:self.imageTwoPercentage];
    
    [self loadNewsFeedArray];
    
    self.tapToOpenImageOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.imageViewOneCurrent addGestureRecognizer:self.tapToOpenImageOne];
    self.tapToOpenImageTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapToOpenImages:)];
    [self.imageViewTwoCurrent addGestureRecognizer:self.tapToOpenImageTwo];
    
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
//// LOAD IMAGES IN
-(void)initalLoadImagesInImageViews{
    if([self.newsFeedArray count] - self.newsFeedCounter == 0) {
        NSLog(@"noMoreNewsFeedPosts");
        [self.spinner stopAnimating];
        [self.loadningView removeFromSuperview];
        [self.imageViewOneCurrent removeFromSuperview];
        [self.imageViewTwoCurrent removeFromSuperview];
        
    }
    if([self.newsFeedArray count] - self.newsFeedCounter == 1){
        objects *current = [self.newsFeedArray objectAtIndex:self.newsFeedCounter];
        __weak typeof(self) weakSelf = self;
        NSMutableString *imageUrlOneCurrent = [NSMutableString string];
        [imageUrlOneCurrent appendString:hostUrl];
        [imageUrlOneCurrent appendString:current.imageOne];
        NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOneCurrent]];
        [self.imageViewOneCurrent setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakSelf.imageViewOneCurrent.image = image;
            weakSelf.tempImageOneCurrent = image;
            weakSelf.imageViewOneCurrent.contentMode = UIViewContentModeScaleAspectFill;
            weakSelf.imageViewOneCurrent.clipsToBounds = YES;
        NSMutableString *imageUrlTwoCurrent = [NSMutableString string];
        [imageUrlTwoCurrent appendString:hostUrl];
        [imageUrlTwoCurrent appendString:current.imageTwo];
        
        NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlTwoCurrent]];
        [weakSelf.imageViewTwoCurrent setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakSelf.tempImageTwoCurrent = image;
                weakSelf.imageViewTwoCurrent.image = image;
                [weakSelf.spinner stopAnimating];
                [weakSelf.loadningView removeFromSuperview];
                weakSelf.textContentLabel.text = current.textContent;
            weakSelf.usernameLabel.text = current.username;
                weakSelf.timeStampLabel.text = [weakSelf inputDate:current.createdAt];
            weakSelf.imageOnePercentage.text = [weakSelf inputCountForReturnPercentage:current.voteCountOne inputVoteCountNoReturn:current.voteCountTwo];
            weakSelf.imageTwoPercentage.text = [weakSelf inputCountForReturnPercentage:current.voteCountTwo inputVoteCountNoReturn:current.voteCountOne];
                weakSelf.imageViewTwoCurrent.contentMode = UIViewContentModeScaleAspectFill;
                weakSelf.imageViewTwoCurrent.clipsToBounds = YES;
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                    weakSelf.imageViewOneCurrent.frame = CGRectMake(0, 0, [weakSelf viewWidth], [weakSelf viewHeight]/2);
                    weakSelf.imageViewTwoCurrent.frame = CGRectMake(0, ([weakSelf viewHeight]/2), [weakSelf viewWidth], [weakSelf viewHeight]/2);
                    
                } completion:^(BOOL finished) {
                    [weakSelf.viewForLabels setAlpha:1.0];
                    
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"fail");
            }];
    }
    
    if([self.newsFeedArray count] - self.newsFeedCounter >=2){
        objects *behind = [self.newsFeedArray objectAtIndex:self.newsFeedCounter+1];
        objects *current = [self.newsFeedArray objectAtIndex:self.newsFeedCounter];
        __weak typeof(self) weakSelf = self;
        NSMutableString *imageUrlOneBehind = [NSMutableString string];
        [imageUrlOneBehind appendString:hostUrl];
        [imageUrlOneBehind appendString:behind.imageOne];
        NSURLRequest *request3 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOneBehind]];
        [weakSelf.imageViewOneBehind setImageWithURLRequest:request3 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakSelf.imageViewOneBehind.image = image;
            weakSelf.tempImageOneBehind = image;
            weakSelf.imageViewOneBehind.contentMode = UIViewContentModeScaleAspectFill;
            weakSelf.imageViewOneBehind.clipsToBounds = YES;
            
            NSMutableString *imageUrlTwoBehind = [NSMutableString string];
            [imageUrlTwoBehind appendString:hostUrl];
            [imageUrlTwoBehind appendString:behind.imageTwo];
            NSURLRequest *request4 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlTwoBehind]];
            [weakSelf.imageViewTwoBehind setImageWithURLRequest:request4 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakSelf.imageViewTwoBehind.image= image;
                weakSelf.tempImageTwoBehind = image;
                weakSelf.imageViewTwoBehind.contentMode = UIViewContentModeScaleAspectFill;
                weakSelf.imageViewTwoBehind.clipsToBounds = YES;
                
                NSMutableString *imageURLOneCurrent = [NSMutableString string];
                [imageURLOneCurrent appendString:hostUrl];
                [imageURLOneCurrent appendString:current.imageOne];
                NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLOneCurrent]];
                [weakSelf.imageViewOneCurrent setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    weakSelf.imageViewOneCurrent.image = image;
                    weakSelf.tempImageOneCurrent = image;
                    weakSelf.imageViewOneCurrent.contentMode = UIViewContentModeScaleAspectFill;
                    weakSelf.imageViewOneCurrent.clipsToBounds = YES;
                    
                    NSMutableString *imageURLTwoCurrent = [NSMutableString string];
                    [imageURLTwoCurrent appendString:hostUrl];
                    [imageURLTwoCurrent appendString:current.imageTwo];
                    NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLTwoCurrent]];
                    [weakSelf.imageViewTwoCurrent setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        weakSelf.imageViewTwoCurrent.image = image;
                        weakSelf.tempImageTwoCurrent = image;
                        weakSelf.imageViewTwoCurrent.contentMode = UIViewContentModeScaleAspectFill;
                        weakSelf.imageViewTwoCurrent.clipsToBounds = YES;
                        [weakSelf.spinner stopAnimating];
                        [weakSelf.loadningView removeFromSuperview];
                        weakSelf.textContentLabel.text = current.textContent;
                        weakSelf.usernameLabel.text = current.username;
                        weakSelf.timeStampLabel.text = [weakSelf inputDate:current.createdAt];
                        weakSelf.imageOnePercentage.text = [weakSelf inputCountForReturnPercentage:current.voteCountOne inputVoteCountNoReturn:current.voteCountTwo];
                        weakSelf.imageTwoPercentage.text = [weakSelf inputCountForReturnPercentage:current.voteCountTwo inputVoteCountNoReturn:current.voteCountOne];
                        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                            weakSelf.imageViewOneCurrent.frame = CGRectMake(0, 0, [weakSelf viewWidth], [weakSelf viewHeight]/2);
                            weakSelf.imageViewTwoCurrent.frame = CGRectMake(0, ([weakSelf viewHeight]/2), [weakSelf viewWidth], [weakSelf viewHeight]/2);
                            
                        } completion:^(BOOL finished) {
                            [weakSelf.viewForLabels setAlpha:1.0];
                            
                        }];

                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        
                    }];
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                }];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
}
// ****************************************************************************************************
// LoadImagesAfterSwipe

-(void)loadImagesAfterSwipe {
    if([self.newsFeedArray count] - self.newsFeedCounter == 1) {
        NSLog(@"No More Images To Load");
        [self.imageViewOneCurrent removeFromSuperview];
        [self.imageViewTwoCurrent removeFromSuperview];
        self.tempImageOneCurrent = nil;
        self.tempImageTwoCurrent = nil;
        [self.viewForLabels removeFromSuperview];
        self.newsFeedCounter++;
    }
    if([self.newsFeedArray count] - self.newsFeedCounter == 2){
        objects *current = [self.newsFeedArray objectAtIndex:self.newsFeedCounter+1];
        self.imageViewOneCurrent.image = self.imageViewOneBehind.image;
        self.imageViewOneCurrent.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewOneCurrent.clipsToBounds = YES;
        self.imageViewTwoCurrent.image = self.imageViewTwoBehind.image;
        self.imageViewTwoCurrent.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewTwoCurrent.clipsToBounds = YES;
        self.tempImageOneCurrent = self.tempImageOneBehind;
        self.tempImageTwoCurrent = self.tempImageTwoBehind;
        self.textContentLabel.text = current.textContent;
        self.usernameLabel.text = current.username;
        self.timeStampLabel.text = [self inputDate:current.createdAt];
        self.imageOnePercentage.text = [self inputCountForReturnPercentage:current.voteCountOne inputVoteCountNoReturn:current.voteCountTwo];
        self.imageTwoPercentage.text = [self inputCountForReturnPercentage:current.voteCountTwo inputVoteCountNoReturn:current.voteCountOne];
        self.imageViewOneBehind.image = nil;
        self.imageViewTwoBehind.image = nil;
        self.tempImageOneBehind = nil;
        self.tempImageTwoBehind = nil;
        self.newsFeedCounter++;
    }
    if([self.newsFeedArray count] - self.newsFeedCounter >=3) {
       /* self.loadningView = [[UIView alloc] initWithFrame:CGRectMake(([self viewWidth]/2)-100, ([self viewHeight]/2)-100, 200, 200)];
        self.loadningView.backgroundColor = [UIColor blackColor];
        [self.newsFeedView addSubview:self.loadningView];
        self.spinner.center = CGPointMake(100, 100);
        [self.loadningView addSubview:self.spinner];
        [self.spinner startAnimating];*/
        objects *behind = [self.newsFeedArray objectAtIndex:self.newsFeedCounter+2];
        objects *current = [self.newsFeedArray objectAtIndex:self.newsFeedCounter+1];
        self.imageViewOneCurrent.image = self.imageViewOneBehind.image;
        self.imageViewOneCurrent.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewOneCurrent.clipsToBounds = YES;
        self.imageViewTwoCurrent.image = self.imageViewTwoBehind.image;
        self.imageViewTwoCurrent.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewTwoCurrent.clipsToBounds = YES;
        self.tempImageOneCurrent = self.tempImageOneBehind;
        self.tempImageTwoCurrent = self.tempImageTwoBehind;
        self.textContentLabel.text = current.textContent;
        self.usernameLabel.text = current.username;
        self.timeStampLabel.text = [self inputDate:current.createdAt];
        self.imageOnePercentage.text = [self inputCountForReturnPercentage:current.voteCountOne inputVoteCountNoReturn:current.voteCountTwo];
        self.imageTwoPercentage.text = [self inputCountForReturnPercentage:current.voteCountTwo inputVoteCountNoReturn:current.voteCountOne];
        
        __weak typeof(self) weakSelf = self;
        NSMutableString *imageUrlOneBehind = [NSMutableString string];
        [imageUrlOneBehind appendString:hostUrl];
        [imageUrlOneBehind appendString:behind.imageOne];
        NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlOneBehind]];
        [self.imageViewOneBehind setImageWithURLRequest:request1 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakSelf.imageViewOneBehind.image = image;
            weakSelf.tempImageOneBehind = image;
            NSMutableString *imageUrlTwoBehind = [NSMutableString string];
            [imageUrlTwoBehind appendString:hostUrl];
            [imageUrlTwoBehind appendString:behind.imageTwo];
            NSURLRequest *request2 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrlTwoBehind]];
            [weakSelf.imageViewTwoBehind setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
              //  [weakSelf.spinner stopAnimating];
              //  [weakSelf.loadningView removeFromSuperview];
                weakSelf.imageViewTwoBehind.image = image;
                weakSelf.tempImageTwoBehind = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];

        self.newsFeedCounter++;
    }
    
}



// ****************************************************************************************************
// Pinch Recognizer

-(void)recognizeThePinchNewsFeed:(UIPinchGestureRecognizer *)recognize {
    
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)recognize scale];
    
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (factor < 1) {
                self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            }
            if(factor < 0.45) {
                [self.newsFeedView removeFromSuperview];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if(factor > 0.45) {
               [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.newsFeedView.transform = CGAffineTransformMakeScale(lastScaleFactor, lastScaleFactor);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
        default:
            break;
    
}
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
            [self.viewForLabels setAlpha:0];
            if(recognize == self.panRecognizerImageOne){
            [self.panRecognizerImageTwo setEnabled:NO];
            }
            if(recognize == self.panRecognizerImageTwo){
                [self.panRecognizerImageOne setEnabled:NO];
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
                }
                if(imageViewTwoCurrentMinX > viewControllerMinX){//vote for image 2
                    
                }
        }
            if(recognize == self.panRecognizerImageTwo){
                recognize.view.center = CGPointMake(recognize.view.center.x + currentPoint.x, recognize.view.center.y);
                [recognize setTranslation:CGPointZero inView:self.newsFeedView];
                self.imageViewOneCurrent.center = CGPointMake(-recognize.view.center.x + currentPoint.x + widthFrame, recognize.view.center.y - heightFrame/2);
                if(imageViewOneCurrentMinX > viewControllerMinX){// vote for image 1
                    
                                   }
                if(imageViewTwoCurrentMinX > viewControllerMinX){// vote for image 2
                                    }

            }
        }
            
        default:
            break;
        case UIGestureRecognizerStateEnded:{
            [self.panRecognizerImageOne setEnabled:YES];
            [self.panRecognizerImageTwo setEnabled:YES];
            // VOTE FOR IMAGE ONE
            if(imageViewOneCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 1;
                [self voteForImage];
                
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(widthFrame, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(-widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                    
                } completion:^(BOOL finished) {
                    [self loadImagesAfterSwipe];
                    
                    self.imageViewOneCurrent.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.imageViewOneCurrent.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                        self.imageViewTwoCurrent.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                        
                    } completion:^(BOOL finished) {
                        [self.viewForLabels setAlpha:1.0];
                        
                    }];
                }];
                
                
            }
            //VOTE FOR IMAGE TWO
            if(imageViewTwoCurrentMinX > 5*(viewControllerMaxX/10)){
                self.voteCounter = 2;
                [self voteForImage];
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(-widthFrame, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(widthFrame, heightFrame/2, widthFrame, heightFrame/2);
                } completion:^(BOOL finished) {
                    [self loadImagesAfterSwipe];
                    self.imageViewOneCurrent.frame = CGRectMake(0, -heightFrame/2, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame, widthFrame, heightFrame/2);
                    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.imageViewOneCurrent.frame =CGRectMake(0, 0, widthFrame, heightFrame/2);
                        self.imageViewTwoCurrent.frame = CGRectMake(0, (heightFrame/2), widthFrame, heightFrame/2);
                    } completion:^(BOOL finished) {
                        [self.viewForLabels setAlpha:1.0];
                    }];
                    
                }];
               
            }
            if(imageViewOneCurrentMinX < 5*(viewControllerMaxX/10) && imageViewTwoCurrentMinX < 5*(viewControllerMaxX/10)){
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.imageViewOneCurrent.frame = CGRectMake(0, 0, widthFrame, heightFrame/2);
                    self.imageViewTwoCurrent.frame = CGRectMake(0, heightFrame/2, widthFrame, heightFrame/2);
                } completion:^(BOOL finished) {
                    
                }];
            }

        }
    }
    
}



-(void)recognizeTheLongPress:(UILongPressGestureRecognizer *)recognize {
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
              //  self.imageViewOneCurrent.frame =CGRectMake(0, -40, [self viewWidth], [self viewHeight]/2);
              //  self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2)+40, [self viewWidth], [self viewHeight]/2);
                [self.viewForLabels setAlpha:1.0];

            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
               // self.imageViewOneCurrent.frame =CGRectMake(0, 0, [self viewWidth], [self viewHeight]/2);
              //  self.imageViewTwoCurrent.frame = CGRectMake(0, ([self viewHeight]/2), [self viewWidth], [self viewHeight]/2);
                [self.viewForLabels setAlpha:0];
                
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

    
    if(self.voteCounter == 1){
      
        NSString *pathVoteImageOne = [NSString stringWithFormat:@"/api/v1/thisthats/%@/1/vote?access_token=%@",postID,userToken];
        [[RKObjectManager sharedManager] postObject:nil path:pathVoteImageOne parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"voteForImageOneSuccess");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"voteForImageOneFail");
        }];
        
    }
    if(self.voteCounter == 2){
        NSString *pathVoteImageTwo = [NSString stringWithFormat:@"/api/v1/thisthats/%@/2/vote?access_token=%@",postID,userToken];
        [[RKObjectManager sharedManager] postObject:nil path:pathVoteImageTwo parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"voteForImageTwoSuccess");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"voteForImageTwoFail");
        }];
    }
}
// ****************************************************************************************************
// Setup CollectionView

/*
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.personalPostsArray count];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    return CGSizeMake((width/2), height/2);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat getWidth = CGRectGetWidth(self.view.frame);
    CGFloat getHeight = CGRectGetHeight(self.view.frame);
    static NSString *cellID = @"cell";
    collectionViewCustomCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    objects *object = [self.personalPostsArray objectAtIndex:indexPath.row];
    cell.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (getWidth/2)-10, getHeight/4)];
    NSMutableString *imageUrlOneCurrent = [NSMutableString string];
    [imageUrlOneCurrent appendString:hostUrl];
    [imageUrlOneCurrent appendString:object.imageOne];
    [cell.imageViewOne setImageWithURL:[NSURL URLWithString:imageUrlOneCurrent]];
    cell.imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewOne.clipsToBounds = YES;

    cell.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (getHeight/4)+5, (getWidth/2)-10, getHeight/4)];
    NSMutableString *imageUrlTwoCurrent = [NSMutableString string];
    [imageUrlTwoCurrent appendString:hostUrl];
    [imageUrlTwoCurrent appendString:object.imageTwo];
    [cell.imageViewTwo setImageWithURL:[NSURL URLWithString:imageUrlTwoCurrent]];
    cell.imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.imageViewTwo.clipsToBounds = YES;

    
    [cell addSubview:cell.imageViewOne];
    [cell addSubview:cell.imageViewTwo];
    
    return cell;
}*/

// ****************************************************************************************************
// Configure Restkit

-(void)configureRestKit {
    NSURL *baseURL  = [NSURL URLWithString:hostUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[objects class]];
    [objectMapping addAttributeMappingsFromDictionary:@{@"userId": @"userId",
                                                        @"image_1": @"imageOne",
                                                        @"image_2": @"imageTwo",
                                                        @"message": @"textContent",
                                                        @"createdAt": @"createdAt",
                                                        @"username": @"username",
                                                        @"id":@"postId",
                                                        @"vote_count_1" :@"voteCountOne",
                                                        @"vote_count_2": @"voteCountTwo"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"ThisThats" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSObject class]];
    RKResponseDescriptor * responseDescriptorTwo = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping
                                                                                                method:RKRequestMethodPOST
                                                                                           pathPattern:nil keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:201]];
    [objectManager addResponseDescriptor:responseDescriptorTwo];
    
    
   
/*    RKResponseDescriptor *responseDescriptorThree = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorThree];
*/
}

// ****************************************************************************************************
// Load News Feed

-(void)loadNewsFeedArray{
    self.loadningView = [[UIView alloc] initWithFrame:CGRectMake(([self viewWidth]/2)-100, ([self viewHeight]/2)-100, 200, 200)];
    self.loadningView.backgroundColor = [UIColor blackColor];
    [self.newsFeedView addSubview:self.loadningView];
    self.spinner.center = CGPointMake(100, 100);
    [self.loadningView addSubview:self.spinner];
    [self.spinner startAnimating];
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/?access_token=%@",userDefaultObject];
//    NSString *fullURL = [NSString stringWithFormat:@"http://local-app.co:1337%@",tokenIDString];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.newsFeedArray = [mappingResult.array mutableCopy];
        [self initalLoadImagesInImageViews];
        NSLog(@"success");
        NSLog(@"newsFeedArrayContents:\n%@",self.newsFeedArray);
        
    }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // figureOut how to map error to invalidToken
            NSLog(@"ERROR");
           // [self.newsFeedView removeFromSuperview];
           // [self performSegueWithIdentifier:@"showLogin" sender:self];
        }];

    

    
}
// ****************************************************************************************************
// Load Personal Posts

-(void)loadPersonalPosts {
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/my?access_token=%@",userDefaultObject];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.personalPostsArray = [mappingResult.array mutableCopy];
        [self initalizeTableView];
        NSLog(@"\npersonalPostsArrayContents:\n%@",self.personalPostsArray);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
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
    CGFloat newImageHeight = imageOriginalHeight/scaleFactor;
    CGFloat yStartingPosition = (viewHeight - newImageHeight)/2;
    
    UIImageView *resizedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, yStartingPosition, viewWidth, newImageHeight)];
    resizedImage.image = image;
    
    return resizedImage;
    
}

-(NSString*)inputCountForReturnPercentage:(NSNumber*)inputVoteCountForReturn inputVoteCountNoReturn:(NSNumber*)inputVoteCountNoReturn{
    float inputVoteCountForReturnInteger = [inputVoteCountForReturn floatValue];
    float inputVoteCountNoReturnInteger = [inputVoteCountNoReturn floatValue];
    float totalVoteCountInt = inputVoteCountForReturnInteger + inputVoteCountNoReturnInteger;
    
    float voteCountReturnPercentage = (inputVoteCountForReturnInteger/totalVoteCountInt)*100;
    int integerPercentageReturn = (int)roundf(voteCountReturnPercentage);
    NSString *voteCountReturnString = [NSString stringWithFormat:@"%d%%",integerPercentageReturn];
    return voteCountReturnString;
    
}


@end
