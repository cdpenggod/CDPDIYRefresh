//
//  CDPDIYRefresh.m
//  DIYRefresh
//
//  Created by 柴东鹏 on 2019/5/2.
//  Copyright © 2019 CDP. All rights reserved.
//

#import "CDPDIYRefresh.h"

@implementation CDPDIYRefresh



//获取下拉控件
+(CDPDIYHeader *)getHeadRefreshWithRefreshBlock:(void(^)())block{
    CDPDIYHeader *header = [CDPDIYHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    //隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    //    header.stateLabel.hidden = YES;
    
    return header;
}
//获取上拉控件
+(CDPDIYAutoFooter *)getFootRefreshWithRefreshBlock:(void(^)())block{
    CDPDIYAutoFooter *footer = [CDPDIYAutoFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    footer.onlyRefreshPerDrag=YES;
    footer.triggerAutomaticallyRefreshPercent=0.2;
    
    //    footer.stateLabel.hidden = YES;
    //    footer.refreshingTitleHidden = YES;
    
    return footer;
}





@end
