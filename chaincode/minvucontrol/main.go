package main

import (
	"fmt"

	"github.com/braduf/curso-hyperledger-fabric/chaincode/foodcontrol/contracts"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	fmt.Printf("Start main")

	CCHContract := new(contracts.MinvuControlContract)
	CCHContract.TransactionContextHandler = new(contracts.CustomTransactionContext)
	CCHContract.BeforeTransaction = contracts.BeforeTransaction
	CCHContract.AfterTransaction = contracts.AfterTransaction
	CCHContract.Currency.Name = "Construccion Conjunto Habitacional"
	CCHContract.Currency.Code = "CCH"
	CCHContract.Name = "CCHTipologiaContract"
	
	CSRContract := new(contracts.MinvuControlContract)
	CSRContract.TransactionContextHandler = new(contracts.CustomTransactionContext)
	CSRContract.BeforeTransaction = contracts.BeforeTransaction
	CSRContract.AfterTransaction = contracts.AfterTransaction
	CSRContract.Currency.Name = "Construccion Sitio Residente"
	CSRContract.Currency.Code = "CSR"
	CSRContract.Name = "CSRTipologiaContract"

	fmt.Printf("Create chaincode from smart contracts")
	chaincode, err := contractapi.NewChaincode(CCHContract, CSRContract)
	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("Start chaincode")
	err = chaincode.Start()
	if err != nil {
		panic(err.Error())
	}
}