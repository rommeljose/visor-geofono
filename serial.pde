/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : serialEvent()                               **
 **     Descripción : Atiende un Evento del Puerto Serie          **
 **     Parámetros  : Puerto que genera la interrupción           **
 **     Retorna     : Nada. Grafica los datos en pantalla         **
 **                   via función traza().                        **
 ** ***************************************************************/

void serialEvent(Serial MiPuerto) {
  if ( ktr_incio == false) MiPuerto.clear();        // Al iniciar el programa evita errores del puerto serial
    
    if (MiPuerto.available() > 0) {                 // If data is available, 
      myString = MiPuerto.readString();             // Trabaja bien .. 
  
      //myString = MiPuerto.readStringUntil(lf);    // Trabaja bien; pero lee caracter por caracter hasta el lf
  
      if (myString != null) {
        String s2 = "00000000" + trim(myString);    // Se anexan ceros asi aparece el string como un color: "FF006699" o "#ffcc00"
        ValorDecimal= unhex(s2);                    // Convierte el valor hexa (10 bits)  a su valor decimal
      }
  
      //println(ValorDecimal+ "  --->  " + myString + "|---"); // para usar en debug
  
      // ********  Funcion de trasferencia A/D ********************************
  
      ValorVolt = Vref * ValorDecimal/Bits_AD;                         // 1024 para 10 bit's 8bit's 254; ambos referenciados a 2,56 V
  
      // **********************************************************************                                                
  
      if (ktr_captura == true) {        
        println(nf(ValorVolt, 1, 4) + " V ;  " + ValorDecimal+ " d ;  " + Hora_Actual());
      }
  
      // Llamada a la funcion traza que: Carga el vector de datos, con la traza: 
      // una Valor Decimal y otra Valor en Voltios que es el dato analogo procedente del cA/D,
      // la atenuacion la define el valor del slider "GCustomSlider"
      // La banderra archivo_flagIn verifica la no concurrencia de presentacion de archivo
      // y data proveniente del puerto serial
      if (!archivo_flagIn ){
          String hora = Hora_Actual();
          int tag_us = millis(); 
          
          CargaVectorTraza(ValorDecimal,tag_us);      // Dibuja la traza del cana A/D y una version atenuada de la misma

         if (arch == true){
           Guarda_datos (ValorVolt,ValorDecimal,hora,tag_us);  // Guarda los datos en un archivo etiquetado con fecha y hora
         }
    }
  }
}
