package contracts

import (
	"fmt"


	"github.com/jvasquezs-tesis/ProyectoTesis/tree/master/chaincode/minvucontrol/postulacion"
	"github.com/jvasquezs-tesis/ProyectoTesis/tree/master/chaincode/minvucontrol/shim"
	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// CurrencyContract is the smart contract structure that will meet the contractapi.ContractInterface
// and implement transactions that with currencies
type MinvuControlContract struct {
	contractapi.Contract
	Tipologia postulacion.Tipologia
}

// BeforeTransaction will be executed before every transaction of this contract
func BeforeTransaction(ctx CustomTransactionContextInterface) (err error) {
	// Check that the sender has permissions to transact on this channel
	hasChannelOU, err := cid.HasOUValue(ctx.GetStub(), ctx.GetStub().GetChannelID())
	if err != nil {
		return
	}
	if !hasChannelOU {
		err = postulacion.ErrNoChannelPermissions
		return
	}

	// GetMSPID and set it to tx context
	msp, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return
	}
	ctx.SetMSPID(msp)
	return
}

// AfterTransaction will be executed after every transaction of this contract
func AfterTransaction(ctx CustomTransactionContextInterface, txReturnValue interface{}) (err error) {
	// After most transactions an event should be fired
	shim.SetCurrencyEvent(ctx.GetStub(), txReturnValue)
	return
}

// GetEvaluateTransactions returns
func (cc *MinvuControlContract) GetEvaluateTransactions() []string {
	return []string{"GetHistoryOfPOS", "QueryCouchDB"}
}

// Inserta una nueva postulación, tarea solo para la EGR 
func (cc *MinvuControlContract) Insert(ctx CustomTransactionContextInterface, rutpostulante int, puntaje float32, montosubsidiouf float32) (payload postulacion.InsertedPayload, err error) {

	//validacion remitente de la transacción, solo la afiliacion EGR esta autorizada para la insercion d
	hasOUPermission, err := cid.HasOUValue(ctx.GetStub(),"egr")

	if err != nil {
		return
	}
	if !hasOUPermission {
		err = postulacion.ErrNoRolAsigando
		return 
	}
	
	// monto de subsidio debe ser mayor a 0
	if montosubsidiouf < 0 {
		err = postulacion.ErrValidarMontoSubsidioUF
		return
	}
	// puntaje del postulante debe ser mayor a 0 y menor o igual a 100
	if puntaje < 0 || puntaje > 100{
		err = postulacion.ErrValidarPuntaje
		return 
	}

	// Llenar estructura postulacion a insertar
	ObjetoPostulacion := postulacion.Postulacion{
		ID				:ctx.GetStub().GetTxID() + ":" + "0",
		//Emisor			:ctx.GetMSPID(),
		Owner			:ctx.GetMSPID(),
		//Receptor        :"", // No existe receptor en proceso de inserción
		RutPostulante   :rutpostulante,
		Puntaje			:puntaje,
		MontoSubsidioUF :montosubsidiouf,
		EstadoExpediente:"Creacion", // el primer estado del expediente es creación
		EstadoPostulante:"Inscrito", // el primer estado del postulante es inscrito
	}

	// insertar postulación
	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, ObjetoPostulacion)
	if err != nil {
		return
	}

	// registros retornados de la nueva inserción través del evento Insertedpayload
	payload = postulacion.InsertedPayload{
		Insert			:ctx.GetMSPID(),
		POSID			:ObjetoPostulacion.ID,
		TipologiaCode	:cc.Tipologia.Code,
		//Receptor        :"",
		RutPostulante   :rutpostulante,
		Puntaje			:puntaje,
		MontoSubsidioUF :montosubsidiouf,
		EstadoExpediente:"Creacion",
		EstadoPostulante:"Inscrito", 
	}
	return
}

