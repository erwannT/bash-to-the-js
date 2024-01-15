#!/usr/bin/env bash

function returnMeAString(){
  return "test"
}

function returnMeANumber(){
  return 1
}

function returnMeAnOtherNumber(){
  return 257
}

function returnMeANegativeNumber(){
  return -255
}

function echoAString(){
  return "test"
}

function nice_function() {
[ $1 ] || { echo "Wrong usage"; exit 1; }

myvar="Let us return something"

eval $1='$myvar'
}

function isSuccess() {
  return 0
}

###
#test=returnMeANumber()
#echo "$test"
## => exception

#test=returnMeANumber
#echo "$test"
## => returnMeANumber

#returnMeANumber
#val=$?
#echo $val
## => 1

#returnMeAnOtherNumber
#val=$?
#echo $val
## => 1

#returnMeANegativeNumber
#val=$?
#echo $val
## => 1

#returnMeAString
#val=$?
#echo "String : ${val}"
## => ""

#nice_function

## Nice "return"
#nice_function result
#echo "$result"

#if isSuccess
#then
#  echo "It's a succes"
#fi

vegetables=(1 2 3 4 5)
for vegetable in ${vegetables[@]}; do
    echo "$vegetable"
done

for vegetable in ${vegetables[@]}; do
    ssh -i ~/.ssh/quizz 127.0.0.1 echo "$vegetable"
done

cat <<EOF > /tmp/vegetables.txt
carot
potatoe
tomato
EOF

while read vegetable ;
do
  echo "$vegetable"
done < /tmp/vegetables.txt

while read vegetable ;
do
  ssh -i ~/.ssh/quizz 127.0.0.1 echo "$vegetable"
done < /tmp/vegetables.txt



