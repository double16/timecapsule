#!/bin/sh

./wait-for-it.sh timecapsule:548

source /sh2ju.sh
juLogClean

juLog -name="opentcp" nc -zv -w 10 timecapsule 548

