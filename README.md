# Datalogger para un sismómetro:

El proyecto consiste de un sistema de digitalización, almacenamiento y visualización de datos proveniente de un sismómetro tipo SM-6. Se estudió e implementó el diseño del preamplificador presentado por **Havskov & Alguacil (2006)**, y se agregó un sistema de acondicionamiento y filtrado de los datos compuestos por celdas tipo Sallen Key (un filtro pasa bajo y un pasa altos).

La digitalización de los datos se realizó mediante una tarjeta de desarrollo PICDEMZ de compañía [Microchip](https://www.microchip.com/); que tiene incorporado un PIC 18F25K20. Para desarrollar el software referente al PIC, se utilizó el IDE [MPLABX]() de Microchip y el compilador de lenguaje CCS de [Custom Computer Services, Inc](http://www.ccsinfo.com/content.php?page=compilers). Para almacenar y graficar los datos en un PC vía el puerto serial, se utilizó el lenguaje [Processing](https://processing.org/) (The Processing Fundation); implementando un conjunto de 8 script. 

La base teórica del sistema datalogger, está documentada y explicada en el artículo anexo al proyecto: [El Sensor Sísmico Geófono](http://tecnologiacumanesa.blogspot.com/2015/05/el-sensor-sismico-geofono.html); publicada en el blog del autor. El prototipo fue iconstruido para participar en la Feria de Ciencias Regional Oriente 2015, convocada en Cumaná (Edo. Sucre., Venezuela).


![Processing](/data/logo_i3.jpg)
