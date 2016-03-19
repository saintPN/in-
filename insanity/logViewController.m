//
//  logViewController.m
//  insanity
//
//  Created by saintPN-Mac on 16/1/21.
//  Copyright © 2016年 saintPN. All rights reserved.
//

#import "logViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"


@interface logViewController () <UITextFieldDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UITextField *userTextfield;

@property (weak, nonatomic) IBOutlet UITextField *passTextfield;

@property (weak, nonatomic) IBOutlet UITextField *mailTextfield;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *passBarButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;

@property (strong, nonatomic) MBProgressHUD *hud1;

@property (strong, nonatomic) MBProgressHUD *hud2;

@property (strong, nonatomic) MBProgressHUD *hud3;


@end


@implementation logViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    iv.image = [UIImage imageNamed:@"bg1"];
    [self.view insertSubview:iv atIndex:0];
    
    self.mailTextfield.hidden = YES;
    [self.segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    
    if ([AVUser currentUser]) {
        self.confirmLabel.text = [NSString stringWithFormat:@"登录用户:%@", [AVUser currentUser].username];
        self.confirmLabel.textColor = [UIColor whiteColor];
        
    } else {
        self.confirmLabel.text = @"未有登录用户";
        self.confirmLabel.textColor = [UIColor lightGrayColor];
        
    }
    
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    __weak typeof (self) wSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注销"
                                                                   message:@"确定注销当前用户?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if ([AVUser currentUser]) {
                                                                  wSelf.hud1 = [[MBProgressHUD alloc] initWithView:wSelf.navigationController.view];
                                                                  [wSelf.navigationController.view addSubview:wSelf.hud1];
                                                                  wSelf.hud1.delegate = wSelf;
                                                                  wSelf.hud1.labelText = @"注销中";
                                                                  [wSelf.hud1 showWhileExecuting:@selector(logout) onTarget:wSelf withObject:nil animated:YES];
                                                                  
                                                              } else {
                                                                  wSelf.hud1 = [MBProgressHUD showHUDAddedTo:wSelf.view animated:YES];
                                                                  wSelf.hud1.mode = MBProgressHUDModeText;
                                                                  wSelf.hud1.labelText = @"当前未有登录用户";
                                                                  wSelf.hud1.margin = 10;
                                                                  wSelf.hud1.removeFromSuperViewOnHide = YES;
                                                                  [wSelf.hud1 hide:YES afterDelay:3];

                                                              }
                                                              
                                                          }];
                                                              
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) { }];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)logout {
    __typeof (self) __weak wSelf = self;
    [AVUser logOut];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![AVUser currentUser]) {
            wSelf.confirmLabel.text = @"未有登录用户";
            wSelf.confirmLabel.textColor = [UIColor lightGrayColor];

            wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
            [wSelf.view addSubview:wSelf.hud2];
            wSelf.hud2.delegate = wSelf;
            wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            wSelf.hud2.mode = MBProgressHUDModeCustomView;
            wSelf.hud2.labelText = @"注销成功";
            [wSelf.hud2 show:YES];
            [wSelf.hud2 hide:YES afterDelay:1];
        }
    });
}

- (IBAction)resetPassword:(UIBarButtonItem *)sender {
    __typeof (self) __weak wSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重置密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"输入注册所用邮箱";
        [textField addTarget:wSelf action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField {
    __typeof (self) __weak wSelf = self;
    if (textField.text) {
        [AVUser requestPasswordResetForEmailInBackground:textField.text block:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
                [wSelf.view addSubview:wSelf.hud2];
                wSelf.hud2.delegate = wSelf;
                wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-check"]];
                wSelf.hud2.mode = MBProgressHUDModeCustomView;
                wSelf.hud2.labelText = @"重置邮件已发送至邮箱";
                [wSelf.hud2 show:YES];
                [wSelf.hud2 hide:YES afterDelay:1];
                
            } else {
                wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
                [wSelf.view addSubview:wSelf.hud2];
                wSelf.hud2.delegate = wSelf;
                wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
                wSelf.hud2.mode = MBProgressHUDModeCustomView;
                wSelf.hud2.labelText = @"请输入正确邮箱地址";
                [wSelf.hud2 show:YES];
                [wSelf.hud2 hide:YES afterDelay:2];
                
            }
            
        }];
        
    }

}

- (void)segmentChange {
    if (self.segment.selectedSegmentIndex == 0) {
        self.mailTextfield.hidden = YES;
        self.confirmLabel.hidden = NO;
        
    } else {
        self.mailTextfield.hidden = NO;
        self.confirmLabel.hidden = YES;
        
    }
    
}

