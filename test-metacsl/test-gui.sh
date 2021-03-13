#!/bin/sh
frama-c-gui -meta -meta-checks -meta-no-simpl -meta-number-assertions all_zeros.c -then-last -wp -wp-rte
