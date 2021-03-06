****************************************************************************************
****************************************************************************************

Agradecimiento al curso [Hyperledger Latinoamérica](https://wiki.hyperledger.org/display/CP/Hyperledger+Latinoamerica "Hyperledger Latinoamérica") y [Business Blockchain](https://www.blockchainempresarial.com/ "Business Blockchain").

****************************************************************************************
****************************************************************************************

1. REQUISITOS PREVIOS 

-Instalar Visual Studio Code Versión 1.52.1
```shell
  sudo snap install --classic code 
```

-Instalar curl Versión 7.68.0
```shell
  sudo apt install curl
```

-Instalar docker Versión 19.03.8
```shell
  sudo apt install docker 
```

-Instalar node Versión 12.14.1
```shell
  sudo apt install nodejs
```

-Instalar nodee-gyp v6.1.0
```shell
  sudo apt install node-gyp
```

-Instalar docker-compose 1.25.0
```shell
   sudo apt install docker-compose
```

-Configurar servicio docker
```shell
  sudo systemctl enable docker
```

-Configurar usuario docker
```shell
  sudo usermod -aG docker ${USER}
```

-Realizar la instalación de Golang de debe ir al sitio oficial https://golang.org/dl/ y descargar la versión para Linux. -Descomprimir go tar.gz
```shell
  sudo tar -xvf go1.15.3.linux-amd64.tar.gz
```

-Mover GO a carpeta de sistema
```shell
  sudo mv go /usr/local
```

-Agregar configuraciones en profile
```shell
  sudo nano ~/.profile
```

-Lineas a agregar en archivo
```shell
  sudo systemctl enable docker
```

-Configurar usuario docker
```shell
  sudo usermod -aG docker ${USER}
```

-Realizar la instalación de Golang de debe ir al sitio oficial https://golang.org/dl/ y descargar la versión para Linux.
-Descomprimir go tar.gz
```shell
  sudo tar -xvf go1.15.6.linux-amd64.tar.gz
```
-Mover GO a carpeta de sistema
```shell
  sudo mv go /usr/local
```

-Agregar configuraciones en profile
```shell
  sudo nano ~/.profile
```

 -Lineas a agregar en archivo
```shell
  export GOROOT=/usr/local/go
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

-Configurar archivos git
```shell
  git config --global core.autocrlf false
  git config --global core.longpaths true
```
-Crear carpeta
```shell
  git config --global core.autocrlf false
  git config --global core.longpaths true
```  

-Crear carpeta
```shell
  mkdir ProyectoTesis
```

-Clonar muestras hyperledger en la carpeta ProyectoTesis
```shell
  curl -sSL https://bit.ly/2ysbOFE | bash -s
```

-Configurar variable de entorno.
```shell
  echo 'export PATH=$PATH:$HOME/ProyectoTesis/fabric-samples/bin'>> ~/.profile
  source ~/.profile
```

-Visualizar Certificado CA
```shell
openssl x509 -in ca-cert.pem -text -noout
```


****************************************************************************************
****************************************************************************************

IMPLEMENTACIÓN DE LA RED AUTOMATIZADA

Solo ejecute archivo up.sh 

```shell
./up.sh
```

Para eliminar material criptografico 

```shell
./down.sh
```

****************************************************************************************
****************************************************************************************



****************************************************************************************
****************************************************************************************

INSTALACIÓN MANUAL DE LA RED HYPERLEDGER FABRIC
 
****************************************************************************************
****************************************************************************************

****************************************************************************************
****************************************************************************************

CONFIGURACIÓN Y EJECUCIÓN DE LA RED HYPERLEDGER FABRIC CON FUNCIONALIDAD CRYPTOGEN
 
****************************************************************************************
****************************************************************************************

MATERIAL CRIPTOGRAFICO.

-Crear archivo crypto-config.yaml dentro de carpeta minvu-network -Configurar archivo con cantidad de organizaciones, usuarios y nodos. Ejecutar comando que permitirá crear el material criptográfico a partir de las configuraciones realizadas en el archivo crypto-config.yaml

  cryptogen generate --config=./crypto-config.yaml
-Crear archivo crypto-config.yaml dentro de carpeta minvu-network 
-Configurar archivo con cantidad de organizaciones, usuarios y nodos. Ejecutar comando que permitirá crear el material criptográfico a partir de las configuraciones realizadas en el archivo crypto-config.yaml
```shell
  cryptogen generate --config=./crypto-config.yaml
```
___________________________________________________________________________________________________________________________________________________

CONFIGURAR BLOQUE GENESIS

-Crear archivo configtx.yaml dentro de carpeta minvu-network -Crear carpeta channel-artifacts dentro de carpeta minvu-network

-Crear archivo configtx.yaml dentro de carpeta minvu-network 
-Crear carpeta channel-artifacts dentro de carpeta minvu-network 
```shell
    mkdir channel-artifacts
```
ThreeOrgsOrdererGenesis corresponde al perfil que se encuentra en el archivo CONFIGTX.YAML (crear bloque genesis)

  configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

-Crear canal

```shell
  configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
```
-Crear canal 
```shell
  configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID postulacion
```
-Crear anchor pears por cada organización, un nodo par en un canal que todos los demás pares pueden descubrir y comunicarse. Cada miembro de un canal tiene un par de anclaje (o varios pares de anclaje para evitar un solo punto de falla), lo que permite que los pares que pertenecen a diferentes miembros descubran todos los pares existentes en un canal.
```shell
  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID postulacion -asOrg Org1MSP
  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID postulacion -asOrg Org2MSP
  configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID postulacion -asOrg Org3MSP
```
___________________________________________________________________________________________________________________________________________________

INFRAESTRUCTURA EN CONTENEDORES DOCKER

-Instalación portainer, permitirá administrar contenedores desde una plataforma con un ambiente gráfico
```shell
  docker volume create portainer_data
  docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock://var/run/docker.sock -v portainer_data:/data portainer/portainer

  export CHANNEL_NAME=postulacion
  export VERBOSE=false
  export FABRIC_CFG_PATH=$PWD
  CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

-Una vez instalado portainer y configurado los contenedores docker se debe ir a: http://localhost:9000/#/auth

-Iniciar consola en contenedor cli, dentro de la consola ejecutar lo siguiente:

```
-Una vez instalado portainer y configurado los contenedores docker se debe ir a:
  http://localhost:9000/#/auth

-Iniciar consola en contenedor cli, dentro de la consola ejecutar lo siguiente:
```shell
  export CHANNEL_NAME=postulacion
  peer channel create -o orderer.minvu.cl:7050 -c  $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem
```
-Asociar organización a canal postulacion

```shell
  peer channel join -b postulacion.block
```
-Asociar a la segunda organización al canal postulación
```shell
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer channel join -b postulacion.block
```
-Asociar a la tercera organización al canal postulación
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer channel join -b postulacion.block

ancho del peer

```
ancho del peer 
```shell
peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOT_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peerO.org2.minvu.cl/tls/ca.crt peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOT_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peerO.org3.minvu.cl/tls/ca.crt peer channel update -o orderer.minvu.cl:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

-Una vez programado el chaincode validar que se encuentre dentro de la ruta definida en docker-compose-cli-couchdb.yaml, resultado esperado "minvucontrol"

ls /opt/gopath/src/github.com/chaincode

-Crear variables bash que contengan lo siguiente: -Nombre del canal -Nombre smart contract -Versión smart contract -Lenguje de ejecución del contrato inteligente -Ruta del smart contract -Servicio de Ordenamiento

```

-Una vez programado el chaincode validar que se encuentre dentro de la ruta definida en docker-compose-cli-couchdb.yaml, resultado esperado "minvucontrol"
 ```shell
 ls /opt/gopath/src/github.com/chaincode
 ``` 

-Crear variables bash que contengan lo siguiente:
  -Nombre del canal 
  -Nombre smart contract 
  -Versión smart contract 
  -Lenguje de ejecución del contrato inteligente
  -Ruta del smart contract
  -Servicio de Ordenamiento 
```shell
export CHANNEL_NAME=postulacion
export CHAINCODE_NAME=minvucontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/minvu.cl/orderers/orderer.minvu.cl/msp/tlscacerts/tlsca.minvu.cl-cert.pem

-Ciclo de vida del chaincode.

  peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >&log.txt

-Instalar empaquetado generado del chaincode en organización 1

```

-Ciclo de vida del chaincode.
```shell
  peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >&log.txt
```
-Instalar empaquetado generado del chaincode en organización 1 
```shell
  peer lifecycle chaincode install minvucontrol.tar.gz
```
Se generará un identificador, este debe coincidir en la instalación de las tres instalaciones, se debe copiar este identificador del paquete, ya que posteriormente se utilizara en otras configurciones:

Chaincode code package identifier: minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Instalar empaquetado generado del chaincode en organización 2

-Instalar empaquetado generado del chaincode en organización 2 
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer lifecycle chaincode install minvucontrol.tar.gz
```
-Instalar empaquetado generado del chaincode en organización 3
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer lifecycle chaincode install minvucontrol.tar.gz

-En esta red las organizaciones 1 ; 2 y 3 tienen permisos para escritura: -Politica, permisos de escritura en la organización 1

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Verificar las políticas

```
-En esta red las organizaciones 1 ; 2 y 3 tienen permisos para escritura:
-Politica, permisos de escritura en la organización 1
```shell
peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13
```
-Verificar las políticas 
```shell
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --output json
```
-Politica, permisos de escritura en la organización 2
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13
```
-Politica, permisos de escritura en la organización 3
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" --package-id minvucontrol_1:995afc1a918b827db0c041e30371b544d546d48fe7775887b0e2471ab01c5f13

-Poner en marcha el chaincode -Se generán tres contenedores del chaincode minvucontrol con un nodo para cada organizacion 1; 2 y 3

peer lifecycle chaincode commit -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.org1.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt --peerAddresses peer0.org2.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt --peerAddresses peer0.org3.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"

-Insertar mediante funciòn set del chaincode -Ingresar a la consola de comandos en cli

-Insertar desde organizacion 1.

```
-Poner en marcha el chaincode 
-Se generán tres contenedores del chaincode minvucontrol con un nodo para cada organizacion 1; 2 y 3 
```shell
peer lifecycle chaincode commit -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.org1.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.minvu.cl/peers/peer0.org1.minvu.cl/tls/ca.crt --peerAddresses peer0.org2.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt --peerAddresses peer0.org3.minvu.cl:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"
```

-Insertar mediante función set del chaincode
-Ingresar a la consola de comandos en cli 


-Insertar desde organización 1.
```shell
peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","3","176941979","3180","55","1300","Ingresado","EGR"]}'
```
Verificar transacción mediante función query del chaincode

```shell
  peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c ‘{“Args”:[“Query”,”3”]}’
```
-Insertar desde organización 2.

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","4","176767671","3180","55","1300","Ingresado","EGR"]}'

-Insertar desde organización 3.

```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/users/Admin@org2.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org2.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.minvu.cl/peers/peer0.org2.minvu.cl/tls/ca.crt peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","4","176767671","3180","55","1300","Ingresado","EGR"]}'
```

-Insertar desde organización 3.
```shell
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/users/Admin@org3.minvu.cl/msp CORE_PEER_ADDRESS=peer0.org3.minvu.cl:7051 CORE_PEER_LOCALMSPID="Org3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.minvu.cl/peers/peer0.org3.minvu.cl/tls/ca.crt peer chaincode invoke -o orderer.minvu.cl:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","5","176767671","3180","55","1300","Ingresado","serviu"]}'
```

****************************************************************************************
****************************************************************************************
COFIGURACIÓN ARQUITECTURA CON ENTIDAD CERTIFICADORA
****************************************************************************************
****************************************************************************************


Crear root CA. o CA Raiz

´´´shell
docker-compose -f docker-compose-root-ca.yaml up -d
´´´
Creamos intermedies CA a traves de los script 
´´´shell
cd scripts/ && ./rootca.sh
´´´

´´´shell
docker-compose -f docker-compose-int-ca.yaml up -d
´´´

´´´shell
cd scripts/ && ./intca.sh
´´´

´´´shell
export CSR_NAMES_ORG1="C=CL,ST=Santiago,L=Santiago,O=Org1,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin

fabric-ca-client register --id.name admin2@org1.minvu.cl --id.secret admin2pw --id.type admin -u http://admin:adminpw@localhost:7056

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin2@org1.minvu.cl

fabric-ca-client enroll -u http://admin2@org1.minvu.cl:admin2pw@localhost:7056 --csr.names "$CSR_NAMES_ORG1"

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/tls-int/clients/admin

fabric-ca-client register --id.name admin2@org1.minvu.cl --id.secret admin2pw --id.type admin -u http://admin:adminpw@localhost:7057

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/tls-int/clients/admin2@org1.minvu.cl

fabric-ca-client enroll -u http://admin2@org1.minvu.cl:admin2pw@localhost:7057 --csr.names "$CSR_NAMES_ORG1" --csr.hosts "admin2@org1.minvu.cl,localhost" --enrollment.profile tls

./identities.sh

./msp.sh

./artifacts.sh


docker-compose -f docker-compose-cli-couchdb.yaml up -d

./channels.sh
´´´



Creae nuevo usuario en la organizacion 1 

´´´shell
export CSR_NAMES_ORG1="C=CL,ST=Santiago,L=Santiago,O=Org1,OU=Hyperledger Fabric"

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin

fabric-ca-client register --id.name user1@org1.minvu.cl --id.secret user1pw --id.type client --id.affiliation postulacion.Mint -u http://admin:adminpw@localhost:7056

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/user1@org1.minvu.cl

fabric-ca-client enroll -u http://user1@org1.minvu.cl:user1pw@localhost:7056 --csr.names "$CSR_NAMES_ORG1"
´´´

Configuración de los certificados de la RED
Crear root CA o CA Raiz

´´´shell 
docker-compose -f docker-compose-root-ca.yaml up -d 
´´´ 

Creamos CA Intermedias a traves de los script 

´´´shell 
cd scripts/ && ./rootca.sh 

docker-compose -f docker-compose-int-ca.yaml up -d 

cd scripts/ && ./intca.sh 

export CSR_NAMES_ORG1="C=CL,ST=Santiago,L=Santiago,O=Org1,OU=Hyperledger Fabric"

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin

fabric-ca-client register --id.name admin2@org1.minvu.cl --id.secret admin2pw --id.type admin -u http://admin:adminpw@localhost:7056

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin2@org1.minvu.cl

fabric-ca-client enroll -u http://admin2@org1.minvu.cl:admin2pw@localhost:7056 --csr.names "$CSR_NAMES_ORG1"

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/tls-int/clients/admin

fabric-ca-client register --id.name admin2@org1.minvu.cl --id.secret admin2pw --id.type admin -u http://admin:adminpw@localhost:7057

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/tls-int/clients/admin2@org1.minvu.cl

fabric-ca-client enroll -u http://admin2@org1.minvu.cl:admin2pw@localhost:7057 --csr.names "$CSR_NAMES_ORG1" --csr.hosts "admin2@org1.minvu.cl,localhost" --enrollment.profile tls

./identities.sh

./msp.sh

./artifacts.sh

docker-compose -f docker-compose-cli-couchdb.yaml up -d

./channels.sh

´´´

Nuevo usuario en la organización 1

´´´shell
export CSR_NAMES_ORG1="C=CL,ST=Santiago,L=Santiago,O=Org1,OU=Hyperledger Fabric"

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin

fabric-ca-client register --id.name user1@org1.minvu.cl --id.secret user1pw --id.type client --id.affiliation postulacion.inicio -u http://admin:adminpw@localhost:7056

export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/user1@org1.minvu.cl

fabric-ca-client enroll -u http://user1@org1.minvu.cl:user1pw@localhost:7056 --csr.names "$CSR_NAMES_ORG1"

´´´
****************************************************************************************
****************************************************************************************
INSTALAR CHAINCODE
****************************************************************************************
****************************************************************************************


Instalar caliper y requisitos previos

´´´shell

sudo apt install npm

npm init -y

npm install --only=prod @hyperledger/caliper-cli@0.3.2

npx caliper bind --caliper-bind-sut fabric:latest-v2 --caliper-bind-sdk latest-v2 --caliper-fabric-gateway-usegateway --caliper-flow-only-test

´´´






