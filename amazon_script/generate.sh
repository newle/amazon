
sellor=$1
mkdir -p $sellor
cd $sellor
#rm * -rf


cat *.result | awk -vFS="\t" 'length($3)>0{gsub(",",""); gsub("#",""); print $0}' | sort -nk3 > total.txt
cat *.result | awk -vFS="\t" 'length($3)==0' > norank.txt
cat norank.txt >> total.txt

#echo "base     url     排名    图片    商标    商品名  review  价格    新商品  老商品  描述" > ../$sellor"total.txt"
#cat total.txt >> ../$sellor"total.txt"
#
echo	"base	排名	类别	图片	商标	商品名	review	价格	新商品	老商品	描述"	>	../$sellor"total.txt"
awk -vFS="\t" '{
    idx=index($3," ");
    score=substr($3,0,idx);
    type=substr($3,idx+3);
    print $1"\t"score"\t"type"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11;}' total.txt >> ../$sellor"total.txt"

echo "<table><tr><td>url</td><td>排名</td><td>  图片</td><td>   商标</td><td>   商品名</td><td> review</td><td> 价格</td><td>   新商品</td><td> 老商品</td><td>      描述</td></tr>" > ../$sellor"total.html"
awk -vFS="\t" '{print "<tr><td><a href=\""$2"\">"$1"</a></td><td>"$3"</td><td><img src="$4" width=200 /></td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td><td>"$9"</td><td>"$10"</td><td></tr>";}' total.txt >> ../$sellor"total.html"
echo "</table>" >> ../$sellor"total.html"


sz ../$sellor"total.txt"

cd ..
#rm $sellor -rf

#rm $sellor.lock
