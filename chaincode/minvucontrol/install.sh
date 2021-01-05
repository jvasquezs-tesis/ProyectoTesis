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

export CC_PACKAGE_ID=minvucontrolv1.0:a515a730b609e279a183c55b63c2a753a5eeba7e7abd8a252cf9b5534620199d
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

export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/admin@org3.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Mint", "99000", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Transfer", "[\"bd27507427999fe57e4c44555de9b3cf1022e57caedee6a57a77ce17ac8f75f1:0\"]", "10000", "Org1MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
export CORE_PEER_LOCALMSPID=Org2MSP
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:SetTrustline", "Org3MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:RequestRedemption", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Transfer", "[\"fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:1\"]", "9000", "Org2MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:ConfirmRedemption", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:QueryCouchDB", "{\"selector\":{\"docType\":\"COP\"}}"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:GetHistoryOfUTXO", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)



## MINVU-NETWORK/SCRIPTS


## HABILITAR TRANSACCIONES DESDE ORG1 A ORG2
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
export CORE_PEER_LOCALMSPID=Org2MSP
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:SetTrustline", "Org1MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:SetTrustline", "Org1MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
## HABILITAR TRANSACCIONES DESDE ORG2 A ORG3
export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/client@org3.minvu.cl/msp)
export CORE_PEER_LOCALMSPID=Org3MSP
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:SetTrustline", "Org2MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:SetTrustline", "Org2MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


## INSERTAR PRIMER BLOQUE CON POSTULACION VALIDO PARA EGR

export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
## insertar
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/client@org1.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Mint", "so", "176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:Mint", "sy", "176941979","100","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)

## transferir

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "[\"8e6128c84c95b2a499773082f815ac5db7bb63fcdfd78ae2029aaf199b525f4d:0\"]", "10000", "Org1MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)






