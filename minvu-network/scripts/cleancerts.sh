function cleanCA(){
    org=$1
    ca=$2

    CA_PATH=../fabric-ca/$org/$ca
    sudo rm -r $CA_PATH/clients
    sudo rm -r $CA_PATH/msp
    sudo rm $CA_PATH/ca-cert.pem
    sudo rm $CA_PATH/fabric-ca-server.db
    sudo rm $CA_PATH/IssuerPublicKey
    sudo rm $CA_PATH/IssuerRevocationPublicKey
    CA_CHAIN_FILE=$CA_PATH/ca-chain.pem
    if test -f "$CA_CHAIN_FILE"; then
        sudo rm $CA_CHAIN_FILE
    fi
}

function cleanOrgMSP() {
    org=$1

    MSP_PATH=../fabric-ca/$org/msp
    sudo rm -r $MSP_PATH/cacerts
    sudo rm -r $MSP_PATH/intermediatecerts
    sudo rm -r $MSP_PATH/tlscacerts
    sudo rm -r $MSP_PATH/tlsintermediatecerts
}

function cleanLocalMSP() {
    org=$1
    name=$2
    type=$3

    LOCAL_MSP_PATH=../fabric-ca/$org/${type}s/$name/msp
    TLS_FOLDER_PATH=../fabric-ca/$org/${type}s/$name/tls

    sudo rm -r $LOCAL_MSP_PATH
    sudo rm -r $TLS_FOLDER_PATH
}

#cleanCA minvu.cl root
#cleanCA minvu.cl int
#cleanCA minvu.cl tls-root
#cleanCA minvu.cl tls-int
cleanCA org1.minvu.cl root
cleanCA org1.minvu.cl int
cleanCA org1.minvu.cl tls-root
cleanCA org1.minvu.cl tls-int
cleanCA org2.minvu.cl root
cleanCA org2.minvu.cl int
cleanCA org2.minvu.cl tls-root
cleanCA org2.minvu.cl tls-int
cleanCA org3.minvu.cl root
cleanCA org3.minvu.cl int
cleanCA org3.minvu.cl tls-root
cleanCA org3.minvu.cl tls-int

cleanOrgMSP org1.minvu.cl
cleanOrgMSP org2.minvu.cl
cleanOrgMSP org3.minvu.cl
#cleanOrgMSP minvu.cl

cleanLocalMSP org1.minvu.cl orderer.org1.minvu.cl orderer
cleanLocalMSP org2.minvu.cl orderer.org2.minvu.cl orderer
cleanLocalMSP org3.minvu.cl orderer.org3.minvu.cl orderer

cleanLocalMSP org1.minvu.cl peer0.org1.minvu.cl peer
cleanLocalMSP org2.minvu.cl peer0.org2.minvu.cl peer
cleanLocalMSP org3.minvu.cl peer0.org3.minvu.cl peer
#cleanLocalMSP minvu.cl orderer.minvu.cl orderer

cleanLocalMSP org1.minvu.cl admin@org1.minvu.cl user
cleanLocalMSP org2.minvu.cl admin@org2.minvu.cl user
cleanLocalMSP org3.minvu.cl admin@org3.minvu.cl user
#cleanLocalMSP minvu.cl admin@minvu.cl user

cleanLocalMSP org1.minvu.cl client@org1.minvu.cl user
cleanLocalMSP org2.minvu.cl client@org2.minvu.cl user
cleanLocalMSP org3.minvu.cl client@org3.minvu.cl user
