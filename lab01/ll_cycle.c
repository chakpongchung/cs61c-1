#include <stdio.h>
#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *tortoise = head;
    node *hare = head;
    while (hare)
    {   
        // hare在末节点
        if (!hare->next)
        {
            return 0;
        }

        //龟向前走一步
        tortoise = tortoise->next;

        //兔向前走两步
        hare = hare->next->next;

        //如果兔追到龟
        if (hare == tortoise)
        {
            return 1;
        }        
    }
    
    return 0;
}