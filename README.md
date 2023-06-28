# Console app

Simple app that simulates a console to handle files and directories using commands.

### How to run

`ruby console.rb`

### Available commands

- `create_file <name> <content>`    - create a file with optional content
- `create_folder <name> `           - create a folder
- `destroy <name>`                  - delete a file or folder
- `rename <name> <new name>         - rename a file or folder
- `cd <folder>`                     - enter a directory
- `show <filename>`                 - show the contents of a file
- `ls`                              - show the content of the current directory
- `metadata <file/folder>`          - show the metadata of a file or folder
- `whereami`                        - show the full path of the current directory
- `exit`                            - exit the application
