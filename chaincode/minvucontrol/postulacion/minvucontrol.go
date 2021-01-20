package postulacion

import "errors"

type Tipologia struct {
	Nombre string `json:"nombre"`
	Code   string `json:"code"`
}

type Postulacion struct {
	ID                string  `json:"id"`
	Emisor            string  `json:"emisor"` 
	Receptor          string  `json:"receptor"`
	RutPostulante     int     `json:"rutpostulante"`
	Puntaje			  float32 `json:"puntaje"`
	MontoSubsidioUF   float32 `json:"montosubsidiouf"`
	EstadoPostulante  string  `json:"estadopostulante"`
	EstadoExpediente  string  `json:"estadoexpediente"`
}

//PostulacionTrustLine establece si una organización confía en un emisor para recibir transacciones
type PostulacionTrustLine struct {
	Receptor string `json:"receptor"`
	Emisor   string `json:"emisor"`
	Trust    bool   `json:"trust"`
}

//Específica los eventos del chaincode
var PostulacionEventNames = map[string]string{
	"Insert"			: "Inserted",   			// emisión del token 
	"Transfer"			: "Transfered", 			// transferencia 
	"SetTrustline"		: "TrustlineSet", 			// Autorización de transacción entre organizaciones ¿De quien acepto transferencias ?
}

//InsertedPayload es la carga útil del evento Inserted 
type InsertedPayload struct {
	Insert       string `json:"insert"`
	POSID       string `json:"PosId"`
	TipologiaCode string `json:"tipologiacode"`
	Receptor          string  `json:"receptor"`
	RutPostulante     int     `json:"rutpostulante"`
	Puntaje			  float32 `json:"puntaje"`
	MontoSubsidioUF   float32 `json:"montosubsidiouf"`
	EstadoPostulante  string  `json:"estadopostulante"`
	EstadoExpediente  string  `json:"estadoexpediente"`
}

// TransferedPayload is the payload of the Transfered Events
type TransferedPayload struct {
	TransferedBy 	string `json:"transferedBy"`
	//ChangePOSID     string `json:"changePosId"`
	TransferedPOSID string `json:"transferedPosId"`
	Receptor        string `json:"recepetor"`
	TipologiaCode   string `json:"TipologiaCode"`
}

// TrustlineSetPayload is the payload of the TrustlineSet Events
type TrustlineSetPayload struct {
	Receptor      string `json:"receptor"`
	Emisor        string `json:"emisor"`
	Trust         bool   `json:"trust"`
	TipologiaCode string `json:"tipologiaCode"`
}

// Errores de Negocio
var (
	ErrValidarPuntaje               = errors.New("El puntaje debe ser mayor igual a 0 y menor o igual a 100")
	ErrValidarMontoSubsidioUF       = errors.New("El Monto del subsidio debe ser mayor a 0")
	ErrRutPostulanteRequerido       = errors.New("Debe ingresar un rut del postulante")
	ErrReceptorRequerido            = errors.New("El MSP receptor debe especificarse para continuar con la postulacion")
	ErrNoRolAsigando           	    = errors.New("La organizacion no esta autorizada para insertar la postulacion")
	ErrTransferirTrustline          = errors.New("El receptor de una transaccion debe confiar en el emisor.")
	ErrTransferVacioPOSIDSet        = errors.New("El conjunto de POSID debe contener al menos una postulacion para transferir")
	ErrDoblePostulacionTransferida  = errors.New("La misma postulacion no puede ser transferida dos veces")
	SoloTransferenciaMismoEmisor    = errors.New("La postulacion a transeferir debe ser de propiedad del emisor")
	ErrEnvioPostulacionCreacion 	= errors.New("En estado Creacion solo la EGR puede transferir")
	ErrEnvioPostulacionEnviado 		= errors.New("En estado Enviado solo SERVIU puede transferir")
	ErrNoChannelPermissions         = errors.New("El remitente de la transaccion no tiene permisos en este canal")

	Err1            = errors.New("Ero1")
	Err2            = errors.New("Eros2")
	Err3            = errors.New("Eros3")

	ErrInsertReceiverRequiered      = errors.New("The receiving MSP should be specified to mint currency to")
	ErrOnlyOwnerTransfer            = errors.New("Only the owner of a UTXO can transfer it")
	ErrInsufficientTransferFunds    = errors.New("The total input value of the UTXO set to transfer should be sufficient to cover the specified amount")
	ErrTrustlineIssuerRequiered     = errors.New("The issuer MSP should specified to set a trustline")
	ErrOnlyOwnerConfirmRedemption   = errors.New("Only the owner of a UTXO can confirm its redemption")
)