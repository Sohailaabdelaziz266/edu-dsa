#include "list.h"

#include <stdlib.h>

void list_init(list_t *list) {
    list->head = NULL;
    list->size = 0;
}

void list_push_back(list_t *list, int value) {
    list_node_t *node = malloc(sizeof(*node));
    if (node == NULL) {
        return;
    }

    node->value = value;
    node->next = NULL;

    if (list->head == NULL) {
        list->head = node;
    } else {
        list_node_t *current = list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = node;
    }

    list->size++;
}

size_t list_size(const list_t *list) {
    return list->size;
}

int list_get(const list_t *list, size_t index) {
    if (index >= list->size) {
        return 0;
    }

    list_node_t *current = list->head;
    for (size_t i = 0; i < index; i++) {
        current = current->next;
    }

    return current->value;
}

void list_destroy(list_t *list) {
    list_node_t *current = list->head;
    while (current != NULL) {
        list_node_t *next = current->next;
        free(current);
        current = next;
    }

    list->head = NULL;
    list->size = 0;
}
