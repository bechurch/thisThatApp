//
//  master.m
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import "master.h"
#import "newsFeed.h"
#import "personalUploads.h"
#import "constants.h"
#import "objects.h"
#import "newsFeedTable.h"

@interface master ()
@property (nonatomic, strong) NSMutableArray *viewControllers;
@end



@implementation master

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    


    UIPageViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    
    pageViewController.dataSource = self;
    self.view.gestureRecognizers = pageViewController.gestureRecognizers;
    UIGestureRecognizer *tapRecognizer = nil;
    for(UIGestureRecognizer *recognizer in pageViewController.gestureRecognizers){
        if([recognizer isKindOfClass:[UITapGestureRecognizer class]]){
            tapRecognizer = recognizer;
            break;
        }
    }
    if(tapRecognizer) {
        [self.view removeGestureRecognizer:tapRecognizer];
        [pageViewController.view removeGestureRecognizer:tapRecognizer];
        
    }
    
    self.viewControllers = [NSMutableArray array];
    
   // newsFeed *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Page1"];
   // newsFeedTableView *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Page1.1"];
    newsFeedTable *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Page1.2"];
    personalUploads *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Page2"];

    _viewControllers = [@[controller1, controller2] mutableCopy];
    
    NSArray *defaultViewController = [NSArray arrayWithObject:_viewControllers[0]];
    [pageViewController setViewControllers:defaultViewController direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if(viewController == _viewControllers[0]) {
        return nil;
    }
    if(viewController == _viewControllers[1]) {
        return _viewControllers[0];
    }

    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if(viewController == _viewControllers[1]) {
        return nil;
    }
    if(viewController == _viewControllers[0]) {
        return _viewControllers[1];
   
    }
    return nil;
}


@end
