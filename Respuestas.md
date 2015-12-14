#Respuestas

##isKindOfClass

Permite conocer el tipo de una clase. Recibe como parámetro un reference type, por ejemplo, una class. Por otra parte, tenemos "is" y "as". "is" puede sustituir a isKindOfClass y puede recibir cualquier tipo o protocolo. "as" es un operador para hacer TypeCasting pero evitando el recibir un error si el objeto que se pretende convetir no es convertible al tipo esperado, simplmente, de vueve un nil que puede ser tratado a continuación.

##Almacenamiento de imágenes y documentos pdf de los libros

Aunque no lo he podido implementar por falta de tiempo, mi idea era usar el FileManager para almacenar imágenes y pdf's el dispositivo. La idea sería:

  - Para las imágenes, crear un directorio en la carpeta /Documents llamado "Imagenes" y almacenar todas las imágenes.
  - Para los pdfs, crear un directorio en la carpeta /Documents llamado "Pdfs" y almacenar todas los ficheros pdfs. En este caso, los guardaría solo en caso de que el usuario haya ido previmente a la vista detalle del libro y haya seleccionado ver el pdf. Así no cargo documentos que a lo mejor el usuario si siquiera querrá ver en el futuro.

##Persistencia de Favoritos

Cada vez que el usario toca la estrella que hay en la vista de detalle del libro, se añade o se quita ese libro de la lista de favoritos. La lista de favoritos es un subconjunto de la lista total de libros, es decir, [AGTBook]. Cada vez que se modifica esta lista, se persiste guardando en NSUserdefaults dicha lista.

##Cambios en la tabla y Favoritos

Cada vez que se produzca un cambio en favoritos, se debe avisar a la tabla. Para ello se podrían usar delegados o notificaciones. Me he decantado por el segundo modelo porque permite que más de un objeto puede atender dicha notificación y actualizarse. En este caso, se realizarían 2 actualizaciones:

  - Si la celda tuviera algún elmento visual que indicara si el libro es favorito o no, bastaría con actualizar dicha celda que previamente se habría suscito a esta notificaón.
  - Si la celda no contiene ningún elemento visual y, dado que en este caso, hay que actualizar una de las secciones de la tabla, lo que se hace es que al lanzar la notificación, ésta se recibe y se actualiza el modelo que alienta la tabla con datos y se vuelve a recargar la información.

##ReloadData

En relación a lo anterior, para actualizar los datos de favoritos, se obliga a la tabla a ejecutar un reloadData para refrescar la información. Desde el punto de vista de rendimiento no es lo más apropiado sobre todo cuando el volumen de datos es muy elevado. Otra justificación, es que si solo se quiere actualizar uno de los elementos de la lista de elementos, no tiene sentido volver a cargarlos a todos en la tabla.

##Actualización del webview para leer los pdf

Nuevamente, usuaría notificaciones de forma similar a cómo se usaron los cambios reflejados en la tabla al marca/desmarcar los libros como favoritos.

