//
//  DescriptStats.cpp
//  Accel
//
//  Created by  on 1/17/18.
//  Copyright © 2018 . All rights reserved.
//

#include "DescriptStats.hpp"

DescriptStats::DescriptStats() {
    
    btreeXInterval = new BinaryTree();
    btreeYInterval = new BinaryTree();
    btreeZInterval = new BinaryTree();
    
    btreeXTotal = new BinaryTree();
    btreeYTotal = new BinaryTree();
    btreeZTotal = new BinaryTree();
}
DescriptStats::~DescriptStats() {}

void DescriptStats::addNewData(double x, double y, double z) {
    
    countXTotal++;
    minXTotal = calcMin(minXTotal, x);
    maxXTotal = calcMax(maxXTotal, x);
    meanXTotal = calcMean(meanXTotal, x, countXTotal);
    
    countYTotal++;
    minYTotal = calcMin(minYTotal, y);
    maxYTotal = calcMax(maxYTotal, y);
    meanYTotal = calcMean(meanYTotal, y, countYTotal);
    
    countZTotal++;
    minZTotal = calcMin(minZTotal, z);
    maxZTotal = calcMax(maxZTotal, z);
    meanZTotal = calcMean(meanZTotal, z, countZTotal);
    
    btreeXTotal->insert(x);
    btreeYTotal->insert(y);
    btreeZTotal->insert(z);
    
    
    //As we are receiving data for 50ms we need to reset data in 5000ms
    if(countXInterval >= 100) {
        resetIntervalData();
    }
    
    countXInterval++;
    minXInterval = calcMin(minXInterval, x);
    maxXInterval = calcMax(maxXInterval, x);
    meanXInterval = calcMean(meanXInterval, x, countXInterval);
    zcXInterval += calcZeroCross(x, zcXLastInterval);
    zcXLastInterval = x;
    
    
    countYInterval++;
    minYInterval = calcMin(minYInterval, y);
    maxYInterval = calcMax(maxYInterval, y);
    meanYInterval = calcMean(meanYInterval, y, countYInterval);
    zcYInterval += calcZeroCross(y, zcYLastInterval);
    zcYLastInterval = y;
    
    countZInterval++;
    minZInterval = calcMin(minZInterval, z);
    maxZInterval = calcMax(maxZInterval, z);
    meanZInterval = calcMean(meanZInterval, z, countZInterval);
    zcZInterval += calcZeroCross(z, zcZLastInterval);
    zcZLastInterval = z;
    
    btreeXInterval->insert(x);
    btreeYInterval->insert(y);
    btreeZInterval->insert(z);

}


int medianIndex = 0;

double getDataWithDfs(node *leaf, double mean, int count, dataTotal* data){
    if(leaf != NULL){
        double current = pow(leaf->value - mean, 2);
        double left =  getDataWithDfs(leaf->left,mean,count,data);
        
        if (count % 2 == 0) {
            if (medianIndex == count / 2){
                data->median += leaf->value / 2.0;
            } else if (medianIndex == (count / 2 - 1)){
                data->median += leaf->value / 2.0;
            }
        } else if (medianIndex == count / 2){
            data->median += leaf->value;
        }
        
        medianIndex = medianIndex + 1;
        
        double right = getDataWithDfs(leaf->right,mean,count,data);
        return current + left + right;
    } else {
        return 0.0;
    }
}

dataTotal* DescriptStats::calcStDevMedian(BinaryTree *btree, double mean){
    dataTotal* data = new dataTotal;
    medianIndex = 0;
    data->median = 0;
    data->stdev =  sqrt(getDataWithDfs(btree->root, mean,btree->count,data) / btree->count);
    return data;
}

dataTotal* DescriptStats::getDataForTree(BinaryTree *currentTree, double mean) {
    dataTotal *data;
    data = calcStDevMedian(currentTree, mean);
    return data;
}

//TOTAL
dataTotal* DescriptStats::getXTotalData(){
    dataTotal *data =  getDataForTree(btreeXTotal,meanXTotal);
    data->max = maxXTotal;
    data->min = minXTotal;
    data->count = countXTotal;
    data->mean = meanXTotal;
    return data;
}
dataTotal* DescriptStats::getYTotalData(){
    dataTotal *data =  getDataForTree(btreeYTotal,meanYTotal);
    data->max = maxYTotal;
    data->min = minYTotal;
    data->count = countYTotal;
    data->mean = meanYTotal;
    return data;
}
dataTotal* DescriptStats::getZTotalData(){
    dataTotal *data =  getDataForTree(btreeZTotal,meanZTotal);
    data->max = maxZTotal;
    data->min = minZTotal;
    data->count = countZTotal;
    data->mean = meanZTotal;
    return data;
}

//INTERVAL
dataTotal* DescriptStats::getXIntervalData(){
    dataTotal *data =  getDataForTree(btreeXInterval,meanXInterval);
    data->max = maxXInterval;
    data->min = minXInterval;
    data->count = countXInterval;
    data->mean = meanXInterval;
    data->zc = zcXInterval;
    return data;
}
dataTotal* DescriptStats::getYIntervalData(){
    dataTotal *data =  getDataForTree(btreeYInterval,meanYInterval);
    data->max = maxYInterval;
    data->min = minYInterval;
    data->count = countYInterval;
    data->mean = meanYInterval;
    data->zc = zcYInterval;
    return data;
}
dataTotal* DescriptStats::getZIntervalData(){
    dataTotal *data =  getDataForTree(btreeZInterval,meanZInterval);
    data->max = maxZInterval;
    data->min = minZInterval;
    data->count = countZInterval;
    data->mean = meanZInterval;
    data->zc = zcZInterval;
    return data;
}


double DescriptStats::calcMin(double min, double newMin){
    if (min<newMin) {
        return min;
    }
    return newMin;
}
double DescriptStats::calcMax(double max, double newMax){
    if (max>newMax) {
        return max;
    }
    return newMax;
}
double DescriptStats::calcMean(double mean, double key, int count){
    return (mean*(count-1)+key)/count;
}

int DescriptStats::calcZeroCross(double x, double previousVal){
    if (x >= 0 && previousVal >= 0){
        return 0;
    } else if (x < 0 && previousVal < 0){
        return 0;
    }
    return 1;
}


void DescriptStats::resetIntervalData(){
    
    btreeXInterval->destroy_tree();
    btreeYInterval->destroy_tree();
    btreeZInterval->destroy_tree();
    
    btreeXInterval = new BinaryTree();
    btreeYInterval = new BinaryTree();
    btreeZInterval = new BinaryTree();
    
    maxXInterval = 0;
    medianXInterval = 0;
    meanXInterval = 0;
    stdevXInterval = 0;
    minXInterval = 0;
    countXInterval = 0;
    zcXInterval = 0;
    
    maxYInterval = 0;
    medianYInterval = 0;
    meanYInterval = 0;
    stdevYInterval = 0;
    minYInterval = 0;
    countYInterval = 0;
    zcYInterval = 0;

    maxZInterval = 0;
    medianZInterval = 0;
    meanZInterval = 0;
    stdevZInterval = 0;
    minZInterval = 0;
    countZInterval = 0;
    zcZInterval = 0;
    
}

//double DescriptStats::calcMedian(){}












