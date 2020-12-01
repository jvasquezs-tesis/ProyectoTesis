import { RouterModule, Routes} from '@angular/router';
import {HomeComponent} from './components/home/home.component';
import {DetallePostulacionComponent} from './components/detallePostulacion/detallePostulacion.component';


const APP_ROUTES: Routes = [
    {path: 'home', component: HomeComponent},
    {path: 'detallePostulacion/:id', component: DetallePostulacionComponent},
    {path: '**', pathMatch: 'full', redirectTo: 'home'}
];

export const APP_ROUTING = RouterModule.forRoot(APP_ROUTES);
