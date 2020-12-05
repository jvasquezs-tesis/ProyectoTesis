import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { PostulacionModel } from '../models/postulacion.model';
import {map} from 'rxjs/operators';

@Injectable({
    providedIn: 'root'
})

export class BlockchainService {

    private url = 'http://localhost:5985/postulacion_minvucontrol/';
    private httpOptions = {
        headers: new HttpHeaders({
            'Authorization': `Basic YWRtaW46YWRtaW5wdw==`,
            'Content-Type': `application/json`
        })
    };

    constructor(private http: HttpClient){}

    crearPostulacionesBlockchain(postulacion: PostulacionModel){
        return this.http.post(`${ this.url}`, postulacion, this.httpOptions)
            .pipe(
                map( (resp: any) => {
                    postulacion._id = resp.id;
                    postulacion._rev = resp.rev;
                })
            );
    }

    ActualizarPostulacionBlockchain(postulacion: PostulacionModel){

        const postulacionTemp = {...postulacion};
        delete postulacionTemp._id;

        return this.http.put(`${ this.url + postulacion._id}`, postulacionTemp, this.httpOptions)
        .pipe(
            map( (resp: any) => {
                postulacion._rev = resp.rev;
            })
        );
    }

    ObtenerPostulaciones(){
        return this.http.get(`${ this.url + '_all_docs?include_docs=true'}`, this.httpOptions)
            .pipe(
                map(resp => this.crearArreglo(resp))
            );
    }

    ObtenerPostulacion(id: string){
        return this.http.get(`${ this.url + id}`, this.httpOptions);
    }

    private crearArreglo(postulacionObj: object){
        const postulaciones: PostulacionModel[] = [];

        if (postulacionObj === null ){
            return [];
        }

        for (let i in postulacionObj){
            for (let j in postulacionObj[i]){
                postulaciones.push(postulacionObj[i][j].doc);
            }
        }

        return postulaciones;
    }

    EliminarPostulacion(postulacion: PostulacionModel){
        const postulacionTemp = {...postulacion};
        delete postulacionTemp._id;
        return this.http.delete(`${ this.url + postulacion._rev}`, this.httpOptions);
    }
}