import {Component, OnInit} from '@angular/core';
import { PostulacionModel } from 'src/app/models/postulacion.model';
import {BlockchainService/*, Postulacion*/} from '../../services/blockchain.service';

@Component({
    selector: 'app-home',
    templateUrl: './home.component.html'
})

export class HomeComponent implements OnInit {
    postulaciones:PostulacionModel [] = [];
    cargando = false;

    constructor( private _blockchainService:BlockchainService){}

    ngOnInit(){

        this.cargando = true;
       this._blockchainService.ObtenerPostulaciones()
       .subscribe( resp => {
           this.postulaciones = resp;
           this.cargando = false;
       });
    }

    EliminarPostulacion(postulacion: PostulacionModel, i: number){
        this.postulaciones.splice(i,1);
        this._blockchainService.EliminarPostulacion(postulacion).subscribe();
    }
}