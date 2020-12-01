import { Injectable } from '@angular/core';
import { StringDecoder } from 'string_decoder';

@Injectable()
export class BlockchainService {


    private listadoPostulaciones:Postulacion[] = [
        {
            "_id": "did:3",
            "_rev": "2-5ca2edb327133b4c8c460d07fe483a41",
            "puntaje": "103",
            "rut": "17694197",
            "monto": 2000,
            "estado":1,
            "version": "CgMBCAA=",
        },
        {
            "_id": "did:4",
            "_rev": "2-5ca2edb327133b4c8c460d07fe483a41",
            "puntaje": "103",
            "rut": "10528930",
            "monto": 1300,
            "estado":2,
            "version": "CgMBCAA="
        }
    ];

    constructor(){
        console.log("Servicio listoco");
    }

    getPostulacionesBlockchain():Postulacion[]{
        return this.listadoPostulaciones;
    }
}

export interface Postulacion{
    _id: string;
    _rev: string;
    puntaje: string;
    rut: string;
    estado: number;
    monto: number;
    version: string;
    
}