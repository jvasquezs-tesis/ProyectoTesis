TRAZABILIDAD DE POSTULACIÓN.

___________________________________________________________________________________________________________________________________________________

REQUISITOS PREVIOS SOBRE SISTEMA OPERATIVO UBUNTU VERSIÓN 20.04.1 LTS

-Instalar Visual Studio Code Versión 1.50.1
  sudo snap install --classic code 

-Instalar curl
  sudo apt install curl

-Instalar docker
  sudo apt install docker 

 
-Instalar docker-compose
   sudo apt install docker-compose

-Configurar servicio docker
  sudo systemctl enable docker
  
-Configurar usuario docker
  sudo usermod -aG docker ${USER}

-Realizar la instalación de Golang de debe ir al sitio oficial https://golang.org/dl/ y descargar la versión para Linux.
-Descomprimir go tar.gz
  sudo tar -xvf go1.15.3.linux-amd64.tar.gz
-Mover GO a carpeta de sistema
  sudo mv go /usr/local
-Agregar configuraciones en profile
  sudo nano ~/.profile
 -Lineas a agregar en archivo
  export GOROOT=/usr/local/go
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

-Configurar archivos git
  git config --global core.autocrlf false
  git config --global core.longpaths true
  
-Crear carpeta
  mkdir ProyectoTesis

-Clonar muestras hyperledger en la carpeta ProyectoTesis
  curl -sSL https://bit.ly/2ysbOFE | bash -s


-Configurar variable de entorno.
  echo 'export PATH=$PATH:$HOME/ProyectoTesis/fabric-samples/bin'>> ~/.profile
  source ~/.profile


___________________________________________________________________________________________________________________________________________________

CONFIGURACIÓN Y EJECUCIÒN DE LA RED HYPERLEDGER FABRIC



MATERIAL CRIPTOGRAFICO.

-Crear archivo crypto-config.yaml dentro de carpeta minvu-network 
-Configurar archivo con cantidad de organizaciones, usuarios y nodos. Ejecutar comando que permitirá crear el material criptográfico a partir de las configuraciones realizadas en el archivo crypto-config.yaml

  cryptogen generate --config=./crypto-config.yaml
___________________________________________________________________________________________________________________________________________________

CONFIGURAR BLOQUE GENESIS
___________________________________________________________________________________________________________________________________________________

-Crear archivo configtx.yaml dentro de carpeta minvu-network 
-Crear carpeta channel-artifacts dentro de carpeta minvu-network 
    mkdir channel-artifacts

ThreeOrgsOrdererGenesis corresponde al perfil que se encuentra en el archivo CONFIGTX.YAML (crear bloque genesis)
  configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

-Crear canal 
  configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID postulacion

-Crear anchor pears por cada organización, un nodo par en un canal que todos los demás pares pueden descubrir y comunicarse. Cada miembro de un canal tiene un par de anclaje (o varios pares de anclaje para evitar un solo punto de falla), lo que permite que los pares que pertenecen a diferentes miembros descubran todos los pares existentes en un canal.

  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID postulacion -asOrg Org1MSP
  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID postulacion -asOrg Org2MSP
  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID postulacion -asOrg Org3MSP

___________________________________________________________________________________________________________________________________________________

INFRAESTRUCTURA EN CONTENEDORES DOCKER
___________________________________________________________________________________________________________________________________________________

-Instalación portainer, permitirá administrar contenedores desde una plataforma con un ambiente gráfico

  docker volume create portainer_data
  docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock://var/run/docker.sock -v portainer_data:/data portainer/portainer
  
  export CHANNEL_NAME=postulacion
  export VERBOSE=false
  export FABRIC_CFG_PATH=$PWD
  CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

-Una vez instalado portainer y configurado los contenedores docker se debe ir a:
  http://localhost:9000/#/auth

