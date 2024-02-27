#!/usr/bin/env bash
prefix="/var/sendmail/new"
numPath="/var/sendmail"

if [ ! -f $numPath/num ]; then
    echo "0" > $numPath/num
fi
num=`cat $numPath/num`
num=$(($num + 1))
echo $num > $numPath/num

name="$prefix/letter_$num.eml"

cat >> $name



chmod 777 $name
/bin/true