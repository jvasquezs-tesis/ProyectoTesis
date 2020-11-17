package main

import (
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct{
	contractapi.Contract
}


//Definir un activo 
type Postulacion struct{
	Puntaje string `json:"puntaje"`       
	Rut string  `json:"rut"`
}

func (s *SmartContract) Set (ctx contractapi.TransactionContextInterface, postulacionId string, puntaje string, rut string){
//agregar validaciones de sintaxis

	postulacion := Postulacion{
		Puntaje: puntaje,
		Rut: rut
	}

	//pasar estructura a bytes
	postulacionAsBytes, _ := json.Marshal(postulacion)
	if err != nil{
		fmt.Printf("3 Marshal error", err.Error())
		return err
	}

	// permite almacenar en el libro distribuido
	return ctx.GetStub().PutState(postulacionId,postulacionAsBytes)

}

func main(){
	chaincode, err := contractapi.newChaincode(new(SmartContract))

	if err != nil{
		fmt.Printf("Error 1 crear minvucontrol chaincode:", err.Error())
		return
	}

	if err:= chaincode.Start(); err != nil{
		fmt.Printf("Error 2 crear minvucontrol chaincode:", err.Error())
	}

}
