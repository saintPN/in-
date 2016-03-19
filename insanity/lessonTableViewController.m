//
//  lessonTableViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/1/1.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "lessonTableViewController.h"


@interface lessonTableViewController ()

@property (strong, nonatomic) NSArray *lessonArray;

@property (strong, nonatomic) NSArray *insanityArray;

@property (strong, nonatomic) NSArray *maxArray;

@property (strong, nonatomic) UISegmentedControl *segment;

@end


@implementation lessonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.insanityArray = [[NSArray alloc] initWithObjects:@"Fit test-基础测试", @"Plyometric cardio circuit-增强式有氧循环", @"Cardio power&resistance-有氧力量与阻力", @"Cardio recovery-有氧恢复", @"Pure cardio-纯有氧", @"Cardio abs-腹部有氧", @"Core cardio&balance-核心有氧与平衡", @"Max interval circuit-极限间歇循环", @"Max interval plyo-极限间歇增强", @"Max cardio conditioning-极限心肺功能调节", @"Max recovery-极限恢复", @"Insane abs-疯狂腹肌", @"Max interval sports traning-极限间歇运动", @"Upper body weight traning-上半身负重",nil];
    self.maxArray = [[NSArray alloc] initWithObjects:@"Cardio chanllenge-有氧挑战", @"Tabata power-嗒巴嗒力量", @"Sweat intervals-间隔性训练", @"Tabata strength-嗒巴嗒体力", @"Friday:Round 1-星期五计划:第1回", @"MAX OUT Cardio-极限有氧", @"MAX OUT Power-极限力量", @"MAX OUT Sweat-极限消耗", @"MAX OUT Strength-极限体力", @"Friday:Round 2-星期五计划:第2回", @"Pulse-恢复性训练", @"Abs attack:10-腹肌突袭10分钟",@"360 Abs-360腹肌", @"MAX OUT 15-极限15分钟", @"MAX OUT Abs-极限腹肌",nil];
    self.lessonArray = [[NSArray alloc] initWithArray:self.insanityArray];
    
    self.tableView.contentInset =UIEdgeInsetsMake(28, 0, 0, 0);
    NSArray *array = [[NSArray alloc] initWithObjects:@"in-60", @"in-max", nil];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    self.segment.frame = CGRectMake(0, -28, self.tableView.bounds.size.width, 28);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.segment];
    
    
}

- (void)segmentChange {
    if (self.segment.selectedSegmentIndex == 0) {
        self.lessonArray = [[NSArray alloc] initWithArray:self.insanityArray];
    } else {
        self.lessonArray = [[NSArray alloc] initWithArray:self.maxArray];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lessonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    cell.detailTextLabel.text = self.lessonArray[indexPath.row];
    
    return cell;
}

@end
