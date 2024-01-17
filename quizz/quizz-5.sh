#!/usr/bin/env bash

cat <<EOF > /tmp/vegetables.txt
tomato
banana
apple
avocado
EOF

cat /tmp/vegetables.txt | while read -r vegetable ;
do
  echo "$vegetable"
done

cat /tmp/vegetables.txt | while read -r vegetable ;
do
  ssh -i ~/.ssh/quizz 127.0.0.1 echo "$vegetable"
done



