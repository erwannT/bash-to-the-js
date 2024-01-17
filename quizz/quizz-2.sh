#!/usr/bin/env bash

function returnMeANumber(){
  return 1
}

function returnMeAnOtherNumber(){
  return 257
}

function returnMeANegativeNumber(){
  return -255
}

returnMeANumber
echo "$?"

returnMeAnOtherNumber
echo "$?"

returnMeANegativeNumber
echo "$?"




