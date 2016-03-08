#!/bin/bash

FACEBOOK_IP_FILE="facebook-ip-addresses.txt"
GOOGLE_IP_FILE="google-ip-addresses.txt"

function validate_ip() {
    local ip=$1
    local stat=1

    # TODO: Check if sipcalc is installed
    res=$(sipcalc $ip | grep "ERR :")

    if [ "$res" == "" ]; then
        stat=0
    else
        stat=1
        echo "Bad IP: $ip"
    fi

    return $stat
}

# facebook
FACEBOOK_AS=(AS32934 AS54115 AS34825)

echo > $FACEBOOK_IP_FILE

for i in "${FACEBOOK_AS[@]}"
do
    IP_RANGES=($(whois -h whois.radb.net !g$i | grep /))
    IP_RANGES+=($(whois -h whois.radb.net !6$i | grep /))

    for IP_RANGE in "${IP_RANGES[@]}"
    do
        if validate_ip $IP_RANGE; then
            #echo "sudo ip route add blackhole $IP_RANGE" >> $FACEBOOK_IP_FILE
            echo "$IP_RANGE" >> $FACEBOOK_IP_FILE
        #else
        #    echo "BAD"
        fi
    done
done

# google
GOOGLE_AS=(AS11344
AS13949
AS1406
AS1424
AS15169
AS16591
AS19425
AS19448
AS22244
AS22577
AS22859
AS26910
AS36039
AS36040
AS36384
AS36385
AS36492
AS36561
AS36987
AS394507
AS394639
AS394699
AS40873
AS41264
AS43515
AS45566
AS55023
AS6432)

GOOGLE_AS+=($(whois -h whois.radb.net '!iAS-GOOGLE,1' | grep AS))

#printf '%s\n' ${GOOGLE_AS[@]}
GOOGLE_AS_UNIQUE=($(echo "${GOOGLE_AS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#printf '%s\n' ${GOOGLE_AS_UNIQUE[@]}

echo > $GOOGLE_IP_FILE

for i in "${GOOGLE_AS[@]}"
do
    IP_RANGES=($(whois -h whois.radb.net !g$i | grep /))
    IP_RANGES+=($(whois -h whois.radb.net !6$i | grep /))

    # Google caching servers
    IP_RANGES+=(103.25.178.0/24
    1.179.253.0/24
    1.179.252.0/24
    1.179.251.0/24
    1.179.250.0/24
    1.179.249.0/24
    1.179.248.0/24
    111.92.162.0/24
    118.174.25.0/24
    118.174.27.0/24
    164.40.244.0/24)

    for IP_RANGE in "${IP_RANGES[@]}"
    do
        if validate_ip $IP_RANGE; then
            #echo "sudo ip route add blackhole $IP_RANGE" >> $GOOGLE_IP_FILE
            echo "$IP_RANGE" >> $GOOGLE_IP_FILE
        #else
        #    echo "BAD"
        fi
    done
done

cat $FACEBOOK_IP_FILE | sort -u -o $FACEBOOK_IP_FILE
cat $GOOGLE_IP_FILE | sort -u -o $GOOGLE_IP_FILE

