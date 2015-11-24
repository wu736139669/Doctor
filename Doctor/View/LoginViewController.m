//
//  LoginViewController.m
//  WlianWorld
//
//  Created by xmfish on 15/11/16.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "AWordDefault.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (nonatomic,strong)LoginViewModel* viewModel;
@end

@implementation LoginViewController

-(id)init
{
    self = [super init];
    
    if (self)
    {
        _viewModel = [[LoginViewModel alloc] init];
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self bindViewModel];
}


-(void)bindViewModel
{
    self.title = _viewModel.model.title;
    RAC(self.viewModel,account) = self.accountTextField.rac_textSignal;
    RAC(self.viewModel,password) = self.passwordTextField.rac_textSignal;
    self.sureBtn.rac_command = self.viewModel.executeLogin;
    
    @weakify(self);
    RAC(self.sureBtn, backgroundColor) = [self.viewModel.validLoginSignal map:^id(NSNumber* value) {
        return[value boolValue] ? [UIColor redColor ]:[UIColor grayColor];
    }];

    [self.viewModel.executeLogin.executionSignals subscribeNext:^(id result) {
        @strongify(self)
        [self.accountTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];

    }];
    [[self.sureBtn.rac_command executing] subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if([executing boolValue]){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"登陆中。。。";
        }
    }];
    [self.sureBtn.rac_command.executionSignals.flatten subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.model.status.intValue == 0) {
            [MBProgressHUD checkHudWithView:self.view label:self.viewModel.model.msg hidesAfter:1.0];
            //[nsde];
        }else
        {
            DLog(@"登陆成功,信息：%@",self.viewModel.model);
            
            [AWordDefault setUid:self.viewModel.model.userid];
            [AWordDefault setToken:self.viewModel.model.token];
            [AWordDefault setShopId:self.viewModel.model.shopid];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
    }];
    [self.sureBtn.rac_command.errors subscribeNext:^(id x) {
        @strongify(self)
        [MBProgressHUD errorHudWithView:self.view label:@"网络连接错误" hidesAfter:1.0];

    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
