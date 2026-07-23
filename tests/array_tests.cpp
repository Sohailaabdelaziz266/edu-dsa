#include <gtest/gtest.h>
// #include <array>
#include <stdexcept>
#include <numeric>
#include "static_array.h"

// ==========================================
// 1. Capacity and Initialization
// ==========================================
TEST(StdArrayTest, CapacityAndInitialization) {
    std::array<int, 5> arr = {1, 2, 3, 4, 5};
    
    // Check sizes
    EXPECT_FALSE(arr.empty());
    EXPECT_EQ(arr.size(), 5);
    EXPECT_EQ(arr.max_size(), 5); // size and max_size are identical for std::array
    
    // Zero-sized array behavior
    std::array<int, 0> empty_arr{};
    EXPECT_TRUE(empty_arr.empty());
    EXPECT_EQ(empty_arr.size(), 0);
}

// ==========================================
// 2. Element Access
// ==========================================
TEST(StdArrayTest, ElementAccess) {
    std::array<int, 3> arr = {10, 20, 30};

    // Unchecked access
    EXPECT_EQ(arr[0], 10);
    EXPECT_EQ(arr[2], 30);

    // Checked access using at()
    EXPECT_EQ(arr.at(1), 20);
    
    // at() must throw std::out_of_range on invalid indices
    EXPECT_THROW(arr.at(3), std::out_of_range);
    EXPECT_THROW(arr.at(-1), std::out_of_range);

    // Front and back access
    EXPECT_EQ(arr.front(), 10);
    EXPECT_EQ(arr.back(), 30);

    // Raw pointer access via data()
    int* ptr = arr.data();
    EXPECT_EQ(*ptr, 10);
    
    // Modifying via raw pointer updates the array
    *(ptr + 1) = 99;
    EXPECT_EQ(arr[1], 99);
}

// ==========================================
// 3. Iterators
// ==========================================
TEST(StdArrayTest, Iterators) {
    std::array<int, 4> arr = {1, 2, 3, 4};

    // Forward iteration
    int sum = 0;
    for (auto it = arr.begin(); it != arr.end(); ++it) {
        sum += *it;
    }
    EXPECT_EQ(sum, 10);

    // Const iterators
    EXPECT_EQ(*arr.cbegin(), 1);
    
    // Reverse iterators
    EXPECT_EQ(*arr.rbegin(), 4);
    EXPECT_EQ(*(arr.rend() - 1), 1);
    
    // STL algorithm compatibility (e.g., std::accumulate)
    int stl_sum = std::accumulate(arr.begin(), arr.end(), 0);
    EXPECT_EQ(stl_sum, 10);
}

// ==========================================
// 4. Modifiers (Operations)
// ==========================================
TEST(StdArrayTest, Modifiers) {
    std::array<int, 3> arr1 = {1, 2, 3};
    std::array<int, 3> arr2 = {7, 8, 9};

    // Fill operation overwrites all elements
    arr1.fill(0);
    EXPECT_EQ(arr1[0], 0);
    EXPECT_EQ(arr1[1], 0);
    EXPECT_EQ(arr1[2], 0);

    // Swap operation exchanges contents between arrays of the same size/type
    arr1.swap(arr2);
    EXPECT_EQ(arr1[0], 7);
    EXPECT_EQ(arr1[2], 9);
    EXPECT_EQ(arr2[0], 0);
}

// ==========================================
// 5. Comparisons
// ==========================================
TEST(StdArrayTest, Comparisons) {
    std::array<int, 3> a = {1, 2, 3};
    std::array<int, 3> b = {1, 2, 3};
    std::array<int, 3> c = {1, 2, 4};
    std::array<int, 3> d = {1, 2, 2};

    // Equality
    EXPECT_TRUE(a == b);
    EXPECT_FALSE(a == c);
    
    // Inequality
    EXPECT_TRUE(a != c);
    
    // Lexicographical comparisons
    EXPECT_TRUE(a < c);  // 3 < 4 at index 2
    EXPECT_TRUE(a > d);  // 3 > 2 at index 2
    EXPECT_TRUE(a <= b);
    EXPECT_TRUE(c >= a);
}

// ==========================================
// 6. Multidimensional Array Test
// ==========================================
TEST(StdArrayTest, NestedArrays) {
    // 2D Array: 2 rows, 3 columns
    std::array<std::array<int, 3>, 2> matrix = {{
        {1, 2, 3},
        {4, 5, 6}
    }};

    EXPECT_EQ(matrix.size(), 2);
    EXPECT_EQ(matrix[0].size(), 3);
    
    EXPECT_EQ(matrix[0][1], 2);
    EXPECT_EQ(matrix[1][2], 6);
}