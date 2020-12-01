export class PostulacionModel{

    _id: string;
    _rev: string;
    puntaje: string;
    rut: string;
    estado: number;
    monto: number;
    version: string;
    

    constructor(){
        this.estado = 1;
    }

}