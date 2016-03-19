//
//  fittestDetailViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/1/25.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "fittestDetailViewController.h"
#import "MBProgressHUD.h"


@interface fittestDetailViewController () <UITextFieldDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoTextField;

@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@property (weak, nonatomic) IBOutlet UITextField *fourTextField;

@property (weak, nonatomic) IBOutlet UITextField *fiveTextField;

@property (weak, nonatomic) IBOutlet UITextField *sixTextField;

@property (weak, nonatomic) IBOutlet UITextField *sevenTextField;

@property (weak, nonatomic) IBOutlet UITextField *eightTextField;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *sixLabel;

@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;

@property (weak, nonatomic) IBOutlet UILabel *eightLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) MBProgressHUD *hud1;

@property (strong, nonatomic) MBProgressHUD *hud2;

@end


@implementation fittestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneLabel.layer.cornerRadius = 5;
    self.twoLabel.layer.cornerRadius = 5;
    self.threeLabel.layer.cornerRadius = 5;
    self.fourLabel.layer.cornerRadius = 5;
    self.fiveLabel.layer.cornerRadius = 5;
    self.sixLabel.layer.cornerRadius = 5;
    self.sevenLabel.layer.cornerRadius = 5;
    self.eightLabel.layer.cornerRadius = 5;
    self.oneLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.twoLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.threeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.fourLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.fiveLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.sixLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.sevenLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.eightLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.oneLabel.layer.borderWidth = 1;
    self.twoLabel.layer.borderWidth = 1;
    self.threeLabel.layer.borderWidth = 1;
    self.fourLabel.layer.borderWidth = 1;
    self.fiveLabel.layer.borderWidth = 1;
    self.sixLabel.layer.borderWidth = 1;
    self.sevenLabel.layer.borderWidth = 1;
    self.eightLabel.layer.borderWidth = 1;
    
    [self settingUI];
}

