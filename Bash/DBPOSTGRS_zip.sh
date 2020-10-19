find //D01sedfs03/ARCHIVES/TLOGS/SEDA1/19-07-08 -name '*.zip' -print0 |
xargs -0 -i -n 1 unzip -c {} '*/long/rphost*/*.log' |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/'\''.*?'\''::\w+/\?/g' |
perl -pe 's/pg_temp\.tt[0-9]+/tt/g' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-[0-9]+,Context,.*Context=/,Context=/' |
perl -pe 's/,Rows.*=-?[0-9]+//' |
perl -pe 's/,Result=\w+//' |
gawk -vORS='<LineBreak>' '{if (match($0, "^[0-9]+:[0-9]+\\.[0-9]+-")) print "\n"$0; else print $0;}' |
sed -r '/^$/d' |
egrep ',DBPOSTGRS,.*Sql=' |
sed -r 's/^[0-9]+:[0-9]+\.[0-9]+-//;s/,DBPOSTGRS,.*Sql=/Sql=/' |
tr \" \' |
gawk -F 'Sql=' '{Sum[$2]+=$1; Exec[$2]+=1; if (Max[$2] < $1) {Max[$2] = $1}; if (Min[$2] == 0 || Min[$2] > $1) {Min[$2] = $1}}END{for (i in Sum) {print Sum[i]/1000000 " суммарное время (сек); " Exec[i] " количество; " Sum[i]/1000000/Exec[i] " среднее время (сек); " Max[i]/1000000 " максимальное время (сек); " Min[i]/1000000 " минимальное время (сек)<LineBreak>-----------------------------------------------------------------------------------------------------------------------------------------------<LineBreak>" i "<LineBreak><LineBreak>-----------------------------------------------------------------------------------------------------------------------------------------------"}}' |
sort -rnb -t';' -k 1 |
head |
sed -r 's/<LineBreak>/\n/g' > DBPOSTGRS.txt