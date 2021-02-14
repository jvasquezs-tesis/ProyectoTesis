export FABRIC_CFG_PATH=$(cd ../ && pwd)
export CC_NAME=minvucontrol
export CC_VERSION=v1.0
export CC_SEQUENCE=1
export CHANNEL_NAME=postulacion
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
peer lifecycle chaincode package ../channel-artifacts/$CC_NAME$CC_VERSION.tar.gz --path ../../chaincode/minvucontrol --lang golang --label $CC_NAME$CC_VERSION
peer lifecycle chaincode install ../channel-artifacts/$CC_NAME$CC_VERSION.tar.gz --peerAddresses $CORE_PEER_ADDRESS --tls $CORE_PEER_TLS_ENABLED --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE

export CC_PACKAGE_ID=minvucontrolv1.0:7cabd931d0ae8c0b2729fd4fc8e2d8d51039e9e0dd66a12f93c13d4338a631a7
peer lifecycle chaincode approveformyorg -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQUENCE --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses $CORE_PEER_ADDRESS

export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
peer lifecycle chaincode install ../channel-artifacts/$CC_NAME$CC_VERSION.tar.gz --peerAddresses $CORE_PEER_ADDRESS --tls $CORE_PEER_TLS_ENABLED --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode approveformyorg -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQUENCE --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses $CORE_PEER_ADDRESS

export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/admin@org3.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/orderers/orderer.org3.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:9050
peer lifecycle chaincode install ../channel-artifacts/$CC_NAME$CC_VERSION.tar.gz --peerAddresses $CORE_PEER_ADDRESS --tls $CORE_PEER_TLS_ENABLED --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode approveformyorg -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQUENCE --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses $CORE_PEER_ADDRESS
peer lifecycle chaincode commit -o $ORDERER_ADDRESS --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE --tls --cafile $ORDERER_CA --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt) --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

## HABILITAR TRANSACCIONES DESDE ORG1 A ORG2
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
export CORE_PEER_LOCALMSPID=Org2MSP
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:SetTrustline", "Org1MSP", "true"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:SetTrustline", "Org1MSP", "true"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
## HABILITAR TRANSACCIONES DESDE ORG2 A ORG3
export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/client@org3.minvu.cl/msp)
export CORE_PEER_LOCALMSPID=Org3MSP
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:SetTrustline", "Org2MSP", "true"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


## INSERTAR POSTULACION ORG 1
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/client@org1.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Insert", "176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

## ORG 2 NO SE PERMITE INSERT DEBIDO A LOS PERMISOS NO OTORGADOS
export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Insert","176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:Insert","176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)

## ORG 3 NO SE PERMITE INSERT DEBIDO A LOS PERMISOS NO OTORGADOS
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/admin@org3.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/orderers/orderer.org3.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:9050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/client@org3.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Insert","176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:Insert","176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)


## TRANSFERIR DE ORG1 A ORG2
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/client@org1.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "097e3a334462857e12fe62b081a089a7b910cd0e7c0ea297bc2504a3eba310c5:0", "Org2MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)




## TRANSFERIR DE ORG2 A ORG3
export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "1705692aa333ce668a2b3106e9abfa8ea78419587c1aa8204f634cfb6421cb6f:1", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)

## RECHAZAR O APROBAR POSTULACION

export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/admin@org3.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/orderers/orderer.org3.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:9050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/client@org3.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Selection", "2992c9c33e751dfaa870eac99dde3f680f86cb8976959fdde54a26bae4736c7c:1", "Seleccionado"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)



# QUERY COUCHDB  OBTENER TODO LO QUE EXISTE DE LA TIPOLOGIA CCH Y CSR 
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:QueryCouchDB", "{\"selector\":{\"docType\":\"CCH\"}}"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

# GET HISTORY OF POSTULACION

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:GetHistoryOfPOS", "a99deceb580190b201b6e0e3bc0edb183478f0d498dbf1d4767e9c69cd8561d7:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:GetHistoryOfPOS", "a99deceb580190b201b6e0e3bc0edb183478f0d498dbf1d4767e9c69cd8561d7:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:GetHistoryOfPOS", "a99deceb580190b201b6e0e3bc0edb183478f0d498dbf1d4767e9c69cd8561d7:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)
