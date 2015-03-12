//
//  objects.h
//  thisThat
//
//  Created by James Connerton on 2014-10-25.
//  Copyright (c) 2014 James Connerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface objects : NSObject

@property (nonatomic, strong) NSString *imageOne;
@property (nonatomic, strong) NSString *imageTwo;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *postId;
@property (nonatomic, strong) NSNumber *voteCountOne;
@property (nonatomic, strong) NSNumber *voteCountTwo;
@property (nonatomic, strong) NSNumber *vote;
@property int x;
@end
