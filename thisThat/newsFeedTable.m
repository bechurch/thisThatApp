//
//  newsFeedTable.m
//  thisThat
//
//  Created by James Connerton on 2015-01-08.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "newsFeedTable.h"
#import "newsFeedTableViewCustomCell.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "objects.h"


@interface newsFeedTable ()

@end

@implementation newsFeedTable


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRestKit];
    self.worldMutableArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",nil];//,@"3",@"4", nil];
    self.friendsMutableArray = [[NSMutableArray alloc] initWithObjects:@"5",@"6",@"7",@"8",@"9", nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentControl.selectedSegmentIndex == 0) {
        return [self.worldMutableArray count];
    }
    if(self.segmentControl.selectedSegmentIndex == 1) {
        return [self.friendsMutableArray count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    newsFeedTableViewCustomCell *customCell = [self.newsFeedTableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(self.segmentControl.selectedSegmentIndex == 0) {
        NSString *worldCellCount = [self.worldMutableArray objectAtIndex:indexPath.row];
        customCell.labelCellCount.text = worldCellCount;
       
        [customCell.voteImageOneRight addTarget:self action:@selector(voteImageOneRightWorld:) forControlEvents:UIControlEventTouchUpInside];
        customCell.voteImageOneRight.tag = indexPath.row;
        
        [customCell.voteImageTwoLeft addTarget:self action:@selector(voteImageTwoLeftWorld:) forControlEvents:UIControlEventTouchUpInside];
        customCell.voteImageTwoLeft.tag = indexPath.row;
        
    }
 /*   if(self.segmentControl.selectedSegmentIndex == 1) {
        NSString *friendsCellCount = [self.friendsMutableArray objectAtIndex:indexPath.row];
        customCell.labelCellCount.text = friendsCellCount;
        
        [customCell.voteImageOneRight addTarget:self action:@selector(voteImageOneRightFriends:) forControlEvents:UIControlEventTouchUpInside];
        customCell.voteImageOneRight.tag = indexPath.row;
        
        [customCell.voteImageTwoLeft addTarget:self action:@selector(voteImageTwoLeftFriends:) forControlEvents:UIControlEventTouchUpInside];
        customCell.voteImageTwoLeft.tag = indexPath.row;
    }*/
    return customCell;
    
}

- (IBAction)segmentControl:(id)sender {
 /*   if(self.segmentControl.selectedSegmentIndex == 0 ){
        [self.newsFeedTableView reloadData];
    }
    if(self.segmentControl.selectedSegmentIndex == 1) {
        [self.newsFeedTableView reloadData];
    }*/
}

-(void)voteImageOneRightWorld: (UIButton *)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:(long)[sender tag] inSection:0];
    [self.worldMutableArray removeObjectAtIndex:path.row];
    [self.newsFeedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationLeft];
    [self.newsFeedTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    NSLog(@"button one pressed in row: %ld in world news feed.",(long)[sender tag]);
    
}
-(void)voteImageTwoLeftWorld: (UIButton *)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:(long)[sender tag] inSection:0];
    [self.worldMutableArray removeObjectAtIndex:path.row];
    [self.newsFeedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationRight];
    [self.newsFeedTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    NSLog(@"button two pressed in row: %ld in world news feed.",(long)[sender tag]);
    
    
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
/*
-(void)voteImageOneRightFriends: (UIButton *)sender {
    NSLog(@"titties");
    NSIndexPath *path = [NSIndexPath indexPathForRow:(long)[sender tag] inSection:0];
    [self.friendsMutableArray removeObjectAtIndex:path.row];
    [self.newsFeedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationLeft];
    [self.newsFeedTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    NSLog(@"button one pressed in row: %ld in friends news feed.",(long)[sender tag]);
    
}
-(void)voteImageTwoLeftFriends: (UIButton *)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:(long)[sender tag] inSection:0];
    [self.friendsMutableArray removeObjectAtIndex:path.row];
    [self.newsFeedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationLeft];
    [self.newsFeedTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    NSLog(@"button two pressed in row: %ld in friends news feed.",(long)[sender tag]);
    
}
*/
@end
