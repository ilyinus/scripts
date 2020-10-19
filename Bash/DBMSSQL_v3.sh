time cat Long/rphost*/*.log |
perl -pe 's/#tt[0-9]+/#tt/g' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-[0-9]+,Context,.*Context=/,Context=/' |
perl -pe 's/,Rows.*=-?[0-9]+//' |
sed -r '/^p_[0-9]+:/d' |
sed -r '/^$/d' |
perl -pe 's/\n/<LineBreak>/; s/\xef\xbb\xbf//g; s/^[0-9]+:[0-9]+\.[0-9]+-/\n/' |
perl -pe 's/(<LineBreak>$|$)/<LineBreak>/' |
egrep ',DBMSSQL,.*p:processName=.*Sql=' |
perl -pe 's/,DBMSSQL,.*p:processName=/|/' |
perl -pe 's/,.*Sql=/|/' |
tr \" \' |
gawk -F '|' '{Sum[tolower($2),$3]+=$1; Exec[tolower($2),$3]+=1; Base[tolower($2),$3] = tolower($2); Context[tolower($2),$3] = $3; if (Max[tolower($2),$3] < $1) {Max[tolower($2),$3] = $1}; if (Min[tolower($2),$3] == 0 || Min[tolower($2),$3] > $1) {Min[tolower($2),$3] = $1}}END{for (i in Sum) printf "База: %s; %.3f суммарное время (сек); %d количество; %.3f среднее время (сек); %.3f максимальное время (сек); %.3f минимальное время (сек)<LineBreak>---------------------------------------------------------------------------------------------------------------------------------------------------------<LineBreak>%s<LineBreak><LineBreak>---------------------------------------------------------------------------------------------------------------------------------------------------------\n", tolower(Base[i]),Sum[i]/1000000,Exec[i],Sum[i]/1000000/Exec[i],Max[i]/1000000,Min[i]/1000000,Context[i]}' |
sort -rnb -t';' -k 2 |
head |
perl -pe 's/<LineBreak>/\n/g' > DBMSSQL.txt