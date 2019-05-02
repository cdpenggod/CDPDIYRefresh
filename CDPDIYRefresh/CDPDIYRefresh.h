//
//  CDPDIYRefresh.h
//  DIYRefresh
//
//  Created by 柴东鹏 on 2019/5/2.
//  Copyright © 2019 CDP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDPDIYHeader.h"
#import "CDPDIYAutoFooter.h"

@interface CDPDIYRefresh : NSObject




/**
 *  获取下拉控件
 */
+(CDPDIYHeader *)getHeadRefreshWithRefreshBlock:(void(^)())block;

/**
 *  获取上拉控件
 */
+(CDPDIYAutoFooter *)getFootRefreshWithRefreshBlock:(void(^)())block;






@end



