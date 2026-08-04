// Copyright 2026 Sohaila Abdelaziz

#ifndef SWB_04_SOHILA_INC_STATIC_ARRAY_H_
#define SWB_04_SOHILA_INC_STATIC_ARRAY_H_

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

#endif  // SWB_04_SOHILA_INC_STATIC_ARRAY_H_

