//
//  ComposeVC.h
//  twitter
//
//  Created by Kevin Lee on 10/22/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeVC : UIViewController<UITextViewDelegate>
- (void)replyToUser:(NSString*)replyToHandle withTweetId:(NSString*)tweetId;
@end
