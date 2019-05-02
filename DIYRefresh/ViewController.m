//
//  ViewController.m
//  DIYRefresh
//
//  Created by CDP on 2019/4/29.
//  Copyright © 2019年 CDP. All rights reserved.
//

#import "ViewController.h"

/****************引入.h头文件*****************/
#import "CDPDIYRefresh.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //创建tableView
    [self createTableView];
}
#pragma mark - 上下拉请求
//下拉
-(void)headRefresh{
    __weak UITableView *tableView=_tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer resetNoMoreData];
    });
}
//上拉
-(void)footRefresh{
    __weak UITableView *tableView=_tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView.mj_footer endRefreshing];
    });
}
#pragma mark - 创建UI
//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,200,self.view.bounds.size.width,300) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,300)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    label.numberOfLines=0;
    label.text=@"需要导入MJRefresh库才能使用CDPDIYRefresh\n\n上下拉tableView查看效果";
    [_tableView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    //添加上下拉refresh控件
    __weak typeof(self) weakSelf=self;
    _tableView.mj_header=[CDPDIYRefresh getHeadRefreshWithRefreshBlock:^{
        [weakSelf headRefresh];
    }];
    _tableView.mj_footer=[CDPDIYRefresh getFootRefreshWithRefreshBlock:^{
        [weakSelf footRefresh];
    }];
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"UITableViewCDPCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor greenColor];
    }
    
    return cell;
}


@end
