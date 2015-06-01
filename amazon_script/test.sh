
if [ $# -eq 2 ]; then
    core=$1
    url=$2
    . $core

    i=1;
    basename="test";

    rm $i.result

    processline $i $basename  $url;

    while [ ! -s $i.result ] ; do 
        sleep 1;
    done

    awk -vFS="\t" 'NR==FNR{a[NR]=$0}NR!=FNR{for(i=1;i<=NF;i++){print a[i]":\n\t"$i;}}' character.list $i.result
else
    echo "Usage: sh test.sh ./sp_core.sh 'http://www.amazon.es/VidaXL-Foco-led-4500-5000-l%C3%BAmenes/dp/B008EK7DJ4/'"
fi
