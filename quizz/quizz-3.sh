#!/usr/bin/env bash

function returnMeAString(){
  echo "Hello RennesJS"
}

function otherWayToReturnAString() {
[ $1 ] || { echo "Wrong usage"; exit 1; }
myvar="Tonight, it's Bash to the JS"
eval $1='$myvar'
}

val=$(returnMeAString)
echo "${val}"

otherWayToReturnAString result
echo "$result"