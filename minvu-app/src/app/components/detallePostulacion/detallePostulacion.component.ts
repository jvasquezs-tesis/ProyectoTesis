import {Component, OnInit} from '@angular/core';
import {PostulacionModel} from '../../models/postulacion.model';
import {NgForm} from '@angular/forms';

@Component({
    selector: 'app-detallePostulacion',
    templateUrl: './detallePostulacion.component.html'
})

export class DetallePostulacionComponent implements OnInit{

detallePostulacion = new PostulacionModel();

    constructor(){}

    ngOnInit(){
    }
        guardar(form: NgForm){
            if (form.invalid){
                console.log("Formulario no válido");
            }
            console.log(form);
            console.log(this.detallePostulacion);
        }
}