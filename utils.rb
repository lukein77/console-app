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
  cd <directory>                  - enter a directory
  ls                              - show the content of the current directory
  ls <directory>                  - show the content of the specified directory
  metadata <name>                 - show the metadata of a file or folder
  whereami                        - show the full path of the current directory
  create_user <username>          - register a new user
  login <username>                - log in as an existing user
  logout                          - log out of the system
  whoami                          - show current session data
  exit                            - exit the application
  "
end