#Если предварительно не нужно выпрямлять строки
find AS*/191014 -name '*.zip' -print0 |
xargs -0 -i -n 1 unzip -c {} 'Long/rphost*/*.log' |
perl -pe 's/\xef\xbb\xbf//g' |
egrep '(inflating|select count\(\*\) from _YearOffset)' |
gawk -vORS='' '{if (match($0, "inflating: ")) print "\n"$0; else print "|"$0}' |
perl -pe 's/^.*inflating.*\/[0-9]{6}//' |
perl -pe 's/\.log  //' |
egrep '^[0-9]{2}|' |
gawk -F '|' '{for (i = 2; i <= NF; i++) print $1":"$i}' |
egrep -o '^.{2}' |
sort | uniq -c | sort -nbk 2 > tst.txt

#Если предварительно нужно выпрямить строки
find AS30/191014 -name '*.zip' -print0 |
xargs -0 -i -n 1 unzip -c {} 'Long/rphost*/*.log' |
perl -pe 's/\xef\xbb\xbf//g' |
sed -r '/(Archive:|extracting:)/d' |
sed -r '/^$/d' |
gawk -vORS='<LineBreak>' '{if (match($0, "(inflating|^[0-9]+:[0-9]+\\.[0-9]+)")) print "\n"$0; else print $0}' |
perl -pe 's/.log  <LineBreak>//' |
egrep '(inflating|,DBMSSQL,)' |
gawk -vORS='' '{if (match($0, "(inflating: )")) print "\n"$0; else print "|"$0}' |
perl -pe 's/^.*inflating.*\/[0-9]{6}//' |
gawk -F '|' '/^[0-9]{2}|/ {for (i = 2; i <= NF; i++) print $1":"$i}' |
sed -r 's/<LineBreak>/\n/g' > tst.txt