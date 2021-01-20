package postulacion

import "errors"

type Tipologia struct {
	Nombre string `json:"nombre"`
	Code   string `json:"code"`
}

type Postulacion struct {
	ID                string  `json:"id"`
	Owner            string  `json:"owner"` 
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
	"Selection"			: "Selected",				// Seleccionar o rechazar postulacion
}

//InsertedPayload es la carga útil del evento Inserted 
type InsertedPayload struct {
	Insert       	  string `json:"insert"`
	POSID       	  string `json:"PosId"`
	TipologiaCode 	  string `json:"tipologiacode"`
	Owner 			  string  `json:"owner"`
	RutPostulante     int     `json:"rutpostulante"`
	Puntaje			  float32 `json:"puntaje"`
	MontoSubsidioUF   float32 `json:"montosubsidiouf"`
	EstadoPostulante  string  `json:"estadopostulante"`
	EstadoExpediente  string  `json:"estadoexpediente"`
}

// TransferedPayload es la carga útil del evento transfered
type TransferedPayload struct {
	TransferedBy 	string `json:"transferedBy"`
	TransferedPOSID string `json:"transferedPosId"`
	Owner 			string `json:"owner"`
	TipologiaCode   string `json:"TipologiaCode"`
}

// SelectedPayload es la carga útil del evento selected
type SelectedPayload struct {
	SelectedBy  	string `json:"selectedBy"`
	SelectedPOSID   string `json:"selectedPosId"`
	Owner 			string `json:"owner"`
	TipologiaCode   string `json:"TipologiaCode"`
}

//TrustlineSetPayload es la carga útil del evento TrustlineSet 
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
	ErrEstadoRequerido              = errors.New("Debe especificar estado del proceso de seleccion")
	ErrEstadoRequeridoNoValido      = errors.New("Debe especificar estado del proceso de seleccion valido Seleccionado o Rechazado")
	ErrNoRolAsigando           	    = errors.New("La organizacion no esta autorizada para insertar la postulacion")
	ErrEnvioPostulacionAprobado		= errors.New("En estado Aprobado solo DPH puede seleccionar o rechazar una postulacion")
	ErrTransferirTrustline          = errors.New("El receptor de una transaccion debe confiar en el emisor.")
	ErrSoloAprobados				= errors.New("Solo postulaciones aprobadas pueden ser sujetas a proceso de seleccion")
	ErrTransferVacioPOSIDSet        = errors.New("El conjunto de POSID debe contener al menos una postulacion para transferir")
	ErrDoblePostulacionTransferida  = errors.New("La misma postulacion no puede ser transferida dos veces")
	SoloTransferenciaMismoEmisor    = errors.New("La postulacion a transeferir debe ser de propiedad del emisor")
	ErrEnvioPostulacionCreacion 	= errors.New("En estado Creacion solo la EGR puede transferir")
	ErrEnvioPostulacionEnviado 		= errors.New("En estado Enviado solo SERVIU puede transferir")
	ErrNoChannelPermissions         = errors.New("El remitente de la transaccion no tiene permisos en este canal")
	ErrTrustlineEmisorRequerido     = errors.New("El MSP emisor debe especificarse para establecer una linea de confianza")
)