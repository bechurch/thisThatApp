//
//  personal.m
//  thisThat
//
//  Created by James Connerton on 2015-01-15.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "personal.h"
#import "upload.h"
#import "objects.h"
#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "customCell.h"
#import "constants.h"
#import "userSettings.h"
#import <UIKit/UIKit.h>

@interface personal ()
@property (nonatomic, strong) NSMutableArray *personalArray;
@end

@implementation personal

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPersonalPosts];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSObject *currentIDObject = [userDefaultContents objectForKey:@"userIDString"];
    NSObject *usernameObject = [userDefaultContents objectForKey:@"username"];
    if(userDefaultObject != nil){
        NSLog(@"\nCurrent ID = %@\nCurrent UserIDToken = %@",currentIDObject,userDefaultObject);
        [self loadPersonalPosts];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_personalArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    objects *object = [_personalArray objectAtIndex:indexPath.row];
    
    //UserID
    NSNumber *userIdNum = object.userId;
    NSString *userIdString = [NSString stringWithFormat:@"%@",userIdNum];
    cell.usernameLabel.text = userIdString;

    
    //ImageOne
    NSMutableString *image_urlOne = [NSMutableString string];
    [image_urlOne appendString:hostUrl];
    [image_urlOne appendString:object.imageOne];
    [cell.imageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
    cell.imageViewOne.tag = indexPath.row;
    
    //ImageTwo
    NSMutableString *image_urlTwo = [NSMutableString string];
    [image_urlTwo appendString:hostUrl];
    [image_urlTwo appendString:object.imageTwo];
   [cell.imageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    
    //DatePosted
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
    
    //TextContent
    cell.textContent.text = object.textContent;
    
    //ImageOneVoteCount
    NSNumber *voteCountImageOneNum = object.voteCountOne;
    NSString *voteCountImageOneString = [NSString stringWithFormat:@"%@ votes",voteCountImageOneNum];
    cell.voteCountImageOne.text = voteCountImageOneString;

    //ImageTwoVoteCount
    NSNumber *voteCountImageTwoNum = object.voteCountTwo;
    NSString *voteCountImageTwoString = [NSString stringWithFormat:@"%@ votes",voteCountImageTwoNum];
    cell.voteCountImageTwo.text = voteCountImageTwoString;


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
    
    
    objects *object = [_personalArray objectAtIndex:indexPath.row];
    NSMutableString *image_urlOne = [NSMutableString string];
    [image_urlOne appendString:hostUrl];
    [image_urlOne appendString:object.imageOne];
    [self.additionalImageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
    self.additionalImageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    self.additionalImageViewOne.clipsToBounds = YES;
    
    CGRect imageViewTwoSize = CGRectMake(0, [self getHeightOfView]/2, [self getWidthOfView], [self getHeightOfView]/2);
    self.additionalImageViewTwo = [[UIImageView alloc] initWithFrame:imageViewTwoSize];
    [self.myView addSubview:self.additionalImageViewTwo];
    
    
    NSMutableString *image_urlTwo = [NSMutableString string];
    [image_urlTwo appendString:hostUrl];
    [image_urlTwo appendString:object.imageTwo];
    [self.additionalImageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    self.additionalImageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
    self.additionalImageViewTwo.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReognized)];
   [self.myView addGestureRecognizer:tapRecognizer];
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)];
    //self.panRecognizer.delegate = self;
    [self.additionalImageViewOne addGestureRecognizer:self.panRecognizer];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadPersonalPosts{
    
    NSUserDefaults *userDefaultContents = [NSUserDefaults standardUserDefaults];
    NSObject *userDefaultObject = [userDefaultContents objectForKey:@"tokenIDString"];
    NSString *tokenIDString = [NSString stringWithFormat:@"/api/v1/ThisThats/my?access_token=%@",userDefaultObject];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:tokenIDString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _personalArray = [mappingResult.array mutableCopy];
        NSLog(@"success");
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Array: %@",error);
    }];
    
}
-(void)tapReognized {
    [self.myView setHidden:YES];
}
-(float)getWidthOfView {
    return CGRectGetWidth(self.view.frame);
}
-(float)getHeightOfView {
    return CGRectGetHeight(self.view.frame);
}

- (IBAction)upload:(id)sender {
    [self performSegueWithIdentifier:@"upload" sender:self];
}

- (IBAction)settings:(id)sender {
    [self performSegueWithIdentifier:@"settings" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
-(void)recognizedPan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:{
            NSLog(@"state changed");
            CGPoint translation = [recognizer translationInView:self.view];
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            //get min x position
          //  float minHorizontalPosition = CGRectGetMinX(self.additionalImageViewOne.frame);
            // get max x position
          //  float maxHorizontalPosition = CGRectGetMaxX(self.additionalImageViewOne.frame);
            
            
        }
            default:
            break;

}
    
    
}

@end
