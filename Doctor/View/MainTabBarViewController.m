//
//  MainTabBarViewController.m
//  Doctor
//
//  Created by xmfish on 15/11/25.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ServiceViewController.h"
#import "MyViewController.h"
#import "NavigateViewController.h"
@interface MainTabBarViewController ()
{
    UINavigationController* _serviceNav;
    UINavigationController* _navigateNav;
    UINavigationController* _myNav;
}
@end

@implementation MainTabBarViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _serviceNav = [[UINavigationController alloc] initWithRootViewController:[[ServiceViewController alloc] init]];
        _navigateNav = [[UINavigationController alloc] initWithRootViewController:[[NavigateViewController alloc] init]];
        _myNav = [[UINavigationController alloc] initWithRootViewController:[[MyViewController alloc] init]];
        [_navigateNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"职能导航" image:[UIImage imageNamed:@"navno"] selectedImage:[UIImage imageNamed:@"naved"]]];
        
        [_serviceNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"医疗服务" image:[UIImage imageNamed:@"serviceno"] selectedImage:[UIImage imageNamed:@"serviced"]]];
        
        [_myNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"myno"] selectedImage:[UIImage imageNamed:@"myed"]]];
        self.viewControllers = @[_navigateNav,_serviceNav, _myNav];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor appMainColor]];
    
    [UIBarButtonItem.appearance setTintColor:[UIColor blackColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor appMainColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor appMainColor]];
//    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    self.selectedIndex = 1;

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
