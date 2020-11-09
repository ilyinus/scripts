time cat Logs/2010*/Long/rphost*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/^[0-9]+:[0-9]+.*,Context,.*Context=/,Context=/' |
gawk -vORS="" '{if (match($0, "^[0-9]+:")) print "\n"$0; else print $0}' | 
perl -pe 's/(,CALL,.*)(,p:processName=.*,)(MemoryPeak=.*,)(InBytes=.*,)(OutBytes=.*,)(CpuTime=.*,)(Context=.*$)/\1\2\7,\3\4\5\6/' |
perl -pe 's/,Module=/Context=/' |
perl -pe 's/,Method=/\./' |
perl -pe 's/\t/ /g' |
egrep ',CALL,.*p:processName=.*Context=.*MemoryPeak=.*InBytes=.*OutBytes=.*CpuTime=.*' |
perl -pe 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
perl -pe 's/,CALL.*p:processName=/|/' |
perl -pe 's/,.*Context=/|/' |
perl -pe 's/,.*MemoryPeak=/|/' |
perl -pe 's/,.*InBytes=/|/' |
perl -pe 's/,.*OutBytes=/|/' |
perl -pe 's/,.*CpuTime=/|/' |
perl -pe 's/\./#/g' |
gawk -F '|' '{Dur[$2,$3]+=$1; CpuTotal+=$7; Exec[$2,$3]+=1; Base[$2,$3] = $2; Context[$2,$3] = $3; if (Max[$2,$3] < $1) {Max[$2,$3] = $1}; if (Min[$2,$3] == 0 || Min[$2,$3] > $1) {Min[$2,$3] = $1}; Memory[$2,$3]+=$4; if (MaxMem[$2,$3] < $4) {MaxMem[$2,$3] = $4}; InBytes[$2,$3]+=$5; OutBytes[$2,$3]+=$6; CpuTime[$2,$3]+=$7}END{print "Base\tDur(sec)\tCount\tAvgDur(sec)\tMaxDur(sec)\tMinDur(sec)\tMemory(MB)\tAvgMemory(MB)\tMaxMemory(MB)\tReads(MB)\tWrites(MB)\tCpuTime(sec)\tCpuLoad(%)\tCpuLoadTotal(%)\tContext"; for (i in Dur) {print Base[i] "\t" Dur[i]/1000000 "\t" Exec[i] "\t" Dur[i]/1000000/Exec[i] "\t" Max[i]/1000000 "\t" Min[i]/1000000 "\t" Memory[i]/1024/1024 "\t" Memory[i]/1024/1024/Exec[i] "\t" MaxMem[i]/1024/1024 "\t" InBytes[i]/1024/1024 "\t" OutBytes[i]/1024/1024 "\t" CpuTime[i]/1000000 "\t" (CpuTime[i]/1000000) / (Dur[i]/1000000) * 100 "\t" CpuTime[i] / CpuTotal * 100 "\t" Context[i]}}' |
perl -pe 's/\./,/g' |
perl -pe 's/#/\./g' > CALL_for_Excell_all_bases.txt