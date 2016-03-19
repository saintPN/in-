//
//  corporationTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/3/8.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "corporationTableViewController.h"
#import "corDetailTableViewController.h"
#import "friendsTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"



@interface corporationTableViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) UISegmentedControl *segment;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) MBProgressHUD *hud1;

@property (strong, nonatomic) NSMutableArray *array;

@property NSInteger selectedRow;

@end


@implementation corporationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.contentInset =UIEdgeInsetsMake(28, 0, 0, 0);
    NSArray *array = [[NSArray alloc] initWithObjects:@"in-60", @"in-max",nil];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    self.segment.frame = CGRectMake(0, -28, self.tableView.bounds.size.width, 28);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.segment];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.tableView.bounds.size.width, 28)];
    self.label.text = @"进度表一片空白,赶紧开始疯狂吧!";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.hidden = YES;
    [self.tableView addSubview:self.label];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.hud1 = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.view addSubview:self.hud1];
    self.hud1.delegate = self;
    self.hud1.labelText = @"正在云端搜寻数据";
    [self.hud1 showWhileExecuting:@selector(getData) onTarget:self withObject:nil animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除进度表";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"corDetailSegue" sender:nil];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([AVUser currentUser].username == self.array[indexPath.row][@"ownerName"]) {
            [self.array removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            if (!self.array.count) {
                self.label.hidden = NO;
            }
            AVQuery *query;
            if (self.segment.selectedSegmentIndex == 0) {
                query = [AVQuery queryWithClassName:@"corporationProgress60"];
            } else {
                query = [AVQuery queryWithClassName:@"corporationProgressMax"];
            }
            [query includeKey:@"participants"];
            [query includeKey:@"details"];
            [query orderByDescending:@"date"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (AVObject *object in objects[indexPath.row][@"details"]) {
                    [object deleteInBackground];
                };
                for (AVUser *user in objects[indexPath.row][@"participants"]) {
                    [user deleteInBackground];
                };
                
                [objects[indexPath.row] deleteInBackground];
                
            }];

        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"需要创建者删除当前进度！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"corCell" forIndexPath:indexPath];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
    if (self.array.count) {
        AVObject *object = self.array[indexPath.row];
        cell.textLabel.text = object[@"name"];
        NSMutableString *string = [NSMutableString stringWithString:@"参与者:"];
        for (AVUser *user in object[@"participants"]) {
            [string appendFormat:@" %@", user.username];

        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,创建者:%@,%@", [formatter stringFromDate:object[@"date"]], object[@"ownerName"], string];
        
    }
    
    return cell;
}

#pragma mark - 获取数据

- (void)getData {
    __typeof(self) __weak weakSelf = self;
    
    self.label.hidden = YES;
    AVQuery *query;
    if (self.segment.selectedSegmentIndex == 0) {
        query = [AVQuery queryWithClassName:@"corporationProgress60"];
    } else {
        query = [AVQuery queryWithClassName:@"corporationProgressMax"];
    }
    [query includeKey:@"details"];
    [query includeKey:@"participants"];
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            weakSelf.label.hidden = YES;
            weakSelf.array = [objects mutableCopy];
            [weakSelf.tableView reloadData];
            
            weakSelf.hud1 = [[MBProgressHUD alloc] initWithView:weakSelf.tableView];
            [weakSelf.view addSubview:weakSelf.hud1];
            weakSelf.hud1.delegate = weakSelf;
            weakSelf.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-check"]];
            weakSelf.hud1.mode = MBProgressHUDModeCustomView;
            weakSelf.hud1.labelText = @"搜寻成功!";
            [weakSelf.hud1 show:YES];
            [weakSelf.hud1 hide:YES afterDelay:1];
            
        }  else {
            
            weakSelf.array = nil;
            [weakSelf.tableView reloadData];
            weakSelf.label.hidden = NO;
            weakSelf.hud1 = [[MBProgressHUD alloc] initWithView:weakSelf.tableView];
            [weakSelf.view addSubview:weakSelf.hud1];
            weakSelf.hud1.delegate = weakSelf;
            weakSelf.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            weakSelf.hud1.mode = MBProgressHUDModeCustomView;
            weakSelf.hud1.labelText = @"搜寻完毕,无数据";
            [weakSelf.hud1 show:YES];
            [weakSelf.hud1 hide:YES afterDelay:1];
            
        }
        
    }];
    
}


#pragma mark - 用户事件

- (IBAction)creatNewProcess:(UIBarButtonItem *)sender {
    if ([AVUser currentUser]) {
        [self performSegueWithIdentifier:@"corporationSegue" sender:nil];
    } else {
        self.hud1 = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.view addSubview:self.hud1];
        self.hud1.delegate = self;
        self.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
        self.hud1.mode = MBProgressHUDModeCustomView;
        self.hud1.labelText = @"请先登录!";
        [self.hud1 show:YES];
        [self.hud1 hide:YES afterDelay:1];
        
    }
}

#pragma mark - segue传值

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[friendsTableViewController class]]) {
        ((friendsTableViewController *)nextController).i = self.segment.selectedSegmentIndex;
    } else {
        ((corDetailTableViewController *)nextController).object = self.array[self.selectedRow];
        ((corDetailTableViewController *)nextController).arrayType = self.segment.selectedSegmentIndex;
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperViewOnHide];
    self.hud1 = nil;
}

@end
