//
//  CDPDIYAutoFooter.m
//  DIYRefresh
//
//  Created by CDP on 2019/4/29.
//  Copyright © 2019年 CDP. All rights reserved.
//

#import "CDPDIYAutoFooter.h"


@interface CDPView : UIView

@property (nonatomic,strong) CALayer *theLayer;
@property (nonatomic,strong) UILabel *theLabel;

@end
@implementation CDPView

@end



@interface CDPDIYAutoFooter()

@property (weak, nonatomic) CDPView *bgView;

@end

@implementation CDPDIYAutoFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    //bg
    CDPView *bgView = [[CDPView alloc] init];
    [self addSubview:bgView];
    
    self.bgView=bgView;
    
    //圆圈hud
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0,10,20,20);
    CGImageRef image=[UIImage imageNamed:@"CDPArc"].CGImage;
    layer.contents=(__bridge id _Nullable)image;
    [bgView.layer addSublayer:layer];
    
    bgView.theLayer=layer;
    
    CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue=[NSNumber numberWithFloat:0.f];
    animation.toValue=[NSNumber numberWithFloat:M_PI*2.0];
    animation.duration=1.0;
    animation.repeatCount=NSIntegerMax;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    [layer addAnimation:animation forKey:nil];
    
    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(25,10,50,20)];
    textLabel.font=[UIFont systemFontOfSize:12];
    textLabel.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    textLabel.text=@"加载中…";
    [bgView addSubview:textLabel];
    
    bgView.theLabel=textLabel;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.bgView.bounds=CGRectMake(0,0,75,40);
    self.bgView.center=CGPointMake(self.mj_w * 0.5,30);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        case MJRefreshStatePulling:
        case MJRefreshStateNoMoreData:
            self.bgView.hidden=YES;
            self.bgView.theLayer.speed=0;
            break;
        case MJRefreshStateWillRefresh:
        case MJRefreshStateRefreshing:
            self.bgView.theLayer.speed=1;
            self.bgView.hidden=NO;
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
