//
//  TweetVCViewController.m
//  twitter
//
//  Created by Kevin Lee on 10/21/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeVC.h"

@interface TweetVC ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@property (nonatomic) Boolean favorite;


- (void)setImageUrl:(NSString *)imageUrl;
- (IBAction)onFavoriteClick:(id)sender;
- (IBAction)onRetweetClick:(id)sender;
- (IBAction)onReplyClick:(id)sender;
- (void)onCompose;
- (void)selectFavoriteButton;
- (void)unselectFavoriteButton;
- (void)selectRetweetButton;
- (void)unselectRetweetButton;
@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setImageUrl:self.tweet.profileUrl];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PencilImage"] style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    
    self.navigationItem.rightBarButtonItem=composeButton;
    
    self.usernameLabel.text = self.tweet.userName;
    self.userHandleLabel.text = [@"@" stringByAppendingString:self.tweet.userHandle];
    
    self.messageLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    self.messageLabel.text = self.tweet.text;
    
    NSDate *postTime = self.tweet.postTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
    self.postDateLabel.text = [formatter stringFromDate:postTime];
    
    if (self.tweet.isFavorite == YES) {
        [self selectFavoriteButton];
    }
    
    if (self.tweet.isRetweet == YES) {
        [self selectRetweetButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.clipsToBounds=YES;
    
    [self.profileImage setImageWithURL:url];
}

- (IBAction)onFavoriteClick:(id)sender {
    if (self.tweet.isFavorite == YES) {
        [[TwitterClient instance] deleteFavoriteWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            [self unselectFavoriteButton];
            NSLog(@"response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to delete favorite");
        }];
    } else {
        [[TwitterClient instance] addFavoriteWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            [self selectFavoriteButton];
            NSLog(@"response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to add favorite");
        }];
    }
}

- (IBAction)onRetweetClick:(id)sender {
    if (self.tweet.isRetweet == YES) {
        [[TwitterClient instance] deleteTweetWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            [self unselectRetweetButton];
            NSLog(@"response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to delete retweet");
        }];
    } else {
        [[TwitterClient instance] retweetWithId:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            [self selectRetweetButton];
            NSLog(@"response: %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to retweet");
        }];
    }
}

- (IBAction)onReplyClick:(id)sender {
    ComposeVC* composeViewController = [[ComposeVC alloc] init];
    
    [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
    [composeViewController replyToUser:self.tweet.userHandle withTweetId:self.tweet.tweetId];
}

- (void)onCompose {
    ComposeVC* composeViewController = [[ComposeVC alloc] init];
    
    [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
}

- (void)selectFavoriteButton {
    self.tweet.favorite = YES;
    
    [self.favoriteButton setBackgroundColor:[UIColor yellowColor]];
}
- (void)unselectFavoriteButton {
    self.tweet.favorite = NO;
    
    [self.favoriteButton setBackgroundColor:[UIColor whiteColor]];
}

- (void)selectRetweetButton {
    self.tweet.retweet = YES;
    
    [self.retweetButton setBackgroundColor:[UIColor yellowColor]];
}
- (void)unselectRetweetButton {
    self.tweet.retweet = NO;
    
    [self.retweetButton setBackgroundColor:[UIColor whiteColor]];
}

@end
