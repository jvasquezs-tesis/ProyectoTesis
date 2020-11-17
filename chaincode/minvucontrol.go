package chaincode

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct{
	contractapi.Contract
}

func main(){
	chaincode, err := contractapi.newChaincode(new(SmartContract))

	if err != nil{
		fmt.Printf("Error 1 crear minvucontrol:", err.Error())
		return
	}

	if err:= chaincode.Start(); err != nil{
		fmt.Printf("Error 2 crear minvucontrol:", err.Error())
	}

}
