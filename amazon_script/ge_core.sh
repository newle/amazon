#http://www.amazon.co.uk/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A1F83G8C2ARO7P&orderID=&seller=A27JMYAV17VOL1&sshmPath=
#A27JMYAV17VOL1
#http://www.amazon.co.uk/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A1F83G8C2ARO7P&orderID=&seller=A27JMYAV17VOL1&sshmPath=
#A27JMYAV17VOL1

site="http://www.amazon.co.uk/gp/aag/ajax/searchResultsJson.html"
head="http://www.amazon.co.uk/dp/"

function processline()
{
    i=$1
    basename=$2
    url=$3
      jobsnum=`jobs -p | wc -l`
      while [[ $jobsnum -gt $MAX_JOBNUM ]]; do
      echo sleep 1
          sleep 1
          jobsnum=`jobs -p | wc -l`
      done

    {
      filename=`mktemp $i.XXXXX`
      wget $url --header="User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" -O $filename
      rank=`grep -a -o -zP "((Best Sellers Rank)|(Amazon Bestsellers Rank))[^\(]+\d+[^\(]+(?=\()" $filename | tail -n 1 | grep -a -o -zP "\d+.*"`
      brand=`grep -a -o -zP "(?<=id=\"brand\")[^<]+</" $filename | grep -a -o -zP "(?<=>)[^<]+(?=</)"`
      name=`grep -a -o -zP "(?<=productTitle\")[^<]+</" $filename | grep -a -o -zP "(?<=>)[^<]+(?=</)"`
      review=`grep -a -o -zP "(?<=acrCustomerReviewText\")[^<]+</" $filename | grep -a -o -zP "(?<=>)[^<]+(?=</)"`
      price=`grep -a -o -zP "(?<=priceblock_ourprice\")[^<]+</" $filename | grep -a -o -zP "(?<=>)[^<]+(?=</)"`
      new_sellor=`grep -a -o -zP "(?<=condition=new\")([\s\S]+?)</span" $filename | grep -a -o -zP "(?<=>)[\s\S]+(?=</span)" | awk -vFS="&nbsp;|>|<" '{print $1" "$2" "$8}'`
      old_sellor=`grep -a -o -zP "(?<=condition=used\")([\s\S]+?)</span" $filename | grep -a -o -zP "(?<=>)[\s\S]+(?=</span)" | awk -vFS="&nbsp;|>|<" '{print $1" "$2" "$8}'`
      describe=`grep -a -o -zP "(?<=feature-bullets\")([\s\S]+?)</div" $filename | grep -a -o -zP "(?<=>)[\s\S]+(?=</div)" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba;s/[\t\r\n]\+/ /g' | awk '{if(length($0) > 2){print $0}}'`
      picurl=`grep -a -o -zP "(?<=\"main\":{\")[^\"]+(?=\")" $filename | head -n 1`
     echo	$basename"	"$url"	"$rank"	"$picurl"	"$brand"	"$name"	"$review"	"$price"	"$new_sellor"	"$old_sellor"	"$describe	>>	$i.result
      rm $filename
    } &
}
