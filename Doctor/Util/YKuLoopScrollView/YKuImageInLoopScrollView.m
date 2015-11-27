//
//  YKuImageInLoopScrollView.m
//  YKuAGP
//
//  Created by DengBin on 13-12-31.
//  Copyright (c) 2013年 YeKuMob.com. All rights reserved.
//

#import "YKuImageInLoopScrollView.h"

#define COLOR_GRAYISHBLUE [UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

#define PageControllDiameter        8      // 默认PageControll的点的直径
#define PageControllGapWidth        4      // 默认PageControll两个点之间的缝隙距离
#define PageControllBottomDistance  10      // 默认PageControll距离底部的距离
#define PageControllStrokeWidth     2      // 默认PageControll的点外圈宽度


static const int maxRange_smallLoopScrollViewX =1000;    //

@interface YKuImageInLoopScrollView()

/*
 设置绝对pageindex [0-2000]; [1000]==0
 */
- (void)setAbsolutePageIndex:(int)index animated:(BOOL)anim;
- (int)absolutePageIndex;


@end


@implementation YKuImageInLoopScrollView
@synthesize delegate;


/*
 返回aindex的view
 @param aindex : 第几个view，arrayindex ,可能为负
 */
- (UIView*)viewAtIndex:(int)arrayindex
{
    UIView *ret = nil;
    // ScrollViewLoop
    if ( self.scrollViewType == ScrollViewLoop )
    {
        ret = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                      [self.delegate widthForScrollView:self],
                                                      self.frame.size.height)];
        [ret setBackgroundColor:[UIColor whiteColor]];
        
        //id<YKuImageInLoopScrollViewDelegate> adelegate = (id<YKuImageInLoopScrollViewDelegate>) self.delegate;
        UIView *oneView = [self.delegate scrollView:self viewAtPageIndex:arrayindex];  //需要处理超大负值
        [ret addSubview:oneView];
        [oneView setCenter:ret.center];
        
        // 添加点击图片事件
        UIControl *retControl = [[UIControl alloc]initWithFrame:oneView.frame];
        [retControl setBackgroundColor:[UIColor clearColor]];
        retControl.tag = arrayindex;
        [retControl addTarget:self action:@selector(didTapIndex:) forControlEvents:UIControlEventTouchUpInside];
        [ret addSubview:retControl];
        [oneView setCenter:ret.center];
        
        assert( ret != nil );
    }
    // 普通的SrollView
    else
    {
        ret = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                      self.frame.size.width,
                                                      self.frame.size.height)];
        [ret setBackgroundColor:[UIColor whiteColor]];
        
//        id<YKuImageInLoopScrollViewDelegate> adelegate = (id<YKuImageInLoopScrollViewDelegate>) self.delegate;
        UIView *oneView = [self.delegate scrollView:self viewAtPageIndex:arrayindex];  //需要处理超大负值
        [oneView setFrame:ret.frame];
        CGRect frame1 = ret.frame;
        [ret addSubview:oneView];
        
        // 添加点击图片事件
        UIControl *retControl = [[UIControl alloc]initWithFrame:oneView.frame];
        [retControl setBackgroundColor:[UIColor clearColor]];
        retControl.tag = arrayindex;
        [retControl addTarget:self action:@selector(didTapIndex:) forControlEvents:UIControlEventTouchUpInside];
        [ret addSubview:retControl];
        [oneView setCenter:ret.center];
        
        assert( ret != nil );
    }
    
    return ret;
}

/**
 *  绘制整个ScrollView
 *
 *  @param centerIndex 索引号
 */
