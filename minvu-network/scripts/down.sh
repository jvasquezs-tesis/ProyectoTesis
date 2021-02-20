cd .. && docker-compose -f docker-compose-root-ca.yaml -f docker-compose-int-ca.yaml -f docker-compose-cli-couchdb.yaml down
docker rm $(docker ps -aq --filter 'name=cli')
docker rm $(docker ps -aq --filter 'name=peer')
docker rm $(docker ps -aq --filter 'name=couch')
docker rm $(docker ps -aq --filter 'name=orderer')
docker rm $(docker ps -aq --filter 'name=ca')
docker rm $(docker ps -aq --filter 'name=minvucontrol')
docker rmi $(docker images -q --filter 'reference=*minvucontrol*')
docker rmi $(docker images -a -q )
cd scripts && ./cleancerts.sh
rm -r ../channel-artifacts/*
rm -r ../fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/production
rm -r ../fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/production
rm -r ../fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/production
rm -r ../fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/production
rm -r ../fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/production
rm -r ../fabric-ca/org3.minvu.cl/orderers/orderer.org3.minvu.cl/production