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

// GetEvaluateTransactions returns functions of CurrencyContract not to be tagged as submit
func (cc *MinvuControlContract) GetEvaluateTransactions() []string {
	return []string{"GetHistoryOfUTXO", "QueryCouchDB"}
}

// Mint issues new coins for a specified amount to a specified receptor
func (cc *MinvuControlContract) Insert(ctx CustomTransactionContextInterface, rutpostulante int, puntaje float32, montosubsidiouf float32) (payload postulacion.InsertedPayload, err error) {

	//validacion remitente de la transaccion
	hasOUPermission, err := cid.HasOUValue(ctx.GetStub(),"egr")

	if err != nil {
		return
	}

	if !hasOUPermission {
		err = postulacion.ErrNoRolAsigando
		return 
	}
	
	// Validate parameters
	if montosubsidiouf < 0 {
		err = postulacion.ErrValidarMontoSubsidioUF
		return
	}

	if puntaje < 0 || puntaje > 100{
		err = postulacion.ErrValidarPuntaje
		return 
	}

	// Check decimals of amount
	/*
	if receptor != ""{
		err = postulacion.ErrReceptorRequerido
		return
	}

	// Check decimals of amount
	if rutpostulante == ""{
		err = postulacion.ErrRutPostulanteRequerido
		return
	}
	*/
	// Mint a new UTXO
	utxo := postulacion.Postulacion{
		ID				:ctx.GetStub().GetTxID() + ":" + "0",
		Emisor			:ctx.GetMSPID(),
		Receptor        :"", // vacio en instancia de insercion por parte de la EGR
		RutPostulante   :rutpostulante,
		Puntaje			:puntaje,
		MontoSubsidioUF :montosubsidiouf,
	}

	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, utxo)
	if err != nil {
		return
	}

	// Return the event payload
	payload = postulacion.InsertedPayload{
		Insert			:ctx.GetMSPID(),
		UTXOID			:utxo.ID,
		Receptor		:"",
		TipologiaCode	:cc.Tipologia.Code,
	}
	//ctx.SetEventPayload(payload)
	return
}

// Transfer transfers a specified amount of the utxo set to a specified receptor
func (cc *MinvuControlContract) Transfer(ctx CustomTransactionContextInterface, utxoIDSet []string, receptor string,  rutpostulante int,  puntaje float32,  montosubsidiouf float32) (payload postulacion.TransferedPayload, err error) {
	// Validate parameters
	if len(utxoIDSet) == 0 {
		err = postulacion.ErrTransferEmptyUTXOSet
		fmt.Printf(err.Error())
		return
	}

	// Validate parameters
	if montosubsidiouf < 0 {
		err = postulacion.ErrValidarMontoSubsidioUF
		return
	}

	if puntaje < 0 || puntaje > 100{
		err = postulacion.ErrValidarPuntaje
		return 
	}

	// Check decimals of amount
	if receptor == ""{
		err = postulacion.ErrReceptorRequerido
		return
	}

	// Validate and spend the UTXO set
	//totalInputAmount := 0
	spentUTXO := make(map[string]bool)
	var emisor string
	for i, utxoID := range utxoIDSet {
		// Check duplicate ID in utxo set
		if spentUTXO[utxoID] {
			err = postulacion.ErrDoubleSpentTransfer
			fmt.Printf(err.Error())
			return
		}
		// Obtain UTXO from state
		var utxo postulacion.Postulacion
		utxo, err = shim.GetPostulacionByID(ctx.GetStub(), cc.Tipologia.Code, utxoID)
		if err != nil {
			fmt.Printf(err.Error())
			return
		}
		// Set issuer of the first utxo in the set
		if i == 0 {
			emisor = utxo.Emisor
			// Check if the receptor accepts coins from this issuer
			var tl postulacion.PostulacionTrustLine
			tl, err = shim.GetPostulacionTrustLine(ctx.GetStub(), cc.Tipologia.Code, receptor, emisor)
			if err == shim.ErrStateNotFound {
				err = postulacion.ErrTransferTrustline
				fmt.Printf(err.Error())
				return
			}
			if err != nil {
				fmt.Printf(err.Error())
				return
			}
			if !tl.Trust {
				err = postulacion.ErrTransferTrustline
				fmt.Printf(err.Error())
				return
			}
		}
		// Check issuer
		if utxo.Emisor != emisor {
			err = postulacion.ErrOnlySameIssuerTransfer
			fmt.Printf(err.Error())
			return
		}
		// Check owner
		if utxo.Receptor != ctx.GetMSPID() {
			err = postulacion.ErrOnlyOwnerTransfer
			fmt.Printf(err.Error())
			return
		}
		// Check redemption status
		if utxo.RedemptionPending {
			err = postulacion.ErrPendingRedemptionTransfer
			fmt.Printf(err.Error())
			return
		}
		// Add value to input amount
		//totalInputAmount += utxo.Value

		err = shim.DeletePostulacion(ctx.GetStub(), cc.Tipologia.Code, utxoID)
		if err != nil {
			fmt.Printf(err.Error())
			return
		}
		spentUTXO[utxoID] = true
	}


	
	// Create new outputs
	var transferUTXO, changeUTXO postulacion.Postulacion
	/*
	comendtado
	if totalInputAmount < amount {
		err = postulacion.ErrInsufficientTransferFunds
		fmt.Printf(err.Error())
		return
	}
*/
	
	transferUTXO = postulacion.Postulacion{
		ID:     ctx.GetStub().GetTxID() + ":" + "0",
		Emisor: emisor,
		Receptor:  receptor,
		//Value:  amount,
	}
	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, transferUTXO)
	if err != nil {
		fmt.Printf(err.Error())
		return
	}

	//changeAmount := totalInputAmount - amount
	//if changeAmount > 0 {
		changeUTXO = postulacion.Postulacion{
			ID:     ctx.GetStub().GetTxID() + ":" + "1",
			Emisor: emisor,
			Receptor:  ctx.GetMSPID(),
			Puntaje:  puntaje-1,
		}
		err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, changeUTXO)
		if err != nil {
			fmt.Printf(err.Error())
			return
		}
	//}

	// Set the event payload
	payload = postulacion.TransferedPayload{
		TransferedBy: ctx.GetMSPID(),
		//SpentUTXOIDSet:   utxoIDSet,
		ChangeUTXOID:     changeUTXO.ID,
		TransferedUTXOID: transferUTXO.ID,
		Receptor:         receptor,
		TipologiaCode:     cc.Tipologia.Code,
	}
	fmt.Printf("End of Transfer: " + payload.TransferedUTXOID)
	//ctx.SetEventPayload(payload)
	return
}