- (void)layoutPage:(int)centerIndex{
    sizeOfPage=self.frame.size;
    
    // 如果是ScrollViewLoop则调用代理，否则宽度大小即为ScrollView的大小
    if ( self.scrollViewType == ScrollViewLoop ) {
        sizeOfPage.width = [self.delegate widthForScrollView:self];
    }
    else{
        sizeOfPage.width = self.frame.size.width;
    }
    // 当前图片两边的留白（其他图片）的宽度
    int cha = self.frame.size.width-sizeOfPage.width;
    cha/=2;
    
    contentScrollView.scrollEnabled = numOfPage > 1;
    
    if( numOfPage > 0 ){
        const int range=2;
        NSMutableDictionary* newdic=[[NSMutableDictionary alloc] init]; //生成新的view
        for( int i=centerIndex-range; i<centerIndex+range; ++i ){
            // 当前页码
            int atArrayIndex=((i-maxRange_smallLoopScrollViewX)%numOfPage+numOfPage)%numOfPage;
            NSNumber* key=[NSNumber numberWithInt:atArrayIndex];
            // 当前视图
            UIView* v=[addSubViewDictionary objectForKey:key];
            
            // 设置当前页面的图片视图
            if( v==nil || [[newdic allKeys] containsObject:key] ){
                v=[self viewAtIndex:atArrayIndex];
            }
            assert(v!=nil);
            // 设置当前图片视图的位置
            CGRect frame=CGRectMake(i*sizeOfPage.width+cha, 0, sizeOfPage.width, sizeOfPage.height);
            v.frame=frame;
            [contentScrollView addSubview:v];
            
            if( [[newdic allKeys] containsObject:key] ){  //当数量很少时会有闪动
                [newdic setObject:v forKey:[NSNumber numberWithInt:i]];
            }else{
                [newdic setObject:v forKey:key];
            }
        }
        for( UIView *v in [addSubViewDictionary allValues] ){
            if( ![[newdic allValues] containsObject:v] ){
                [v removeFromSuperview];
            }
        }
        [addSubViewDictionary removeAllObjects];
        [addSubViewDictionary addEntriesFromDictionary:newdic];
    }
}

/**
 *  设置当前页码
 *
 *  @param index 索引号
 *  @param anim  是否动画
 *  @param set   <#set description#>
 */
- (void)setAbsolutePageIndex:(int)index animated:(BOOL)anim setContentOffset:(BOOL)set{
    //YKuLog(@"%s index=%d",__FUNCTION__,index);
    if( index == m_absolutePageIndex || numOfPage < 1 ){
        return;
    }
    if( index+1 >= 2*maxRange_smallLoopScrollViewX || index-1 <= 0 ){
        index = maxRange_smallLoopScrollViewX+((index-maxRange_smallLoopScrollViewX)%numOfPage+numOfPage)%numOfPage;
        set=YES;
    }
    [self layoutPage:index];
    m_absolutePageIndex=index;
    contentScrollView.contentSize=CGSizeMake(sizeOfPage.width*maxRange_smallLoopScrollViewX*2, sizeOfPage.height);    
    if(set){
        float x=index*sizeOfPage.width;
        [contentScrollView setContentOffset:CGPointMake(x, 0) animated:anim];
//        YKuLog(@"contentScrollView=%@",contentScrollView);
    }else{
        //setContenOffset 后会引起page change
        if([delegate respondsToSelector:@selector(scrollView:didSelectedPageIndex:)]){
            [self.styledPageControl setCurrentPage:[self pageIndex]];
            [delegate scrollView:self didSelectedPageIndex:[self pageIndex]];
        }    
    }
//    YKuLog(@" contentScrollView=%@",contentScrollView);
}
-(void)setAbsolutePageIndex:(int)index animated:(BOOL) anim{
    [self setAbsolutePageIndex:index animated:anim setContentOffset:YES];
}

-(void)setAbsolutePageIndex:(int)index {
    [self setAbsolutePageIndex:index animated:NO];
}

/**
 *  返回当前页码
 *  @return 当前页码
 */
-(int)absolutePageIndex{
    return m_absolutePageIndex;
}

/**
 *  跳转指定页
 *  @param index 索引号
 *  @param anim  是否动画
 */
-(void)setPageIndex:(int)index animated:(BOOL) anim{
    assert(index>=0 && index<numOfPage );
    int absindex= maxRange_smallLoopScrollViewX+index;
    [self setAbsolutePageIndex:absindex animated:anim];
}

-(int) pageIndex{
    return ((m_absolutePageIndex-maxRange_smallLoopScrollViewX)%numOfPage+numOfPage)%numOfPage;
}

-(void)nextPage:(BOOL)anim{
    int currentindex=m_absolutePageIndex+1;
    [self setAbsolutePageIndex:currentindex animated:anim];
}

