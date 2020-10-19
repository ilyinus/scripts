find AS33/200113 -name '*.zip' -print0 |
xargs -0 -i -n 1 unzip -c {} 'Locks/rphost*/*.log' |
perl -pe 's/\xef\xbb\xbf//g' |
sed -r '/(Archive|inflating|extracting).*(\.zip|\.log)/d' |
sed -r '/^$/d' |
gawk -vORS='<LineBreak>' '{if (match($0, "^[0-9]+:[0-9]+\\.")) print "<LineBreak>\n"$0; else print $0}' |
egrep ',TLOCK,.*WaitConnections=[0-9]+.*Context=' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
perl -pe 's/,TLOCK,.*Regions=/<Regions>(/' |
perl -pe 's/,.*Context=/) Context=/' |
#gawk -F '<Regions>' '{Dur[$2]+=$1; Count[$2]+=1; Total+=$1}END{for (i in Dur) {print Dur[i]/1000000 " (сек.) Длительность; " Dur[i]/1000000/Count[i] " Средняя длит-ость (сек.); " Count[i] " Кол-во; " Dur[i]/Total*100 "% вклад;<LineBreak>--------------------------------------------------------------------------------------------<LineBreak>" i}}' |
gawk -F '<Regions>' '{Dur[$2]+=$1; Count[$2]+=1; Total+=$1}END{for (i in Dur) {printf "%.3f Длительность (сек.); %.3f Средняя длит-ость (сек.); %d Кол-во; %.3f%% вклад;<LineBreak>--------------------------------------------------------------------------------------------<LineBreak>%s\n", Dur[i]/1000000,Dur[i]/1000000/Count[i],Count[i],Dur[i]/Total*100,i}}' |
perl -pe 's/<LineBreak><LineBreak>/<LineBreak>/g' |
sort -rnb -k 1 -t ';' |
sed -r 's/<LineBreak>/\n/g' > LocksWait.txt