require_relative "encrypt_message"
require_relative "decrypt_message"
require_relative "crack_message"

class Enigma

  def encrypt(message=nil, key=nil, date=Date.today)
    key = nil if key.zero?
    e = EncryptMessage.new(message, key, date)
    {key: e.encrypt, message: e.to_encrypt.message}
  end

  def decrypt(message=nil, key=nil, date=Date.today)
    d = DecryptMessage.new(message, key, date)
    {key: d.decrypt, message: d.to_decrypt.message}
  end
  
  def crack(message=nil, date=Date.today)
    c = CrackMessage.new(message, date)
    {key: c.crack, message: c.to_crack.message}
  end
end