class IncompleteCommandError < StandardError
end

class FileNotFoundError < StandardError
end

class FolderNotFoundError < StandardError
end

class FileExistsError < StandardError
end

class PathNotFoundError < StandardError
end

class IsNotDirectoryError < StandardError
end

class UserAlreadyExistsError < StandardError
end

class UserNotExistsError < StandardError
end

class UserNotAuthenticatedError < StandardError
end