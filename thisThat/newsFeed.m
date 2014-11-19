//
//  newsFeed.m
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "newsFeed.h"
#import "objects.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"
#import <Foundation/Foundation.h>



@interface newsFeed ()
@property (nonatomic, strong) NSArray *thisThatArray;
@end
int userID = 2;

@implementation newsFeed

@synthesize i;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self configureRestKit];
     [self loadImage];
    i = 0;
    
    self.noPhotosLabelOne.layer.cornerRadius = 20.0f;
    self.noPhotosLabelOne.clipsToBounds = YES;
    self.noPhotosLabelOne.layer.borderWidth = 3.0f;
    self.noPhotosLabelOne.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.noPhotosLabelTwo.layer.cornerRadius = 20.0f;
    self.noPhotosLabelTwo.clipsToBounds = YES;
    self.noPhotosLabelTwo.layer.borderWidth = 3.0f;
    self.noPhotosLabelTwo.layer.borderColor = [UIColor grayColor].CGColor;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadImage {
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
    
}

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
                                                                                        statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTwo];
    
}
 //uncoment below when restkit is installed, should all work.
- (IBAction)voteForPhoto:(id)sender {
 
   if(i < [_thisThatArray count]) {
       [self.noPhotosLabelOne setHidden:YES];
       [self.noPhotosLabelTwo setHidden:YES];
        objects *object = [_thisThatArray objectAtIndex:i];
        //assign imageone
       NSMutableString *image_urlOne = [NSMutableString string];
        [image_urlOne appendString:hostUrl];
        [image_urlOne appendString:object.imageOne];
        [self.imageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
       self.imageViewOne.image = [self scaleImage:self.imageViewOne.image toSize:CGSizeMake(240, 240)];
       self.imageViewOne.layer.cornerRadius = 20.0f;
       self.imageViewOne.clipsToBounds = YES;
       self.imageViewOne.layer.borderWidth = 3.0f;
       self.imageViewOne.layer.borderColor = [UIColor grayColor].CGColor;
       
        NSMutableString *image_urlTwo = [NSMutableString string];
        [image_urlTwo appendString:hostUrl];
        [image_urlTwo appendString:object.imageTwo];
        [self.imageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
       self.imageViewTwo.image = [self scaleImage:self.imageViewTwo.image toSize:CGSizeMake(240, 240)];
       self.imageViewTwo.layer.cornerRadius = 20.0f;
       self.imageViewTwo.clipsToBounds = YES;
       self.imageViewTwo.layer.borderWidth = 3.0f;
       self.imageViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
        //assign text content
      //  self.textContentLabel.text = object.textContent;
       self.textContentLabel.text = object.textContent;
        //increment counter/index
        i++;

       // assiging button property to sender
       
       self.voteForImageOne = (UIButton *)sender;
       self.voteForImageTwo = (UIButton *)sender;
       
       //vote for imageOne
       
       if(self.voteForImageOne.tag == 10){
         
         
           NSDictionary *parameters = @{@"username" : @"jamesTestUser",
                                        @"password" : @"jamesTestUser"};
           NSNumber *currentPostID = object.postId;
           NSString *voteForImageOnePath = [[NSString alloc] initWithFormat:@"/api/v1/ThisThats/%@/image1/vote",currentPostID];
           NSURL *baseURL = [NSURL URLWithString:hostUrl];
           RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
           NSMutableURLRequest *operation = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:voteForImageOnePath parameters:parameters];
           RKObjectRequestOperation *requestOperation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:operation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               NSLog(@"voted for image one");
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               NSLog(@"voting for image one did not work");
           }];
           [[RKObjectManager sharedManager] enqueueObjectRequestOperation:requestOperation];
       }
       
       //vote for imageTwo
       
       if(self.voteForImageTwo.tag == 20){
        
           
           NSDictionary *parameters = @{@"username" : @"jamesTestUser",
                                        @"password" : @"jamesTestUser"};
           NSNumber *currentPostID = object.postId;
           NSString *voteForImageTwoPath = [[NSString alloc] initWithFormat:@"/api/v1/ThisThats/%@/image2/vote",currentPostID];
           NSURL *baseURL = [NSURL URLWithString:hostUrl];
           RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
           NSMutableURLRequest *operation = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:voteForImageTwoPath parameters:parameters];
           RKObjectRequestOperation *requestOperation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:operation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               NSLog(@"voted for image Two");
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               NSLog(@"voting for image two did not work");
           }];
           [[RKObjectManager sharedManager] enqueueObjectRequestOperation:requestOperation];

       }
   }
    // no more photos.. 
   else {
       [self.noPhotosLabelOne setHidden:NO];
       [self.noPhotosLabelTwo setHidden:NO];
       self.imageViewOne.image = nil;
       self.imageViewTwo.image = nil;
       self.textContentLabel.text = nil;
   }

}

-(UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
