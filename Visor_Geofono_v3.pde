/** ****************************************************************
 **     Proyecto: Captura y Graficado de datos A/D puerto serie   **
 **               por: Rommel Contreras - UDO Octubre 2017  V2.0  **
 **               email:    rommeljose@gmail.com                  **
 **               http://tecnologiacumanesa.blogspot.com/         **
 **                                                               **
 **      - Configurar puerto serial (baudios) preferente 19200    **
 **      - Seleccionar el puerto serial configurado en "portname" **
 **      - Directorio ./Datos_geofono/ ;contiene datos capturados **
 **      - Usar con programa PIC "Geofono_2017" MPLAB X / XC8     **
 **                                                               **
 ** ***************************************************************/

import processing.serial.*;             // Librería para el manejo de puerto serial
import java.awt.Rectangle;
//import java.util.ArrayList;
import g4p_controls.*;

// variables auxiliares puerto serial y conversion de datos
//byte[] inBuffer = new byte[11];       // Buffer para almacenar la data capturada del puerto serial
BufferedReader reader;                  // Para guardar los datos proveneintes de un archivo
String line;                            // 
Serial MiPuerto;                        // Objeto de puerto
int baudios = 19200;

// Constantes globales
String myString;// = null;
int lf = 10;                            // Line Feed
int cr = 13;                            // Carrier Return
int HT =  9;                            // Tabulador horizontal
int umbral_I = 3;                       // Utilizada en el slider de umbral de alarma

// Boton 1 -> Inicio y parada de traza
int button_1_x  =  20;                  // Posición x de captura de datos y valores en volt
int button_1_y  =  360;                 // Posición y del botón de iniciar captura datos
int button_1_width  =  240;             // Ancho: captura datos, valores en volt
int button_1_high   =  390;             // Alto del botón de iniciar captura datos
int[] rgbbutton_1_ = {155, 245, 170 };  // color rectangulo Inicio y Parada
String tipocaptura="Iniciar captura datos Geofono";// Mensaje de button_1_

// Boton 2 -> Generar y seleccionar archivo para data logger
int button_2_x  =  420;                  // Posición x de captura de datos y valores en volt
int button_2_y  =  360;                  // Posición y del botón de iniciar captura datos
int button_2_width  =  700;              // Ancho: captura datos, valores en volt
int button_2_high   =  390;              // Alto del botón de iniciar captura datos
int[] rgbbutton_2_ = {255, 247, 117};    // color rectangulo Generar Archivo
String Disponible = "  Generar Archivo para guardar datos";// Mensaje de button_2_


// Boton EXIT -> Sale de la Aplicacion
int button_Exit_x  =  735;                // Posición x de captura de datos y valores en volt
int button_Exit_y  =  360;                // Posición y del botón de iniciar captura datos
int button_Exit_width  =  790;            // Ancho: captura datos, valores en volt
int button_Exit_high   =  390;            // Alto del botón de iniciar captura datos
int[] rgbbutton_Exit_ = {255, 247, 117};  // color rectangulo EXIT
String Salida_exit    = "Salida";         // Mensaje de button_Exitbutton_Exit_  

PFont font, font2;                    // Objeto de tipo de fuente
PrintWriter Archivo_datos;            // Objeto de Archivo (Archivo_datos)
boolean archivo_flagOut = false;      // Bandera para verificar la creacion de archivo; etiquetado con la fecha y hora
boolean archivo_flagIn  = false;      // Bandera para verificar seleccion de archivo de entrada de datos
boolean arch = false;                 // Verifica para proceder a guarda data en archivo seleccionado
boolean Stop_file = false;            // Informa el cierre del archivo de datos; luego de guardar datos
String  NombreA_Seleccionado;         // Nombre del archivo seleccionado; a desplegar en barra de status
String  NombreA_Generado;             // Nombre del archivo generado; a desplegar en barra status

char[] datosc=new char[13];           // Array de almacen de trama recibida en el puerto serie 
int[]  datos2=new int[17];            // Array de datos ajustados para guardar en archivo 

int valorMuestra =0;                  // Indice del array traza su valor maximo = LongVentana
int LongVentana = 700;                // Largo de la ventana e inicio de la traza
//int[][] traza=new int[LongVentana][3];// Array para guardar la data; los datos a visualizar 
float[][] Vector_traza = new float[LongVentana][3];
// para graficar se requiere dos posiciones traza1 [0 y 1] , traza2 [2 y 3]

// Constantes implicadas en el control de la traza o graficado de la data
// boolean ktr_traza=false;           // Control de Inicio-fin de trama del puerto
boolean ktr_captura = false;          // Control global de la presentacion de la traza; pero no de la captura de datos 
boolean ktr_incio = false;            // Control del inicio de captura de datos

boolean reticula = false;             // Bandera para activar el reticulado
boolean voltaje  = false;             // Bandera para presentar valor voltaje
boolean hora     = true;              // Bandera pra presentar la hora hasta ms.
boolean status   = false;             // Bandera para Presenta los creditos
boolean p_rapido = false;             // Bandera para acelerar la presentacion de datos de archivos seleccionadoas
boolean A_D      = false ;            // bandera para presentar parametros del conversor A/D y PIC
boolean NoooSerial     = false;             // bandera para verificar la existencia de puerto serial virtual o físico
// Parametros conversor analogo-digital
int    sp = 70;                       // Separacion entre trazas; X para 8 bits is ok
int    pp = -8;                       // Atenuacion de la data original; Negativa para invertir presentacion (flip vertical)
int    Bits_AD = 1024;                // Resolucion del conversor Analogo-Digital (254 para 8bits; 1023 para 10)
float  Vref = 2.56;                   // Voltaje de referencia
float  ValorVolt;                     // Valor en voltios de la data proveniente del conversor A/D
int    ValorDecimal;                  // Valor en byte de la data del conversor A/D

int R = 255;                          // Valor color Rojo
int G = 0;                            // Valor color Verde 
int B = 0;                            // Valor color Azul

// Spring drawing constants for geofono
int springHeight = 54;                // Height
boolean move = false;                 // If mouse down and over

// Spring simulation constants
float M = 1.0;                        // Mass
float K = 0.7;                        // Spring constant
float D = 0.93;                       // Damping
float I = 115;                        // Posición inicial del geofono

// Spring simulation variables
float ps = R;                         // Position
float vs = 0.0;                       // Velocity
float as = 0;                         // Acceleration
float f = 0;                          // Force

PImage img;                           //Geofono sin bobina
PImage bobina;                        //Bobina del geofono
PImage rocas;                         // Subsuelo
PImage udo;                           // logo UDO

GCustomSlider Atenuado, Umbral_evento;
//GCustomSlider Umbral_evento;
GLabel Extra_Label, Creditos;

GCheckbox Voltaje, Reticula, Hora, P_Rapido, Conversor_A_D;

//GToggleGroup tg = new GToggleGroup();
//GOption optLeft, optRight, optTrack;

// Credito desplegados al inicio en el centro del recuadro de la aplicacion
String RJCG = "Visor_Geofono" + "\n" + 
  "por: Rommel Contreras / 2017" + "\n" + 
  "http://ciencia.digital.info.ve";
