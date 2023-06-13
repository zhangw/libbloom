#include <inttypes.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include "bloom.h"

#ifdef __linux
#include <sys/time.h>
#include <time.h>
#endif

uint64_t get_current_time_millis()
{
    struct timeval tp;
    gettimeofday(&tp, NULL);
    return (tp.tv_sec * 1000L) + (tp.tv_usec / 1000L);
}

void init_and_merge(int entries, double error)
{
    struct bloom bloom_a, bloom_b;
    assert(bloom_init2(&bloom_a, entries, error) == 0);
    assert(bloom_init2(&bloom_b, entries, error) == 0);
    uint64_t t1 = get_current_time_millis();
    assert(bloom_merge(&bloom_a, &bloom_b) == 0);
    uint64_t t2 = get_current_time_millis();
    printf("init_and_merge: %10d size cost: %6" PRIu64 " ms\n", entries, (t2 - t1));
}

void basic()
{
    printf("libloom %s\n", bloom_version());

    init_and_merge(1000, 0.001);
    init_and_merge(10000, 0.001);
    init_and_merge(100000, 0.001);
    init_and_merge(1000000, 0.001);
    init_and_merge(10000000, 0.001);
    init_and_merge(100000000, 0.001);
}

int main(int argc, char **argv)
{
    if (argc == 1)
    {
        basic();
        exit(0);
    }
}