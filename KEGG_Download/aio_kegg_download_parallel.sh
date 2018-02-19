rm ko.o
rm ko.o*
rm ko*conv
echo "Get KO List"
curl http://rest.kegg.jp/list/ko > ko.o
split -d -l 1000 ko.o ko.o.part
echo "Get Conv Tables"
for i in `ls ko.o.part*`;
do
        nohup python mod_get_kegg_conv.py $i &
done
for job in `jobs -p`
do
    echo $job
    wait $job || let "FAIL+=1"
done
cat ko.o.part*.conv > ko.conv
cat ko.conv | awk '{print $2}' | sort | uniq > ko.conv.f2
cp ko.conv.f2 ko.conv.f2.to_find

rm -f ko.seq

run_again=1
while [ $run_again -eq 1 ]
do
        echo "Run Download $i"
        rm -f ko.conv*part*seq
        rm -f ko.conv*part*missing
        to_find_lines=`wc -l ko.conv.f2.to_find | awk '{print $1}'`
        sp_size=`expr $to_find_lines / 20`
        split -d -l $sp_size ko.conv.f2.to_find ko.conv.f2.to_find.part
        for i in `ls ko.conv.f2.to_find.part*`;
        do
                nohup python mod_get_KEGG_home_safe_linear.py $i &
        done
        for job in `jobs -p`;
        do
            echo $job
            wait $job || let "FAIL+=1"
        done
        cat ko.conv*part*.seq >> ko.seq
        cat ko.seq | grep ">" | awk '{print $1}' | tr -d ">" | sort --parallel 20 -S 30% > ko.seq.found.su
        comm ko.conv.f2 ko.seq.found.su -3 -2 > ko.conv.f2.to_find
        if [ `cat ko.conv*part*seq | wc -l` -lt 500 ]
        then
        	if [ `cat ko.conv*part*seq | grep ">" | awk '{print $1}' | tr -d ">" | grep -f - ko.conv.f2.to\_find | wc -l` -eq 0 ]
        	then
        		run_again=0
        	fi
        fi
done
