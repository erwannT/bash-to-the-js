#!/usr/bin/env bash

vegetables=(tomato banana apple avocado)

for vegetable in ${vegetables[@]}; do
    echo "$vegetable"
done

for vegetable in ${vegetables[@]}; do
    ssh -i ~/.ssh/quizz 127.0.0.1 echo "$vegetable"
done