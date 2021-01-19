/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **     Función     : setup()                                     **
 **     Descripción : Inicializa los parámetros del programa antes**
 **                   de ejecutar draw                            **
 **     Parámetros  : No                                          **
 **     Retorna     : Nada                                        **
 ** ***************************************************************/

void settings() {
  size(800, 440);
}

void setup() {
  // size(800, 440);
  //       Dimensiones del diálogo de la aplicación (define with y heigh)

  font  = loadFont("Arial-BoldMT-14.vlw");    //Carga la fuente
  font2 = loadFont("Consolas-8.vlw");         //Carga la fuente

  frameRate (30);                             // Establece el número de ejecuciones de draw() por segundo

  //==================Atenua la segunda traza =================================
  // Slider para atenuar segunda traza
  Atenuado = new GCustomSlider(this, 20, 300, 200, 50, "red_yellow18px");
  // show          opaque  ticks value limits
  Atenuado.setShowDecor(false, true, true, true);
  Atenuado.setNbrTicks(5);
  Atenuado.setLimits(1, 1, 5); // centro en 1, inicia en 1 y culmina en 5
  Atenuado.setStickToTicks(true);
  Atenuado.setEasing(5);

  //=================Umbral de Alarma de Evento ==============================
  // Slider para definir el umbral de alarma de evento
  Umbral_evento = new GCustomSlider(this, 450, 300, 200, 50, "red_yellow18px");
  // show          opaque  ticks value limits
  Umbral_evento.setShowDecor(false, true, true, true);
  Umbral_evento.setLocalColorScheme(#FFF700); 
  Umbral_evento.setNbrTicks(5);
  Umbral_evento.setLimits(8, 6, 10); // centro en 8, inicia en 6 y culmina en 10
  Umbral_evento.setStickToTicks(true);
  Umbral_evento.setEasing(5);
  Umbral_evento.setShowValue(true);
  Umbral_evento.setShowLimits(false); 

  //=========================== Creditos =================================
  int x, y ;
  x = width - 600; 
  y = 150; 
  Creditos = new GLabel(this, x, y, 200, 50, RJCG);
  Creditos.setLocalColorScheme(10);   // Averiguar como poner el color adecuado ..int
  Creditos.setTextAlign(GAlign.JUSTIFY, null);
  Creditos.setTextBold();
  Creditos.setTextItalic();
  Creditos.setVisible(true);
  //Creditos.setOpaque(true);

  //============================ GLabel ===================================

  x = width - 480; 
  y = 300;

  Extra_Label = new GLabel(this, x-45, y+15, 100, 12, "Extras");
  Extra_Label.setTextAlign(GAlign.LEFT, null);
  Extra_Label.setTextBold();

  Voltaje        = new GCheckbox(this, x, y + 13, 80, 18, "Vol");
  Reticula       = new GCheckbox(this, x, y + 33, 80, 18, "Ret");
  Hora           = new GCheckbox(this, x, y + 53, 80, 18, "Hora");
  P_Rapido       = new GCheckbox(this, x, y + 73, 80, 18, " >>");
  Conversor_A_D  = new GCheckbox(this, x, y + 93, 80, 18, "PIC A/D");

  // tg.addControls(optLeft,optRight, optTrack);               // excluyente
  Hora.setSelected(true);                                     // preseleccionado

  // ------- Carga imagenes - geofono y logo institucional --------
  rectMode(CORNERS);
  rocas = loadImage("rocas.png");
  bobina = loadImage("bobina.png");
  img = loadImage("interior_geofono_3.png");

  udo = loadImage("LogoUDO.gif");

  // -------------- Seleccion del Puerto Serial -------------------
  // Abriendo el puerto serial especificado o el primero de la lista

  String[] sa2 = append(Serial.list(), "NO"); 
  if (sa2[0] != "NO") {
    println("Abriendo Puerto Serie...");
    println(Serial.list());
    // println("Configurando diálogo" + " en " + Serial.list()[0] + " a " + baudios + " Baudios");
    String portname = Serial.list()[0];             // Selecciona el primer puerto serial
    MiPuerto = new Serial(this, portname, baudios); // El último valor es el BaudRate
    MiPuerto.clear();                               // clear the serial port buffer
    MiPuerto.bufferUntil(lf);                       // Ok. Evita la lectura repetida x 4 
    println("OK");
  } else {
    ClearStatus ();
    NoooSerial = true;
    ktr_captura = false; 
    println ("NoooSerialooooooo ooooo ooo");
  }
  //Créditos iniciales despletados en consola

  println ("**********************************"); 
  println (RJCG);
  println ("**********************************");
  println ("Listo para operar .....") ;
}  // Fin Setup
