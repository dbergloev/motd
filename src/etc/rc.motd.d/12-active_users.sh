#!/bin/bash

echo "@list Active users: $(who -q | tail -n 1 | grep -oe '[0-9]\+$')"
