module SecureSecret
  require 'securerandom'

  def self.secure_token(filename)
    token_file = Rails.root.join(filename)
    if File.exist?(token_file)
      # Use the existing token.
      File.read(token_file).chomp
    else
      # Generate a new token and store it in token_file.
      token = SecureRandom.hex(64)
      File.write(token_file, token)
      token
    end
  end
end