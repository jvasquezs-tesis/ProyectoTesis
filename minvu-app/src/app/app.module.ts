import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

// Rutas
import {APP_ROUTING} from './app.routes';
import {FormsModule} from '@angular/forms';

// Servicios
import {BlockchainService} from './services/blockchain.service';

// Componentes
import { AppComponent } from './app.component';
import {HeaderComponent} from './components/header/header.component';
import {HomeComponent} from './components/home/home.component';
import {FooterComponent} from './components/footer/footer.component';
import {DetallePostulacionComponent} from './components/detallePostulacion/detallePostulacion.component';


@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    HomeComponent,
    FooterComponent,
    DetallePostulacionComponent
  ],
  imports: [
    BrowserModule,
    APP_ROUTING,
    FormsModule
  ],
  providers: [
  BlockchainService

  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
