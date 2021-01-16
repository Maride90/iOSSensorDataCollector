//
//  DescriptStatsWrapper.m
//  Accel
//
//  Created by  on 1/17/18.
//  Copyright © 2018 . All rights reserved.
//

#import "DescriptStatsWrapper.h"
#include "DescriptStats.hpp"

@interface DescriptStatsWrapper()

@property DescriptStats *statItem;

@end

@implementation DescriptStatsWrapper

- (instancetype)init{
    if(self = [super init]){
        self.statItem = new DescriptStats();
    }
    return self;
}

- (void)addNewDataX:(double)x Y:(double)y Z:(double)z {
    self.statItem->addNewData(x, y, z);
}

- (NSDictionary *)getDataTotal{
    
    NSMutableDictionary *totalData = [NSMutableDictionary new];
    
    Stats *statX = [Stats new];
    dataTotal *dataX = self.statItem->getXTotalData();
    statX.max = dataX->max;
    statX.median = dataX->median;
    statX.mean = dataX->mean;
    statX.stdev = dataX->stdev;
    statX.min = dataX->min;
    statX.count = dataX->count;
    [totalData setObject:statX forKey:@"X"];
    
    Stats *statY = [Stats new];
    dataTotal *dataY = self.statItem->getYTotalData();
    statY.max = dataY->max;
    statY.median = dataY->median;
    statY.mean = dataY->mean;
    statY.stdev = dataY->stdev;
    statY.min = dataY->min;
    statY.count = dataY->count;
    [totalData setObject:statY forKey:@"Y"];
    
    Stats *statZ = [Stats new];
    dataTotal *dataZ = self.statItem->getZTotalData();
    statZ.max = dataZ->max;
    statZ.median = dataZ->median;
    statZ.mean = dataZ->mean;
    statZ.stdev = dataZ->stdev;
    statZ.min = dataZ->min;
    statZ.count = dataZ->count;
    [totalData setObject:statZ forKey:@"Z"];
    

    return totalData;
}

- (NSDictionary *)getDataInterval{
    
    NSMutableDictionary *intervalData = [NSMutableDictionary new];
    
    Stats *statX = [Stats new];
    dataTotal *dataX = self.statItem->getXIntervalData();
    statX.max = dataX->max;
    statX.median = dataX->median;
    statX.mean = dataX->mean;
    statX.stdev = dataX->stdev;
    statX.min = dataX->min;
    statX.count = dataX->count;
    statX.zc = dataX->zc;
    [intervalData setObject:statX forKey:@"X"];
    
    Stats *statY = [Stats new];
    dataTotal *dataY = self.statItem->getYIntervalData();
    statY.max = dataY->max;
    statY.median = dataY->median;
    statY.mean = dataY->mean;
    statY.stdev = dataY->stdev;
    statY.min = dataY->min;
    statY.count = dataY->count;
    statY.zc = dataY->zc;
    [intervalData setObject:statY forKey:@"Y"];
    
    Stats *statZ = [Stats new];
    dataTotal *dataZ = self.statItem->getZIntervalData();
    statZ.max = dataZ->max;
    statZ.median = dataZ->median;
    statZ.mean = dataZ->mean;
    statZ.stdev = dataZ->stdev;
    statZ.min = dataZ->min;
    statZ.count = dataZ->count;
    statZ.zc = dataZ->zc;
    [intervalData setObject:statZ forKey:@"Z"];
    
    return intervalData;
}


@end

