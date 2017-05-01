require_relative 'message.rb'
require_relative 'cryption_module'
require_relative 'key_gen'
require_relative 'offset_gen'
require_relative 'message_io'

class EncryptMessage
  include Cryption, MessageIO, KeyGen, OffsetGen
  attr_reader :to_encrypt

  def initialize(message, key=nil, date=Date.today)
    @to_encrypt = Message.new(message, key, date)
  end
  
  def encrypt
    get_offset
    get_rotations
    parse_and_split_message
    rotation = rotation_and_offset(@to_encrypt.rotation, @to_encrypt.offset)
    @to_encrypt.message = run_the_cipher(@to_encrypt.message, rotation)
    "Message encrypted with key: #{@to_encrypt.key} and date: #{@to_encrypt.date.to_s}"
  end

  def get_offset
    @to_encrypt.offset = convert_into_offset(@to_encrypt.date)
  end
  
  def get_rotations
    @to_encrypt.key = generate_original_key if @to_encrypt.key.nil?
    @to_encrypt.rotation = generate(@to_encrypt.key)
  end
  
  def parse_and_split_message
    message = parse(@to_encrypt.message)
    @to_encrypt.message = split_into_sub_arrays(message)
  end
end