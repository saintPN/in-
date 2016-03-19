//
//  StatusService.h
//  test
//
//  Created by lzw on 14-9-7.
//  Copyright (c) 2014年 lzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface StatusService : NSObject
+(NSArray *) findRecentStatuses:(NSInteger)limit;
+(NSArray *)findAllUsers:(NSString*)subName;
+(NSArray *)findAllUsersExceptMe:(NSString*)subName;
+(BOOL) isMyFollower:(AVUser *)user;
+(BOOL) isMyFollowee:(AVUser *)user;
+(NSString *)followStatus:(AVUser *)user;
+(void)followOperation:(BOOL)followed user:(AVUser*) user;
+(NSString *)followOperationTitle:(BOOL)followed;
+(void)sendStatus:(NSString*)text andCallBack:(AVBooleanResultBlock)callBack;
@end
