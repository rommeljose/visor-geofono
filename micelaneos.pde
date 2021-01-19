/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : Varias                                      **
 ** ***************************************************************/

// Funcion para generar la fecha - hora actual - al milisegundo
String Hora_Actual() {
  //La función nf() separa los números correctamente
  String time = nf(day(), 2)    + ":" +
    nf(month())  + ":" +
    nf(year())   + ":" +
    nf(hour())   + ":" + 
    nf(minute()) + ":" + 
    nf(second()); 
  return time;
}  // fin hora

// Guarda los datos en un archivo etiquetado con fecha y hora; si la bandera arch es true
void Guarda_datos (float volt, int valor, String tiempo, int Us) {
  //if (arch == true) {    // incorporar ktr_captura
  Archivo_datos.println(nf(volt, 1, 3) + TAB + valor+ TAB + tiempo + TAB + Us);
  //}
}

// Borra la Barra de Status
void ClearStatus () {
  fill (241, 250, 0);          // Color de relleno ventana principal y status
  rect  (5, 410, 795, 435);      // Barrra de Status
  fill  (0);         // Color de relleno comandos siguiente ... textos etc

  Conversor_A_D.setSelected(false);
}

// Restablece las condiciones iniciale (parcial) de los botones
void restablece() {
  for (int i = 0; i  < LongVentana - 1; i++) { // Elimina los datos previos a la presentacion de los datos archivados
    Vector_traza[i][0]=map(590, 0, 1024, 285, 85);
  }
  arch = false;
  archivo_flagIn = false;          // Restablece la bandera a no seleccionado
  ktr_captura = false;             // Detiene la presentacion de la traza
  tipocaptura = "Iniciar captura datos Geofono";
  fill(rgbbutton_2_[0], rgbbutton_2_[1], rgbbutton_2_[2]);  // Restablce color botton_2_
  Disponible = "  Seleccción de Archivo / Lectura "; 
  rgbbutton_2_[0] = 255;
  rgbbutton_2_[1] = 247;
  rgbbutton_2_[2] = 117;
  //fill (0);
}


// Seleccion de Archivo
void fileSelected(File Archivo_datos) {
  if (Archivo_datos == null) {
    println("El usario ha cerrado la ventana .");
    archivo_flagIn = false;           // Error, No se hizo seleccion
  } else {
    Disponible = "    Archivo de Datos Selecccionado " ;//+ (Archivo_datos);  // + Archivo_datos.getAbsolutePath()
    reader = createReader(Archivo_datos);               // Buffer para guardar la data leida del archivo
    NombreA_Seleccionado = Archivo_datos.getName();
    println ("Se ha seleccionado el archivo:  " + NombreA_Seleccionado);
    archivo_flagIn = true;            // Bandera de archivo seleccionado
    rgbbutton_2_[0] = 0;
    rgbbutton_2_[1] = 255;
    rgbbutton_2_[2] = 0;
    for (int i = 0; i  < LongVentana - 1; i++) { // Elimina los datos previos a la presentacion de los datos archivados
      Vector_traza[i][0]=map(590, 0, 1024, 285, 85);
      ;
    }
    //    Grafica_Archivo ();             // Grafica archivo seleccionado
    //    archivo_flagIn = false;         // Restablece la bandera a no seleccionado
  }
}

// Funcion que carga el archivo de datos seleccionado y lo grafica en la ventana de despliegue. 
// Sólo presenta los ultimos X puntos. Esta asociado a el modo de presenttacion rapida
void Grafica_Archivo () {
  if (archivo_flagIn) {
    String[] lines = loadStrings(reader);
    //saveStrings("lineas.txt", lines );  // guarda lines en un archivo !!
    //println (lines);              // Solo para Debug
    //println("Son: " + lines.length + " lines");
    for (int i = 0; i < lines.length; i++) {
      //println(lines[i]);          // Solo para Debug
      String[] Linea_datos = split(lines[i], TAB); // Lee una linea del archivo y separa en cada Tabulador
      float x = int(Linea_datos[0]);     // Valor del dato en voltios
      int   y = int(Linea_datos[1]);     // Valor en decimal ASCII -> Decimal
      int  MiliSeg   = int(Linea_datos[3]); // Carga los milisegundo desde que incicio el programa
      ktr_captura = true;           // Inicia la Presentacion de la traza
      myString    = "1";            // Es necesario para ejecutar función traza; se require no NULL
      Hora.setSelected(false);      // Elimina la preseleccion
      hora = false;                 // Desactiva la bandera hora
      P_Rapido.setSelected(false);  // Deselecciona opcion de presentado rapido (>>)
      A_D = false;                  // Deselecciona bandera para presentar datos del PIC y conversor A/D

      CargaVectorTraza(y, MiliSeg) ;                   // Para cargar el arreglo traza
    }
  }
}

