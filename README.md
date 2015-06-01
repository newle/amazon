1. amazon_script
    * analysis single amazon store using script shell
        * input: 
            * key: store key
            * country: support country includes: 
                * uk - United Kindom
                * us - American
                * ca - Canada 
                * de - Germany 
                * fr - France 
                * sp - Spain 
                * it - Italy 
        * output: analysis result
            * key + total.txt
        * for example:
        > http://www.amazon.com/s?marketplaceID=ATVPDKIKX0DER&me=A3GWKTDVH3V66K&merchant=A3GWKTDVH3V66K&redirect=true
        > sh simple_get.sh A3GWKTDVH3V66K us > A3GWKTDVH3V66K.log 2>&1 &
        > result : A3GWKTDVH3V66Ktotal.txt
    * usage: sh simple_get.sh [key] [country] > key.log 2>&1 &
2. status log:
    * 2015-6-1 10:31:37 uk & us finished 
    * de : http://www.amazon.de/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A1PA6795UKMFR9&orderID=&seller=A11EKHJ9JF38TG&sshmPath=
