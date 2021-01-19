/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : draw()                                      **
 **     Descripción : Función de dibujo y diálogos                **
 **     Parámetros  : No                                          **
 **     Retorna     : Nada                                        **
 ** ***************************************************************/

void draw() {

  background(200, 200, 255); // Color del rectangulo de la aplicacion; externo

  int w, t, q;

  textFont(font);                //Selecciona la fuente para el reloj
  stroke(64, 64, 64);            // Establece el color utilizado para dibujar líneas y 
  // bordes alrededor de las formas
  fill  (63, 102, 150);          // Color de relleno ventana principal y status
  rect  (15, 30, 800, 285);      // Ventana principal; visualización de la gráfica
  stroke(49, 65, 111);           // Borde ventana pricipal

  rect  (5, 410, 795, 435);      // Barrra de Status
  fill  (122, 122, 122);         // Color de relleno comandos siguiente ... textos etc

  image(udo, button_Exit_x + 5, button_Exit_y-55, 40, 40); 

  textFont(font2); //Selecciona la fuente para la escala vertical 

  // ------------  Presenta un reticulada en el area de despliegue -------------
  if (reticula) {              
    //stroke (171,205,206);
    // Líneas horizontales en ventana de despliegue
    for (int k = 0; k <=8; k++) {
      t = (128 - 32 * k);
      w = 30 + 32 * k;
      line(15, w, 677, w);     // Líneas de división horizontales de la gráfica
      text(t, 0, w);           //Escribe texto en la posición (0,t)
    }

    // Lineas verticales en la ventana de despliegue
    for (int v = 0; v <= 22; v++) {
      q = 16 + 30 * v;
      line (q, 30, q, 285);
    }
  }

  font = loadFont("Consolas-12.vlw"); //Carga la fuente
  textFont(font); //Selecciona la fuente actual
  stroke (193, 193, 193);

  // Dibuja button_1_ Inicio y Parada de captura de datos
  fill(rgbbutton_1_[0], rgbbutton_1_[1], rgbbutton_1_[2]);        // Establece el color de relleno button_1_
  rect(button_1_x, button_1_y, button_1_width, button_1_high);    // Dibuja un rectángulo de button_1_
  fill(0);                                                        // Establece color negro para letras
  text(tipocaptura, button_1_x+10, button_1_y+20);                // Escribe mensaje de button_1_ 

  // Dibuja button_2_ Para crear Archivo etiquetado con la hora
  fill(rgbbutton_2_[0], rgbbutton_2_[1], rgbbutton_2_[2]);             // Establece el color de relleno button_2_
  rect(button_2_x, button_2_y, button_2_width, button_2_high);         // Dibuja un rectángulo de button_2_
  fill(0);                                                             // Establece color negro para letras
  text(Disponible, button_2_x+10, button_2_y+20);

  if (NoooSerial) {
    fill (255, 255, 0);
    text("                        <<<<<<<<< No existe puerto Serial físico o virtual  <<<<<<<<<", 15, 427);
    fill(0);
  } else if (myString == null ) {    // Noooooo trabaja bien al inicio !!!!
    fill (255, 255, 0);
    text("                        <<<<<<<<<    No esta conectado el conversor A/D     <<<<<<<<<", 15, 427);
    fill(0);
  }

  if (voltaje) {                            // Escrive el voltaje A/D
    text("Valor en volt: " + nf(ValorVolt, 0, 2), button_1_x+40, button_1_y-340);  // Escribe valor Voltaje Debajo del Boton_1
  }

  if (hora) {
    text(Hora_Actual(), 300, 20);          // Escribe hora en esas coordenadas
  }

  if (A_D) {
    ClearStatus ();
    Conversor_A_D.setSelected(true);
    text("A/D de 10 Bits" + 
      " - PIC 18F25K20" + 
      " - F. muestreo 46,51 KHz" + 
      " - T. de Conversión 11,5 us" + 
      " - Vref: 0 a 2,56 V" +
      " - Canal 2", 15, 427);
    fill(0);
  }

  if (!Creditos.isVisible()) {             // Si se  hace invisible los creditos al inicio, se ponen en la parte superior
    text("por: Rommel J. C. G. / 2017", 560, 20);
  }

  if (Stop_file && !ktr_captura) {
    ClearStatus ();
    fill(250, 0, 250);
    text("Datos guardados en archivo: " + NombreA_Generado, 15, 427);
    fill(0);
  } else if (ktr_captura)
  {
    ClearStatus ();
    Stop_file = false;
    fill(250, 0, 250);
    text(" Tiempo Real:   Traza de los datos del conversor A/D - 10 bits - del Geofono  SM-6", 15, 427);
    fill(0);
  }

  // -------- Dibuja rectangulo de Salida o Exit ------------------
  fill(rgbbutton_Exit_[0], rgbbutton_Exit_[1], rgbbutton_Exit_[2]);          // Establece el color de relleno button_Exit_
  rect(button_Exit_x, button_Exit_y, button_Exit_width, button_Exit_high);   // Dibuja un rectángulo de button_Exit_
  fill(0);                                                                   // Establece color negro para letras
  text(Salida_exit, button_Exit_x+10, button_Exit_y+20);

  // ---------------movimiento del  geofono -----------------------
  image(img, 702, ps - 105 + springHeight, 107, 168 );
  image(rocas, 702, ps + 58 + springHeight, 100, 173 -ps  );
  image(bobina, 737, 90, 37, 49);

  // * * * * * * Acciones dentro de la funcion draw * * * * * * 
  // **********************************************************
  if (archivo_flagIn) {
    LeeArchivo ();             // Lee ->una linea<- del archivo selecionado; trabaja fino pero es linea a linea ... lento
    ClearStatus ();            // limpia la barra de Status
    text("Se ha seleccionado el archivo:  " + NombreA_Seleccionado, 15, 427);
    fill(0);   
    if (line == null) {
      restablece();           // Restablece las condiciones iniciale (parcial) de los botones
    }
  }
  updateSpring();             // Actualiza el geofono
  grafiko();                  // traza la grafica; de los datos cargados en el arrray traza[700][3]
  Umbral_Alarma();
}   // fin draw



// --------------------- Manejo de los CheckBox ----------------------------- 
public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if (option == Voltaje)
    voltaje = !voltaje;

  else if  (option == Reticula)
    reticula = !reticula;

  else if  (option == Hora)
    hora = !hora;   

  else if  (option == Conversor_A_D &&  !archivo_flagIn) {
    ClearStatus ();             // limpia la barra de Status
    A_D = !A_D;
  } else if  (option == P_Rapido) {
    if (arch == true) {         // Opera cuando la data proviene de un archivo guardado
      ClearStatus ();           // limpia la barra de Status
      p_rapido = !p_rapido;
      Grafica_Archivo ();       // Lee todo el archivo y presenta de una vez la grafica de todos los datos
      restablece();             // Restablece las condiciones iniciale (parcial) de los botones
    }
    else {
      P_Rapido.setSelected(false); // Evita seleccionar la opcion >> cuando esta recibiendo data en tiempo real
    }
  }
}

public void handleSliderEvents(GValueControl slider, GEvent event) { 

  /* code */
}