- (IBAction)done:(UIButton *)sender {
    self.logoutBarButtonItem.enabled = NO;
    self.passBarButtonItem.enabled = NO;
    self.segment.enabled = NO;
    self.userTextfield.enabled = NO;
    self.passTextfield.enabled = NO;
    self.mailTextfield.enabled = NO;
    self.doneButton.enabled = NO;
    
    if (self.segment.selectedSegmentIndex == 0) {
        if (![AVUser currentUser]) {
            self.hud1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:self.hud1];
            self.hud1.delegate = self;
            self.hud1.labelText = @"登录中";
            [self.hud1 showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
            
        } else {
            self.logoutBarButtonItem.enabled = YES;
            self.passBarButtonItem.enabled = YES;
            self.segment.enabled = YES;
            self.userTextfield.enabled = YES;
            self.passTextfield.enabled = YES;
            self.mailTextfield.enabled = YES;
            self.doneButton.enabled = YES;
            
            self.hud1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:self.hud1];
            self.hud1.delegate = self;
            self.hud1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            self.hud1.mode = MBProgressHUDModeCustomView;
            self.hud1.labelText = @"已有用户,请先注销!";
            [self.hud1 show:YES];
            [self.hud1 hide:YES afterDelay:2];
            
        }
    
    } else {
        self.hud1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.hud1];
        self.hud1.delegate = self;
        self.hud1.labelText = @"注册中";
        [self.hud1 showWhileExecuting:@selector(signup) onTarget:self withObject:nil animated:YES];
    }
    
    [self resign];

}

- (void)login {
    __weak typeof (self) wSelf = self;
    [AVUser logInWithUsernameInBackground:self.userTextfield.text password:self.passTextfield.text block:^(AVUser *user, NSError *error) {
        wSelf.logoutBarButtonItem.enabled = YES;
        wSelf.passBarButtonItem.enabled = YES;
        wSelf.segment.enabled = YES;
        wSelf.userTextfield.enabled = YES;
        wSelf.passTextfield.enabled = YES;
        wSelf.mailTextfield.enabled = YES;
        wSelf.doneButton.enabled = YES;
        
        if (user) {
            [wSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            wSelf.hud2 = [[MBProgressHUD alloc] initWithView:wSelf.view];
            [wSelf.view addSubview:wSelf.hud2];
            wSelf.hud2.delegate = wSelf;
            wSelf.hud2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
            wSelf.hud2.mode = MBProgressHUDModeCustomView;
            wSelf.hud2.labelText = @"请输入正确的用户名和密码";
            [wSelf.hud2 show:YES];
            [wSelf.hud2 hide:YES afterDelay:2];

        }
        
    }];

}

- (void)signup {
    __weak typeof (self) wSelf = self;
    AVUser *newUser = [AVUser user];
    if (self.userTextfield.text.length) {
        newUser.username = self.userTextfield.text;
    }
    if (self.passTextfield.text.length) {
        newUser.password = self.passTextfield.text;
    }
    if ([self isValidateEmail:self.mailTextfield.text]) {
        newUser.email = self.mailTextfield.text;
    }
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        wSelf.logoutBarButtonItem.enabled = YES;
        wSelf.passBarButtonItem.enabled = YES;
        wSelf.segment.enabled = YES;
        wSelf.userTextfield.enabled = YES;
        wSelf.passTextfield.enabled = YES;
        wSelf.mailTextfield.enabled = YES;
        wSelf.doneButton.enabled = YES;
        
        if (succeeded) {
            [wSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            if (error.code == 200) {
                wSelf.hud3 = [[MBProgressHUD alloc] initWithView:wSelf.view];
                [wSelf.view addSubview:wSelf.hud3];
                wSelf.hud3.delegate = wSelf;
                wSelf.hud3.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
                wSelf.hud3.mode = MBProgressHUDModeCustomView;
                wSelf.hud3.labelText = @"用户名不能为空";
                [wSelf.hud3 show:YES];
                [wSelf.hud3 hide:YES afterDelay:2];
            } else if (error.code == 201) {
                wSelf.hud3 = [[MBProgressHUD alloc] initWithView:wSelf.view];
                [wSelf.view addSubview:wSelf.hud3];
                wSelf.hud3.delegate = wSelf;
                wSelf.hud3.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
                wSelf.hud3.mode = MBProgressHUDModeCustomView;
                wSelf.hud3.labelText = @"密码不能为空";
                [wSelf.hud3 show:YES];
                [wSelf.hud3 hide:YES afterDelay:2];
                
            } else {
                wSelf.hud3 = [[MBProgressHUD alloc] initWithView:wSelf.view];
                [wSelf.view addSubview:wSelf.hud3];
                wSelf.hud3.delegate = wSelf;
                wSelf.hud3.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cross"]];
                wSelf.hud3.mode = MBProgressHUDModeCustomView;
                wSelf.hud3.labelText = @"用户名已被注册";
                [wSelf.hud3 show:YES];
                [wSelf.hud3 hide:YES afterDelay:2];
                
            }
            
        }
        
    }];

}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailFormat = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat];
    
    return [emailTest evaluateWithObject:email];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
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

- (void)resign {
    [self.userTextfield resignFirstResponder];
    [self.passTextfield resignFirstResponder];
    [self.mailTextfield resignFirstResponder];

}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self resign];
}


#pragma mark - mbprogresshud delegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.hud1 removeFromSuperViewOnHide];
    [self.hud2 removeFromSuperViewOnHide];
}

@end
