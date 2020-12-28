function createChannelMSP() {
    org=$1

    MSP_PATH=../fabric-ca/$org/msp
    mkdir -p $MSP_PATH
    mkdir $MSP_PATH/cacerts && cp ../fabric-ca/$org/root/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
    mkdir $MSP_PATH/intermediatecerts && cp ../fabric-ca/$org/int/ca-cert.pem $MSP_PATH/intermediatecerts/ca-cert.pem
    mkdir $MSP_PATH/tlscacerts && cp ../fabric-ca/$org/tls-root/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
    mkdir $MSP_PATH/tlsintermediatecerts && cp ../fabric-ca/$org/tls-int/ca-cert.pem $MSP_PATH/tlsintermediatecerts/ca-cert.pem
}

function createLocalMSP() {
    org=$1
    name=$2
    type=$3

    LOCAL_MSP_PATH=../fabric-ca/$org/${type}s/$name/msp

    mkdir -p $LOCAL_MSP_PATH
    cp ../fabric-ca/$org/msp/config.yaml $LOCAL_MSP_PATH
    mkdir $LOCAL_MSP_PATH/cacerts && cp ../fabric-ca/$org/root/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
    mkdir $LOCAL_MSP_PATH/intermediatecerts && cp ../fabric-ca/$org/int/ca-cert.pem $LOCAL_MSP_PATH/intermediatecerts/ca-cert.pem
    mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../fabric-ca/$org/tls-root/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
    mkdir $LOCAL_MSP_PATH/tlsintermediatecerts && cp ../fabric-ca/$org/tls-int/ca-cert.pem $LOCAL_MSP_PATH/tlsintermediatecerts/ca-cert.pem
    mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../fabric-ca/$org/int/clients/$name/msp/signcerts $LOCAL_MSP_PATH/
    key=$(find ../fabric-ca/$org/int/clients/$name/msp/keystore -name *_sk)
    mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key
}

function createTLSFolder(){
    org=$1
    name=$2
    type=$3

    TLS_FOLDER_PATH=../fabric-ca/$org/${type}s/$name/tls

    mkdir -p $TLS_FOLDER_PATH
    cp ../fabric-ca/$org/tls-int/ca-chain.pem $TLS_FOLDER_PATH/ca.crt
    cp ../fabric-ca/$org/tls-int/clients/$name/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
    key=$(find ../fabric-ca/$org/tls-int/clients/$name/msp/keystore -name *_sk)
    cp $key $TLS_FOLDER_PATH/server.key
}

createChannelMSP org1.minvu.cl
createChannelMSP org2.minvu.cl
createChannelMSP org3.minvu.cl
#createChannelMSP minvu.cl

createLocalMSP org1.minvu.cl peer0.org1.minvu.cl peer
createTLSFolder org1.minvu.cl peer0.org1.minvu.cl peer

createLocalMSP org2.minvu.cl peer0.org2.minvu.cl peer
createTLSFolder org2.minvu.cl peer0.org2.minvu.cl peer

createLocalMSP org3.minvu.cl peer0.org3.minvu.cl peer
createTLSFolder org3.minvu.cl peer0.org3.minvu.cl peer

createLocalMSP org1.minvu.cl orderer.org1.minvu.cl orderer
createTLSFolder org1.minvu.cl orderer.org1.minvu.cl orderer

createLocalMSP org2.minvu.cl orderer.org2.minvu.cl orderer
createTLSFolder org2.minvu.cl orderer.org2.minvu.cl orderer

createLocalMSP org3.minvu.cl orderer.org3.minvu.cl orderer
createTLSFolder org3.minvu.cl orderer.org3.minvu.cl orderer
#createLocalMSP minvu.cl orderer.minvu.cl orderer
#createTLSFolder minvu.cl orderer.minvu.cl orderer

createLocalMSP org1.minvu.cl admin@org1.minvu.cl user
createTLSFolder org1.minvu.cl admin@org1.minvu.cl user

createLocalMSP org2.minvu.cl admin@org2.minvu.cl user
createTLSFolder org2.minvu.cl admin@org2.minvu.cl user

createLocalMSP org3.minvu.cl admin@org3.minvu.cl user
createTLSFolder org3.minvu.cl admin@org3.minvu.cl user

#createLocalMSP minvu.cl admin@minvu.cl user
#createTLSFolder minvu.cl admin@minvu.cl user

createLocalMSP org1.minvu.cl client@org1.minvu.cl user
createTLSFolder org1.minvu.cl client@org1.minvu.cl user

createLocalMSP org2.minvu.cl client@org2.minvu.cl user
createTLSFolder org2.minvu.cl client@org2.minvu.cl user

createLocalMSP org3.minvu.cl client@org3.minvu.cl user
createTLSFolder org3.minvu.cl client@org3.minvu.cl user
