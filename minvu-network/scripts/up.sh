cd .. && docker-compose -f docker-compose-root-ca.yaml up -d
sleep 20
cd scripts && ./rootca.sh
cd .. && docker-compose -f docker-compose-int-ca.yaml up -d
sleep 20
cd scripts && ./intca.sh
./identities.sh
./msp.sh
./artifacts.sh
cd .. && docker-compose -f docker-compose-cli-couchdb.yaml up -d
sleep 20
cd scripts && ./channels.sh
