# Console app

Aplicación simple que simula una consola para manejar archivos y carpetas desde una línea de comandos.

### Cómo ejecutar

`ruby console.rb`

### Comandos disponibles

<style scoped>
table {
  font-size: 13px;
}
</style>

Comando | Funcionalidad | Ejemplo
--- | --- | ---
`create_file <name> <content>` | crear un archivo con contenido opcional |  `create_file hola.txt Hola`
`create_folder <name> `         | crear una carpeta |  `create_folder carpeta`
`destroy <name>`              | eliminar un archivo o carpeta | `destroy hola.txt`
`rename <name> <new name>`         | renombrar un archivo o carpeta |   `rename carpeta carpeta2`
`cd <folder>`                     | acceder a un directorio |   `cd carpeta2`
`show <filename>`                 | mostrar el contenido de un archivo  |   `show hola.txt`
`ls`                              | mostrar el contenido del directorio actual  |   
`metadata <file/folder>`          | mostrar la metadata de un archivo o carpeta |   `metadata hola.txt`
`whereami`                        | mostrar la ruta de la carpeta actual    |   
`help`                            | mostrar lista de comandos disponibles   |
`exit`                            | salir de la aplicación |

