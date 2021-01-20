export FABRIC_CFG_PATH=$(cd ../ && pwd)
export CC_NAME=minvucontrol
export CC_VERSION=v1.0
export CC_SEQUENCE=3
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

export CC_PACKAGE_ID=minvucontrolv1.0:e6d0174a0a83c41883c14c4a489f56dcf0c406aabc182e74a2f95edd4a6621ae
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

#export CORE_PEER_LOCALMSPID=Org3MSP
#export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/users/admin@org3.minvu.cl/msp)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Mint", "99000", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Transfer", "[\"bd27507427999fe57e4c44555de9b3cf1022e57caedee6a57a77ce17ac8f75f1:0\"]", "10000", "Org1MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
#export CORE_PEER_LOCALMSPID=Org2MSP
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:SetTrustline", "Org3MSP", "true", "-1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:RequestRedemption", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:Transfer", "[\"fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:1\"]", "9000", "Org2MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:ConfirmRedemption", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:QueryCouchDB", "{\"selector\":{\"docType\":\"COP\"}}"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["COPCurrencyContract:GetHistoryOfUTXO", "fbaa859c200bcc6334902eb3ef78f14be70c63b55a0b1038d47acc0bddcdc5c9:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

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
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:SetTrustline", "Org2MSP", "true"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


## INSERTAR POSTULACION

export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/client@org1.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Insert", "176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
#peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:Insert", "176941979","99","1800"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

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
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "de9d3a70dd2525a31e85d9e86679f6cf822f0f2b3c97981fe9ab672f6f1fae8d:0", "Org2MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "de9d3a70dd2525a31e85d9e86679f6cf822f0f2b3c97981fe9ab672f6f1fae8d:0", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/admin@org2.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/orderers/orderer.org2.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:8050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org2.minvu.cl/users/client@org2.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "de9d3a70dd2525a31e85d9e86679f6cf822f0f2b3c97981fe9ab672f6f1fae8d:0", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


## TRANSFERIR DE ORG1 A ORG3 ERROR 
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/admin@org1.minvu.cl/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/orderers/orderer.org1.minvu.cl/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/org1.minvu.cl/users/client@org1.minvu.cl/msp)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:Transfer", "[\"39533ec5dc201805723c8ed05a5d886c686a6889c41c213d3f359e77edec4752:1\"]", "Org3MSP"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../ && echo $PWD/fabric-ca/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt)


## 

# REDEEM
export ACCOUNTNUMBER=$(echo -n "\"123-45678-90TszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
export BANK=$(echo -n "\"BancolombiaTszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
export SALT=$(echo -n "\"TszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["USDCurrencyContract:Redeem", "63fd3dd5ba2a9f0fd5d70d895cb9f89420db2e923460488325eab911c71e9c69:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt) --transient "{\"accountNumber\":\"$ACCOUNTNUMBER\",\"bank\":\"$BANK\",\"salt\":\"$SALT\"}"

# QUERY COUCHDB  OBTENER TODO LO QUE EXISTE DE LA TIPOLOGIA CCH Y CSR 
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CSRTipologiaContract:QueryCouchDB", "{\"selector\":{\"docType\":\"CSR\"}}"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:QueryCouchDB", "{\"selector\":{\"docType\":\"CCH\"}}"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

# GET HISTORY OF UTXO
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:GetHistoryOfUTXO", "1cf14af0e49da60a15b71e26873a24c86b7d26a52a333c20810d201c784db3c4:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["CCHTipologiaContract:GetHistoryOfUTXO", "e6584a0209a2a088c73a83c7a701a2406bba6df991a18b9d8d937d11c4ee71df:1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles $(cd ../../minvu-network && echo $PWD/fabric-ca/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt)