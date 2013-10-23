//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)tweetId {
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)userName {
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)userHandle {
    return [self.data valueOrNilForKeyPath:@"user.screen_name"];
}

- (NSString *)profileUrl {
    return [self.data valueOrNilForKeyPath:@"user.profile_image_url"];
}

- (NSDate *)postTime {
    NSString *str = [self.data valueOrNilForKeyPath:@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE MMM dd hh:mm:ss Z yyyy"];
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

- (NSString *)elapsedPostTime {
    NSDate *postDate = [self postTime];

    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:postDate];

    NSInteger ti = (NSInteger)diff;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%2i h", hours];
    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"%02i m", minutes];
    } else {
        return [NSString stringWithFormat:@"%02i s", seconds];
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:params];
        tweet.favorite = [[tweet.data valueOrNilForKeyPath:@"favorited"] boolValue];
        tweet.retweet = [[tweet.data valueOrNilForKeyPath:@"retweeted"] boolValue];
        
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
