//
//  MyViewController.m
//  Doctor
//
//  Created by xmfish on 15/11/25.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "MyViewController.h"
#import "MyTopView.h"
@interface MyViewController ()
{
    MyTopView *_myTopView;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    
    _myTopView = [Ash_UIUtil instanceXibView:@"MyTopView"];
    
    _myTopView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
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
