//
//  personalUploads.m
//  thisThat
//
//  Created by James Connerton on 2014-10-29.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "personalUploads.h"
#import "upload.h"
#import "objects.h"
#import <Restkit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "newsFeed.h"
#import "customCell.h"
#import "constants.h"
#import "userSettings.h"
#import <UIKit/UIKit.h>



@interface personalUploads ()
@property (nonatomic, strong) NSArray *thisThatPersonalPostsArray;
@end

@implementation personalUploads {
    NSTimeInterval elapsedTime;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

        NSUserDefaults *userDefaultsContents = [NSUserDefaults standardUserDefaults];
        NSObject *object = [userDefaultsContents objectForKey:@"tokenIDString"];
        NSLog(@"userdefaults contenst: %@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        if(object != nil) {
            [self loadPersonalPosts];
            NSLog(@"login with: %@",object);
        } else {
            [self performSegueWithIdentifier:@"showLogin" sender:self];
            NSLog(@"%@",object);
    }
    [self.navigationController.navigationBar setHidden:NO];
  //  [self loadPersonalPosts];
   
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.addionalView setHidden:YES];
  //  [self.addionalView addGestureRecognizer:self.tapGesture];
    [self setUploadButtonFeatures];
    [self loadPersonalPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    
    [self.myTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTableViewContents:) forControlEvents:UIControlEventValueChanged];
    

  /*
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    refreshControl.backgroundColor = [UIColor blueColor];
    
    [self.myTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTableViewContents) forControlEvents:UIControlEventValueChanged];
*/
    
    /*
    NSUserDefaults *userDefaultsContents = [NSUserDefaults standardUserDefaults];
    NSObject *object = [userDefaultsContents objectForKey:@"tokenIDString"];
    NSLog(@"userdefaults contenst: %@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    if(object != nil) {
        // [self performSegueWithIdentifier:@"login" sender:self];
        NSLog(@"login with: %@",object);
    } else {
        [self performSegueWithIdentifier:@"login" sender:self];
        NSLog(@"%@",object);
    }
    */
    
    //[self.view addSubview:self.myTableView];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)upload:(id)sender {
    [self performSegueWithIdentifier:@"upload" sender:self];
    
}

