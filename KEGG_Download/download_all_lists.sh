curl rest.kegg.jp/list/organism/ | awk '{print $2}' > kegg_organisms
for i in `cat kegg_organisms`;
do
	curl rest.kegg.jp/list/pathway/$i > path_lists/$i.list
done
