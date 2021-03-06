//
//  personalDetailTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/2/28.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "personalDetailTableViewController.h"

@interface personalDetailTableViewController ()

@property (strong, nonatomic) NSArray *array;

@property (strong, nonatomic) NSMutableArray *mutableArray;

@property (strong, nonatomic) NSArray *array60;

@property (strong, nonatomic) NSArray *arrayMax;

@end

@implementation personalDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.mutableArray = [[NSMutableArray alloc] init];
    if (self.object[@"details"]) {
        self.mutableArray = self.object[@"details"];
    }
    self.array60 = [[NSArray alloc] initWithObjects:@"第1天-基础测试", @"第2天-增强式有氧循环", @"第3天-有氧力量与阻力", @"第4天-有氧恢复", @"第5天-纯有氧", @"第6天-增强式有氧循环", @"第7天-休息", @"第8天-有氧力量与阻力", @"第9天-纯有氧", @"第10天-增强式有氧", @"第11天-有氧恢复", @"第12天-有氧力量与阻力", @"第13天-纯有氧/腹部有氧", @"第14天-休息", @"第15天-基础测试", @"第16天-增强式有氧循环", @"第17天-纯有氧/腹部有氧", @"第18天-有氧恢复", @"第19天-有氧力量与阻力", @"第20天-增强式有氧循环", @"第21天-休息", @"第22天-纯有氧/腹部有氧", @"第23天-有氧力量与阻力", @"第24天-有氧恢复", @"第25天-纯有氧", @"第26天-纯有氧/腹部有氧",@"第27天-增强式有氧循环", @"第28天-休息",@"第29天-核心有氧与平衡", @"第30天-核心有氧与平衡", @"第31天-核心有氧与平衡", @"第32天-核心有氧与平衡", @"第33天-核心有氧与平衡", @"第34天-核心有氧与平衡", @"第35天-休息",@"第36天-基础测试/极限间歇循环", @"第37天-极限间歇增强", @"第38天-极限心肺功能调节", @"第39天-极限恢复", @"第40天-极限间歇运动训练", @"第41天-极限间歇循环", @"第42天-休息", @"第43天-极限心肺功能调节", @"第44天-极限间歇增强", @"第45天-极限间歇增强", @"第46天-极限恢复", @"第47天-心肺功能/疯狂腹肌", @"第48天-核心有氧与平衡", @"第49天-休息", @"第50天-基础测试/极限间歇循环", @"第51天-极限间歇增强", @"第52天-心肺功能/疯狂腹肌", @"第53天-极限恢复", @"第54天-极限间歇增强", @"第55天-核心有氧与平衡", @"第56天-休息", @"第57天-极限间歇增强", @"第58天-心肺功能/疯狂腹肌", @"第59天-极限间歇循环", @"第60天-核心有氧与平衡", @"第61天-极限间歇增强", @"第62天-心肺功能/疯狂腹肌", @"第63天-休息",nil];
    self.arrayMax = [[NSArray alloc] initWithObjects:@"第1天-有氧挑战", @"第2天-嗒巴嗒力量", @"第3天-间隔性训练", @"第4天-嗒巴嗒力量", @"第5天-星期五计划:第1回", @"第6天-恢复性训练", @"第7天-休息", @"第8天-有氧挑战/腹肌突袭", @"第9天-嗒巴嗒力量", @"第10天-极限消耗/腹肌突袭", @"第11天-嗒巴嗒力量", @"第12天-星期五计划:第1回", @"第13天-恢复性训练/腹肌突袭", @"第14天-休息", @"第15天-有氧挑战/极限腹肌", @"第16天-嗒巴嗒力量", @"第17天-极限消耗/360腹肌", @"第18天-嗒巴嗒力量", @"第19天-星期五计划:第1回", @"第20天-恢复性训练/腹肌突袭", @"第21天-休息", @"第22天-有氧挑战/360腹肌", @"第23天-嗒巴嗒力量", @"第24天-极限消耗/极限腹肌", @"第25天-嗒巴嗒力量", @"第26天-星期五计划:第1回",@"第27天-恢复性训练/腹肌突袭", @"第28天-休息",@"第29天-极限有氧", @"第30天-极限力量", @"第31天-极限消耗", @"第32天-极限体力", @"第33天-星期五计划:第2回", @"第34天-恢复性训练", @"第35天-休息",@"第36天-极限有氧/腹肌突袭", @"第37天-极限力量", @"第38天-极限消耗/腹肌突袭", @"第39天-极限体力", @"第40天-星期五计划:第2回", @"第41天-恢复性训练/腹肌突袭", @"第42天-休息", @"第43天-极限有氧/极限有氧", @"第44天-极限力量", @"第45天-极限消耗/360腹肌", @"第46天-极限体力", @"第47天-星期五计划:第2回", @"恢复性训练/腹肌突袭", @"第49天-休息", @"第50天-极限有氧/360腹肌", @"第51天-极限力量", @"第52天-极限消耗/极限腹肌", @"第53天-极限体力", @"第54天-星期五计划:第2回", @"第55天-有氧挑战", @"第56天-休息", nil];
    if (self.arrayType == 1) {
        self.array = [[NSArray alloc] initWithArray:self.array60];
    } else {
        self.array = [[NSArray alloc] initWithArray:self.arrayMax];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.object[@"details"] = self.mutableArray;
    [self.object saveInBackground];
}

