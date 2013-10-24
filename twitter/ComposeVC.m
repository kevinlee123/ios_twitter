//
//  ComposeVC.m
//  twitter
//
//  Created by Kevin Lee on 10/22/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeVC ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *characterNumLabel;

@property (nonatomic, strong) NSString *replyTweetId;

- (IBAction)onCancel:(id)sender;
- (IBAction)onTweet:(id)sender;

- (void)updateCharacterCountWithMessageLength:(int)length;
- (void)reloadTweets;
@end

@implementation ComposeVC

int const MAX_NUM_CHARS = 140;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    User* currentUser = [User currentUser];
    self.userNameLabel.text = [currentUser.data valueOrNilForKeyPath:@"name"];
    self.userHandleLabel.text = [@"@" stringByAppendingString:[currentUser.data valueOrNilForKeyPath:@"screen_name"]];
    
    NSURL *url = [NSURL URLWithString:[currentUser.data valueOrNilForKeyPath:@"profile_image_url"]];
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.clipsToBounds=YES;
    
    [self.profileImage setImageWithURL:url];
    
    self.messageText.delegate = self;
    self.messageText.text = @"";
    
    [self updateCharacterCountWithMessageLength:self.messageText.text.length];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweet:(id)sender {
    if ([self.messageText.text length] == 0) {
        return;
    }
    
    if (self.replyTweetId != nil) {
        [[TwitterClient instance] replyToTweetId:self.replyTweetId withMessage:self.messageText.text success:^(AFHTTPRequestOperation *operation, id response) {
            [self reloadTweets];
            [self onCancel:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to tweet");
        }];
    } else {
        [[TwitterClient instance] tweetWithMessage:self.messageText.text success:^(AFHTTPRequestOperation *operation, id response) {
            [self reloadTweets];
            [self onCancel:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"An error occurred while trying to tweet");
        }];
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int numCharacters = (text.length - range.length) + self.messageText.text.length;
    if (numCharacters > MAX_NUM_CHARS) {
        return NO;
    }
    
    [self updateCharacterCountWithMessageLength:numCharacters];
    
    return YES;
}

- (void)updateCharacterCountWithMessageLength:(int)length {
    self.characterNumLabel.text = [NSString stringWithFormat:@"%i", (MAX_NUM_CHARS - length)];
}

- (void)replyToUser:(NSString*)replyToHandle withTweetId:(NSString*)tweetId
{
    self.replyTweetId = tweetId;
    self.messageText.text = [NSString stringWithFormat:@"@%@ ", replyToHandle];
    
    [self updateCharacterCountWithMessageLength:self.messageText.text.length];
}

- (void)reloadTweets {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReloadTimelineTweets"
     object:nil];
}
@end
