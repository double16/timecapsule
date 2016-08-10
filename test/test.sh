#!/bin/sh

source /sh2ju.sh
juLogClean

juLog -name="opentcp" nc -zv -w 10 timecapsule 548

