# ORG 1
export CSR_NAMES_ORG1="C=CL,ST=Santiago,L=Santiago,O=Org1,OU=Hyperledger Fabric"
# Enroll bootstrap identity of int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:7056 --csr.names "$CSR_NAMES_ORG1"
# Enroll bootstrap identity of tls int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org1.minvu.cl/tls-int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:7057 --csr.names "$CSR_NAMES_ORG1"

# ORG 2
export CSR_NAMES_ORG2="C=CL,ST=Santiago,L=Santiago,O=Org2,OU=Hyperledger Fabric"
# Enroll bootstrap identity of int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org2.minvu.cl/int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:8056 --csr.names "$CSR_NAMES_ORG2"
# Enroll bootstrap identity of tls int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org2.minvu.cl/tls-int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:8057 --csr.names "$CSR_NAMES_ORG2"

# ORG 3
export CSR_NAMES_ORG3="C=CL,ST=Santiago,L=Santiago,O=Org3,OU=Hyperledger Fabric"
# Enroll bootstrap identity of int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org3.minvu.cl/int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:9056 --csr.names "$CSR_NAMES_ORG3"
# Enroll bootstrap identity of tls int CA
export FABRIC_CA_CLIENT_HOME=../fabric-ca/org3.minvu.cl/tls-int/clients/admin
fabric-ca-client enroll -u http://admin:adminpw@localhost:9057 --csr.names "$CSR_NAMES_ORG3"

## ORG ACME
#export CSR_NAMES_ACME="C=BE,ST=Flemish Brabant,L=Louvain,O=Acme,OU=Hyperledger Fabric"
## Enroll bootstrap identity of int CA
#export FABRIC_CA_CLIENT_HOME=../fabric-ca/minvu.cl/int/clients/admin
#fabric-ca-client enroll -u http://admin:adminpw@localhost:10056 --csr.names "$CSR_NAMES_ACME"
## Enroll bootstrap identity of tls int CA
#export FABRIC_CA_CLIENT_HOME=../fabric-ca/minvu.cl/tls-int/clients/admin
#fabric-ca-client enroll -u http://admin:adminpw@localhost:10057 --csr.names "$CSR_NAMES_ACME"
