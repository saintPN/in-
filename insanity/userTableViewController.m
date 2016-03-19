//
//  userTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/2/29.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "userTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
#import "StatusService.h"


@interface userTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UIButton *userIconButton;

@property (strong, nonatomic) UIButton *showButton;

@property (strong, nonatomic) MBProgressHUD *hud1;

@property (strong, nonatomic) NSMutableArray *followeeArray;

@property (strong, nonatomic) UILabel *infoLabel;

@property (assign) int i;

@end


@implementation userTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setting];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __typeof (self) __weak weakSelf = self;
    if ([AVUser currentUser]) {
        AVUser *user = [AVUser currentUser];
        self.userLabel.text = user.username;
        AVFile *file = [AVFile fileWithURL:user[@"iconURL"]];
        if (user[@"iconURL"]) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [weakSelf.userIconButton setImage:image forState:UIControlStateNormal];
            }];
            
        } else {
            [self.userIconButton setImage:[UIImage imageNamed:@"run"] forState:UIControlStateNormal];
        }
        
        
        AVQuery *followeeQuery = [AVUser followeeQuery:[AVUser currentUser].objectId];
        [followeeQuery includeKey:@"followee"];
        [followeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects) {
                weakSelf.followeeArray = [objects mutableCopy];
                [weakSelf.tableView reloadData];
            }
        }];
        
    } else {
        [self.userIconButton setImage:[UIImage imageNamed:@"run"] forState:UIControlStateNormal];
        self.userLabel.text = @"用户名称";

    }
    
}

- (void)setting {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, -120, self.tableView.bounds.size.width, 120)];
    iv.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:iv];
    
    self.userIconButton = [[UIButton alloc] initWithFrame:CGRectMake((self.tableView.bounds.size.width-80)/2, -115, 80, 80)];
    [self.userIconButton setImage:[UIImage imageNamed:@"run"] forState:UIControlStateNormal];
    self.userIconButton.layer.cornerRadius = CGRectGetHeight(self.userIconButton.bounds)/2;
    self.userIconButton.layer.masksToBounds = YES;
    [self.userIconButton addTarget:self action:@selector(userChoose) forControlEvents:UIControlEventTouchUpInside];
    self.userIconButton.layer.borderWidth = 2;
    self.userIconButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.tableView addSubview:self.userIconButton];
    
    self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -33, self.tableView.bounds.size.width, 28)];
    self.userLabel.textColor = [UIColor whiteColor];
    self.userLabel.text = @"用户名称";
    self.userLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.userLabel];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followeeArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消关注";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    if (self.followeeArray.count) {
        AVUser *user = self.followeeArray[indexPath.row][@"followee"];
        cell.textLabel.text = user.username;
        
    }
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.showButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
        [self.showButton addTarget:self action:@selector(showFollowee) forControlEvents:UIControlEventTouchUpInside];
        [self.showButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [view addSubview:self.showButton];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.tableView.bounds.size.width, 30)];
        self.infoLabel.textColor = [UIColor blackColor];
        self.infoLabel.text = @"关注好友";
        self.infoLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.infoLabel];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AVUser *user = self.followeeArray[indexPath.row][@"followee"];
        [[AVUser currentUser] unfollow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {}];
        
        [self.followeeArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    AVUser *user = [AVUser currentUser];
    if (user[@"iconURL"]) {
        AVFileQuery *fileQ = [AVFileQuery query];
        [fileQ whereKey:@"url" equalTo:user[@"iconURL"]];
        [fileQ findFilesInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (AVFile *file in objects) {
                [file deleteInBackground];
            }
        }];
    }
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    AVFile *file = [AVFile fileWithData:data];
    file.ACL = [AVACL ACLWithUser:user];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [user setObject:file.url forKey:@"iconURL"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    AVFile *file = [AVFile fileWithURL:user[@"iconURL"]];
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [self.userIconButton setImage:image forState:UIControlStateNormal];
                    }];
                    
                }
            }];
            
        }
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 用户事件

- (IBAction)addFollowee:(UIBarButtonItem *)sender {
    __typeof (self) __weak weakSelf = self;

    if ([AVUser currentUser]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关注好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField addTarget:weakSelf action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关注好友,请先登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf performSegueWithIdentifier:@"logSegue" sender:nil];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    __typeof (self) __weak weakSelf = self;
    
    AVQuery *query = [AVUser query];
    [query whereKey:@"username" equalTo:textField.text];
    NSString *str = [query getFirstObject].objectId;
    
    [[AVUser currentUser] follow:str andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            AVQuery *followeeQuery = [AVUser followeeQuery:[AVUser currentUser].objectId];
            [followeeQuery includeKey:@"followee"];
            [followeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects) {
                    weakSelf.followeeArray = [objects mutableCopy];
                    [weakSelf.tableView reloadData];
                }
            }];
            
            weakSelf.hud1 = [[MBProgressHUD alloc] initWithView:weakSelf.tableView];
            [weakSelf.view addSubview:weakSelf.hud1];
            weakSelf.hud1.delegate = weakSelf;
            weakSelf.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-check"]];
            weakSelf.hud1.mode = MBProgressHUDModeCustomView;
            weakSelf.hud1.labelText = @"关注成功";
            [weakSelf.hud1 show:YES];
            [weakSelf.hud1 hide:YES afterDelay:1];

        } else {
            weakSelf.hud1 = [[MBProgressHUD alloc] initWithView:weakSelf.tableView];
            [weakSelf.view addSubview:weakSelf.hud1];
            weakSelf.hud1.delegate = weakSelf;
            weakSelf.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            weakSelf.hud1.mode = MBProgressHUDModeCustomView;
            weakSelf.hud1.labelText = @"请输入正确的用户名";
            [weakSelf.hud1 show:YES];
            [weakSelf.hud1 hide:YES afterDelay:2];
            
        }
    
    }];
    
}

- (void)showFollowee {
    __typeof (self) __weak weakSelf = self;
    if (self.followeeArray.count) {
        self.followeeArray = nil;
        [self.tableView reloadData];
        self.userIconButton.alpha = 0;

    } else {
        AVQuery *followeeQuery = [AVUser followeeQuery:[AVUser currentUser].objectId];
        [followeeQuery includeKey:@"followee"];
        [followeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects) {
                weakSelf.followeeArray = [objects mutableCopy];
                [weakSelf.tableView reloadData];
                weakSelf.userIconButton.alpha = 1;

            }
            
        }];
        
    }

}

- (void)userChoose {
    __typeof (self) __weak weakSelf = self;
    if ([AVUser currentUser]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"手机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            imagePicker.delegate = weakSelf;
            imagePicker.showsCameraControls = YES;
            imagePicker.allowsEditing = YES;
            
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary & UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.delegate = weakSelf;
            imagePicker.allowsEditing = YES;
            
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置头像,请先登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf performSegueWithIdentifier:@"logSegue" sender:nil];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperViewOnHide];
    self.hud1 = nil;
}

@end
