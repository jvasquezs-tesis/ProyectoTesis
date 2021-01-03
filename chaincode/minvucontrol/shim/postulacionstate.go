package shim

import (
	"github.com/jvasquezs-tesis/ProyectoTesis/tree/master/chaincode/minvucontrol/postulacion"
	"github.com/hyperledger/fabric-chaincode-go/shim"
)

// CurrencyUTXOState represents a CurrencyUTXO on the World State
type PostulacionState struct {
	DocType string `json:"docType"`
	Value   postulacion.Postulacion
}

// CurrencyTrustlineState represents a Trustline on the World State
type PostulacionTrustLineState struct {
	DocType string `json:"docType"`
	Value   postulacion.PostulacionTrustLine
}

// TrustlineDocType is the Document type a trustline will be stored under in the World State
var TrustlineDocType = "TL"

// PutCurrencyUTXO stores a UTXO as a state in the World State
func PutPostulacion(stub shim.ChaincodeStubInterface, tipologiaCode string, utxo postulacion.Postulacion) (err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{utxo.ID})
	if err != nil {
		return
	}
	err = PutState(stub, tipologiaCode, key, utxo)
	return
}

// PutCurrencyTrustline stores a trustline as a state in the World State
func PutPostulacionTrustLine(stub shim.ChaincodeStubInterface, tipologiaCode string, tl postulacion.PostulacionTrustLine) (err error) {
	key, err := stub.CreateCompositeKey(TrustlineDocType, []string{tipologiaCode, tl.Receptor, tl.Emisor})
	if err != nil {
		return
	}
	err = PutState(stub, TrustlineDocType, key, tl)
	return
}

// DeleteCurrencyUTXO deletes a UTXO from the World State
func DeletePostulacion(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}
	err = DelState(stub, key)
	return
}

// GetCurrencyUTXOByID retrieves the UTXO with id from the World State
func GetPostulacionByID(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (utxo postulacion.Postulacion, err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}

	var utxoState PostulacionState
	err = GetState(stub, key, &utxoState)
	if err != nil {
		return
	}
	utxo = utxoState.Value
	return
}

// GetCurrencyTrustline retrieves a trustline from the World State
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

// GetHistoryForCurrencyUTXOID retrieves all state changes a UTXO with the specified ID has gone through
func GetHistoryForPostulacionID(stub shim.ChaincodeStubInterface, tipologiaCode string, id string) (historyJSONString string, err error) {
	key, err := stub.CreateCompositeKey(tipologiaCode, []string{id})
	if err != nil {
		return
	}

	historyBuffer, err := GetHistoryForKey(stub, key)
	if err != nil {
		return
	}
	historyJSONString = string(historyBuffer.Bytes())

	return
}

// SetCurrencyEvent sets an event for the Currency Contract transactions
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
