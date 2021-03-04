package shim

import (
	"github.com/jvasquezs-tesis/ProyectoTesis/tree/master/chaincode/minvucontrol/postulacion"
	"github.com/hyperledger/fabric-chaincode-go/shim"
)

type PostulacionState struct {
	DocType string `json:"docType"`
	Value   postulacion.Postulacion
}

type PostulacionTrustLineState struct {
	DocType string `json:"docType"`
	Value   postulacion.PostulacionTrustLine
}

var TrustlineDocType = "TL"


func PutPostulacion(stub shim.ChaincodeStubInterface, tipologiaCode string, pos postulacion.Postulacion) (err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{pos.ID})
	if err != nil {
		return
	}
	err = PutState(stub, tipologiaCode, key, pos)
	return
}

func PutPostulacionTrustLine(stub shim.ChaincodeStubInterface, tipologiaCode string, tl postulacion.PostulacionTrustLine) (err error) {
	key, err := stub.CreateCompositeKey(TrustlineDocType, []string{tipologiaCode, tl.Receptor, tl.Emisor})
	if err != nil {
		return
	}
	err = PutState(stub, TrustlineDocType, key, tl)
	return
}

func DeletePostulacion(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}
	err = DelState(stub, key)
	return
}

func GetPostulacionByID(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (pos postulacion.Postulacion, err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}

	var posState PostulacionState
	err = GetState(stub, key, &posState)
	if err != nil {
		return
	}
	pos = posState.Value
	return
}

func GetPostulacionTrustLine(stub shim.ChaincodeStubInterface, tipologiaCode string, receptor string, emisor string) (tl postulacion.PostulacionTrustLine, err error) {
	key, err := stub.CreateCompositeKey(TrustlineDocType, []string{tipologiaCode, receptor, emisor})
	if err != nil {
		return
	}

	var tlState PostulacionTrustLineState
	err = GetState(stub, key, &tlState)
	if err != nil {
		return
	}
	tl = tlState.Value
	return
}

func GetHistoryForPostulacionID(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (historyJSONString string, err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}

	historyBuffer, err := GetHistoryForKey(stub, key)
	//historyBuffer, err := stub.GetHistoryForKey(key)
	if err != nil {
		return
	}
	historyJSONString = string(historyBuffer.Bytes())

	return
}

func SetCurrencyEvent(stub shim.ChaincodeStubInterface, payload interface{}) (err error) {
	funcName, _ := stub.GetFunctionAndParameters()

	event, ok := postulacion.PostulacionEventNames[funcName]
	if !ok {
		// No event should be set for this function
		return
	}
	err = SetEvent(stub, event, payload)
	return
}
