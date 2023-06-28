def get_current_time
    current_time = Time.now
    return current_time.strftime("%Y-%m-%d %H:%M:%S UTC%Z")
end

def get_command_list
    return "
    Available commands:
    create_file <name> <content?>   - creates a file with optional content
    create_folder <name>            - creates a folder
    cd <folder>                     - enters a directory
    ls                              - shows the content of the current directory
    metadata <file/folder>          - shows the metadata of a file or folder
    exit                            - exits the application
    "
end