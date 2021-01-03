package postulacion

import "errors"

/*
// Currency specifies a currency // monedas
type Currency struct {
	Name     string `json:"name"`
	Code     string `json:"code"`
	Decimals int    `json:"decimals"`
}
*/

type Tipologia struct {
	Nombre     string `json:"nombre"`
	Code     string `json:"code"`
}

/*
// CurrencyUTXO is an unspent amount of a certain currency
type CurrencyUTXO struct {
	ID                string `json:"id"`
	Issuer            string `json:"issuer"`
	Owner             string `json:"owner"`
	Value             int    `json:"value"`
	RedemptionPending bool   `json:"redemptionPending"`
}
*/
// CurrencyUTXO is an unspent amount of a certain currency
type Postulacion struct {
	ID                string  `json:"id"`
	Emisor            string  `json:"emisor"` // siempre EGR al inicio.
	Receptor          string  `json:"receptor"`
	RutPostulante     int     `json:"rutpostulante"`
	Puntaje			  float32 `json:"puntaje"`
	MontoSubsidioUF   float32 `json:"montosubsidiouf"`
	RedemptionPending bool   `json:"redemptionPending"`
}

/*
// MonedaUTXO es una cantidad no gastada de una determinada moneda
type CurrencyUTXO struct {
	Cadena de identificación `json:" id "`
	Cadena de emisor `json:" emisor "`
	Cadena de propietario `json:" propietario "`
	Valor int `json:" valor "`
	RedemptionPending bool `json:" redemptionPending "`
	}
*/
// CurrencyTrustline sets if an organization trusts an issuer to receive coins from
/*type CurrencyTrustline struct {
	Receiver string `json:"receiver"`
	Issuer   string `json:"issuer"`
	Trust    bool   `json:"trust"`
	MaxLimit int    `json:"maxLimit"`
}
*/

// CurrencyTrustline sets if an organization trusts an issuer to receive coins from
type PostulacionTrustLine struct {
	Receptor string `json:"receptor"`
	Emisor   string `json:"emisor"`
	Trust    bool   `json:"trust"`
}


/*
// CurrencyTrustline establece si una organización confía en un emisor para recibir monedas de
type CurrencyTrustline struct {
	Cadena de receptor `json:" receptor "`
	Cadena de emisor `json:" emisor "`
	Confíe en bool `json:" confianza "`
	MaxLimit int `json:" maxLimit "`
	}
*/

/*
// CurrencyEventNames specifies the names of the events that should be fired after the txs
var CurrencyEventNames = map[string]string{
	"Mint":              "Minted",
	"Transfer":          "Transfered",
	"RequestRedemption": "RedemptionRequested",
	"ConfirmRedemption": "RedemptionConfirmed",
	"SetTrustline":      "TrustlineSet",
}
*/
var PostulacionEventNames = map[string]string{
	"Mint":              "Minted",   // emision del token 
	"Transfer":          "Transfered", // transferencia 
	"RequestRedemption": "RedemptionRequested", // solicitar intercambio de token por efectivo
	"ConfirmRedemption": "RedemptionConfirmed", // destruir token en la red
	"SetTrustline":      "TrustlineSet", // quien permitio el envio o bloqueo 
}

/*

// CurrencyEventNames especifica los nombres de los eventos que deben activarse después de los txs
var CurrencyEventNames = mapa [cadena] cadena {
"Mint": "Acuñado",
"Transferir": "Transferido",
"RequestRedemption": "RedemptionRequested",
"ConfirmRedemption": "RedemptionConfirmed",
"SetTrustline": "TrustlineSet",
}

*/

// MintedPayload is the payload of the Minted Events
type MintedPayload struct {
	Minter       string `json:"minter"`
	UTXOID       string `json:"UtxoId"`
	Receptor     string `json:"receptor"`
	TipologiaCode string `json:"tipologiacode"`
}

/*
// MintedPayload es la carga útil de Minted Events
type MintedPayload struct {
	Cadena de minter `json:" minter "`
	Cadena UTXOID `json:" UtxoId "`
	Cadena de receptor `json:" receptor "`
	CurrencyCode cadena `json:" currencyCode "`
	}
*/

// TransferedPayload is the payload of the Transfered Events
type TransferedPayload struct {
	TransferedBy string `json:"transferedBy"`
	//SpentUTXOIDSet   []string `json:"spentUtxoIdSet"`
	ChangeUTXOID     string `json:"changeUtxoId"`
	TransferedUTXOID string `json:"transferedUtxoId"`
	Receptor         string `json:"recepetor"`
	TipologiaCode     string `json:"TipologiaCode"`
}

/*
// TransferedPayload es la carga útil de los eventos transferidos
type TransferedPayload struct {
Transferido por cadena `json:" transferido por "`
// SpentUTXOIDSet [] string `json:" gastadoUtxoIdSet "`
Cadena ChangeUTXOID `json:" changeUtxoId "`
TransferidoUTXOID cadena `json:" transferidoUtxoId "`
Cadena de receptor `json:" receptor "`
CurrencyCode cadena `json:" currencyCode "`
}
*/

// RedemptionRequestedPayload is the payload of the RedemptionRequested Events
type RedemptionRequestedPayload struct {
	Requestor    string `json:"requestor"`
	Redeemer     string `json:"redeemer"`
	UTXOID       string `json:"utxoID"`
	TipologiaCode string `json:"tipologiaCode"`
}

