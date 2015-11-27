//
//  YKuImageInLoopScrollView.h
//  YKuAGP
//
//  Created by DengBin on 13-12-31.
//  Copyright (c) 2013年 YeKuMob.com. All rights reserved.
//
/*
    实现了中间的image的宽度可以小于view的宽度
    有一个问题，滚动的动画打断后会停在当前位置
    在SrollView中增加内置的PageControll
    可显示6种样式和自定义图片，可配置位置
 */

#import <UIKit/UIKit.h>

@class StyledPageControl;

typedef enum
{
    ScrollViewDefault = 0,
    ScrollViewLoop,
    
}ScrollViewType;    // ScrollView显示类型

typedef enum
{
    PageControlStyleDefault        = 0,
    PageControlStyleStrokedCircle  = 1,
    PageControlStylePressed1       = 2,
    PageControlStylePressed2       = 3,
    PageControlStyleWithPageNumber = 4,
    PageControlStyleThumb          = 5,     // 可设置图片
    PageControlStyleStrokedSquare  = 6,
    PageControlStyleSquareRect = 7,
} PageControlStyle; // pageControll显示类型

typedef enum
{
    PageControlSiteLeft       = 0,
    PageControlSiteMiddle     = 1,
    PageControlSiteRight      = 2,
} PageControlSite; // pageControll显示位置

@protocol YKuImageInLoopScrollViewDelegate;

/*
 横向循环滚动的图片 paging scrollview ,需要在delegate 中 实现，，主要作用是嵌入在scrollview 中比YKSlideView 更自然
 usage:
 implement delegate ,not add view to self
 @remark:
    构建一个超大contentsize 的scrollview,把需要的子view 铺在可视范围周边
 */
@interface YKuImageInLoopScrollView : UIView<UIScrollViewDelegate>{
@private
    int                     m_absolutePageIndex;     // 当前第几页
    int                     numOfPage;               // 总共有多少页
    float                   oldOffsetX;              // 滑动时记录ScrollView的横坐标
    BOOL                    skipSetContentOffset;    // 跳过处理setcontentOffset 事件
    UIScrollView            *contentScrollView;
    NSMutableDictionary     *addSubViewDictionary;   // 本类自动添加的子试图,key为pageindex (NSNumber) value 为view
    CGSize                  sizeOfPage;              // ScrollView的大小
    NSDate                  *startDate;              // scroll 开始时间
    NSDate                  *endDate;                // scroll 结束时间 用开始和结束时间差小于0.2秒来响应快速且scroll距离小于一半的size.width
    NSTimer                 *repeatTimer;            // 自动轮播的定时器

    
}
@property(nonatomic,assign) id<YKuImageInLoopScrollViewDelegate> delegate;

/**
 *  ScrollView的显示类型
 *  默认为ScrollViewDefault（常规ScrollView）
 *  设置为ScrollViewLoop 周边留白
 */
@property(nonatomic,assign) ScrollViewType      scrollViewType;
/**
 *  ScrollView内置的PageView
 */
@property(nonatomic,strong) StyledPageControl   *styledPageControl;


@property (nonatomic, assign) NSTimeInterval        repeatInterval;             //自动轮播时间

/**
 *  初始化方法
 *  style pagecontrol样式 参考枚举PageControlStyle
 *  position 参考枚举PageControlSite
 *  gap 点间距
 *  selectedColor 选中后的颜色
 */
- (id)initWithFrame:(CGRect)frame
   pageControlStyle:(PageControlStyle) style
           position:(PageControlSite) position
           gapWidth:(int) gap
      selectedColor:(UIColor *) color;

-(void)stop;

/**
 *  重新加载
 */
-(void) reloadData;

/**
 *  下一张图片
 *
 *  @param anim 是否需要动画
 */
- (void) nextPage:(BOOL)anim;

/**
 *  设置pageindex [0-delegate.numOfPageForScrollView];
 *
 *  @param index 图片索引
 *  @param anim  是否需要动画
 */
- (void)setPageIndex:(int)index animated:(BOOL)anim;

/**
 *  获取当前的索引号
 *
 *  @return 当前的索引号
 */
