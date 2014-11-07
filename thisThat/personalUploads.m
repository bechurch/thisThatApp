//
//  personalUploads.m
//  thisThat
//
//  Created by James Connerton on 2014-10-29.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "personalUploads.h"
#import "upload.h"

@interface personalUploads ()

@end

@implementation personalUploads

- (void)viewDidLoad {
    [super viewDidLoad];
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
@end
