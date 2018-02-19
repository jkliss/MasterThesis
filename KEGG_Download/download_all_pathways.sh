for i in $(ls *.list)
do
	mkdir paths_$i.dir
	for j in $(cat $i | awk '{print $1}')
	do
		echo "start_download $j"
		curl rest.kegg.jp/get/$j/kgml > paths_$i.dir/$j &
		cnt=11
		while [ $cnt -gt 10 ]
		do
			cnt=0
			for job in `jobs -p`;
			do
				cnt=$[$cnt+1]
			done
			sleep 0.2
		done

	done
done
