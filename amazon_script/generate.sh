
sellor=$1
mkdir -p $sellor
cd $sellor
#rm * -rf


cat *.result | awk -vFS="\t" 'length($3)>0{gsub(",",""); gsub("#",""); print $0}' | sort -nk3 > total.txt
cat *.result | awk -vFS="\t" 'length($3)==0' > norank.txt
cat norank.txt >> total.txt

#echo "base     url     ����    ͼƬ    �̱�    ��Ʒ��  review  �۸�    ����Ʒ  ����Ʒ  ����" > ../$sellor"total.txt"
#cat total.txt >> ../$sellor"total.txt"
#
echo	"base	����	���	ͼƬ	�̱�	��Ʒ��	review	�۸�	����Ʒ	����Ʒ	����"	>	../$sellor"total.txt"
awk -vFS="\t" '{
    idx=index($3," ");
    score=substr($3,0,idx);
    type=substr($3,idx+3);
    print $1"\t"score"\t"type"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11;}' total.txt >> ../$sellor"total.txt"

echo "<table><tr><td>url</td><td>����</td><td>  ͼƬ</td><td>   �̱�</td><td>   ��Ʒ��</td><td> review</td><td> �۸�</td><td>   ����Ʒ</td><td> ����Ʒ</td><td>      ����</td></tr>" > ../$sellor"total.html"
awk -vFS="\t" '{print "<tr><td><a href=\""$2"\">"$1"</a></td><td>"$3"</td><td><img src="$4" width=200 /></td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td><td>"$9"</td><td>"$10"</td><td></tr>";}' total.txt >> ../$sellor"total.html"
echo "</table>" >> ../$sellor"total.html"


sz ../$sellor"total.txt"

cd ..
#rm $sellor -rf

#rm $sellor.lock