//Transfer, transfiere una postulación a una organización específica
func (cc *MinvuControlContract) Transfer(ctx CustomTransactionContextInterface, posIDSet string, receptor string) (payload postulacion.TransferedPayload, err error) {
	
	//variables 
	var emisor string
	var ObjetoPostulacion postulacion.Postulacion
	var transferPostulacion postulacion.Postulacion
	// Validar que se ingrese por lo menos una postulacion a transferir
	if posIDSet == "" {
		err = postulacion.ErrTransferVacioPOSIDSet
		fmt.Printf(err.Error())
		return
	}
	// Se debe agregar un receptor
	if receptor == ""{
		err = postulacion.ErrReceptorRequerido
		return
	}
	//obtener postulaciona traves del POSID
	ObjetoPostulacion, err = shim.GetPostulacionByID(ctx.GetStub(), cc.Tipologia.Code, posIDSet)
	if err != nil {
		fmt.Printf(err.Error())
		return
	}

	// pasar emisor
	//emisor = ObjetoPostulacion.Emisor
	emisor = ObjetoPostulacion.Owner

	// Validar que se permita la transaferencia entre organizaciones
	tl, err := shim.GetPostulacionTrustLine(ctx.GetStub(), cc.Tipologia.Code, receptor, emisor)
	if err != nil {
		return
	}
	if !tl.Trust {
		err = postulacion.ErrTransferirTrustline
		return
	}


	// Validar que emisor sea el dueño de la postulacion
	if ObjetoPostulacion.Owner != emisor {
		err = postulacion.SoloTransferenciaMismoEmisor
		fmt.Printf(err.Error())
		return
	}

	if ObjetoPostulacion.EstadoExpediente == "Creacion"{
		

		hasOUPermission, errr := cid.HasOUValue(ctx.GetStub(),"egr")

		if errr != nil {
			return
		}

		if !hasOUPermission {
			errr  = postulacion.ErrEnvioPostulacionCreacion
			fmt.Printf(errr.Error())
			return 
		}

		// Crear estructura de postulacion para realizar envio desde egr a serviu
		transferPostulacion = postulacion.Postulacion{
			ID				  :ctx.GetStub().GetTxID() + ":" + "1",
			//Emisor            :emisor,
			//Receptor          :receptor,
			Owner		      :receptor,
			EstadoExpediente  :"Enviado",
			EstadoPostulante  :"Inscrito",
			RutPostulante     :ObjetoPostulacion.RutPostulante,
			Puntaje			  :ObjetoPostulacion.Puntaje,
			MontoSubsidioUF   :ObjetoPostulacion.MontoSubsidioUF,
		}
		
	}else if ObjetoPostulacion.EstadoExpediente == "Enviado" { 
		
		//SERVIU solo puede enviar expedientes en estado Enviado
		hasOUPermission, errr := cid.HasOUValue(ctx.GetStub(),"serviu")
		if errr != nil {
			return
		}

		if !hasOUPermission {
			errr  = postulacion.ErrEnvioPostulacionEnviado
			fmt.Printf(errr.Error())
			return 
		}

		// Crear estructura de postulacion para realizar envio desde egr a serviu
		transferPostulacion = postulacion.Postulacion{
			ID				  :ctx.GetStub().GetTxID() + ":" + "1",
			//Emisor            :emisor,
			//Receptor          :receptor,
			Owner		      :receptor,
			EstadoExpediente  :"Aprobado",
			EstadoPostulante  :"Inscrito",
			RutPostulante     :ObjetoPostulacion.RutPostulante,
			Puntaje			  :ObjetoPostulacion.Puntaje,
			MontoSubsidioUF   :ObjetoPostulacion.MontoSubsidioUF,
		}

	}

	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, transferPostulacion)
	if err != nil {
		fmt.Printf(err.Error())
		return
	}
	
	// Set the event payload
	payload = postulacion.TransferedPayload{
		TransferedBy   :ctx.GetMSPID(),
		TransferedPOSID:transferPostulacion.ID,
		//Receptor       :receptor,
		Owner       :receptor,
		//Receptor:ObjetoPostulacion.TipologiaCode,
		TipologiaCode  :cc.Tipologia.Code,
	}
	fmt.Printf("End of Transfer: " + payload.TransferedPOSID)

	return
	
}

