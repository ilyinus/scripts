cat Locks/rphost*/*.log | sed -r 's/\xef\xbb\xbf//g' |
gawk -vORS='<LineBreak>' '{if (match($0, "^[0-9]+:[0-9]+\\.")) print "<LineBreak>\n"$0; else print $0}' |
egrep ',TLOCK,.*WaitConnections=[0-9]+.*Context=' |
sed -r 's/^[0-9]+:[0-9]+\.[0-9]+-//;s/,TLOCK,.*Regions=/<Regions>(/;s/,.*Context=/) Context=/' |
gawk -F '<Regions>' '{Dur[$2]+=$1; Count[$2]+=1; Total+=$1}END{for (i in Dur) {print Dur[i]/1000000 " (сек.) Длительность; " Dur[i]/1000000/Count[i] " Средняя длит-ость (сек.); " Count[i] " Кол-во; " Dur[i]/Total*100 "% вклад;<LineBreak>--------------------------------------------------------------------------------------------<LineBreak>" i}}' |
sort -rnb |
sed -r 's/<LineBreak>/\n/g' > LocksWait.txt