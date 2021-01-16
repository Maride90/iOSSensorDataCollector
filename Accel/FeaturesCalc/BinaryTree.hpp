//
//  BinaryTree.hpp
//  Accel
//
//  Created by  on 1/18/18.
//  Copyright © 2018 . All rights reserved.
//

#ifndef BinaryTree_hpp
#define BinaryTree_hpp

#include <iostream>

using namespace std;

struct node{
    double value;
    node *left;
    node *right;
};

class BinaryTree{
public:
    BinaryTree();
    ~BinaryTree();
    
    void insert(double key);
    node *search(double key);
    void destroy_tree();
    void inorder_print();
    void postorder_print();
    void preorder_print();
    node *root;
    int count;
    
private:
    void destroy_tree(node *leaf);
    void insert(double key, node *leaf);
    node *search(double key, node *leaf);
    void inorder_print(node *leaf);
    void postorder_print(node *leaf);
    void preorder_print(node *leaf);
    
    
};

#endif /* BinaryTree_hpp */