func (cc *MinvuControlContract) Selection(ctx CustomTransactionContextInterface, posIDSet string, estado string) (payload postulacion.SelectedPayload, err error) {
	
	//variables 
	var ObjetoPostulacion postulacion.Postulacion
	var transferPostulacion postulacion.Postulacion
	var estadoPostulante string = "Beneficiado"
	// Validar que se ingrese por lo menos una postulacion a seleccionar
	if posIDSet == "" {
		err = postulacion.ErrTransferVacioPOSIDSet
		fmt.Printf(err.Error())
		return
	}
	// Se debe agregar estado requerido 
	if estado == ""{
		err = postulacion.ErrEstadoRequerido 
		return
	}else if estado != "Seleccionado" && estado != "Rechazado" {
		err = postulacion.ErrEstadoRequeridoNoValido
		return
	}

	//obtener postulaciona traves del POSID
	ObjetoPostulacion, err = shim.GetPostulacionByID(ctx.GetStub(), cc.Tipologia.Code, posIDSet)
	if err != nil {
		fmt.Printf(err.Error())
		return
	}

	// validar estado actual del expediente
	if ObjetoPostulacion.EstadoExpediente == "Aprobado"{
		
		// solo dph puede beneficiar postulantes
		hasOUPermission, errr := cid.HasOUValue(ctx.GetStub(),"dph")

		if errr != nil {
			return
		}

		if !hasOUPermission {
			errr = postulacion.ErrEnvioPostulacionAprobado
			fmt.Printf(errr.Error())
			return 
		}

		if estado != "Seleccionado"{
			estadoPostulante = "No Seleccionado"
		}

		// Crear estructura de postulacion para realizar envio desde egr a serviu
		transferPostulacion = postulacion.Postulacion{
			ID				  :ctx.GetStub().GetTxID() + ":" + "0",
			Owner		      :ObjetoPostulacion.Owner,
			EstadoExpediente  :estado,
			EstadoPostulante  :estadoPostulante,
			RutPostulante     :ObjetoPostulacion.RutPostulante,
			Puntaje			  :ObjetoPostulacion.Puntaje,
			MontoSubsidioUF   :ObjetoPostulacion.MontoSubsidioUF,
		}
		
	}else { 
		// solo postulaciones aprobadas pueden ser evaluadas en esta etapa
		err  = postulacion.ErrSoloAprobados
		fmt.Printf(err.Error())
		return 
	}

	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, transferPostulacion)
	if err != nil {
		fmt.Printf(err.Error())
		return
	}
	
	// Set the event payload
	payload = postulacion.SelectedPayload{
		SelectedBy   :ctx.GetMSPID(),
		SelectedPOSID:transferPostulacion.ID,
		Owner        :ObjetoPostulacion.Owner,
		TipologiaCode:cc.Tipologia.Code,
	}
	fmt.Printf("End of Transfer: " + payload.SelectedPOSID)

	return
	
}

// SetTrustline permitir transferencias entre organizaciones
func (cc *MinvuControlContract) SetTrustline(ctx CustomTransactionContextInterface, emisor string, trust bool) (payload postulacion.TrustlineSetPayload, err error) {
	// Validar emisor 
	if emisor == "" {
		err = postulacion.ErrTrustlineEmisorRequerido
		return
	}

	// Insertar linea de confianza
	err = shim.PutPostulacionTrustLine(ctx.GetStub(), cc.Tipologia.Code, postulacion.PostulacionTrustLine{
		Receptor: ctx.GetMSPID(),
		Emisor:   emisor,
		Trust:    trust,
	})
	if err != nil {
		return
	}

	payload = postulacion.TrustlineSetPayload{
		Receptor:     ctx.GetMSPID(),
		Emisor:       emisor,
		Trust:        trust,
		TipologiaCode: cc.Tipologia.Code,
	}
	return
}

//QueryCouchDB se puede utilizar para ejecutar consultas contra CouchDB
func (cc *MinvuControlContract) QueryCouchDB(ctx CustomTransactionContextInterface, query string) (queryResultInJSONString string, err error) {
	queryResultInJSONString, err = shim.QueryCouchDB(ctx.GetStub(), query)
	return
}


//GetHistoryOfPOS se puede utilizar para buscar en el historial de una postulacion
func (cc *MinvuControlContract) GetHistoryOfPOS(ctx CustomTransactionContextInterface, id string) (historyInJSONString string, err error) {
	historyInJSONString, err = shim.GetHistoryForPostulacionID(ctx.GetStub(), cc.Tipologia.Code, id)
	return
}


