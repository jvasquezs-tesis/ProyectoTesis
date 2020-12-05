export class PostulacionModel{

    _id: string;
    _rev: string;
    llamado: number;
    puntaje: string;
    rut: string;
    estado: number;
    monto: number;
    version: string;

    constructor(){
        this.estado = 1;
    }

}