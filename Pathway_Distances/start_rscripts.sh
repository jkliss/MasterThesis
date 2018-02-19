for i in `ls -1 /home/julius/cut_fusions_redo_maxtarget/test_run_everything_with_relations_instead_evalue/run_with_random_pairs/run/*`;
do
	echo "start_pathway $i"
	#nohup Rscript no_merge_list_read_pathway_org_batch.R $i 1> $i.out 2> $i.err &
	nohup nice -19 Rscript list_read_pathway_org_batch.R $i 1> $i.out 2> $i.err &
	cnt=16
	while [ $cnt -gt 10 ]
	do
		cnt=0
		for job in `jobs -p`;
		do
			cnt=$[$cnt+1]
		done
	done
done
