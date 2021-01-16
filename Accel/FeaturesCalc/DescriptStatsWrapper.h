//
//  DescriptStatsWrapper.h
//  Accel
//
//  Created by  on 1/17/18.
//  Copyright © 2018 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stats.h"

@interface DescriptStatsWrapper : NSObject

- (instancetype)init;
- (void)addNewDataX:(double)x Y:(double)y Z:(double)z;
- (NSDictionary *)getDataTotal;
- (NSDictionary *)getDataInterval;

@end

