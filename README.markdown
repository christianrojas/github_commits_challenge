# TangoSource Challenge
Reto impuesto para medir habilidades en el desarrollo de una implementación.

#### Descripcion del reto:
Utilizando la API de Github crear una aplicación que analice la densidad de commits en un día por medio de una gráfica, cualquier repositorio puede ser especificado en la pagina.(Idealmente deberíamos guardar la información de la densidad de commits de los repositorios para no consumir requests futuros hacia github.

##### Wireframe:
![alt text](http://christianrojas.s3.amazonaws.com/Git%20graph.png "wireframe")

##### Limitations
* Solo se pueden realizar peticiones de depositos publicos.
* La cantidad de peticiones por hora tiene un limite de 60, ya que no estamos autenticando al usuario con una cuenta actual de github. Un usuario autenticado puede tener 5000 por hora.
* La cantidad de commits por peticion es de max 100. Ej: Un deposito como rails/rails el cual cuenta con mas de 1000+ commits necesitarian 10+ peticiones.

##### Presenta:
Christian Rojas @christianrojas