-(void)timerFired:(NSTimer *)timer{
    [self nextPage:[timer.userInfo boolValue]];
}

/**
 *  刷新数据
 */
-(void) reloadData{
//    id<YKuImageInLoopScrollViewDelegate> adelegate=(id<YKuImageInLoopScrollViewDelegate>) self.delegate;
    // 总页数
    int num=[self.delegate numOfPageForScrollView:self];
    assert(num>=0);
    numOfPage=num;
    
    m_absolutePageIndex=-1;
    for(NSNumber* key in [addSubViewDictionary allKeys]){
        UIView* v=[addSubViewDictionary objectForKey:key];
        [v removeFromSuperview];
    }
    [addSubViewDictionary removeAllObjects];
    if(num>0){
        [self setAbsolutePageIndex:maxRange_smallLoopScrollViewX];
    }
    
    int offsetY = - 10;
    // 根据图片数量设置PageControl
    self.styledPageControl.numberOfPages = num;
    [self.styledPageControl setFrame:CGRectMake(0, 0,
                                                self.styledPageControl.diameter*num + (num-1)*self.styledPageControl.gapWidth,
                                                self.styledPageControl.diameter)];
    // 设置pageControlSite的位置
    switch ( self.styledPageControl.pageControlSite ){
        case PageControlSiteLeft:{
            [self.styledPageControl setFrame:CGRectMake(
                                                        0,
                                                        self.frame.size.height - self.styledPageControl.diameter - self.styledPageControl.bottomDistance+offsetY,
                                                        self.styledPageControl.diameter*num + (num-1)*self.styledPageControl.gapWidth,
                                                        self.styledPageControl.diameter)];
        }
            break;
        case PageControlSiteMiddle:{
            [self.styledPageControl setFrame:CGRectMake(
                                                        self.center.x - self.styledPageControl.frame.size.width/2,
                                                        self.frame.size.height - self.styledPageControl.diameter - self.styledPageControl.bottomDistance+offsetY,
                                                        self.styledPageControl.diameter*num + (num-1)*self.styledPageControl.gapWidth,
                                                        self.styledPageControl.diameter)];
        }
            break;
        case PageControlSiteRight:{
            [self.styledPageControl setFrame:CGRectMake(
                                                        self.frame.size.width - self.styledPageControl.frame.size.width+offsetY,
                                                        self.frame.size.height - self.styledPageControl.diameter - self.styledPageControl.bottomDistance,
                                                        self.styledPageControl.diameter*num+(num-1) * self.styledPageControl.gapWidth,
                                                        self.styledPageControl.diameter)];
        }
            break;
        default:
            break;
    }
    [self addSubview:self.styledPageControl];
    if (self.styledPageControl.numberOfPages < 2)
    {
        self.styledPageControl.hidden = YES;
    }
    else
    {
        self.styledPageControl.hidden = NO;
    }
    if (repeatTimer.isValid  == NO && self.styledPageControl.numberOfPages >= 2)
    {
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:@YES repeats:YES];
    }
}

/**
 *  轮播图点击事件
 *  @param sender 根据轮播图中的Tag判断点击的位置
 */
- (void)didTapIndex:(id)sender{
    
//    id<YKuImageInLoopScrollViewDelegate> adelegate=(id<YKuImageInLoopScrollViewDelegate>) self.delegate;
    int num=[self.delegate numOfPageForScrollView:self];
    if (num==0) {
        return;
    }
    [self.delegate scrollView:self didTapIndex:(int)((UIControl *)sender).tag];
}

-(void)setRepeatInterval:(NSTimeInterval)repeatInterval
{
    _repeatInterval = repeatInterval;
}

/**
 *  初始化
 */
-(void) internalInit{
    self.styledPageControl = [[StyledPageControl alloc]init];
    addSubViewDictionary=[[NSMutableDictionary alloc] init];
    contentScrollView=[[YKuImageInLoopScrollViewInternal alloc] initWithFrame:self.bounds];
    contentScrollView.delegate=self;
    contentScrollView.scrollsToTop = NO;
    contentScrollView.pagingEnabled=NO;
    contentScrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentScrollView.showsVerticalScrollIndicator=NO;
    contentScrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:contentScrollView];
    [self reloadData];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self internalInit];
    }
    return self;
}

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
      selectedColor:(UIColor *) color
{
    self=[super initWithFrame:frame];
    if(self)
    {
        [self internalInit];
        [self.styledPageControl setPageControlStyle:style];
        [self.styledPageControl setPageControlSite:position];
        [self.styledPageControl setGapWidth:gap];
        [self.styledPageControl setCoreSelectedColor:color];
        [self.styledPageControl setCoreNormalColor:[UIColor colorWithHexString:@"#ffffff" alpha:.4f]];
    }
    return self;
}