-(void)presentUploadViewController {
    
    upload *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadVC"];
    [self.parentViewController presentViewController:uploadViewController animated:YES completion:nil];
    
}
-(void)loadPersonalPosts {
    
  //  NSString *usernameString = [[NSString alloc] init];
  //  usernameString = @"James";
    NSUserDefaults *userDefaultsContents = [NSUserDefaults standardUserDefaults];
    NSObject *object = [userDefaultsContents objectForKey:@"tokenIDString"];

    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/my?access_token=%@",object];
    NSLog(@"tokenIDString = %@",tokenIDString);
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _thisThatPersonalPostsArray = mappingResult.array;
        [self loadView];
        [self setUploadButtonFeatures];
       // [self.addionalView setHidden:YES];
        [self.refreshControl endRefreshing];
        NSLog(@"contents of array: %@",_thisThatPersonalPostsArray);
        NSLog(@"refreshing has ended");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error loading from API: %@", error);
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_thisThatPersonalPostsArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    objects *object = [_thisThatPersonalPostsArray objectAtIndex:indexPath.row];
   
    //imageONE
    NSMutableString *image_urlOne = [NSMutableString string];
    [image_urlOne appendString:hostUrl];
    [image_urlOne appendString:object.imageOne];
    [cell.imageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
    cell.imageViewOne.layer.cornerRadius = 7.0f;
    cell.imageViewOne.clipsToBounds = YES;
    cell.imageViewOne.layer.borderWidth = 3.0f;
    cell.imageViewOne.layer.borderColor = [UIColor grayColor].CGColor;
    
    //imageTWO
    NSMutableString *image_urlTwo = [NSMutableString string];
    [image_urlTwo appendString:hostUrl];
    [image_urlTwo appendString:object.imageTwo];
    //UIImageView *holdImageOne = [UIImageView alloc];
   // [holdImageOne setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    //UIImageView *holdImageOneTwo = [self scaleImage:holdImageOne toSize:CGSizeMake(135, 135)];
    [cell.imageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    cell.imageViewTwo.layer.cornerRadius = 7.0f;
    cell.imageViewTwo.clipsToBounds = YES;
    cell.imageViewTwo.layer.borderWidth = 3.0f;
    cell.imageViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
   
    //DATE
  /*  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd, h:m a"];
    NSString *dateFormatted = [dateFormat stringFromDate:object.createdAt];
    NSLog(@"created at: %@",object.createdAt);
    cell.dateLabel.text = dateFormatted;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"s"];*/
    
    NSDate *datePosted = object.createdAt;
    NSDate *currentDate = [NSDate date];
    double timeSinceToday = [datePosted timeIntervalSinceDate:currentDate];
    timeSinceToday = timeSinceToday * -1;
    if(timeSinceToday < 60) { //
        NSString *postingTime = @"Just Now";
        cell.dateLabel.text = postingTime;
    }
    if( timeSinceToday > 60 && timeSinceToday < 3600) {
        timeSinceToday = timeSinceToday / 60;
        NSString *postingTime = [NSString stringWithFormat:@"%dm",(int)roundf(timeSinceToday)];
        cell.dateLabel.text = postingTime;
    }
    if(timeSinceToday > 3600  && timeSinceToday < 86400) {
        timeSinceToday = timeSinceToday / 60/ 60;
        NSString *postingTime = [NSString stringWithFormat:@"%dh",(int)roundf(timeSinceToday)];
        cell.dateLabel.text = postingTime;
    }
    if(timeSinceToday > 86400 && timeSinceToday < 604800) {
        timeSinceToday = timeSinceToday /3600/24;
        NSString *postingTime = [NSString stringWithFormat:@"%dd",(int)roundf(timeSinceToday)];
        cell.dateLabel.text = postingTime;
    }
    if(timeSinceToday > 604800) {
        timeSinceToday = timeSinceToday /3600/24/7;
        NSString *postingTime = [NSString stringWithFormat:@"%dw",(int)roundf(timeSinceToday)];
        cell.dateLabel.text = postingTime;
    }
    
    
    //textCONTENT
    cell.textContent.text = object.textContent;
   
    //voteCountONE
    NSNumber *voteCountImageOneNum = object.voteCountOne;
    NSString *voteCountImageOneString = [NSString stringWithFormat:@"%@ votes",voteCountImageOneNum];
    cell.voteCountImageOne.text = voteCountImageOneString;
    
    //voteCountTWO
    NSNumber *voteCountImageTwoNum = object.voteCountTwo;
    NSString *voteCountImageTwoString = [NSString stringWithFormat:@"%@ votes",voteCountImageTwoNum];
    cell.voteCountImageTwo.text = voteCountImageTwoString;
   
    //userId
    NSNumber *userIdNum = object.userId;
    NSString *userIdString = [NSString stringWithFormat:@"%@",userIdNum];
    cell.usernameLabel.text = userIdString;
    
    //tap on cell, nothing happens.. yet
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    // delete button
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect viewRect = CGRectMake(0, 0, [self getWidthOfView], [self getHeightOfView]);
    self.myView = [[UIView alloc] initWithFrame:viewRect];
    self.myView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.myView];
    [self.tabBarController.view addSubview:self.myView];
    
    
    CGRect imageViewOneSize = CGRectMake(0, 0, [self getWidthOfView], [self getHeightOfView]/2);
    self.additionalImageViewOne = [[UIImageView alloc] initWithFrame:imageViewOneSize];
    [self.myView addSubview:self.additionalImageViewOne];
    
    objects *object = [_thisThatPersonalPostsArray objectAtIndex:indexPath.row];
    NSMutableString *image_urlOne = [NSMutableString string];
    [image_urlOne appendString:hostUrl];
    [image_urlOne appendString:object.imageOne];
    [self.additionalImageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
    self.additionalImageViewOne.contentMode = UIViewContentModeScaleAspectFill;
  //  self.additionalImageViewTwo.clipsToBounds = NO;
    
    CGRect imageViewTwoSize = CGRectMake(0, [self getHeightOfView]/2, [self getWidthOfView], [self getHeightOfView]/2);
    self.additionalImageViewTwo = [[UIImageView alloc] initWithFrame:imageViewTwoSize];
    [self.myView addSubview:self.additionalImageViewTwo];
    
    NSMutableString *image_urlTwo = [NSMutableString string];
    [image_urlTwo appendString:hostUrl];
    [image_urlTwo appendString:object.imageTwo];
    [self.additionalImageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    self.additionalImageViewTwo.contentMode = UIViewContentModeScaleAspectFill;

    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReognized)];
    [self.myView addGestureRecognizer:tapRecognizer];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    
}

//curing edges of button, border width, border color

-(void)setUploadButtonFeatures{
  /*  self.upload.layer.cornerRadius = 10.0f;
    self.upload.clipsToBounds = YES;
    self.upload.layer.borderWidth = 3.0f;
    self.upload.layer.borderColor = [UIColor grayColor].CGColor;*/
}

//Action:@selector invoked when deleteButton pressed

-(void)deleteButtonTapped:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    NSLog(@"delete post at row: %ld",(long)senderButton.tag);

    //ADD CODE TO DELETE POST
}

- (IBAction)settings:(id)sender {
   // [self presentUserSettingsViewController];
    [self performSegueWithIdentifier:@"userSettings" sender:self];
}


-(void)presentUserSettingsViewController {
    
    userSettings *userSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userSettings"];
    [self.parentViewController presentViewController:userSettingsViewController animated:YES completion:nil];
}
-(UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)refreshTableViewContents:(id)sender {
    [self loadPersonalPosts];
    NSLog(@"trying to refresh");
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    if([segue.identifier isEqualToString:@"userSettings"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    if([segue.identifier isEqualToString:@"upload"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
-(void)tapReognized{
    [self.myView setHidden:YES];
}
-(float)getWidthOfView{
    return CGRectGetWidth(self.view.frame);
}
-(float)getHeightOfView {
    return CGRectGetHeight(self.view.frame);
}
@end
