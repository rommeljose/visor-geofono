/** **************************************************************** //<>// //<>//
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : grafiko()                                   **
 **     Descripción : IDibuja el Array traza, GRAFICA             **
 **                   de ejecutar draw                            **
 **     Parámetros  : No                                          **
 **     Retorna     : Nada                                        **
 ** ***************************************************************/

/** Grafica los datos cargada en el arrray traza[700][3] en forma de una señal sismica
 *maximo valor variable valorMuesra 700 y LongVentana = 700
 *valorMuestra informa el numero de datos cargados en el array traza
 */
void grafiko() { 
  stroke(R, G, B);             // Color de la traza

  // ================== Primera traza  ===================================

  // Primera sección de la grafica las primeras 700 muestras
  // Es la que se presenta vacia al inicio del programa
  for (int i = 0; i + valorMuestra < LongVentana - 1; i++) {  
    line(i, Vector_traza[i+valorMuestra][0], (i+1), Vector_traza[i+valorMuestra+1][0]);
  }

  // Segunda seccion de la grafica las siguientes 700 muestras
  // Es la que empieza a aparecer por la derecha al inicio del programa
  for (int i = 0; i < valorMuestra - 1; i++) {  
    line((i+LongVentana-valorMuestra), Vector_traza[i][0], (i+LongVentana-valorMuestra+1), Vector_traza[i+1][0]);
  }

  R = 255; 
  G = 255;
  if(archivo_flagIn ){
     B = 255;}
  else { B= 0;}
  strokeWeight(1);


  noStroke();
  fill(204);
  rect(0, 110, 14, 206);
}

// Solo para Revisar datos guardados lento o rapido (ambas modalidades)
// Carga el vector de datos, con la traza: una original y otra atenuada
// la atenuacion la define el valor del slider "GCustomSlider"  
void CargaVectorTraza(float ValorDecimal, int tag) {
  if (ktr_captura  && (myString != null)) {          // Cuando se evita los null -> && (myString != null)
    int atenua = int(Atenuado.getValueS());          // se obtiene el valor del slider para atenuar segunda traza

    Vector_traza[valorMuestra][0]= map(ValorDecimal/atenua, 0, 1024, 285, 85);

    Vector_traza[valorMuestra][1]= tag;                     // carga la etiqueta de tiempo en milisegundos

    //text(nf(Vector_traza[valorMuestra][1] ), 690, 310);  // Produce una falla aleatoria cambio colores
    //text(valorMuestra, 690, 310);

    valorMuestra++;

    // Secciona gráfica en ventanas de valor: LongVentana = 700 muestras
    // Y reinicia la nueva sección
    if (valorMuestra >= LongVentana) valorMuestra=0;
  }
}

/* 
 void mouseWheel(MouseEvent event) {
 int e = event.getCount();
 
 println(e);
 
 stroke(R);             // Color de la traza
 
 if (e > 0){
 kkk ++;
 println(traza[kkk][1]);
 
 text(nfc(traza[kkk][1]), 690, 300);
 
 //for (int i = 0; i + valorMuestra < LongVentana - 1; i++) {  
 //line(i, traza[i+valorMuestra][1], (i+1), traza[i+valorMuestra+1][1]);
 //}
 }
 }
 */
