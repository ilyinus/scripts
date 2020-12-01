time cat Logs/2010*/log/rphost*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
gawk -vORS="<LineBreak>" '{if (match ($0, "^[0-9]+:[0-9]+\\.")) print "\n"$0; else print $0}' |
egrep ',EXCP,.*Descr=' |
perl -pe 's/^.*p:processName=/Base=/' |
perl -pe 's/,.*Descr=/, Descr=/' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-[0-9]+, //' |
sort | uniq -c | sort -rnb |
perl -pe 's/<LineBreak>/\n/g' > Excp.txt