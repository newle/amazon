#!/bin/sh


iftest=0
if [ $# -ge 2 ]; then 
    country=$2
    if [ "$country"x = "uk"x ]; then
    . ./uk_core.sh
    elif [ "$country"x = "us"x ]; then
    . ./us_core.sh
    elif [ "$country"x = "de"x ]; then
    . ./de_core.sh
    elif [ "$country"x = "ca"x ]; then
    . ./ca_core.sh
    elif [ "$country"x = "fr"x ]; then
    . ./fr_core.sh
    elif [ "$country"x = "es"x ]; then
    . ./es_core.sh
    elif [ "$country"x = "it"x ]; then
    . ./it_core.sh
    elif [ "$country"x = "jp"x ]; then
    . ./jp_core.sh
    else
        echo "          Usage: sh simple_get.sh sellorid countryname"
        echo "                                           Available countryname candidate: uk  us de"
        exit 1
    fi

   if [ $3"x" = "test"x ]; then
       iftest=1;
   fi
else
   echo "          Usage: sh simple_get.sh sellorid countryname"
   echo "                                           Available countryname candidate: uk  us de"
   exit 1
fi





#touch $sellor.lock

sellor=$1
mkdir -p $sellor
cd $sellor
#rm * -rf

start=1

MAX_JOBNUM=2

while [[ 1 ]]; do 

    i=$start
    wget $site --post-data="seller=$sellor&currentPage=$i&useMYI=0" -O $i.html 
    filedu=`du -b $i.html | awk '{print $1}'`
    if [ $filedu -lt 70 ]; then
      break;
    fi

    cat $i.html | grep -a -o -zP "(?<=\")\w+(?=\")" | awk -v head=$head '{print $0"\t"head""$0;}' | while read line; do
        processline $i $line
    done

    if [ $iftest -eq 1 ]; then
       break;
    fi
  start=$((start+1))
done

#http://www.amazon.co.uk/Illuminated-Jeweler-Magnifying-Glasses-Magnifier/dp/B00V34VKZQ/ref=aag_m_pw_dp?ie=UTF8&m=A3EFHR7YJIPFL0
#http://www.amazon.co.uk/dp/B009NBUJL2/ref=aag_m_pw_dp?ie=UTF8&m=A3EFHR7YJIPFL0
#http://www.amazon.co.uk/dp/B009NBUJL2?ie=UTF8&m=A3EFHR7YJIPFL0

dub=`du -b ../$sellor.log | awk '{print $1}'`
sleep 2
newdub=`du -b ../$sellor.log | awk '{print $1}'`
while [[ $newdub -ne $dub ]]; do
   dub=$newdub
   sleep 2
   newdub=`du -b ../$sellor.log | awk '{print $1}'`
done

cat *.result | awk -vFS="\t" 'length($3)>0{gsub(",",""); gsub("#",""); gsub(/\./,""); gsub("&nbsp;", " "); print $0}' | sort -nk3 > total.txt
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


if [ $iftest -eq 0 ]; then
 sz ../$sellor"total.txt"
fi

cd ..
#rm $sellor -rf

#rm $sellor.lock
