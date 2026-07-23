#include <gtest/gtest.h>

extern "C" {
#include "list.h"
}

TEST(ListTest, Empty) {
    list_t list;
    list_init(&list);

    EXPECT_EQ(list_size(&list), 0u);

    list_destroy(&list);
}

TEST(ListTest, PushAndGet) {
    list_t list;
    list_init(&list);

    list_push_back(&list, 10);
    list_push_back(&list, 20);
    list_push_back(&list, 30);

    EXPECT_EQ(list_size(&list), 3u);
    EXPECT_EQ(list_get(&list, 0), 10);
    EXPECT_EQ(list_get(&list, 1), 20);
    EXPECT_EQ(list_get(&list, 2), 30);

    list_destroy(&list);
}

TEST(ListTest, DestroyClearsState) {
    list_t list;
    list_init(&list);

    list_push_back(&list, 42);
    list_destroy(&list);

    EXPECT_EQ(list_size(&list), 0u);

    list_destroy(&list);
}
