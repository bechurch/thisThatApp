//
//  newsFeed.h
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface newsFeed : UIViewController <UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *noPhotosLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *noPhotosLabelTwo;
- (IBAction)voteForPhoto:(id)sender;
@property int i;
@property (weak, nonatomic) IBOutlet UIButton *voteForImageOne;
@property (weak, nonatomic) IBOutlet UIButton *voteForImageTwo;

@end
