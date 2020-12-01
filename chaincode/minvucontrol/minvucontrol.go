
package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for control the food
type SmartContract struct {
	contractapi.Contract
}

//Food describes basic details of what makes up a food
type Postulacion struct {
	Rut  string `json:"rut"`
	Llamado int `json:"llamado"`
	Puntaje string `json:"puntaje"`
	Estado string `json:"estado"`}

func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, postulacionId string, rut string,llamado int, puntaje string, estado string) error {

	//Validaciones de sintaxis

	//validaciones de negocio

	postulacion := Postulacion{
		Rut:  rut,
		Llamado:  llamado,
		Puntaje: puntaje,
		Estado: estado,}


	postulacionAsBytes, err := json.Marshal(postulacion)
	if err != nil {
		fmt.Printf("Marshal error: %s", err.Error())
		return err
	}

	return ctx.GetStub().PutState(postulacionId, postulacionAsBytes)
}

func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, postulacionId string) (*Postulacion, error) {

	postulacionAsBytes, err := ctx.GetStub().GetState(postulacionId)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if postulacionAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", postulacionId)
	}

	postulacion := new(Postulacion)

	err = json.Unmarshal(postulacionAsBytes, postulacion)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	return postulacion, nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create foodcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting foodcontrol chaincode: %s", err.Error())
	}
}