count=0;
total=0; 

for i in $(cat ${1} | grep First | awk '{print $6}')
do
 #echo ${i}
 total=$(echo $total+$i | bc )
((count++))
done
echo "First Request (ms)"
echo "scale=2; $total / $count" | bc

count=0;
total=0;

for i in $(cat ${1} | grep Foot | awk '{print $5}')
do
 #echo ${i}
 total=$(echo $total+$i | bc )
((count++))
done
echo "Footprint (MB)"
echo "scale=2; $total / $count" | bc
