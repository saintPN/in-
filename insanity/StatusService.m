//
//  StatusService.m
//  test
//
//  Created by lzw on 14-9-7.
//  Copyright (c) 2014年 lzw. All rights reserved.
//

#import "StatusService.h"

@implementation StatusService

+(NSArray *)findRecentStatuses:(NSInteger)limit{
    AVStatusQuery *query=[AVStatus inboxQuery:kAVStatusTypeTimeline];
    [query includeKey:@"source"];
    //query.limit=50;
    NSArray *objects=[query findObjects];
    return objects;
}

+(NSArray *)findAllUsers:(NSString* )subName{
    AVQuery *q=[AVUser query];
    if(subName){
        [q whereKey:@"username" containsString:subName];
    }
    return [q findObjects];
}

+(NSArray*)findAllUsersExceptMe:(NSString*) subName{
    NSArray *users=[self findAllUsers:subName];
    NSMutableArray *_users=[NSMutableArray arrayWithArray:users];
    AVUser* currentUser=[AVUser currentUser];
    for(AVUser *_user in _users){
        if([[currentUser username] isEqualToString:[_user username]]){
            [_users removeObject:_user];
            break;
        }
    }
    return [NSArray arrayWithArray:_users];
}

+(BOOL)askFollowStatus:(AVUser *)user askFollower:(BOOL) askFollower{
    AVUser* curUser=[AVUser currentUser];
    AVQuery *q;
    if(askFollower){
        q=[AVUser followerQuery:curUser.objectId];
        [q whereKey:@"follower" equalTo:user];
    }else{
        q=[AVUser followeeQuery:curUser.objectId];
        [q whereKey:@"followee" equalTo:user];
    }
    AVObject* follow=[q getFirstObject];
    if(follow){
        return YES;
    }else{
        return NO;
    }
}

+(BOOL) isMyFollower:(AVUser *)user{
    return [self askFollowStatus:user askFollower:YES];
}

+(BOOL) isMyFollowee:(AVUser *)user{
    return [self askFollowStatus:user askFollower:NO];
}

+(NSString *)followStatus:(AVUser *)user{
    BOOL isMyFollower=[self isMyFollower:user];
    NSLog(@"isMyFollower");
    BOOL isMyFollowee=[self isMyFollowee:user];
    if(isMyFollower && isMyFollowee){
        return @"互相关注";
    }else if(isMyFollower){
        return @"Ta关注了您";
    }else if(isMyFollowee){
        return @"已关注";
    }else{
        return @"";
    }
}

+(NSString *)followOperationTitle:(BOOL)followed{
    if(followed){
        return @"取消关注";
    }else{
        return @"关注Ta";
    }
}

+(void)followOperation:(BOOL)followed user:(AVUser*) user{
    AVUser* curUser=[AVUser currentUser];
    if(followed){
        [curUser unfollow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
        }];
    }else{
        [curUser follow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
        }];
    }
}

+(void)sendStatus:(NSString*)text andCallBack:(AVBooleanResultBlock)callBack{
    AVStatus *status=[[AVStatus alloc] init];
    AVUser* curUser=[AVUser currentUser];
    NSLog(@"curUser=%@",[curUser username]);
    status.source=curUser;
    status.data=@{@"text":text};
    [AVStatus sendStatusToFollowers:status andCallback:callBack];
}
@end
