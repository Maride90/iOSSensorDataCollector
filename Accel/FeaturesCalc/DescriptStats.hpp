//
//  DescriptStats.hpp
//  Accel
//
//  Created by  on 1/17/18.
//  Copyright © 2018 . All rights reserved.
//

#ifndef DescriptStats_hpp
#define DescriptStats_hpp

#include <string>
#include "BinaryTree.hpp"
#include <cmath>


struct dataTotal {
    double max;
    double median;
    double mean;
    double stdev;
    double min;
    double count;
    double zc;
};



class DescriptStats {
public:
    DescriptStats();
    ~DescriptStats();
    
    void addNewData(double x, double y, double z);
    
    dataTotal * getXTotalData();
    dataTotal * getYTotalData();
    dataTotal * getZTotalData();
    
    dataTotal * getXIntervalData();
    dataTotal * getYIntervalData();
    dataTotal * getZIntervalData();
    
    
private:
    //INTERVAL
    BinaryTree *btreeXInterval;
        double maxXInterval = 0;
        double medianXInterval = 0;
        double meanXInterval = 0;
        double stdevXInterval = 0;
        double minXInterval = 0;
        double countXInterval = 0;
        int zcXInterval = 0;
        double zcXLastInterval = 0;
    
    
    BinaryTree *btreeYInterval;
        double maxYInterval = 0;
        double medianYInterval = 0;
        double meanYInterval = 0;
        double stdevYInterval = 0;
        double minYInterval = 0;
        double countYInterval = 0;
        int zcYInterval = 0;
        double zcYLastInterval = 0;
    
    BinaryTree *btreeZInterval;
        double maxZInterval = 0;
        double medianZInterval = 0;
        double meanZInterval = 0;
        double stdevZInterval = 0;
        double minZInterval = 0;
        double countZInterval = 0;
        int zcZInterval = 0;
        double zcZLastInterval = 0;
    
    
    //TOTAL
    BinaryTree *btreeXTotal;
        double maxXTotal = 0;
        double medianXTotal;
        double meanXTotal = 0;
        double stdevXTotal;
        double minXTotal = 0;
        double countXTotal = 0;
    
    BinaryTree *btreeYTotal;
        double maxYTotal = 0;
        double medianYTotal;
        double meanYTotal = 0;
        double stdevYTotal;
        double minYTotal = 0;
        double countYTotal = 0;
    
    BinaryTree *btreeZTotal;
        double maxZTotal = 0;
        double medianZTotal;
        double meanZTotal = 0;
        double stdevZTotal;
        double minZTotal = 0;
        double countZTotal = 0;
    
    double calcMin(double min, double newMin);
    double calcMax(double max, double newMax);
    double calcMean(double mean, double key, int count);
    int calcZeroCross(double x, double zcXLastInterval);
    
    dataTotal* calcStDevMedian(BinaryTree *btree, double mean);
    dataTotal* getDataForTree(BinaryTree *currentTree, double mean);
    
    void resetIntervalData();
    
};
#endif /* DescriptStats_hpp */
