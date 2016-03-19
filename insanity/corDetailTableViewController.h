//
//  corDetailTableViewController.h
//  insanity
//
//  Created by saintPN-Mac on 16/3/9.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>


@interface corDetailTableViewController : UITableViewController

@property (strong, nonatomic) AVObject *object;

@property (assign, nonatomic) NSInteger arrayType;

@end
