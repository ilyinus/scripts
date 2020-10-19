time cat Long/rphost*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/^[0-9]+:[0-9]+.*,Context,.*Context=/,Context=/' |
gawk -vORS="" '{if (match($0, "^[0-9]+:")) print "\n"$0; else print $0}' | 
perl -pe 's/(,CALL,.*)(,p:processName=.*,)(MemoryPeak=.*,)(InBytes=.*,)(OutBytes=.*,)(Context=.*$)/\1\2\6,\3\4\5/' |
perl -pe 's/\t/ /g' |
egrep ',CALL,.*p:processName=.*Context=.*MemoryPeak=.*InBytes=.*OutBytes=.*' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
perl -pe 's/,CALL.*p:processName=/|/' |
perl -pe 's/,.*Context=/|/' |
perl -pe 's/,.*MemoryPeak=/|/' |
perl -pe 's/,.*InBytes=/|/' |
perl -pe 's/,.*OutBytes=/|/' |
perl -pe 's/\./#/g' |
gawk -F '|' '{Dur[tolower($2),$3]+=$1; Exec[tolower($2),$3]+=1; Base[tolower($2),$3] = tolower($2); Context[tolower($2),$3] = $3; if (Max[tolower($2),$3] < $1) {Max[tolower($2),$3] = $1}; if (Min[tolower($2),$3] == 0 || Min[tolower($2),$3] > $1) {Min[tolower($2),$3] = $1}; Memory[tolower($2),$3]+=$4; if (MaxMem[tolower($2),$3] < $4) {MaxMem[tolower($2),$3] = $4}; InBytes[tolower($2),$3]+=$5; OutBytes[tolower($2),$3]+=$6}END{print "Base\tDurSum(sec)\tCount\tAvgDur(sec)\tMaxDur(sec)\tMinDur(sec)\tMemory(MB)\tAvgMemory(MB)\tMaxMemory(MB)\tReads(MB)\tWrites(MB)\tContext"; for (i in Dur) {print Base[i] "\t" Dur[i]/1000000 "\t" Exec[i] "\t" Dur[i]/1000000/Exec[i] "\t" Max[i]/1000000 "\t" Min[i]/1000000 "\t" Memory[i]/1024/1024 "\t" Memory[i]/1024/1024/Exec[i] "\t" MaxMem[i]/1024/1024 "\t" InBytes[i]/1024/1024 "\t" OutBytes[i]/1024/1024 "\t" Context[i]}}' |
perl -pe 's/\./,/g' |
perl -pe 's/#/\./g' > CALL_for_Excell.txt