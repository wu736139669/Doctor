//
//  MyViewController.m
//  Doctor
//
//  Created by xmfish on 15/11/25.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "MyViewController.h"
#import "MyTopView.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MyTopView *_myTopView;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_myTopView)
    {
        _myTopView = [Ash_UIUtil instanceXibView:@"MyTopView"];
        _myTopView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        _tableView.tableHeaderView = _myTopView;
    }

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = 2;
            break;
        case 3:
            row = 2;
            break;
            
        default:
            break;
    }
    return row;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 5.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIndentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = @"测试";
    return cell;
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
