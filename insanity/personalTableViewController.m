//
//  personalTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/2/27.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "personalDetailTableViewController.h"
#import "fittestDetailViewController.h"
#import "personalTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"


@interface personalTableViewController () <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;

@property (strong, nonatomic) UISegmentedControl *segment;

@property (strong, nonatomic) MBProgressHUD *hud1;

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) UILabel *label;

@property NSInteger selectedRow;

@end


@implementation personalTableViewController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.contentInset =UIEdgeInsetsMake(28, 0, 0, 0);
    NSArray *array = [[NSArray alloc] initWithObjects:@"Fit test", @"in-60", @"in-max",nil];
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

#pragma mark - UITableViewDelegate

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
    
    if (self.segment.selectedSegmentIndex == 0) {
        [self performSegueWithIdentifier:@"fittestDetailSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"personalDetailSegue" sender:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    if (self.array.count) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        
        AVObject *object= self.array[indexPath.row];
        cell.textLabel.text = object[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:object[@"date"]]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.array removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if (!self.array.count) {
            self.label.hidden = NO;
        }
    }
    
    AVQuery *query;
    if (self.segment.selectedSegmentIndex == 0) {
        query = [AVQuery queryWithClassName:@"fittest"];
    } else if (self.segment.selectedSegmentIndex == 1) {
        query = [AVQuery queryWithClassName:@"progress60"];
    } else {
        query = [AVQuery queryWithClassName:@"progressMax"];
    }
    [query includeKey:@"details"];
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVObject *object in objects[indexPath.row][@"details"]) {
            [object deleteInBackground];
        };
        [objects[indexPath.row] deleteInBackground];
        
    }];
    
}

#pragma mark - 创建新进度表

- (IBAction)createNewProcess:(UIBarButtonItem *)sender {
    __typeof (self) __weak weakSelf = self;
    if ([AVUser currentUser]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入记录表名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            [textField addTarget:weakSelf action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        weakSelf.hud1 = [[MBProgressHUD alloc] initWithView:weakSelf.tableView];
        [weakSelf.view addSubview:weakSelf.hud1];
        weakSelf.hud1.delegate = weakSelf;
        weakSelf.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
        weakSelf.hud1.mode = MBProgressHUDModeCustomView;
        weakSelf.hud1.labelText = @"请先登录!";
        [weakSelf.hud1 show:YES];
        [weakSelf.hud1 hide:YES afterDelay:1];
        
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length) {
        AVObject *newObject;
        if (self.segment.selectedSegmentIndex == 0) {
            newObject = [AVObject objectWithClassName:@"fittest"];
        } else if (self.segment.selectedSegmentIndex == 1) {
            newObject = [AVObject objectWithClassName:@"progress60"];
        } else {
            newObject = [AVObject objectWithClassName:@"progressMax"];
        }
        newObject[@"name"] = textField.text;
        newObject[@"date"] = [NSDate date];
        newObject.ACL = [AVACL ACLWithUser:[AVUser currentUser]];
        [newObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                AVQuery *query;
                if (self.segment.selectedSegmentIndex == 0) {
                    query = [AVQuery queryWithClassName:@"fittest"];
                } else if (self.segment.selectedSegmentIndex == 1) {
                    query = [AVQuery queryWithClassName:@"progress60"];
                } else {
                    query = [AVQuery queryWithClassName:@"progressMax"];
                }
                [query includeKey:@"details"];
                [query orderByDescending:@"date"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count) {
                        
                        self.label.hidden = YES;
                        self.array = [objects mutableCopy];
                        [self.tableView reloadData];
                    }
                }];
            }

            
        }];
        
        
    } else {
        self.hud1 = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.view addSubview:self.hud1];
        self.hud1.delegate = self;
        self.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
        self.hud1.mode = MBProgressHUDModeCustomView;
        self.hud1.labelText = @"名称不能为空!";
        [self.hud1 show:YES];
        [self.hud1 hide:YES afterDelay:1];

    }
    
}

#pragma mark - 获取数据

- (void)getData {
    __typeof(self) __weak weakSelf = self;
    
    self.label.hidden = YES;
    
    AVQuery *query;
    if (self.segment.selectedSegmentIndex == 0) {
        query = [AVQuery queryWithClassName:@"fittest"];
    } else if (self.segment.selectedSegmentIndex == 1) {
        query = [AVQuery queryWithClassName:@"progress60"];
    } else {
        query = [AVQuery queryWithClassName:@"progressMax"];
    }
    [query includeKey:@"details"];
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.addBarButtonItem.enabled = YES;
        
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

#pragma mark - segue跳转传值

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[fittestDetailViewController class]]) {
        ((fittestDetailViewController *)nextController).object = self.array[self.selectedRow];
    } else {
        ((personalDetailTableViewController *)nextController).object = self.array[self.selectedRow];
        ((personalDetailTableViewController *)nextController).arrayType = self.segment.selectedSegmentIndex;
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperViewOnHide];
    self.hud1 = nil;
}

@end
