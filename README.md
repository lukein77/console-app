# Console app

Aplicación simple que simula una consola para manejar archivos y carpetas desde una línea de comandos.

### Cómo ejecutar

`ruby main.rb`

Para persistir los archivos creados:
`ruby main.rb -p <nombre_archivo>`

### Comandos disponibles

Comando | Funcionalidad | Ejemplo
--- | --- | ---
`create_file <nombre> <contenido>` | crear un archivo con contenido opcional |  `create_file hola.txt Hola`
`create_folder <nombre> `         | crear una carpeta |  `create_folder carpeta`
`destroy <nombre>`              | eliminar un archivo o carpeta | `destroy hola.txt`
`cd <directorio>`                     | acceder a un directorio |   `cd carpeta2`
`show <nombre>`                 | mostrar el contenido de un archivo  |   `show hola.txt`
`ls`                             | mostrar el contenido del directorio actual |   
`ls <directorio>`               | mostrar el contenido de un directorio | `ls /carpeta1/carpeta2`
`metadata <file/folder>`          | mostrar la metadata de un archivo o carpeta |   `metadata hola.txt`
`whereami`                        | mostrar la ruta de la carpeta actual    |   
`create_user <nombre>`      | registrar un nuevo usuario | `create_user messi`
`login <nombre>`          | iniciar sesión con un usuario existente | `login messi`
`logout`                  | cerrar la sesión actual |
`whoami`                  | mostrar la sesión actual | 
`help`                            | mostrar lista de comandos disponibles   |
`exit`                            | salir de la aplicación |


### Comentarios

Para crear y eliminar archivos o carpetas, es necesario haber iniciado sesión con un usuario existente.
Por defecto, no existen usuarios registrados, por lo que es necesario crear uno con el comando `create_user`. El sistema de autenticación es rudimentario, enfocándose solamente en manejar contraseñas de forma invisible al usuario y encriptarlas usando el algoritmo SHA-256. 
Una vez creados, los usuarios se almacenan en el archivos "users.dat" al ingresar el comando `exit` y serán cargados la próxima vez que se inicie la aplicación.

A la hora de acceder a un directorio con el comando `cd`, puede especificarse tanto la ruta relativa como la ruta absoluta. Es decir, `cd documentos/2023` buscará la carpeta "documentos" dentro del directorio actual (y dentro de ella la carpeta 2023), mientras que `cd /programas/notepad` buscará la carpeta "programas" dentro del directorio raíz (identificado como **"/"**)

En caso de iniciarse la consola con la opción `-p` debe especificarse el nombre del archivo donde se guardará el sistema de archivos generado dentro de la aplicación cuando se ingrese el comando `exit`. La próxima vez que se ejecute la aplicación con el mismo parámetro, se cargará el sistema desde dicho archivo.
