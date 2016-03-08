#!/bin/bash

for f in *.txt; do
    cat $f | sort -u | xargs -I '{}' bash -c 'sudo ip route add blackhole {}'
done

