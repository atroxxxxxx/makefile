#!/bin/bash

ORANGE="\e[0;33m";
DEFAULT_COLOR="\e[0m";

echo -e "$ORANGE""[RUN] $1""$DEFAULT_COLOR";
START_TIME=$(date +%s%N);
./$1 $2;
FINISH_TIME=$(date +%s%N);
echo -e "$ORANGE""procces finished after $(( ($FINISH_TIME - $START_TIME) / 1000000 ))ms with exit code $?""$DEFAULT_COLOR";

