//
//  personalPostsTableViewCell.m
//  thisThat
//
//  Created by James Connerton on 2015-02-11.
//  Copyright (c) 2015 James Connerton. All rights reserved.
//

#import "personalPostsTableViewCell.h"

@implementation personalPostsTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}
@end
