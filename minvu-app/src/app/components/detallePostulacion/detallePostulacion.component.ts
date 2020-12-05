import {Component, OnInit} from '@angular/core';
import {PostulacionModel} from '../../models/postulacion.model';
import {NgForm} from '@angular/forms';
import { BlockchainService } from '../../services/blockchain.service';
import Swal from 'sweetalert2';
import { Observable } from 'rxjs';
import { ActivatedRoute } from '@angular/router';

@Component({
    selector: 'app-detallePostulacion',
    templateUrl: './detallePostulacion.component.html'
})

export class DetallePostulacionComponent implements OnInit{

    postulacion: PostulacionModel = new PostulacionModel();

    constructor(private blockchainService: BlockchainService, private route:ActivatedRoute){}

    ngOnInit(){
        const id = this.route.snapshot.paramMap.get('id');
        if ( id !== 'nuevo'){
            this.blockchainService.ObtenerPostulacion(id)
            .subscribe((resp: PostulacionModel) =>{
                this.postulacion = resp;
            });
        }
    }

    guardar(form: NgForm){
        if (form.invalid){
            console.log("Formulario no válido");
            return;
        }

        Swal.fire({
            title: 'Espere',
            text: 'Guardando información',
            allowOutsideClick: false
        });
        Swal.showLoading();

        let peticion: Observable<any>;

        // si ID existe actualizamos postulacion de lo contrario creamos nueva actualización
        if (this.postulacion._id){
            peticion = this.blockchainService.ActualizarPostulacionBlockchain(this.postulacion);
        }else{
            peticion = this.blockchainService.crearPostulacionesBlockchain(this.postulacion);
        }

        peticion.subscribe( resp => {
            Swal.fire({
                title: this.postulacion.rut,
                text: 'Se actualizó correctamente'
            });
        });
    }
}