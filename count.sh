#！ /bin/bash

echo "'file ID','Numreds'"
for dir in `ls|grep -v normal|grep -v file|grep -v out|grep -v count`
do  
  #echo "$dir" 
  #TPM=`cat "$dir"/quant.sf|grep -v TPM | cut -f 4 |awk '{sum += $1};END {print sum/100}' `
  Num=`cat "$dir"/quant.sf|grep -v TPM | cut -f 5 |awk '{sum += $1};END {print sum}'`
  echo "$dir,$Num"

done
