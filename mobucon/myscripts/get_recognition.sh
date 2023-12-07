#!/bin/bash

tail -2 $1 | head -1 > $2 &&
sed -i -e 's/]),/]),\n/g' $2 &&
sed -i '/^.*closePerm.*/!d' $2