#pragma mark - tableview设置

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalDetailCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"button-cross"];
    cell.textLabel.text = self.array[indexPath.row];
    cell.detailTextLabel.text = @"未完成";
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
    formatter.timeStyle = NSDateIntervalFormatterShortStyle;
    for (AVObject *object in self.mutableArray) {
        if ([object[@"row"] integerValue] == indexPath.row) {
            cell.imageView.image = [UIImage imageNamed:@"button-check"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"完成于%@", [formatter stringFromDate:object[@"date"]]];
            cell.backgroundColor = [UIColor lightGrayColor];
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    __weak __typeof (self) weakSelf = self;
    
    if ([cell.detailTextLabel.text isEqualToString:@"未完成"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确认"
                                                                       message:@"完成当前课程?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  cell.imageView.image = [UIImage imageNamed:@"button-check"];
                                                                  cell.backgroundColor = [UIColor lightGrayColor];
                                                                  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                  formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
                                                                  formatter.timeStyle = NSDateIntervalFormatterShortStyle;
                                                                  cell.detailTextLabel.text = [formatter stringFromDate:[NSDate date]];
                                                                  
                                                                  AVObject *object;
                                                                  if (weakSelf.arrayType == 1) {
                                                                      object = [AVObject objectWithClassName:@"detail60"];
                                                                  } else {
                                                                      object = [AVObject objectWithClassName:@"detailMax"];
                                                                  }
                                                                  object[@"row"] = [NSNumber numberWithInteger:indexPath.row];
                                                                  object[@"date"] = [NSDate date];
                                                                  object.ACL = [AVACL ACLWithUser:[AVUser currentUser]];
                                                                  [object saveInBackground];
                                                                  
                                                                  [weakSelf.mutableArray addObject:object];

                                                              }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确认"
                                                                       message:@"复原当前课程?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  cell.imageView.image = [UIImage imageNamed:@"button-cross"];
                                                                  cell.textLabel.text = self.array[indexPath.row];
                                                                  cell.detailTextLabel.text = @"未完成";
                                                                  cell.backgroundColor = [UIColor whiteColor];
                                                                  
                                                                  for (AVObject *object in weakSelf.mutableArray) {
                                                                      if ([object[@"row"] integerValue] == indexPath.row) {
                                                                          [weakSelf.mutableArray removeObject:object];
                                                                          break;
                                                                      }
                                                                  }
                                                                  weakSelf.object[@"details"] = self.mutableArray;
                                                                  
                                                              }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
