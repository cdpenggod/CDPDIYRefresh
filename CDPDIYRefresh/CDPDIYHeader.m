//
//  CDPDIYHeader.m
//  DIYRefresh
//
//  Created by CDP on 2019/4/29.
//  Copyright © 2019年 CDP. All rights reserved.
//

#import "CDPDIYHeader.h"

#define CDPMainColor [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1]

@interface CDPDIYHeader()
@property (nonatomic,weak) UIImageView *imgView;
@property (nonatomic,weak) UIView *moveView;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,weak) UIActivityIndicatorView *loadView;

@end

@implementation CDPDIYHeader

-(void)dealloc{
    _shapeLayer=nil;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 100;
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.mj_w*0.5-15,60,30,30)];
    imgView.backgroundColor=CDPMainColor;
    imgView.image=[UIImage imageNamed:@"CDPRefreshIcon"];
    imgView.layer.cornerRadius=15;
    [self addSubview:imgView];
    
    self.imgView=imgView;
    
    [self setShadowWithLayer:imgView.layer y:-1];
    
    UIView *moveView=[[UIView alloc] initWithFrame:imgView.frame];
    moveView.backgroundColor=CDPMainColor;
    moveView.layer.cornerRadius=15;
    [self insertSubview:moveView belowSubview:imgView];
    
    self.moveView=moveView;
    
    [self setShadowWithLayer:moveView.layer y:1];
    
    UIActivityIndicatorView *loadView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.mj_w*0.5-8,42,16,16)];
    loadView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    loadView.hidesWhenStopped=YES;
    [self addSubview:loadView];
    
    self.loadView=loadView;
}
-(void)setShadowWithLayer:(CALayer *)layer y:(CGFloat)y{
    layer.shadowColor=CDPMainColor.CGColor;
    layer.shadowOpacity=1;
    layer.shadowOffset=CGSizeMake(0,y);
    layer.shadowRadius=1;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    //更新UI
    [self updateFrame];
    
    CGRect frame=self.loadView.frame;
    frame.origin.x=self.mj_w*0.5-8;
    self.loadView.frame=frame;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    //    if (self.state == MJRefreshStatePulling) {
    //        //自动开始刷新
    //        [self beginRefreshing];
    //    }
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
        case MJRefreshStateIdle:{
            if (oldState == MJRefreshStateRefreshing) {
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.loadView.alpha=0;
                } completion:^(BOOL finished) {
                    if (self.state!=MJRefreshStateIdle) return;
                    self.loadView.alpha=1;
                    self.moveView.hidden=NO;
                    self.imgView.hidden=NO;
                    [self.loadView stopAnimating];
                }];
            } else {
                self.moveView.hidden=NO;
                self.imgView.hidden=NO;
                [self.loadView stopAnimating];
            }
        }
            break;
        case MJRefreshStateWillRefresh:{
            [self.loadView stopAnimating];
            self.moveView.hidden=NO;
            self.imgView.hidden=NO;
        }
            break;
        case MJRefreshStatePulling:
        case MJRefreshStateRefreshing:{
            self.loadView.alpha=1;
            [self.loadView startAnimating];
            
            self.moveView.hidden=YES;
            self.imgView.hidden=YES;
            if (_shapeLayer) {
                [_shapeLayer removeFromSuperlayer];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    [self updateFrame];
}
#pragma mark - 更新UI
//更新frame和绘制曲线
-(void)updateFrame{
    if (self.pullingPercent<=0.4) {
        self.imgView.frame=CGRectMake(self.mj_w*0.5-15,self.mj_h*0.6,30,30);
        self.imgView.layer.cornerRadius=15;
        self.moveView.frame=self.imgView.frame;
        self.moveView.layer.cornerRadius=15;
    }
    else{
        CGFloat distance=self.moveView.center.y-self.imgView.center.y;
        if (distance<0) {
            distance=0;
        }
        CGFloat imgR=15-distance/15.0;
        CGFloat moveR=15-distance/6.0;
        if (imgR<=0) {
            imgR=2;
        }
        if (moveR<=0) {
            moveR=1;
        }
        CGFloat y=(0.9<=self.pullingPercent)?10:self.mj_h*(1.0-self.pullingPercent);
        self.imgView.frame=CGRectMake(self.mj_w*0.5-imgR,y,imgR*2,imgR*2);
        self.imgView.layer.cornerRadius=imgR;
        
        self.moveView.frame=CGRectMake(self.mj_w*0.5-moveR,self.mj_h-moveR*2-10,moveR*2,moveR*2);
        self.moveView.layer.cornerRadius=moveR;
    }
    
    //曲线路径
    if (self.imgView.hidden==NO) {
        UIBezierPath *path = [self getPath];
        
        if (_shapeLayer==nil) {
            _shapeLayer=[CAShapeLayer layer];
            _shapeLayer.fillColor=CDPMainColor.CGColor;
            [self setShadowWithLayer:_shapeLayer y:1];
        }
        if (_shapeLayer.superlayer==nil) {
            [self.layer insertSublayer:_shapeLayer atIndex:0];
        }
        _shapeLayer.path=path.CGPath;
    }
}
//描述两个圆之间的不规则路径
-(UIBezierPath *)getPath{
    CGFloat distance=self.moveView.center.y-self.imgView.center.y;
    
    if (distance<=0) {
        return nil;
    }
    
    CGFloat moveR=CGRectGetWidth(self.moveView.frame)*0.5;
    CGFloat imgR=CGRectGetWidth(self.imgView.frame)*0.5;
    
    CGPoint pointA=CGPointMake(CGRectGetMinX(self.moveView.frame),CGRectGetMinY(self.moveView.frame)+moveR);
    CGPoint pointB=CGPointMake(CGRectGetMaxX(self.moveView.frame),pointA.y);
    
    CGPoint pointC=CGPointMake(CGRectGetMaxX(self.imgView.frame),CGRectGetMinY(self.imgView.frame)+imgR);
    CGPoint pointD=CGPointMake(CGRectGetMinX(self.imgView.frame),pointC.y);
    
    CGPoint pointO=CGPointMake(pointA.x,pointA.y-distance*0.5);
    CGPoint pointP=CGPointMake(pointB.x,pointB.y-distance*0.5);
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