-Iniciar consola en contenedor cli, dentro de la consola ejecutar lo siguiente:
  export CHANNEL_NAME=postulacion
  peer channel create -o orderer.minvu.cl:7050 -c  $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

-Asociar organización a canal postulacion
  peer channel join -b postulacion.block

-Asociar a la segunda organización al canal postulación

  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer channel join -b postulacion.block

-Asociar a la tercera organización al canal postulación

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer channel join -b postulacion.block

ancho del peer 

peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOT_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peerO.org2.minvu.cl/tls/ca.crt peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOT_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peerO.org3.minvu.cl/tls/ca.crt peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem


-Una vez programado el chaincode validar que se encuentre dentro de la ruta definida en docker-compose-cli-couchdb.yaml, resultado esperado "minvucontrol"
  ls /opt/gopath/src/github.com/chaincode
  

-Crear variables bash que contengan lo siguiente:
  -Nombre del canal 
  -Nombre smart contract 
  -Versión smart contract 
  -Lenguje de ejecución del contrato inteligente
  -Ruta del smart contract
  -Servicio de Ordenamiento 

export CHANNEL_NAME=postulacion
export CHAINCODE_NAME=minvucontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem


-Ciclo de vida del chaincode.
  peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >&log.txt

-Instalar empaquetado generado del chaincode en organización 1 
  peer lifecycle chaincode install minvucontrol.tar.gz

Se generará un identificador, este debe coincidir en la instalación de las tres instalaciones, se debe copiar este identificador del paquete, ya que posteriormente se utilizara en otras configurciones:

  Chaincode code package identifier: minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Instalar empaquetado generado del chaincode en organización 2 

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer lifecycle chaincode install minvucontrol.tar.gz

-Instalar empaquetado generado del chaincode en organización 3

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer lifecycle chaincode install minvucontrol.tar.gz

-En esta red las organizaciones 1 ; 2 y 3 tienen permisos para escritura:
-Politica, permisos de escritura en la organización 1

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Verificar las políticas 

peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --output json

-Politica, permisos de escritura en la organización 2

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Politica, permisos de escritura en la organización 3

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Poner en marcha el chaincode 
-Se generán tres contenedores del chaincode minvucontrol con un nodo para cada organizacion 1; 2 y 3 

peer lifecycle chaincode commit -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.org1.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt --peerAddresses peer0.org2.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt --peerAddresses peer0.org3.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"


-Insertar mediante funciòn set del chaincode
-Ingresar a la consola de comandos en cli 


-Insertar desde organizacion 1.
peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","3","176941979","3180","55","1300","Ingresado","EGR"]}'

Verificar transaccion mediante función query del chaincode
  peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c ‘{“Args”:[“Query”,”3”]}’

-Insertar desde organizacion 2.
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","4","176941979","3180","55","1300","Ingresado","EGR"]}'


-Insertar desde organizacion 3.
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","5","176941979","3180","55","1300","Ingresado","serviu"]}'



----------------------------------------------------------------------------------------------------------
CONFIGURAR CA PARA LAS OTRAS ORGANIZACIONES
----------------------------------------------------------------------------------------------------------

USO DE BINARIOS DE FABRIC SIN DOCKER CLI

verificar que se tenga instalado de lo contrario instalar
gcc -version
Instalar gcc 
sudo apt install gcc

go get -u github.com/hyperledger/fabric/cmd/configtxgen
go get -u github.com/hyperledger/fabric/cmd/configtxlator
go get -u github.com/hyperledger/fabric/cmd/peer
go get -u github.com/hyperledger/fabric-ca/cmd/fabric-ca-client

export PATH=$PATH:$GOPATH/bin

-Crear archivo en la raiz de minvu-network, se desplegara el Root CA para todas las organizaciones por separado.
docker-compose-root-ca.yaml


-Crear archivo en la raiz de minvu-network, se desplegara el Root CA para todas las organizaciones por separado.
docker-compose-int-ca.yaml






