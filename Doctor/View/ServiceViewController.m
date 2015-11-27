//
//  ServiceViewController.m
//  Doctor
//
//  Created by xmfish on 15/11/25.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "ServiceViewController.h"
#import "YKuImageInLoopScrollView.h"
@interface ServiceViewController ()<YKuImageInLoopScrollViewDelegate>
{

}
@property(nonatomic,strong)YKuImageInLoopScrollView* mYKuImageInLoopScrollView;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"医疗服务";

    
    _mYKuImageInLoopScrollView = [[YKuImageInLoopScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 250)
                                                                pageControlStyle:PageControlStyleSquareRect position:PageControlSiteLeft
                                                                        gapWidth:4
                                                                   selectedColor:[UIColor appMainColor]];
    
    
    _mYKuImageInLoopScrollView.delegate = self;
    _mYKuImageInLoopScrollView.scrollViewType = ScrollViewDefault;
    _mYKuImageInLoopScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mYKuImageInLoopScrollView];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mYKuImageInLoopScrollView reloadData];

}
#pragma mark - YKuImageInLoopScrollViewDelegate
- (int)numOfPageForScrollView:(YKuImageInLoopScrollView *)ascrollView
{
    return 4;
}

- (int)widthForScrollView:(YKuImageInLoopScrollView *)ascrollView
{
    return kScreenWidth;
}

- (UIView *)scrollView:(YKuImageInLoopScrollView *)ascrollView viewAtPageIndex:(int)apageIndex
{

    CGFloat height = _mYKuImageInLoopScrollView.frame.size.height;
    
    NSLog(@"%f",_mYKuImageInLoopScrollView.frame.origin.y);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    UIImageView *oneimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    
    oneimage.contentMode = UIViewContentModeScaleAspectFill;
    [oneimage setImage:[UIImage imageNamed:@"bannerbg"]];
        
    [view addSubview:oneimage];

        
    return view;
}

- (void)scrollView:(YKuImageInLoopScrollView*) ascrollView didTapIndex:(int)apageIndex
{

}

- (void) scrollView:(YKuImageInLoopScrollView*) ascrollView didSelectedPageIndex:(int)apageIndex
{
    
}

- (void)scrollViewWillBeginDecelerating:(YKuImageInLoopScrollView*)ascrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(YKuImageInLoopScrollView*)ascrollView
{
    
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
