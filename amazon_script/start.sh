#!/bin/sh


if [ $# -lt 2 ]; then
    echo "Usage: sh start.sh key country"
    echo "                                           Available countryname candidate: uk us de ca fr es it jp"
fi

sh simple_get.sh $1 $2 > $1$2.log 2>&1 &

tail -f $1$2.log



