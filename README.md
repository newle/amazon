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
                * jp - Japan
        * output: analysis result
            * key + total.txt
        * for example: [link](http://www.amazon.com/s?marketplaceID=ATVPDKIKX0DER&me=A3GWKTDVH3V66K&merchant=A3GWKTDVH3V66K&redirect=true)
        
           ```shell
             sh simple_get.sh A3GWKTDVH3V66K us > A3GWKTDVH3V66K.log 2>&1 &
             result : A3GWKTDVH3V66Ktotal.txt
           ```
    * usage: sh simple_get.sh [key] [country] > key.log 2>&1 &
2. status log:
    * 2015-6-1 10:31:37 uk & us finished 
    * 2015-6-1 14:28:55 finish ca, de, fr, sp, it, jp 
    * uk : http://www.amazon.co.uk/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=1&isCBA=&marketplaceID=A1F83G8C2ARO7P&orderID=&seller=A3EFHR7YJIPFL0&sshmPath=
    * us : http://www.amazon.co.uk/Breville-Blend-Active-Personal-Blender-White/dp/B00DGLUW4E/ref=zg_bs_kitchen_1 
    * ca : http://www.amazon.it/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=APJ6JRA9NG5V4&orderID=&seller=AUNGYH863E97M&sshmPath=
    * de : http://www.amazon.de/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A1PA6795UKMFR9&orderID=&seller=A11EKHJ9JF38TG&sshmPath=
    * fr : http://www.amazon.fr/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A13V1IB3VIYZZH&orderID=&seller=AUNGYH863E97M&sshmPath=
    * sp : http://www.amazon.es/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=A1RKKUPIHCS9HS&orderID=&seller=AUNGYH863E97M&sshmPath=
    * it : http://www.amazon.it/gp/aag/main?ie=UTF8&asin=&isAmazonFulfilled=&isCBA=&marketplaceID=APJ6JRA9NG5V4&orderID=&seller=AUNGYH863E97M&sshmPath=
    * jp : http://www.amazon.co.jp/gp/aag/main/ref=olp_merch_name_1?ie=UTF8&asin=B00DANSDD0&isAmazonFulfilled=0&seller=A3VNZZ5M6SIYCP
