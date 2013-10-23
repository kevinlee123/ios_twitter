//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;

@end

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet
{
    self.userNameLabel.text = tweet.userName;
    self.userHandleLabel.text = [@"@" stringByAppendingString:tweet.userHandle];
    self.messageLabel.text = tweet.text;
    self.postTimeLabel.text = tweet.elapsedPostTime;
    
    NSURL *url = [NSURL URLWithString:tweet.profileUrl];
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.clipsToBounds=YES;
    
    [self.userImage setImageWithURL:url];
}

@end
