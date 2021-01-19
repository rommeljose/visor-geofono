/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : mousePressed()                              **
 **     Descripción : Atiende los Eventos del ratón               **
 **     Parámetros  : Puerto que genera la interrupción           **
 **     Retorna     : Nada                                        **
 ** ***************************************************************/

void mousePressed() {
        ClearStatus ();
  Creditos.setVisible(false);            // Quita el texto referento a los creditos
  // println("mouseX: "+mouseX +" mouseY: "+mouseY);   // Solo para debug
  ktr_incio = true;                      // Habilita a "serialEvent()" para capturar datos por el puerto serial 
  // Boton 1: Verificacion si el clip del raton presionado es el LEFT
  if ((mouseButton == LEFT) && (arch != true) ) { // Eventos de click derecho si y solo si No se esta guardando datos en un archivo
    if (mouseX>=button_1_x&&mouseX<=(button_1_x+220)&&mouseY>=button_1_y&&mouseY<=(button_1_y+30)) { // Evento del botón1 "Conectar-Desconectar"
      if (ktr_captura) {
        ktr_captura = false;          // Detiene la presentacion de la traza
        tipocaptura = "Iniciar captura datos Geofono";     
        rgbbutton_1_[0] = 155;
        rgbbutton_1_[1] = 245;
        rgbbutton_1_[2] = 170;
      } else {      
        ktr_captura = true;             // Inicia la Presentacion de la traza
        tipocaptura = "    Detener Captura datos";
        rgbbutton_1_[0] = 250;
        rgbbutton_1_[1] = 255;
        rgbbutton_1_[2] = 125;
      }
    }    // End if coordenadas
  }    // End if del LEFT


  // Boton 1: Verificacion si el clip del raton presionado es el  RIGHT
  else if (mouseButton == RIGHT ) {          // Eventos de click derecho
    if (mouseX>=button_1_x&&mouseX<=(button_1_x+220)&&mouseY>=button_1_y&&mouseY<=(button_1_y+30)) { // Evento del botón1 "Conectar-Desconectar"
      if (ktr_captura && arch && archivo_flagOut) { 
        ktr_captura = false;
        G = 0;                              // Color verde
        StopCapturaDataFile ();
        Stop_file = true;
        tipocaptura="Iniciar Captura Data Archivo";
        rgbbutton_1_[0]=155;
        rgbbutton_1_[1]=245;
        rgbbutton_1_[2]=170;
      } else if (archivo_flagOut ) {
        ktr_captura = true;   // Permite la pesentacion de la traza en la ventana de despliegue
        arch = true;          // Permite el envio de datos al archivo creado o seleccionado 
        tipocaptura="Detener captura data Archivo";
        //  println(Archivo_datos);  // para debug
        rgbbutton_1_[0]=255;
        rgbbutton_1_[1]=0;
        rgbbutton_1_[2]=0;
      }
    }   // End if de las coordenadas
  }     // End else if


  //  Boton 2: Verificacion si el clip del raton presionado es el RIGHT
  if (mouseButton == RIGHT && (arch != true) && !ktr_captura ) {
    if (mouseX>=button_2_x && mouseX<=(button_2_x +280) && mouseY>=button_2_y && mouseY<=(button_2_y+30)  ) { // Evento del botón2 
      if (archivo_flagIn == false) {
        G = 0;
        Disponible = "  Seleccción de Archivo / Lectura ";
        //selectOutput("Selecion de archivo para almacenar datos:", "fileSelected");   // Envia la accion al method to be called when the selection is made
        selectInput("Selecion de archivo de datos:", "fileSelected");   // Envia la accion al metodo a ser llamado cuando se hace la seleccon
 //       archivo_flagIn = true;  // da problemas para arrancar LeeArchivo()
        rgbbutton_2_[0] = 255;
        rgbbutton_2_[1] = 255;
        rgbbutton_2_[2] = 0;
        // over = true;             // If mouse over
      }
    }    // En if coordenadas del boton disponible
  }  // End del if de Boton 2 verificacion LEFT

  else  if (mouseButton == LEFT && (arch != true)) {
    if (mouseX>=button_2_x && mouseX<=(button_2_x +280) && mouseY>=button_2_y && mouseY<=(button_2_y+30) ) { // Evento del botón2 
      if (archivo_flagOut == false) {
        G = 0;
        Disponible = "  Creado archivo para guardar datos";
        NombreA_Generado = "./Datos_Geofono/" + "A_D_" + str(year())+ "_" + str(month())+ "_" + str(day()) + "_" + str(hour()) + str(minute()) + str(second()) + ".txt";
        Archivo_datos = createWriter(NombreA_Generado);
        //println(NombreA_Generado);   // Para debug
        archivo_flagOut = true;
        rgbbutton_2_[0] = 0;
        rgbbutton_2_[1] = 255;
        rgbbutton_2_[2] = 0;
        //over = false;           // If mouse over
      }
    }
  }   // End else if RIGHT


  // Boton EXIT: Verificacion si el clip del raton presionado es el CENTER
  else if (mouseButton == CENTER) {                              // Eventos de click derecho
    if (mouseX>=button_Exit_x&&mouseX<=(button_Exit_x+button_Exit_width)&&mouseY>=button_Exit_y&&mouseY<=(button_Exit_y+button_Exit_high)) { // Evento del botón1 "Conectar-Desconectar"
      if (ktr_captura == false ) {    // NO esta activa la presentacion de la traza
        if (archivo_flagOut) { 
          Archivo_datos.flush(); // Writes the remaining data to the file
          Archivo_datos.close(); // Finishes the file
        }
        MiPuerto.stop();
        exit();  // Stops the program
      }
    }  // end if coordenadas
  }
  //print (ktr_captura); // Solo para debug
}   // End Funcion mousePressed
