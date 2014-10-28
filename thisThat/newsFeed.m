//
//  newsFeed.m
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "newsFeed.h"
#import "objects.h"
#import <RestKit/RestKit.h>


typedef NS_ENUM(NSInteger, VoteForPhoto) {
    VoteForPhotoOne = 10,
    VoteForPhotoTwo = 20
};

@interface newsFeed ()
@property (nonatomic, assign) VoteForPhoto didVoteForPhoto;
@property (nonatomic, strong) NSArray *thisThatArray;
@end
int userID = 2;
NSString *hostUrl = @"http://local-app.co:1337";

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
    NSDictionary *getInfo = @{@"user_Id" : [NSNumber numberWithInt:userID]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v1/ThisThats/all" parameters:getInfo success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
    [objectMapping addAttributeMappingsFromDictionary:@{@"user_id": @"userId",@"image_1": @"imageOne", @"image_2": @"imageTwo", @"message": @"textContent", @"createdAt": @"createdAt"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"ThisThats" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
}
 //uncoment below when restkit is installed, should all work.
- (IBAction)voteForPhoto:(id)sender {
    
   if(i < [_thisThatArray count]) {
       
        objects *object = [_thisThatArray objectAtIndex:i];
        //assign imageone
        NSMutableString *image_urlOne = [NSMutableString string];
        [image_urlOne appendString:hostUrl];
        [image_urlOne appendString:object.imageOne];
        [self.imageViewOne setImageWithURL:[NSURL URLWithString:image_urlOne]];
        //assign imagetwo
        NSMutableString *image_urlTwo = [NSMutableString string];
        [image_urlTwo appendString:hostUrl];
        [image_urlTwo appendString:object.imageTwo];
        [self.imageViewTwo setImageWithURL:[NSURL URLWithString:image_urlTwo]];
        //assign text content
        self.textContentLabel.text = object.textContent;
        //increment counter/index
        i++;

    if([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = sender;
        self.didVoteForPhoto = button.tag;
    }
    switch (self.didVoteForPhoto) {
        case VoteForPhotoOne:
            // send vote count to server for photo 1
            break;
            case VoteForPhotoTwo:
            // send vote count to server for photo 2
            break;
        default:
            break;
        }
    }
}
@end