// RequestRedemption requests to receive the off-chain currency that is guarded by the issuer of the specified UTXO
func (cc *MinvuControlContract) RequestRedemption(ctx CustomTransactionContextInterface, utxoID string) (payload postulacion.RedemptionRequestedPayload, err error) {
	utxo, err := shim.GetPostulacionByID(ctx.GetStub(), cc.Tipologia.Code, utxoID)
	if err != nil {
		return
	}
	if utxo.RedemptionPending {
		err = postulacion.ErrRedemptionRequestPending
		return
	}
	if utxo.Emisor != ctx.GetMSPID() {
		err = postulacion.ErrOnlyOwnerRequestRedemption
		return
	}
	utxo.RedemptionPending = true
	err = shim.PutPostulacion(ctx.GetStub(), cc.Tipologia.Code, utxo)
	if err != nil {
		return
	}

	payload = postulacion.RedemptionRequestedPayload{
		Requestor:    ctx.GetMSPID(),
		Redeemer:     utxo.Emisor,
		UTXOID:       utxo.ID,
		TipologiaCode: cc.Tipologia.Code,
	}
	//ctx.SetEventPayload(payload)
	return
}

// ConfirmRedemption confirms the off-chain reception of the currency represented by the utxo and destroys the utxo on-chain
func (cc *MinvuControlContract) ConfirmRedemption(ctx CustomTransactionContextInterface, utxoID string) (payload postulacion.RedemptionConfirmedPayload, err error) {
	utxo, err := shim.GetPostulacionByID(ctx.GetStub(), cc.Tipologia.Code, utxoID)
	if err != nil {
		return
	}
	if !utxo.RedemptionPending {
		err = postulacion.ErrNoRedemptionRequestToConfirm
		return
	}
	if utxo.Emisor != ctx.GetMSPID() {
		err = postulacion.ErrOnlyOwnerConfirmRedemption
		return
	}
	err = shim.DeletePostulacion(ctx.GetStub(), cc.Tipologia.Code, utxoID)
	if err != nil {
		return
	}

	payload = postulacion.RedemptionConfirmedPayload{
		ConfirmedBy:  ctx.GetMSPID(),
		Redeemer:     utxo.Emisor,
		UTXOID:       utxo.ID,
		TipologiaCode: cc.Tipologia.Code,
	}
	//ctx.SetEventPayload(payload)
	return
}

// SetTrustline can be used to enable or disable receptions of this currency from a specific issuer
func (cc *MinvuControlContract) SetTrustline(ctx CustomTransactionContextInterface, emisor string, trust bool) (payload postulacion.TrustlineSetPayload, err error) {
	// createCompositeKey with currency code, sender,issuer and value of bool trust
	// Validate parameters
	if emisor == "" {
		err = postulacion.ErrTrustlineIssuerRequiered
		return
	}

	// Set trustline
	err = shim.PutPostulacionTrustLine(ctx.GetStub(), cc.Tipologia.Code, postulacion.PostulacionTrustLine{
		Receptor: ctx.GetMSPID(),
		Emisor:   emisor,
		Trust:    trust,
		//MaxLimit: limit,
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
	//ctx.SetEventPayload(payload)
	return
}

// QueryCouchDB can be used to execute rich queries against the CouchDB
func (cc *MinvuControlContract) QueryCouchDB(ctx CustomTransactionContextInterface, query string) (queryResultInJSONString string, err error) {
	queryResultInJSONString, err = shim.QueryCouchDB(ctx.GetStub(), query)
	return
}

// GetHistoryOfUTXO can be used to search through the history of a UTXO
func (cc *MinvuControlContract) GetHistoryOfUTXO(ctx CustomTransactionContextInterface, id string) (historyInJSONString string, err error) {
	historyInJSONString, err = shim.GetHistoryForPostulacionID(ctx.GetStub(), cc.Tipologia.Code, id)
	return
}