/*
// RedemptionRequestedPayload es la carga útil de los eventos RedemptionRequested
type RedemptionRequestedPayload struct {
Cadena de solicitante `json:" solicitante "`
Cadena de redentor `json:" redentor "`
Cadena UTXOID `json:" utxoID "`
CurrencyCode cadena `json:" currencyCode "`
}
*/

// RedemptionConfirmedPayload is the payload of the RedemptionConfirmed Events
type RedemptionConfirmedPayload struct {
	ConfirmedBy  string `json:"confirmedBy"`
	Redeemer     string `json:"redeemer"`
	UTXOID       string `json:"utxoID"`
	TipologiaCode string `json:"tipologiaCode"`
}

/*

// RedemptionConfirmedPayload es la carga útil de los eventos RedemptionConfirmed
type RedemptionConfirmedPayload struct {
ConfirmedBy string `json:" confirmadoBy "`
Cadena de redentor `json:" redentor "`
Cadena UTXOID `json:" utxoID "`
CurrencyCode cadena `json:" currencyCode "`
}

*/
// TrustlineSetPayload is the payload of the TrustlineSet Events
type TrustlineSetPayload struct {
	Receptor     string `json:"receptor"`
	Emisor       string `json:"emisor"`
	Trust        bool   `json:"trust"`
	MaxLimit     int    `json:"maxLimit"`
	TipologiaCode string `json:"tipologiaCode"`
}

/*
// TrustlineSetPayload es la carga útil de TrustlineSet Events
escriba TrustlineSetPayload struct {
	Cadena de receptor `json:" receptor "`
	Cadena de emisor `json:" emisor "`
	Confíe en bool `json:" confianza "`
	MaxLimit int `json:" maxLimit "`
	CurrencyCode cadena `json:" currencyCode "`
	}
*/

// Errores de Negocio
var (
	ErrValidarPuntaje               = errors.New("El puntaje debe ser mayor a 0 y menor o igual a 100")
	ErrValidarMontoSubsidioUF       = errors.New("El Monto del subsidio debe ser mayor a 0")
	ErrRutPostulanteRequerido       = errors.New("Debe ingresar un rut del postulante")
	ErrReceptorRequerido            = errors.New("El MSP receptor debe especificarse para continuar con la postulacion")
	ErrMintReceiverRequiered        = errors.New("The receiving MSP should be specified to mint currency to")
	ErrTransferEmptyUTXOSet         = errors.New("The set of UTXO should contain at least one UTXO to transfer")
	ErrDoubleSpentTransfer          = errors.New("The same UTXO can not be spent twice")
	ErrPendingRedemptionTransfer    = errors.New("A UTXO that is already requested to be redeemed can not be transfered")
	ErrOnlyOwnerTransfer            = errors.New("Only the owner of a UTXO can transfer it")
	ErrInsufficientTransferFunds    = errors.New("The total input value of the UTXO set to transfer should be sufficient to cover the specified amount")
	ErrOnlySameIssuerTransfer       = errors.New("The UTXO's in the input set should all have the same issuer")
	ErrNoChannelPermissions         = errors.New("The transaction sender does not have permissions on this channel")
	ErrTrustlineIssuerRequiered     = errors.New("The issuer MSP should specified to set a trustline")
	ErrTransferTrustline            = errors.New("The receiver of a transfer should trust the issuer of the transfered coins")
	ErrRedemptionRequestPending     = errors.New("The redemption of the UTXO has already been requested")
	ErrOnlyOwnerRequestRedemption   = errors.New("Only the owner of a UTXO con request its redemption")
	ErrNoRedemptionRequestToConfirm = errors.New("The UTXO should have a pending redemption request to be able to confirm the redemption")
	ErrOnlyOwnerConfirmRedemption   = errors.New("Only the owner of a UTXO can confirm its redemption")
)

/*
var (
	ErrNegativeMintAmount = errors.New ("La cantidad para acuñar una moneda debe ser un valor positivo")
	ErrMintReceiverRequiered = errors.New ("El MSP receptor debe especificarse para acuñar moneda")
	ErrTransferEmptyUTXOSet = errors.New ("El conjunto de UTXO debe contener al menos un UTXO para transferir")
	ErrDoubleSpentTransfer = errors.New ("El mismo UTXO no se puede gastar dos veces")
	ErrPendingRedemptionTransfer = errors.New ("No se puede transferir un UTXO que ya se solicitó para canjear")
	ErrOnlyOwnerTransfer = errors.New ("Solo el propietario de un UTXO puede transferirlo")
	ErrInsufficientTransferFunds = errors.New ("El valor total de entrada del UTXO configurado para transferir debería ser suficiente para cubrir la cantidad especificada")
	ErrOnlySameIssuerTransfer = errors.New ("Los UTXO en el conjunto de entrada deben tener el mismo emisor")
	ErrNoChannelPermissions = errors.New ("El remitente de la transacción no tiene permisos en este canal")
	ErrTrustlineIssuerRequiered = errors.New ("El MSP emisor debe especificar para establecer una línea de confianza")
	ErrTransferTrustline = errors.New ("El receptor de una transferencia debe confiar en el emisor de las monedas transferidas")
	ErrRedemptionRequestPending = errors.New ("Ya se ha solicitado el canje del UTXO")
	ErrOnlyOwnerRequestRedemption = errors.New ("Solo el propietario de un UTXO con solicita su canje")
	ErrNoRedemptionRequestToConfirm = errors.New ("El UTXO debe tener una solicitud de canje pendiente para poder confirmar el canje")
	ErrOnlyOwnerConfirmRedemption = errors.New ("Solo el propietario de un UTXO puede confirmar su canje")
	)
*/