#ifndef LIST_H
#define LIST_H

#include <stddef.h>

typedef struct list_node {
    int value;
    struct list_node *next;
} list_node_t;

typedef struct {
    list_node_t *head;
    size_t size;
} list_t;

void list_init(list_t *list);
void list_push_back(list_t *list, int value);
size_t list_size(const list_t *list);
int list_get(const list_t *list, size_t index);
void list_destroy(list_t *list);

#endif /* LIST_H */