- (void)settingUI {
    if (self.object[@"details"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        formatter.timeStyle = NSDateIntervalFormatterShortStyle;
        NSString *str = [formatter stringFromDate:self.object[@"details"][@"date"]];
        self.label.text = [NSString stringWithFormat:@"%@,你的fit test次数", str];
        self.oneTextField.hidden = YES;
        self.twoTextField.hidden = YES;
        self.threeTextField.hidden = YES;
        self.fourTextField.hidden = YES;
        self.fiveTextField.hidden = YES;
        self.sixTextField.hidden = YES;
        self.sevenTextField.hidden = YES;
        self.eightTextField.hidden = YES;

        self.oneLabel.text = [NSString stringWithFormat:@"交换蹬腿:%@次", self.object[@"details"][@"one"]];
        self.twoLabel.text = [NSString stringWithFormat:@"强力深蹲:%@次", self.object[@"details"][@"two"]];
        self.threeLabel.text = [NSString stringWithFormat:@"强力抬膝:%@次", self.object[@"details"][@"three"]];
        self.fourLabel.text = [NSString stringWithFormat:@"强力弹跳:%@次", self.object[@"details"][@"four"]];
        self.fiveLabel.text = [NSString stringWithFormat:@"来回弹跳:%@次", self.object[@"details"][@"five"]];
        self.sixLabel.text = [NSString stringWithFormat:@"自杀式弹跳:%@次", self.object[@"details"][@"six"]];
        self.sevenLabel.text = [NSString stringWithFormat:@"强力俯卧撑:%@次", self.object[@"details"][@"seven"]];
        self.eightLabel.text = [NSString stringWithFormat:@"平底撑斜抬膝:%@次", self.object[@"details"][@"eight"]];
        
        self.button.hidden = YES;
        
    } else {
        self.label.text = @"输入你的fit test次数";
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        self.fourLabel.hidden = YES;
        self.fiveLabel.hidden = YES;
        self.sixLabel.hidden = YES;
        self.sevenLabel.hidden = YES;
        self.eightLabel.hidden = YES;
        
    }
    
}

- (IBAction)sure:(id)sender {
    __typeof (self) __weak wSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认次数" message:@"你的次数都输入完毕了吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        wSelf.navigationItem.hidesBackButton = YES;
        AVObject *object = [AVObject objectWithClassName:@"detailFittest"];
        object[@"date"] = [NSDate date];
        object[@"one"] = wSelf.oneTextField.text;
        object[@"two"] = wSelf.twoTextField.text;
        object[@"three"] = wSelf.threeTextField.text;
        object[@"four"] = wSelf.fourTextField.text;
        object[@"five"] = wSelf.fiveTextField.text;
        object[@"six"] = wSelf.sixTextField.text;
        object[@"seven"] = wSelf.sevenTextField.text;
        object[@"eight"] = wSelf.eightTextField.text;
        object.ACL = [AVACL ACLWithUser:[AVUser currentUser]];
        wSelf.object[@"details"] = object;
        [wSelf.object saveInBackground];
        
        wSelf.hud1 = [[MBProgressHUD alloc] initWithView:wSelf.view];
        [wSelf.view addSubview:self.hud1];
        wSelf.hud1.delegate = self;
        wSelf.hud1.labelText = @"正在云端搜寻数据";
        [wSelf.hud1 showWhileExecuting:@selector(getdata) onTarget:self withObject:nil animated:YES];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)getdata {
    __typeof (self) __weak wSelf = self;
    AVQuery *query = [AVQuery queryWithClassName:@"fittest"];
    [query includeKey:@"details"];
    [query getObjectInBackgroundWithId:wSelf.object.objectId block:^(AVObject *object, NSError *error) {
        wSelf.navigationItem.hidesBackButton = NO;

        if (object[@"details"]) {
            wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
            [wSelf.view addSubview:wSelf.hud2];
            wSelf.hud2.delegate = wSelf;
            wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-check"]];
            wSelf.hud2.mode = MBProgressHUDModeCustomView;
            wSelf.hud2.labelText = @"保存成功!";
            [wSelf.hud2 show:YES];
            [wSelf.hud2 hide:YES afterDelay:1];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
            formatter.timeStyle = NSDateIntervalFormatterShortStyle;
            NSString *str = [formatter stringFromDate:self.object[@"details"][@"date"]];
            self.label.text = [NSString stringWithFormat:@"%@,你的基础测试次数", str];
            
            wSelf.oneTextField.hidden = YES;
            wSelf.twoTextField.hidden = YES;
            wSelf.threeTextField.hidden = YES;
            wSelf.fourTextField.hidden = YES;
            wSelf.fiveTextField.hidden = YES;
            wSelf.sixTextField.hidden = YES;
            wSelf.sevenTextField.hidden = YES;
            wSelf.eightTextField.hidden = YES;
            
            wSelf.oneLabel.hidden = NO;
            wSelf.twoLabel.hidden = NO;
            wSelf.threeLabel.hidden = NO;
            wSelf.fourLabel.hidden = NO;
            wSelf.fiveLabel.hidden = NO;
            wSelf.sixLabel.hidden = NO;
            wSelf.sevenLabel.hidden = NO;
            wSelf.eightLabel.hidden = NO;
            wSelf.oneLabel.text = [NSString stringWithFormat:@"交换蹬腿:%@次", object[@"details"][@"one"]];
            wSelf.twoLabel.text = [NSString stringWithFormat:@"强力深蹲:%@次", object[@"details"][@"two"]];
            wSelf.threeLabel.text = [NSString stringWithFormat:@"强力抬膝:%@次", object[@"details"][@"three"]];
            wSelf.fourLabel.text = [NSString stringWithFormat:@"强力弹跳:%@次", object[@"details"][@"four"]];
            wSelf.fiveLabel.text = [NSString stringWithFormat:@"来回弹跳:%@次", object[@"details"][@"five"]];
            wSelf.sixLabel.text = [NSString stringWithFormat:@"自杀式弹跳:%@次", object[@"details"][@"six"]];
            wSelf.sevenLabel.text = [NSString stringWithFormat:@"强力俯卧撑:%@次", object[@"details"][@"seven"]];
            wSelf.eightLabel.text = [NSString stringWithFormat:@"平底撑斜抬膝:%@次", object[@"details"][@"eight"]];
            
            self.button.hidden = YES;
            
        } else {
            wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
            [wSelf.view addSubview:wSelf.hud2];
            wSelf.hud2.delegate = wSelf;
            wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            wSelf.hud2.mode = MBProgressHUDModeCustomView;
            wSelf.hud2.labelText = @"保存失败,请稍候再试";
            [wSelf.hud2 show:YES];
            [wSelf.hud2 hide:YES afterDelay:1];
            
            wSelf.label.text = @"输入你的fit test次数";
            wSelf.oneLabel.hidden = YES;
            wSelf.twoLabel.hidden = YES;
            wSelf.threeLabel.hidden = YES;
            wSelf.fourLabel.hidden = YES;
            wSelf.fiveLabel.hidden = YES;
            wSelf.sixLabel.hidden = YES;
            wSelf.sevenLabel.hidden = YES;
            wSelf.eightLabel.hidden = YES;
            
            self.button.hidden = NO;

        }
        
    }];

}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.oneTextField resignFirstResponder];
    [self.twoTextField resignFirstResponder];
    [self.threeTextField resignFirstResponder];
    [self.fourTextField resignFirstResponder];
    [self.fiveTextField resignFirstResponder];
    [self.sixTextField resignFirstResponder];
    [self.sevenTextField resignFirstResponder];
    [self.eightTextField resignFirstResponder];
    
}


#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    textField.layer.masksToBounds = NO;
    textField.layer.cornerRadius = 5;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.shadowRadius = 8;
    textField.layer.shadowOpacity = 1;
    textField.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    textField.layer.shadowRadius = 0;
    textField.layer.shadowOpacity = 0;
    textField.layer.shadowOffset = CGSizeMake(0, 0);
    textField.layer.shadowColor = nil;
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - mbprogresshud delegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperview];
    [self.hud2 removeFromSuperview];
    self.hud1 = nil;
    self.hud2 = nil;
}

@end
