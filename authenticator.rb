require 'digest'
require_relative 'exceptions.rb'
require_relative 'session.rb'

# Simple user authentication system. 
# Of course, it is in no way secure since usernames and passwords are stored in a simple file with no encryption.
# The system's only purpose is to handle and store hashed passwords for user authentication.

class Authenticator
  @@users = {}

  # Load saved users
  def self.load
    begin
			File.open('users.dat', 'rb') do |file|
				@@users = Marshal.load(file.read)
			end
		rescue Errno::ENOENT
			@@users = {}
		end
  end

  # Save users to file
  def self.save
    File.open('users.dat', 'wb') do |file|
			file.write(Marshal.dump(@@users))
		end
  end
  
  # Create a new user and store it
  def self.new_user(username, password)
    raise UserAlreadyExistsError, username if @@users[username]
    
    @@users[username] = encrypt_password(password)
  end
  
  # Check if login information is correct
  def self.authenticate_user(username, password)
    user = @@users[username]
    raise UserNotExistsError, username if user.nil?
    
    if verify_password(password, @@users[username])
      return Session.new(username)
    else
      return nil
    end
  end
  
  # Encrypt password and return it
  def self.encrypt_password(password)
    digest = Digest::SHA256.new
    digest.update(password)
    hashed_password = digest.hexdigest
    hashed_password
  end

  # Encrypt the password used for logging in and compare it to the stored hashed password
  def self.verify_password(password, stored_hashed_password)
    digest = Digest::SHA256.new
    digest.update(password)
    hashed_password = digest.hexdigest
  
    hashed_password == stored_hashed_password
  end

end