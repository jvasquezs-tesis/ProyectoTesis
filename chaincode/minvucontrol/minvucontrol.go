
package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
	contractapi.Contract
}

//estructura de los datos a registrar dentro de la transaccion
type Postulacion struct {
	Llamado int `json:"llamado"`
	Rut  string `json:"rut"`
	Puntaje float32 `json:"puntaje"`
	Monto float32`json:"monto"`
	Estado int `json:"estado"`
	Usuario string `json:"usuario"`}

func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, postulacionId string,llamado int, rut string, puntaje float32,monto float32, estado int, usuario string) error {

	// Validar elementos vacios
	ResultadoValidacion := ValidarVariablesEntrada(postulacionId,llamado,rut,puntaje,monto,estado,usuario,ctx)
	// validar que no exista en la blockchain si es un elemento nuevo
	// dependiendo el usuario solo podra realizar la accion permitida 

	if(ResultadoValidacion != "ok"){
		return fmt.Errorf("Error al validar registros: %s", ResultadoValidacion)
	}
	
	postulacion := Postulacion{
		Llamado:  llamado,
		Rut:  rut,
		Puntaje: puntaje,
		Monto: monto,
		Estado: estado,
		Usuario: usuario}

	// pasar la estructura postulacion y  transformarlo a bytes
	postulacionAsBytes, err := json.Marshal(postulacion)
	if err != nil {
		fmt.Printf("Error al asignar postulacionAsBytes: %s", err.Error())
		return err
	}

	// Función que permite guardar en el libro distribuido
	return ctx.GetStub().PutState(postulacionId, postulacionAsBytes)
}

func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, postulacionId string) (*Postulacion, error) {

	postulacionAsBytes, err := ctx.GetStub().GetState(postulacionId)

	if err != nil {
		return nil, fmt.Errorf("No se pudo leer el registro solicitado %s", err.Error())
	}

	if postulacionAsBytes == nil {
		return nil, fmt.Errorf("%No existe la postulación", postulacionId)
	}

	postulacion := new(Postulacion)

	err = json.Unmarshal(postulacionAsBytes, postulacion)
	if err != nil {
		return nil, fmt.Errorf("Error al obtener la postulacion. %s", err.Error())
	}

	return postulacion, nil
}

func ValidarVariablesEntrada(postulacionId string,llamado int,rut string, puntaje float32,monto float32, estado int, usuario string, ctx contractapi.TransactionContextInterface)string {
	
	if(postulacionId == "" || llamado < 0 || rut == "" || puntaje < 0 || monto < 0 || estado < 0 || usuario == ""){
		return "Error 1, Debe completar todos los registros, recuerde que monto, puntaje y los llamados deben tener asigando un valor mayor a 0."
	}
	// estado 1 = ingreso EGR
	// estado 2 = aprobacion SERVIU
	// estado 3 = observado SERVIU
	// estado 4 = seleccionado DPH
	// estado 5 = rechazado DPH
	// sólo EGR puede realizar ingreso de postulaciones
	if(estado == 1 && usuario != "EGR"){
		return "Error 2, Solo EGR esta autorizada a ingresar postulaciones"
	}
	// sólo SERVIU aprueba postulaciones 
	if(estado == 2 && usuario != "SERVIU"){
		return "Error 3, Solo SERVIU esta autorizado a ingresar postulaciones"
	}
	// sólo SERVIU observa postulaciones 
	if(estado == 3 && usuario !=  "SERVIU"){
		return "Error 4, Solo SERVIU esta autorizado a observar postulaciones"
	}
	// sólo DPH selecciona postulaciones 
	if(estado == 4 && usuario != "DPH"){
		return "Error 5, Solo DPH esta autorizado a seleccionar postulaciones"
	}
	// sólo DPH rechaza postulaciones 
	if(estado == 5 && usuario != "DPH"){
		return "Error 6, Solo DPH esta autorizado a observado postulaciones"
	}

	/*
	// Verificar que postulante no sea modificado de una postulacion.
	postulacionAsBytes, err := ctx.GetStub().GetState(postulacionId)

	if err != nil {
		return "No se pudo leer el registro solicitado"
	}

	// si el registro es nuevo 
	if postulacionAsBytes == nil {
		return "ok"
	}else{
		
		postulacionFormatoGo := new(Postulacion)

		err = json.Unmarshal(postulacionAsBytes, postulacionFormatoGo)
	
		
		//if err != nil {
		//	return "Error al obtener la postulacion"
		//}
		
	
		return "Retorno : " + postulacionFormatoGo.Rut
	}
	*/
	
	return "ok"
}
	

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error al crear minvucontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error Iniciar minvucontrol chaincode: %s", err.Error())
	}
}