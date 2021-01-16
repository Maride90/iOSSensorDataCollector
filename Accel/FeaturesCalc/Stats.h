//
//  Stats.h
//  Accel
//
//  Created by  on 1/18/18.
//  Copyright © 2018 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (assign) double max;
@property (assign) double median;
@property (assign) double mean;
@property (assign) double stdev;
@property (assign) double min;
@property (assign) int count;
@property (assign) int zc;

@end
