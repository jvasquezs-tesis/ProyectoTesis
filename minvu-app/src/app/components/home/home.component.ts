import {Component, OnInit} from '@angular/core';
import {BlockchainService, Postulacion} from '../../services/blockchain.service';

@Component({
    selector: 'app-home',
    templateUrl: './home.component.html'
})

export class HomeComponent implements OnInit {
    listadoPostulaciones:Postulacion[]=[];

    constructor( private _blockchainService:BlockchainService)
    {  
    }

    ngOnInit(){
        this.listadoPostulaciones = this._blockchainService.getPostulacionesBlockchain();
    }
}