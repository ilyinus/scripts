find //D01sedfs03/ARCHIVES/TLOGS/SEDA1/19-07-0* -name '*.zip' -print0 |
xargs -0 -i -n 1 unzip -c {} '*/long/rphost*/*.log' |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/^[0-9]+:[0-9]+.*,Context,.*Context=/,Context=/' |
gawk -vORS="" '{if (match($0, "^[0-9]+:")) print "\n"$0; else print $0}' | 
perl -pe 's/(,CALL,.*)(MemoryPeak=.*,)(InBytes=.*,)(OutBytes=.*,)(Context=.*$)/\1\5,\2\3\4/' |
perl -pe 's/\t/ /g' |
egrep ',CALL,.*Context=.*MemoryPeak=.*InBytes=.*OutBytes=.*' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
perl -pe 's/,CALL.*Context=/|/' |
perl -pe 's/,.*MemoryPeak=/|/' |
perl -pe 's/,.*InBytes=/|/' |
perl -pe 's/,.*OutBytes=/|/' |
perl -pe 's/\./#/g' |
gawk -F '|' '{Dur[$2]+=$1; Exec[$2]+=1; if (Max[$2] < $1) {Max[$2] = $1}; if (Min[$2] == 0 || Min[$2] > $1) {Min[$2] = $1}; Memory[$2]+=$3; if (MaxMem[$2] < $3) {MaxMem[$2] = $3}; InBytes[$2]+=$4; OutBytes[$2]+=$5}END{print "Dur(sec)\tCount\tAvgDur(sec)\tMaxDur(sec)\tMinDur(sec)\tMemory(MB)\tAvgMemory(MB)\tMaxMemory(MB)\tReads(MB)\tWrites(MB)\tContext"; for (i in Dur) {print Dur[i]/1000000 "\t" Exec[i] "\t" Dur[i]/1000000/Exec[i] "\t" Max[i]/1000000 "\t" Min[i]/1000000 "\t" Memory[i]/1024/1024 "\t" Memory[i]/1024/1024/Exec[i] "\t" MaxMem[i]/1024/1024 "\t" InBytes[i]/1024/1024 "\t" OutBytes[i]/1024/1024 "\t" i}}' |
perl -pe 's/\./,/g' |
perl -pe 's/#/\./g' > CALL_for_Excell.txt