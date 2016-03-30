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
        echo "                                           Available countryname candidate: uk us de ca fr es it jp"
        exit 1
    fi

   if [ $3"x" = "test"x ]; then
       iftest=1;
   fi
else
   echo "          Usage: sh simple_get.sh sellorid countryname"
   echo "                                           Available countryname candidate: uk us de ca fr es it jp"
   exit 1
fi





#touch $sellor.lock

sellor=$1
sellor_path=$1$2
mkdir -p $sellor_path

backtime=`date +"%Y%m%d%H%M"`
mv $sellor_path"total.html" backup/$backtime$sellor_path"total.html"
mv $sellor_path"total.txt" backup/$backtime$sellor_path"total.txt"
mv $sellor_path"total.csv" backup/$backtime$sellor_path"total.csv"

cd $sellor_path
rm * -rf
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

dub=`du -b ../$sellor_path.log | awk '{print $1}'`
sleep 10
newdub=`du -b ../$sellor_path.log | awk '{print $1}'`
while [[ $newdub -ne $dub ]]; do
   dub=$newdub
   sleep 10
   newdub=`du -b ../$sellor_path.log | awk '{print $1}'`
done

cat *.result | awk -vFS="\t" 'length($3)>0{gsub(",",""); gsub("#",""); gsub("&nbsp;", " "); print $0}' | sort -nk3 > total.txt
cat *.result | awk -vFS="\t" 'length($3)==0' > norank.txt
cat norank.txt >> total.txt

#echo "base     url     ����    ͼƬ    �̱�    ��Ʒ��  review  �۸�    ����Ʒ  ����Ʒ  ����" > ../$sellor_path"total.txt"
#cat total.txt >> ../$sellor_path"total.txt"
#
echo	"base	����	���	ͼƬ	�̱�	��Ʒ��	review	�۸�	����Ʒ	����Ʒ	����"	>	../$sellor_path"total.txt"
awk -vFS="\t" '{
    idx=index($3," ");
    score=substr($3,0,idx);
    type=substr($3,idx+3);
    print $1"\t"score"\t"type"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11;}' total.txt >> ../$sellor_path"total.txt"

echo "base,����,���,ͼƬ,�̱�,��Ʒ��,review,�۸�,����Ʒ,����Ʒ,����"	>	../$sellor_path"total.csv"
awk -vFS="\t" '{
    idx=index($3," ");
    score=substr($3,0,idx);
    type=substr($3,idx+3);
    print $1","score","type","$4","$5","$6","$7","$8","$9","$10","$11;}' total.txt >> ../$sellor_path"total.csv"



echo "<table><tr><td>url</td><td>����</td><td>  ͼƬ</td><td>   �̱�</td><td>   ��Ʒ��</td><td> review</td><td> �۸�</td><td>   ����Ʒ</td><td> ����Ʒ</td><td>      ����</td></tr>" > ../$sellor_path"total.html"
awk -vFS="\t" '{print "<tr><td><a href=\""$2"\">"$1"</a></td><td>"$3"</td><td><img src="$4" width=200 /></td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td><td>"$9"</td><td>"$10"</td><td></tr>";}' total.txt >> ../$sellor_path"total.html"
echo "</table>" >> ../$sellor_path"total.html"

cd ..

if [ $iftest -eq 0 ]; then
    subject=`date +"%Y-%m-%d %H:%M:%S"`"  "$sellor_path
    python sendmail.py -f 'newle.hit@gmail.com' -t '34719570@qq.com;649890795@qq.com;david@omgaidirect.com' -s "$subject" -a $sellor_path"total.csv" -c $sellor_path"total.html"
fi

#rm $sellor_path -rf

#rm $sellor_path.lock