- (int)pageIndex;

@end


@protocol YKuImageInLoopScrollViewDelegate <NSObject>

/*
 总共有多少页
 */
- (int) numOfPageForScrollView:(YKuImageInLoopScrollView*)ascrollView;

/*
 显示在中间的view的width
 */
- (int) widthForScrollView:(YKuImageInLoopScrollView*)ascrollView;

/*
 第apageIndex 页的图片网址,  view会被设置为新的frame
 @param viewAtPageIndex:[0- viewAtPageIndex];
 */
- (UIView*)scrollView:(YKuImageInLoopScrollView*)ascrollView viewAtPageIndex:(int)apageIndex;

@optional
- (void)scrollView:(YKuImageInLoopScrollView*)ascrollView didTapIndex:(int)apageIndex;

@optional
/*
 选中第几页
 @param didSelectedPageIndex 选中的第几项，[0-numOfPageForScrollView];
 */
- (void) scrollView:(YKuImageInLoopScrollView*) ascrollView didSelectedPageIndex:(int)apageIndex;

/*
 开始滚动
 */
- (void)scrollViewWillBeginDecelerating:(YKuImageInLoopScrollView*)ascrollView;

/*
 结束滚动
 */
- (void)scrollViewDidEndDecelerating:(YKuImageInLoopScrollView*)ascrollView;


@end




@protocol YKuImageInLoopScrollViewInternalDelegate <UIScrollViewDelegate>

-(void) onSetContentOffset:(CGPoint)contentOffset;

@end


@interface YKuImageInLoopScrollViewInternal : UIScrollView {
@private
    
}
@end

@interface StyledPageControl : UIControl
@property (nonatomic, assign ) PageControlStyle     pageControlStyle;           // 显示类型
@property (nonatomic, assign ) PageControlSite      pageControlSite;            // 显示位置（左中右）
@property (nonatomic, strong ) UIColor              *coreNormalColor;           // 未选中内心(某些类型未用)
@property (nonatomic, strong ) UIColor              *coreSelectedColor;         // 选中下内心
@property (nonatomic, strong ) UIColor              *strokeNormalColor;         // 未选中外框
@property (nonatomic, strong ) UIColor              *strokeSelectedColor;       // 选中下外框
@property (nonatomic, strong ) UIImage              *thumbImage;                // 未选中的图片
@property (nonatomic, strong ) UIImage              *selectedThumbImage;        // 选中下的图片
@property (nonatomic, strong ) NSMutableDictionary  *thumbImageForIndex;        // 各个位置未选中的图片字典
@property (nonatomic, strong ) NSMutableDictionary  *selectedThumbImageForIndex;// 各个位置选中下的图片字典
@property (nonatomic, assign ) BOOL                 hidesForSinglePage;         // 单个点是否隐藏
@property (nonatomic, assign ) int                  currentPage;                // 当前页码
@property (nonatomic, assign ) int                  numberOfPages;              // 页码总数
@property (nonatomic, assign ) int                  strokeWidth;                // 外圈的宽度(宽度包括在直径里面)
@property (nonatomic, assign ) int                  gapWidth;                   // 两个点之间的距离
@property (nonatomic, assign ) int                  diameter;                   // 点的直径(包括外圈宽度)
@property (nonatomic, assign ) float                bottomDistance;             // 距离底部的距离


/**
 *  单个设置PageControll在相应位置上的默认图片
 *
 *  @param aThumbImage:需要设置的图片
 *  @param index:位置索引号
 */
- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index;

/**
 *  获取PageControll在相应位置上的默认图片
 *
 *  @param index:位置索引号
 *  @return
 */
- (UIImage *)thumbImageForIndex:(NSInteger)index;

/**
 *  单个设置PageControll在被选中的相应位置上的的图片
 *
 *  @param aSelectedThumbImage:需要设置的图片
 *  @param index:位置索引号
 */
- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index;

/**
 *  获取PageControll在相应位置上的选中图片
 *
 *  @param index:位置索引号
 *  @return
 */
- (UIImage *)selectedThumbImageForIndex:(NSInteger)index;

@end

