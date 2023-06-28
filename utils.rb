def get_current_time
    current_time = Time.now
    return current_time.strftime("%Y-%m-%d %H:%M:%S UTC%Z")
end

def get_command_list
    return "
    Available commands:

    create_file <name> <content?>   - create a file with optional content
    create_folder <name>            - create a folder
    destroy <name>                  - delete a file or folder
    cd <folder>                     - enter a directory
    ls                              - show the content of the current directory
    metadata <file/folder>          - show the metadata of a file or folder
    whereami                        - show the full path of the current directory
    exit                            - exit the application
    "
end