-(void)stop
{
    for(NSNumber* key in [addSubViewDictionary allKeys])
    {
        UIView* v=[addSubViewDictionary objectForKey:key];
        [v removeFromSuperview];
    }
    if (repeatTimer)
    {
        [repeatTimer invalidate];
        repeatTimer = nil;
    }
}

-(void)dealloc
{
    for(NSNumber* key in [addSubViewDictionary allKeys])
    {
        UIView* v=[addSubViewDictionary objectForKey:key];
        [v removeFromSuperview];
    }
    if ( repeatTimer )
        [repeatTimer invalidate];
    repeatTimer = nil;
}

/**
 *  开始拖动
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    // 暂停定时器
    if ( [repeatTimer isValid] )  [repeatTimer invalidate];
    oldOffsetX = scrollView.contentOffset.x;
    startDate = [[NSDate date] copy];
}

/**
 *  跳转到下一张
 */
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    CGPoint pOff =  scrollView.contentOffset;

    float currentX = pOff.x;
    float cha = currentX-oldOffsetX;
    endDate = [[NSDate date] copy];
    NSTimeInterval inter = [endDate timeIntervalSinceDate:startDate];
    if (inter<0.2) {
        if (cha<0) {
            pOff.x = ((int)(oldOffsetX/sizeOfPage.width)-1)*sizeOfPage.width;
        }else{
            pOff.x = ((int)(oldOffsetX/sizeOfPage.width)+1)*sizeOfPage.width;
        }
    }else{
        
        if (abs(cha)<sizeOfPage.width/2) {
            pOff.x = ((int)(oldOffsetX/sizeOfPage.width))*sizeOfPage.width;
        }else{
            if (cha<0||cha==0) {
                pOff.x = ((int)(oldOffsetX/sizeOfPage.width)-1)*sizeOfPage.width;
            }else{
                pOff.x = ((int)(oldOffsetX/sizeOfPage.width)+1)*sizeOfPage.width;
            }
            
        }
    }
    [scrollView setContentOffset:pOff animated:YES];
    if([delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]){
        [delegate scrollViewWillBeginDecelerating:self];
    }
}

/**
 *  停止拖动，将要减速，不一定跳到下一张
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (repeatTimer.isValid  == NO && self.styledPageControl.numberOfPages >= 2)
    {
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:@YES repeats:YES];
    }
    
    if (!decelerate) {
        CGPoint pOff =  scrollView.contentOffset;
        
        float currentX = pOff.x;
        float cha = currentX-oldOffsetX;
        if (abs(cha)<sizeOfPage.width/2) {
            pOff.x = ((int)(oldOffsetX/sizeOfPage.width))*sizeOfPage.width;
        }else{
            if (cha<0||cha==0) {
                pOff.x = ((int)(oldOffsetX/sizeOfPage.width)-1)*sizeOfPage.width;
            }else{
                pOff.x = ((int)(oldOffsetX/sizeOfPage.width)+1)*sizeOfPage.width;
            }
            
        }
        [scrollView setContentOffset:pOff animated:YES];
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //在当前位置左右都铺上subview
    if([delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [delegate scrollViewDidEndDecelerating:self];
    }
    
}

-(void) onSetContentOffset:(CGPoint)contentOffset{
    //YKuLog(@"%s contentOffset=%@",__FUNCTION__,NSStringFromCGPoint(contentOffset));
    if(skipSetContentOffset){
        skipSetContentOffset=NO;
        return;
    }
    int currentindex=round(contentOffset.x/sizeOfPage.width);
    if(currentindex+1>=2*maxRange_smallLoopScrollViewX || currentindex-1<=0){
        skipSetContentOffset=YES;
        [self setAbsolutePageIndex:currentindex animated:NO setContentOffset:YES];
    }else{
        [self setAbsolutePageIndex:currentindex animated:NO setContentOffset:NO];
        
    }
}


@end


@implementation YKuImageInLoopScrollViewInternal

-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    if([self.delegate respondsToSelector:@selector(onSetContentOffset:)]){
        [(id<YKuImageInLoopScrollViewInternalDelegate>)self.delegate onSetContentOffset:contentOffset];
    }
}

@end

@implementation StyledPageControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self=[super initWithCoder:aDecoder];
	if (self)
    {
		[self setup];
	}
	return self;
}

-(void)setup
{
	[self setBackgroundColor:[UIColor clearColor]];
	
	self.pageControlStyle = PageControlStyleDefault;
    self.bottomDistance = PageControllBottomDistance;
	self.strokeWidth = PageControllStrokeWidth;
	self.gapWidth = PageControllGapWidth;
	self.diameter = PageControllDiameter;
    
	// 切换下一张手势
//	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//	[self addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  点击原点事件，切换下一张（上一张）
 *
 *  @param gesture 手势
 */
- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2)
    {
        // move left
        if (self.currentPage>0)
        {
            if (touchPoint.x <= 22)
            {
                self.currentPage = 0;
            }
            else
            {
                self.currentPage -= 1;
            }
        }
        
    }
    else {
        // move right
        if (self.currentPage<self.numberOfPages-1)
        {
            if (touchPoint.x >= (CGRectGetWidth(self.bounds) - 22))
            {
                self.currentPage = self.numberOfPages-1;
            }
            else
            {
                self.currentPage += 1;
            }
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


/**
 *  重新绘画各中类型的PageControll,系统自己调用
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect
{
    UIColor *coreNormalColor, *coreSelectedColor, *strokeNormalColor, *strokeSelectedColor;
    
    if (self.coreNormalColor)
    {
        coreNormalColor = self.coreNormalColor;
    }
    else
    {
        coreNormalColor = COLOR_GRAYISHBLUE;
    }
    
    if (self.coreSelectedColor)
    {
        coreSelectedColor = self.coreSelectedColor;
    }
    else
    {
        if (self.pageControlStyle==PageControlStyleStrokedSquare ||
            self.pageControlStyle==PageControlStyleStrokedCircle ||
            self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            coreSelectedColor = COLOR_GRAYISHBLUE;
        }
        else
        {
            coreSelectedColor = COLOR_GRAY;
        }
    }
    
    if (self.strokeNormalColor)
    {
        strokeNormalColor = self.strokeNormalColor;
    }
    else
    {
        if (self.pageControlStyle==PageControlStyleDefault && self.coreNormalColor)
        {
            strokeNormalColor = self.coreNormalColor;
        }
        else
        {
            strokeNormalColor = COLOR_GRAYISHBLUE;
        }
        
    }
    // 如果有设定选中颜色
    if (self.strokeSelectedColor)
    {
        strokeSelectedColor = self.strokeSelectedColor;
    }
    else
    {
        if (self.pageControlStyle==PageControlStyleStrokedSquare || self.pageControlStyle==PageControlStyleStrokedCircle || self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            strokeSelectedColor = COLOR_GRAYISHBLUE;
        }
        else if (self.pageControlStyle==PageControlStyleDefault && self.coreSelectedColor)
        {
            strokeSelectedColor = self.coreSelectedColor;
        }
        
        else if (self.pageControlStyle == PageControlStyleSquareRect)
        {
            strokeNormalColor = [UIColor clearColor];
            strokeSelectedColor = [UIColor clearColor];
        }
        else
        {
            strokeSelectedColor = COLOR_GRAY;
        }
    }
    
    // Drawing code
    if (self.hidesForSinglePage && self.numberOfPages==1)
	{
		return;
	}
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
    // 两个点之间的距离
	int gap = self.gapWidth;
    // 内心的直径
    float diameter = self.diameter - 2*self.strokeWidth;
    
    if (self.pageControlStyle==PageControlStyleThumb)
    {
        if (self.thumbImage && self.selectedThumbImage)
        {
            diameter = self.thumbImage.size.width;
        }
    }
	
	int total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
	
    // 如果设置的总宽度大于pageControll的宽度，则调整直径diameter大小
	if (total_width>self.frame.size.width)
	{
		while (total_width>self.frame.size.width)
		{
			diameter -= 2;
			gap = diameter + 2;
			while (total_width>self.frame.size.width)
			{
				gap -= 1;
				total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
				
				if (gap==2)
				{
					break;
					total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
				}
			}
			
			if (diameter==2)
			{
				break;
				total_width = self.numberOfPages*diameter + (self.numberOfPages-1)*gap;
			}
		}
	}
	
	int i;
	for (i=0; i<self.numberOfPages; i++)
	{
		int x = (self.frame.size.width-total_width)/2 + i*(diameter+gap);
        
        if (self.pageControlStyle==PageControlStyleDefault)
        {
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
#warning 实心方形的绘制方法，added by 张闽
        else if (self.pageControlStyle == PageControlStyleSquareRect)
        {
            if (i == self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
                CGContextFillRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedSquare)
        {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedCircle)
        {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                int _currentPageDiameter = diameter*1.6;
                x = (self.frame.size.width-total_width)/2 + i*(diameter+gap) - (_currentPageDiameter-diameter)/2;
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                
                NSString *pageNumber = [NSString stringWithFormat:@"%i", i+1];
                CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);
                [pageNumber drawInRect:CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2-1,_currentPageDiameter,_currentPageDiameter)
                              withFont:[UIFont systemFontOfSize:_currentPageDiameter-2]
                         lineBreakMode:NSLineBreakByCharWrapping
                             alignment:NSTextAlignmentCenter];
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStylePressed1 || self.pageControlStyle==PageControlStylePressed2)
        {
            if (self.pageControlStyle==PageControlStylePressed1)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2-1,diameter,diameter));
            }
            else if (self.pageControlStyle==PageControlStylePressed2)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2+1,diameter,diameter));
            }
            
            
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleThumb)
        {
            UIImage* thumbImage = [self thumbImageForIndex:i];
            UIImage* selectedThumbImage = [self selectedThumbImageForIndex:i];
            
            if (thumbImage && selectedThumbImage)
            {
                if (i==self.currentPage)
                {
                    [selectedThumbImage drawInRect:CGRectMake(x,(self.frame.size.height-selectedThumbImage.size.height)/2, selectedThumbImage.size.width, selectedThumbImage.size.height)];
                }
                else
                {
                    [thumbImage drawInRect:CGRectMake(x,(self.frame.size.height-thumbImage.size.height)/2, thumbImage.size.width, thumbImage.size.height)];
                }
            }
        }
	}
}

- (void)setPageControlStyle:(PageControlStyle)style
{
    _pageControlStyle = style;
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(int)page
{
    _currentPage = page;
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(int)numOfPages
{
    _numberOfPages = numOfPages;
    [self setNeedsDisplay];
}

- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index
{
    if (self.thumbImageForIndex == nil)
    {
        [self setThumbImageForIndex:[NSMutableDictionary dictionary]];
    }
    
    if ((aThumbImage != nil))
        [self.thumbImageForIndex setObject:aThumbImage forKey:@(index)];
    else
        [self.thumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}

- (UIImage *)thumbImageForIndex:(NSInteger)index
{
    UIImage* aThumbImage = [self.thumbImageForIndex objectForKey:@(index)];
    if (aThumbImage == nil)
        aThumbImage = self.thumbImage;
    
    return aThumbImage;
}

- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index
{
    if (self.selectedThumbImageForIndex == nil)
    {
        [self setSelectedThumbImageForIndex:[NSMutableDictionary dictionary]];
    }
    
    if ((aSelectedThumbImage != nil))
        [self.selectedThumbImageForIndex setObject:aSelectedThumbImage forKey:@(index)];
    else
        [self.selectedThumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}

- (UIImage *)selectedThumbImageForIndex:(NSInteger)index
{
    UIImage* aSelectedThumbImage = [self.selectedThumbImageForIndex objectForKey:@(index)];
    if (aSelectedThumbImage == nil)
        aSelectedThumbImage = self.selectedThumbImage;
    
    return aSelectedThumbImage;
}

@end

