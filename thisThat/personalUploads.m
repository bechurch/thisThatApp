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



@interface personalUploads ()
@property (nonatomic, strong) NSArray *thisThatPersonalPostsArray;
@end

@implementation personalUploads {
    NSTimeInterval elapsedTime;
}
/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.upload.layer.cornerRadius = 10.0f;
    self.upload.clipsToBounds = YES;
    self.upload.layer.borderWidth = 3.0f;
    self.upload.layer.borderColor = [UIColor grayColor].CGColor;
}*/
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.addionalView setHidden:YES];
    [self.addionalView addGestureRecognizer:self.tapGesture];
    [self setUploadButtonFeatures];
    [self loadPersonalPosts];
    
    //[self.view addSubview:self.myTableView];


    // Do any additional setup after loading the view.
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

- (IBAction)upload:(id)sender {
    [self presentUploadViewController];
}

-(void)presentUploadViewController {
    
    upload *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadVC"];
    [self.parentViewController presentViewController:uploadViewController animated:YES completion:nil];
    
}
-(void)loadPersonalPosts {
    
    NSString *usernameString = [[NSString alloc] init];
    usernameString = @"James";
    
    NSDictionary *param = @{@"userId" : @"2" };
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v1/ThisThats/all" parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _thisThatPersonalPostsArray = mappingResult.array;
        [self loadView];
        [self setUploadButtonFeatures];
        [self.addionalView setHidden:YES];
        NSLog(@"contents of array: %@",_thisThatPersonalPostsArray);
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
    [cell.imageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    cell.imageViewTwo.layer.cornerRadius = 7.0f;
    cell.imageViewTwo.clipsToBounds = YES;
    cell.imageViewTwo.layer.borderWidth = 3.0f;
    cell.imageViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
   
    //DATE
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd, h:m a"];
    NSString *dateFormatted = [dateFormat stringFromDate:object.createdAt];
    cell.dateLabel.text = dateFormatted;
    
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
    //presenting additional view when you select the row, this shows the bigger images. swiping left/right will all you to vote on imageOne or imageTwo
    [self.addionalView setHidden:NO];
    [self.addionalView addGestureRecognizer:self.tapGesture];
        objects *object = [_thisThatPersonalPostsArray objectAtIndex:indexPath.row];
    NSMutableString *image_urlOne = [NSMutableString string];
    [image_urlOne appendString:hostUrl];
    [image_urlOne appendString:object.imageOne];
    [self.additionalImageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
    self.additionalImageViewOne.layer.cornerRadius = 20.0f;
    self.additionalImageViewOne.clipsToBounds = YES;
    self.additionalImageViewOne.layer.borderWidth = 3.0f;
    self.additionalImageViewOne.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    
    NSMutableString *image_urlTwo = [NSMutableString string];
    [image_urlTwo appendString:hostUrl];
    [image_urlTwo appendString:object.imageTwo];
    [self.additionalImageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
    self.additionalImageViewTwo.layer.cornerRadius = 20.0f;
    self.additionalImageViewTwo.clipsToBounds = YES;
    self.additionalImageViewTwo.layer.borderWidth = 3.0f;
    self.additionalImageViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
    
}

//curing edges of button, border width, border color

-(void)setUploadButtonFeatures{
    self.upload.layer.cornerRadius = 10.0f;
    self.upload.clipsToBounds = YES;
    self.upload.layer.borderWidth = 3.0f;
    self.upload.layer.borderColor = [UIColor grayColor].CGColor;
}

//Action:@selector invoked when deleteButton pressed

-(void)deleteButtonTapped:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    NSLog(@"delete post at row: %ld",(long)senderButton.tag);

    //ADD CODE TO DELETE POST
}

- (IBAction)settings:(id)sender {
    [self presentUserSettingsViewController];
}

- (IBAction)tapGesture:(id)sender {
    [self.addionalView setHidden:YES];
}

-(void)presentUserSettingsViewController {
    
    userSettings *userSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userSettings"];
    [self.parentViewController presentViewController:userSettingsViewController animated:YES completion:nil];
    

}

@end