// Esta función permite optener los datos contenidos en un archivo generado por la aplicación
// separa los campo en cada TAB y llama a la función traza que carga el arreglo traza[700][3]
void LeeArchivo () {
  if (archivo_flagIn) {
    try {
      line = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line == null) {
      // Stop reading because of an error or file is empty 
      //// Fue necesario comentar ambos para evitar una abrupta parada luego de graficar datas en archivo
      //noLoop();  
      // reader.close();
      archivo_flagIn = false;           // Bandera a condición de No seleccion de archivo
      ktr_captura    = false;           // Detiene la Presentacion de la traza
    } else {

      arch = true;
      String[] Linea_datos = split(line, TAB); // Lee una linea del archivo y separa en cada Tabulador
      float Amplitud = int(Linea_datos[0]);    // Valor del dato en voltios
      int   V_Ascii  = int(Linea_datos[1]);    // Valor en decimal ASCII -> Decimal
      int  MiliSeg   = int(Linea_datos[3]);
      ktr_captura = true;               // Inicia la Presentacion de la traza
      myString    = "1";                // Es necesario para ejecutar función traza; se require no NULL
      Hora.setSelected(false);          // Elimina la preseleccion del despliegue de la hra
      hora = false;                     // Desactiva la bandera hora

      CargaVectorTraza(V_Ascii, MiliSeg) ;      // Grafica los datos del archivo seleccionado 

      //println (x + "   " + y);        // Para debug
    }
  }
}

// Para PARAR la captura y almacenamiento de datos, Flush y Cierra el archivo abierto
void StopCapturaDataFile () {
  if (ktr_captura == false ) {      // NO esta activa la presentacion de la traza
    arch = false;                   // Detiene el envio de datos al archivo selecionado
    Archivo_datos.flush();          // Writes the remaining data to the file
    Archivo_datos.close();          // Finishes the file
    // arch = true;                 // Restablece la posibilidad de enviar data a nuevo archivo seleccionado
    archivo_flagOut = false;        // Permite crear nuevo archivo
    Disponible = "  Seleccción de Archivo / Lectura "; 
    rgbbutton_2_[0] = 255;
    rgbbutton_2_[1] = 247;
    rgbbutton_2_[2] = 117;
  }
}

// Configura el nivel de umbral en el PIC para activar la alarma por evento
// El nivel por defecto en el PIC es 700; el Slider Umbral_evento varia de 6 a 10
// A estos valores se le suma 48 para trasmitir al PIC donde luego se le restan
// Finalmente, los valores posibles de 6 a 10 son multiplicados por 100; de esa 
// manera se tiene un rango de oscilación entre 600 a 1000. La data A/D fue acondicionada
// por hardware +/- 2,54 voltios; para no saturar el conversor A/D cuyo Vol-Ref es 2,56V.

void Umbral_Alarma() {
  int umbral = 48 + int(Umbral_evento.getValueS()); // + 48 para convertir a ASCII
  if (umbral != umbral_I && ktr_captura && !NoooSerial) {
    umbral_I = umbral;

    MiPuerto.write (umbral_I);
  }
}

// ------------------geofono -----------------------------------
// Movimiento de las imagenes que conforman el geofono
// Ver ejemplo "Spring"en topics-Simulate de la ayuda processing

void updateSpring() {
  // Update the spring position
  if (!move) {
    f = -K * (ps - I);          // f=-ky  donde I es la posicion inicial del geofono
    as = f / M;                 // Set the acceleration, f=ma ==> a=f/m
    vs = D * (vs + as);         // Set the velocity
    //    ps = ps + vs;         // Updated position
    ps = ((ValorVolt*100)/3)+60;     // Updated position
  }
  if (abs(vs) < 0.1) {
    vs = 0.0;
  }
}
