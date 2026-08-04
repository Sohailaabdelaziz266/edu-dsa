// Copyright 2026 Sohaila Abdelaziz
#ifndef STATIC_ARRAY_H
#define STATIC_ARRAY_H

#include <iostream>

class StaticArray {
private:
    int data[100]; 
    int size;    

public:
    StaticArray() {
        size = 0;
    }

   
    void insert(int value) {
        if (size < 100) {
            data[size] = value;
            size++;
        }
    }
    void display() {
        for (int i = 0; i < size; i++) {
            std::cout << data[i] << " ";
        }
        std::cout << std::endl;
    }
};

#endif