//
//  friendsTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/3/8.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "friendsTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"


@interface friendsTableViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) NSArray *followeeArray;

@property (strong, nonatomic) NSMutableArray *selectedFolloweeMutableArray;

@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) MBProgressHUD *hud1;

@end


@implementation friendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
    self.selectedFolloweeMutableArray = [[NSMutableArray alloc] init];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, -60, self.tableView.bounds.size.width, 30)];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.placeholder = @"输入进度表名称";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.tableView addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, -30, self.tableView.bounds.size.width, 30);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(creatNewProcess) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __typeof (self) __weak weakSelf = self;
    if ([AVUser currentUser]) {
        AVQuery *followeeQuery = [AVUser followeeQuery:[AVUser currentUser].objectId];
        [followeeQuery includeKey:@"followee"];
        [followeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects) {
                weakSelf.followeeArray = [NSArray arrayWithArray:objects];
                [weakSelf.tableView reloadData];
            }
        }];
        
    }

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followeeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    
    if (self.followeeArray) {
        AVUser *user = self.followeeArray[indexPath.row][@"followee"];
        cell.textLabel.text = user.username;
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        AVUser *user = self.followeeArray[indexPath.row][@"followee"];
        [self.selectedFolloweeMutableArray addObject:user];
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        AVUser *user = self.followeeArray[indexPath.row][@"followee"];
        for (AVUser *_user in self.selectedFolloweeMutableArray) {
            if ([_user isEqual:user]) {
                [self.selectedFolloweeMutableArray removeObject:_user];
            }
            break;
        }

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label;
    if (section == 0) {
        label = [[UILabel alloc] init];
        label.text = @"好友列表";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor lightGrayColor];
    }
    
    return label;
}

#pragma mark - 用户事件

- (void)creatNewProcess {
    if (self.textField.text.length && self.selectedFolloweeMutableArray) {
        AVObject *newObject;
        if (self.i == 0) {
            newObject = [AVObject objectWithClassName:@"corporationProgress60"];
            
        } else {
            newObject = [AVObject objectWithClassName:@"corporationProgressMax"];
            
        }
        
        newObject[@"name"] = self.textField.text;
        newObject[@"date"] = [NSDate date];
        newObject[@"ownerName"] = [AVUser currentUser].username;
        newObject[@"participants"] = [NSArray arrayWithArray:self.selectedFolloweeMutableArray];
        AVACL *acl = [AVACL ACLWithUser:[AVUser currentUser]];
        for (AVUser *user in self.selectedFolloweeMutableArray) {
            [acl setWriteAccess:YES forUser:user];
            [acl setReadAccess:YES forUser:user];
        }
        newObject.ACL = acl;
        [newObject saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        self.hud1 = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.view addSubview:self.hud1];
        self.hud1.delegate = self;
        self.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
        self.hud1.mode = MBProgressHUDModeCustomView;
        self.hud1.labelText = @"名称为空或未选取用户!";
        [self.hud1 show:YES];
        [self.hud1 hide:YES afterDelay:1];
        
    }
    
    
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperViewOnHide];
    self.hud1 = nil;
}

@end
